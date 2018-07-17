        name    dev
        page    60,132
        title   'DEV --- Report installed device drivers'

; DEV --- a utility to report device header information for
;         all installed device drivers
; 
; Requires PC-DOS or MS-DOS 2.0.
;
; Used in the form:
; A>DEV 
;
; version 1.0   December 12, 1984
; Copyright (c) 1984 by Ray Duncan

cr      equ     0dh             ;ASCII carriage return
lf      equ     0ah             ;ASCII line feed
blank	equ	20h		;ASCII space code
eom	equ	'$'		;end of string marker


cseg	segment	para public 'CODE'

	assume	cs:cseg,ds:data,es:data,ss:stack


dev 	proc    far             ;entry point from PC-DOS

        push    ds              ;save DS:0000 for final
        xor     ax,ax           ;return to PC-DOS
        push    ax
        mov     ax,data         ;make our data segment
	mov	ds,ax		;addressable via DS and ES.
	mov     es,ax 
        mov     ah,30h		;check version of PC-DOS.	
        int     21h
        cmp     al,2
        jae     dev1		;proceed, DOS 2.0 or greater.
        mov     dx,offset msg2  ;DOS 1.x --- print error message.
	jmp	dev6

dev1:	mov	cx,ax		;save DOS version number.
	mov	ah,15		;now try and open the "NUL" device.
	mov	dx,offset nulfcb
	int	21h
	or	al,al		;opened successfully?
	jz	dev2		;yes, jump.
	mov	dx,offset msg1	;no, print error msg and exit.
	jmp	dev6

dev2:				;Pick up double pointer to device 
				;driver chain out of reserved
				;area in fcb.  This area is mapped
				;differently in DOS 2.x and DOS 3.x.
	cmp	cl,2		;is this DOS 2.x?
	ja	dev3		;no, jump.
	mov	bx,word ptr nulfcb+25
	mov	es,word ptr nulfcb+27
	jmp	dev4

dev3:				;come here if DOS 3.0 or greater.
	mov	bx,word ptr nulfcb+26
	mov	es,word ptr nulfcb+28

dev4:	call	header		;print sign-on message and 
				;column headings.

dev5:				;trace through the device chain

	call	prdev		;print device header information
				;for driver pointed to by ES:BX.
				;pick up addr of next header.
	les	bx,dword ptr es:[bx]
	cmp	bx,-1		;found last one yet?
	jne	dev5		;no, try next.
	
      	mov	dx,offset msg3	;yes, print "end of device chain".

dev6: 	mov	ah,9		;print the string whose address
	int	21h		;is in DX.
	ret			;then return to DOS.

dev   	endp


header	proc	near		;print out headings for device
	mov	dx,offset hdr	;driver information.
	mov	ah,9
	int	21h
	ret
header	endp


prdev	proc	near		;print out device driver info.
				;ES:BX is pointer to device header,
				;which must be preserved.
	mov	ax,es		;convert segment of device header
	mov	di,offset inf1
	call	hexasc
	mov	ax,bx		;convert offset of device header.
	mov	di,offset inf2
	call	hexasc
	mov	ax,es:[bx+4]	;get attribute word, save a 
	push	ax		;copy of it, then convert it.
	mov	di,offset inf3
	call	hexasc
	mov	ax,es:[bx+6]	;convert ptr to device strategy.
	mov	di,offset inf4
	call	hexasc
	mov	ax,es:[bx+8]	;convert ptr to device int handler.
	mov	di,offset inf5
	call	hexasc

				;if not char device, clear out name
				;field and set number of units.
	pop	ax		;get back attribute word.
	test	ax,08000h	;is bit 15 = 1 ?
	jnz	prdev7		;yes, it's character dev, jump.
	              		;no, it's block device.
				;set flag to skip device name.
	mov 	byte ptr inf8,eom
	mov	al,es:[bx+10]	;pick up number of units.
	aam			;convert to ASCII decimal and
	add	ax,'00'		;store into output string.
	mov	byte ptr inf7+1,al
	mov	byte ptr inf7,ah
				;set type = B for Block
	mov	byte ptr inf6,'B'	
	jmp	prdev9

prdev7:				;if char device, move its 8-character
				;name into the output string.
	xor	si,si
prdev8:	mov	al,es:[si+bx+10]
	mov	[si+inf8],al
	inc	si
	cmp	si,8
	jne	prdev8
				;remove # of units field.
	mov	word ptr inf7,'  '
				;set type = C for Character.
	mov	byte ptr inf6,'C'

prdev9: mov	dx,offset inf	;now print device information
	mov	ah,9		;and exit.
	int	21h
	ret
prdev	endp

hexasc	proc	near		;convert binary word to hex ASCII.
				;call with AX=binary value
				;          DI=addr to store string 
				;returns AX, CX, DI destroyed.
	push	ax		;save copy of original value.
	mov	al,ah
	call	btoa		;convert upper byte.
	add	di,2		;increment output address.
	pop	ax
	call	btoa		;convert lower byte.
	ret			;return to caller.
hexasc	endp

btoa	proc	near		;convert binary byte to hex ASCII.
				;call with AL=binary value 
				;          DI=addr to store string
				;returns AX, CX destroyed.
	mov	ah,al		;save lower nibble.
	mov	cx,4		;shift right 4 positions
	shr	al,cl		;to get upper nibble.
	call	ascii		;convert 4 bits to ASCII equivalent
	mov	[di],al		;store into output string.
	mov	al,ah		;get back lower nibble.
	and	al,0fh
	call	ascii		;convert 4 bits to ASCII
	mov     [di+1],al	;and store into output string.
	ret			;back to caller.
btoa	endp

ascii	proc	near		;convert 4 lower bits of AL
	add	al,'0'		;into the equivalent ASCII char.
	cmp	al,'9'		;in the range {0...9,A...F}
	jle	ascii2		;and return char. in AL.
	add	al,'A'-'9'-1	;"fudge factor" for range A-F.
ascii2:	ret			;return to caller.
ascii	endp

cseg    ends


data    segment para public 'DATA'

msg1	db	cr,lf
	db	'Failed to open NUL device.'
	db	cr,lf,eom

msg2    db      cr,lf
        db      'Requires DOS version 2 or greater.'
        db      cr,lf,eom

msg3	db	cr,lf
	db	'End of device chain.'
	db	cr,lf,eom

hdr	db	cr,lf
	db	'Addr      Attr '
	db	'Str  Int   Type  Units  Name   '
	db	eom


inf 	db	cr,lf
inf1	db	'XXXX:'		;seg device header
inf2	db	'XXXX '		;offs device header
inf3	db	'XXXX '		;attribute
inf4	db	'XXXX '		;strategy
inf5	db	'XXXX   '	;interrupt handler
inf6	db	'X     '	;type (block or char)
inf7	db	'XX    '	;units (if block device)
inf8	db	'         '	;name  (if char device)
	db	eom

				;fcb to open NUL device
nulfcb	db	0		;drive
	db	'NUL'		;name of NUL device
	db	8 dup (' ')
	db	25 dup (0)
data    ends    


stack   segment para stack 'STACK'
        db      64 dup (?)
stack   ends

        end     dev
