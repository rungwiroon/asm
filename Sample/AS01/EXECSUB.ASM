; EXECSUB - execute program from compiled BASIC - requires DOS 2.00
; This version allows one BASIC program to call another
;
; CALL EXECSUB(PROG$,PARM$,FCB1$,FCB2$,RETCD%)
; PROG$ is the program name (e.g. 'command.com')
; PARM$ is the parameter to be passed to the program (e.g. '/c dir *.bas')
; FCB1$ is the first file control block (required by some programs)
; FCB2$ is the second file control block (required by some programs)
; RETCD% is the error return code

	skip equ 2		; 1 for interpretive, 2 for compiled

cseg	segment para public 'code'
public	execsub
execsub proc far

	assume cs:cseg,ds:cseg,ss:nothing,es:nothing

basicds equ 510h
i24ip	equ 90h
i24cs	equ 92h
i1bip	equ 6ch
i1bcs	equ 6eh
i1cip	equ 70h
i1ccs	equ 72h

b24ip	equ 51ah
b24cs	equ 51ch
b1bip	equ 516h
b1bcs	equ 518h
b1cip	equ 512h
b1ccs	equ 514h

	push bp
	mov bp,sp
	jmp p010

stak	equ this byte
	dw 0			; save sp
	dw 0			; save ss

prm1	equ this byte
	dw 0			; environment
prm2	equ this word
	dw 0			; command line - ip & cs
	dw 0
prm3	equ this byte
	dw 0			; default FCB - ip & cs
	dw 0
prm4	equ this byte
	dw 0			; second default FCB - ip & cs
	dw 0

p010:
	xor ax,ax		; get psp
	mov es,ax		; es=0
	mov bx,ds		; save ds
	mov ds,ax		; ds=0
	cli

	push ds:[basicds]	; save basic's ds

	push ds:[i24ip] 	; save int 24h and shadow
	push ds:[b24ip]
	push ds:[b24ip]
	pop ds:[i24ip]

	push ds:[i24cs]
	push ds:[b24cs]
	push ds:[b24cs]
	pop ds:[i24cs]

	push ds:[i1bip] 	; save int 1bh and shadow
	push ds:[b1bip]
	push ds:[b1bip]
	pop ds:[i1bip]

	push ds:[i1bcs]
	push ds:[b1bcs]
	push ds:[b1bcs]
	pop ds:[i1bcs]

	push ds:[i1cip] 	; save int 1ch and shadow
	push ds:[b1cip]
	push ds:[b1cip]
	pop ds:[i1cip]

	push ds:[i1ccs]
	push ds:[b1ccs]
	push ds:[b1ccs]
	pop ds:[i1ccs]

	sti
	mov ds,bx		; restore ds

	mov di,4f2h		; point to dos comm. area
	mov ax,es:[di]		; get psp segment
	mov es,ax
	mov di,2
	mov bx,es:[di]		; get top of memory
	sub bx,ax		; subtract psp
	mov ah,4ah
	int 21h 		; free memory
	jnc p020		; no error
	mov ah,0		; memory error
	jmp p090		; to error control

p020:	mov si,[bp+12]		; point to parm$
	add si,skip
	mov ax,[si]
	mov si,offset prm2	; establish command line
	mov cs:[si],ax
	mov ax,ds
	mov cs:[si+2],ax

	mov si,[bp+10]		; point to fcb1$
	add si,skip
	mov ax,[si]
	mov si,offset prm3
	mov cs:[si],ax
	mov ax,ds
	mov cs:[si+2],ax

	mov si,[bp+8]		; point to fcb2$
	add si,skip
	mov ax,[si]
	mov si,offset prm4	; establish second fcb
	mov cs:[si],ax
	mov ax,ds
	mov cs:[si+2],ax

	push bp 		; save registers
	push ds
	push es
	pushf
	mov si,offset stak	; save stack
	mov cs:[si],sp
	mov cs:[si+2],ss

	mov ah,4bh		; load prog
	mov al,0		; load & execute
	mov si,[bp+14]		; point to prog$
	add si,skip
	mov dx,[si]
	push cs
	pop es
	mov bx,offset prm1	; point to parameter
	int 21h 		; load & execute program
	jnc p050		; no error
	mov ah,1		; set error code
	jmp p060

p050:	mov ax,0		; clear error

p060:	mov bx,cs		; restore stack
	mov ds,bx
	mov si,offset stak
	cli			; no interrupts
	mov sp,cs:[si]
	mov ss,cs:[si+2]
	sti			; allow interrupts

	popf			; restore registers
	pop es
	pop ds
	pop bp

	mov cx,ds		; save ds
	xor bx,bx
	mov ds,bx		; ds=0
	cli

	pop ds:[b1ccs]		; restore int 1ch
	pop ds:[i1ccs]
	pop ds:[b1cip]
	pop ds:[i1cip]

	pop ds:[b1bcs]		; restore int 1bh
	pop ds:[i1bcs]
	pop ds:[b1bip]
	pop ds:[i1bip]

	pop ds:[b24cs]		; restore int 24h
	pop ds:[i24cs]
	pop ds:[b24ip]
	pop ds:[i24ip]

	pop ds:[basicds]	; restore basic's ds
	sti
	mov ds,cx

p090:	mov si,[bp+6]		; point to RETCD%
	mov [si],ax		; return error, if any

	pop bp			; return to caller
	ret 10

execsub endp
cseg	ends
end
