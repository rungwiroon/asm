; STARTDP.ASM - 32-bit DPMI startup code for ASM32/DPMI
;  Original code by Tran (a.k.a. Thomas Pytel)
;  Modified August 1995 for ASM32/DPMI by Douglas Herr

; Assemble with TASM 2.0 or newer:
; TASM /M2 STARTDP;

.386p
locals

; tell linker where library code is
includelib	asm32dp.lib

STACKLEN	= 4000h 		; size of stack in bytes

PMODE_TEXT      segment para public use16 'CODE'
PMODE_TEXT      ends
_TEXT           segment byte public use32 'CODE'
_TEXT           ends
_DATA           segment dword public use32 'DATA'
_DATA           ends
EXE_STACK       segment para stack use16 'STACK'
EXE_STACK       ends

DGROUP          group   _DATA
assume  cs:_TEXT, ds:DGROUP

PMODE_TEXT      segment para public use16 'CODE'
assume  cs:PMODE_TEXT, ds:PMODE_TEXT

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
align 2
errmsgtbl       dw      errmsg0,errmsg1,errmsg2,errmsg3
                dw      errmsg4,errmsg5,errmsg6

errmsg0         db      'Not enough low memory!',13,10,36
errmsg1         db      '80386 or better not detected!',13,10,36
errmsg2         db      'No DPMI found!',13,10,36
errmsg3         db      'DPMI host is not 32bit!',13,10,36
errmsg4         db      'Could not enable A20 gate!',13,10,36
errmsg5         db      'Could not enter DPMI 32bit protected mode!',13,10,36
errmsg6         db      'Could not allocate needed DPMI selectors!',13,10,36

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
start:
	push	cs			; DS = CS
        pop	ds

; release unused DOS memory
	mov	bx,ZSEG
	mov	ax,es
	sub	bx,ax
	mov	ah,4Ah
	int	21h

	push	cs
	call	near ptr _pm_info	; get information
	jnc	short @@startf0		; if no error, go on

@@startf1:
	mov	si,ax			; print error message for code AX
        add	si,ax
        mov	dx,errmsgtbl[si]
        mov	ah,9
        int	21h
        mov	ax,4cffh
        int	21h

@@startf0:
	xor	ax,ax			; check low memory and allocate low
	mov	cx,ss			;  buffer needed for protected mode
	add	cx,STACKLEN
        movzx	edx,word ptr es:[2]
        sub	dx,cx
        cmp	dx,bx
        jb	@@startf1
        mov	es,cx

	mov	ax,DGROUP
	mov	ds,ax
	push	cs
	call	near ptr _pm_init	; enter protected mode
	jc	@@startf1		; if error, go to error message
	push	es			; save PSP selector

	mov	cx,1			; allocate 1 descriptor
	xor	ax,ax
	int	31h

	mov	bx,ax			; BX = descriptor allocated

        mov	dx,0ffffh		; set size to 4G
        mov	cx,dx
        mov	ax,8
        int	31h

	mov	edx,_TEXT		; base address = 32bit code segment
        shl	edx,4
        shld	ecx,edx,16
        mov	ax,7
        int	31h

	mov	ax,cs			; set descriptor type to 32bit code
	lar	cx,ax			;  at the current CPL
        mov	cl,ch
        mov	ch,0c0h
        mov	ax,9
        int	31h

	mov	bp,bx			; preserve 32bit code selector
	mov	bx,ds			; BX = current data selector

        mov	dx,0ffffh		; set size to 4G
        mov	cx,dx
        mov	ax,8
        int	31h

	mov	edx,DGROUP		; base address = 32bit data segment
        shl	edx,4
        shld	ecx,edx,16
        mov	ax,7
        int	31h

        cli                             ; we don't want to be interrupted
					;  while changing SS:ESP

; set all segment registers to data selector
	mov	es,bx		
        mov	fs,bx
        mov	gs,bx
        mov	ss,bx

assume  ds:DGROUP

	mov	eax,EXE_STACK		; adjust ESP for new base of stack
        mov	ebx,DGROUP
        sub	eax,ebx
        shl	eax,4
        add	esp,eax

        sti

	pop	psp_sel

	push	ebp			; push target CS:EIP in 32bit code
        db	66h,68h
        dd	offset start32

	db	66h			; 32bit RETF to 32bit code
        retf

PMODE_TEXT      ends

public	$zerosel, $pspsel, $aliassel
extrn   main32:near

_TEXT           segment byte public use32 'CODE'
assume  cs:_TEXT

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
start32:

; initialize selector for linear address 00000000h
	mov	cx,1			; allocate 1 descriptor
	xor	ax,ax
	int	31h

	mov	bx,ax			; BX = descriptor allocated
	mov	zero_sel,ax

	mov	dx,0ffffh		; set size to 4G
	mov	cx,dx
	mov	ax,8
	int	31h

	xor	edx,edx			; base address = 00000000h
	mov	ecx,edx
	mov	ax,7
	int	31h

	call	main32			; call main code

	mov	ah,4Ch			; exit to DOS
	int	21h

$zerosel:
	mov	ax,zero_sel
	ret

$pspsel:
	mov	ax,psp_sel
	ret

$aliassel:
	jmp	[alias_proc]
get_alias:
	mov	alias_proc,offset @curseg:alias2ax
	push	ebx
	mov	bx,cs
	mov	ax,0Ah
	int	31h
	pop	ebx
	mov	alias_sel,ax
alias2ax:
	mov	ax,alias_sel
	ret

@curseg	ends

public	zero_sel, psp_sel

_DATA           segment dword public use32 'DATA'
zero_sel	dw ?
psp_sel		dw ?
alias_sel	dw ?
alias_proc	dd get_alias

@curseg	ends


EXE_STACK       segment para stack use16 'STACK'
                db      STACKLEN dup(?)
@curseg	ends


; ASM32/DPMI protected mode interface kernel.
; derived from Tran's PMODE 3.0b

.386p
locals
PMODE_TEXT      segment para public use16 'CODE'
assume  cs:PMODE_TEXT, ds:PMODE_TEXT


;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; DATA
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

align 4
dpmiepmode      dd      ?               ; DPMI enter pmode addx


;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
; DETECT/INIT CODE
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
; Get protected mode info
; Out:
;   AX - return code:
;     0000h - successful
;     0001h - no 80386+ detected
;     0002h - system already in protected mode and no VCPI or DPMI found
;     0003h - DPMI - host is not 32bit
;   CF - set on error, if no error:
;     BX - number of paragraphs needed for protected mode data (may be 0)
;     CL - processor type:
;       03h - 80386
;       04h - 80486
;       05h - 80586
;       06h-FFh - reserved for future use
;     CH - protected mode type:
;       00h - raw
;       01h - XMS
;       02h - VCPI
;       03h - DPMI
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
_pm_info:
        push dx si di ds es bx cx       ; preserve registers

	push	cs			; DS = CS (PMODE_TEXT)
	pop	ds

	mov	ax,1687h		; check for DPMI
	int	2fh
	test	ax,ax			; DPMI present?
	mov	ax,2			; no DPMI error code
	jnz	short @@infofail

	mov	ax,3			; error code in case DPMI not 32bit
	test	bl,1			; is DPMI 32bit?
	jz	@@infofail		; if no, fail

        mov ax,1                        ; error code in case no processor 386+
        cmp cl,3                        ; is processor 386+?
        jb @@infofail                   ; if no, fail

        mov word ptr dpmiepmode[0],di   ; store DPMI initial mode switch addx
        mov word ptr dpmiepmode[2],es

        mov bx,si                       ; BX = number of paragraphs needed
        mov ch,3                        ; pmode type is 3 (DPMI)

        add sp,4                        ; skip BX and CX on stack
        xor ax,ax                       ; success code, also clear carry flag
	jmp	short @@infodone

;-----------------------------------------------------------------------------
@@infofail:
        pop cx bx                       ; restore BX and CX
        stc                             ; carry set, failed
        jmp short @@infodone

;-----------------------------------------------------------------------------
@@infodone:
        pop es ds di si dx              ; restore other registers
        retf                            ; return


;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
; Initialize protected mode
; In:
;   ES - real mode segment for protected mode data (ignored if not needed)
; Out:
;   AX - return code:
;     0000h - successful
;     0001h - no 80386+ detected
;     0002h - system already in protected mode and no VCPI or DPMI found
;     0003h - DPMI - host is not 32bit
;     0004h - could not enable A20 gate
;     0005h - DPMI - could not enter 32bit protected mode
;     0006h - DPMI - could not allocate needed selectors
;   CF - set on error, if no error:
;     ESP - high word clear
;     CS - 16bit selector for real mode CS with limit of 64k
;     SS - selector for real mode SS with limit of 64k
;     DS - selector for real mode DS with limit of 64k
;     ES - selector for PSP with limit of 100h
;     FS - 0 (NULL selector)
;     GS - 0 (NULL selector)
;°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°
_pm_init:
        push bx cx                      ; get initial info on protected mode
	push	cs
        call	near ptr _pm_info
        pop cx bx
        jnc short @@initf0              ; error?

        retf                            ; yup, abort

@@initf0:                               ; no error, init protected mode
        pushad
        push ds
        mov bp,sp
        push cs                         ; DS = PMODE_TEXT
        pop ds
        cld

;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
; DPMI protected mode init
;ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ
        pop ds                          ; get original caller DS from stack
        mov ax,1                        ; enter DPMI protected mode
        call cs:dpmiepmode
        push ds                         ; put DS back onto stack
        jnc short dvxr_init             ; error? if not, go on with init

        mov bx,6                        ; error entering protected mode, set
        cmp ax,8011h                    ;  error code and abort
        stc
        je short init_done
        mov bl,5                        ; error code 5, not 6

;-----------------------------------------------------------------------------
init_done:                              ; return with return code
        mov [bp+30],bx
        pop ds
        popad
        retf

;ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dvxr_init:                              ; DPMI/VCPI/XMS/raw common init tail
        mov bx,cs                       ; BX = CS if needed for same seg exit
        cmp word ptr [bp+36],@curseg	; call came from same segment?
        je short @@dvxr_initdone        ; if yes, done now

        xor ax,ax                       ; allocate selector for return code
        mov cx,1
        int 31h
        jnc short @@dvxr_initf0

        mov ah,4ch                      ; could not allocate selector
        int 21h                         ; terminate immediately

@@dvxr_initf0:
        mov bx,ax                       ; new code descriptor for return

        mov ax,0007h                    ; set base address of calling segment
        xor cx,cx
        mov dx,[bp+36]
        shld cx,dx,4
        shl dx,4
        int 31h

        mov ax,0008h                    ; set selector limit of 64k
        xor cx,cx
        mov dx,0ffffh
        int 31h

        mov ax,0009h                    ; set selector type and access rights
        mov dx,cs                       ; get DPL from current CPL, and access
        lar cx,dx                       ;  rights and type from current CS
        shr cx,8                        ; type is already 16bit code segment
        int 31h

@@dvxr_initdone:
        mov [bp+36],bx                  ; store selector in return address
        xor bx,bx                       ; init successful, carry clear
        jmp init_done


@curseg	ends

;
; mark the end of the program
;
ZSEG	segment para use16 'ZSEG'
copyright	db 0Dh,0Ah
		db 'ASM32/DPMI Copyright (C) 1995 Douglas Herr'
		db 0Dh,0Ah
@curseg	ends

	end	start
