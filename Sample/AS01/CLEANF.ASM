	name	cleanf
	page	55,132
	title	'CLEANF - Filter text file'
;
; CLEANF - a DOS 2.0 filter for word processing document files.
; 
; CLEAN.ASM Originally written by Ray Duncan
; Converted to DOS 2.0 filter CLEANF.ASM by Bob Taylor.
;
; This program reads text from the standard input device and writes
; filtered and transformed text to the standard output device.
; 
;	1.  High bit of all characters is stripped off.
; 	2.  Tabs are expanded.
;       3.  Removes all control codes except for line
;           feeds, carriage returns, and form feeds.
;       4.  Appends an end-of-file mark to the text, if
;           none was present in the input stream.
;
; Can be used to make a WordStar file acceptable for 
; other screen or line editors, and vice versa.
;
;
cr	equ	0dh		; ASCII carriage return
lf	equ	0ah		; ASCII line feed
ff	equ	0ch		; ASCII form feed
eof	equ	01ah		; End-of-file marker
tab	equ	09h		; ASCII tab code

command	equ	80h		; buffer for command tail

; DOS 2.0 Pre-Defined Handles

stdin	equ	0000		; standard input file
stdout	equ	0001		; standard output file
stderr	equ	0002		; standard error file
stdaux	equ	0003		; standard auxilliary file
stdprn	equ	0004		; standard printer file

cseg	segment para public 'CODE'

	assume	cs:cseg,ds:cseg

	org	100H		; start .COM at 100H

clean	proc	far		; entry point from PC-DOS.
	push	ds		; push a long return back
	xor	ax,ax		; to DOS onto the stack.
	push	ax

clean3:	call	get_char	; get a character from input.
	and	al,7fh		; turn off the high bit.
	cmp	al,20h		; is it a control char?
	jae	clean4		; no.  write it to output.
	cmp	al,eof		; is it end of file?
	je	clean6		; yes, go write EOF mark and exit.
	cmp	al,tab		; is it a tab?
	je	clean5		; yes, go expand it to spaces.
	cmp	al,cr		; is it a carriage return?
	je	clean35		; yes, go process it.
	cmp	al,lf		; is it a line feed?
	je	clean35		; yes, go process it.
	cmp	al,ff		; is it a form feed?
	jne	clean3		; no. discard it.  
clean35:
	mov	column,0	; if it's a legit ctrl char,
	jmp	clean45		;  we should be back at column 0.

clean4:	inc	column		; if it's a non-ctrl char, 
clean45:			;  col = col + 1.
	call	put_char	; write the char to output.
	jnc	clean3		; if OK, go back for another char.

	mov	bx,stderr	; not OK.  Set up to show error.
	mov	dx,offset err_msg
	mov	cx,err_msg_len	; error = Disk full.
	mov	ah,40h		; write the error message
	int	21h		; to the standard error device. (CON:)
	ret			; back to DOS.

clean5:	mov	ax,column	; tab code detected, must expand 
	cwd			; expand tabs to spaces.
	mov	cx,8		; divide the current column counter
	idiv	cx		; by eight...
	sub	cx,dx		; eight minus the remainder is the 
	add	column,cx	; number of spaces to send out to
clean55:			; move to the next tab position.
	push	cx
	mov	al,20h
	call	put_char	; send an ASCII blank
	pop	cx
	loop	clean55
	jmp	clean3

clean6:	call	put_char	; write out the EOF mark,
	ret			; and return to DOS.

clean	endp


get_char proc near
	mov	bx,stdin		; get chars from std. input
	mov	cx,1			; # of chars to get = 1
	mov	dx,offset input_buffer	; location = input_buffer
	mov	ah,3fh
	int	21h			; do the function call
	or	ax,ax			; test # of chars returned
	jz	get_char1		; if none, return EOF
	mov	al,input_buffer		; else, return the char in AL
	ret
get_char1:
	mov	al,eof			; no chars read, return 
	ret				; an End-of-File (EOF) mark.
get_char endp

put_char proc near
	mov	output_buffer,al	; put char to write in buffer.
	mov	bx,stdout		; write to std. output
	mov	cx,1			; # of chars = 1
	mov	dx,offset output_buffer	; location = output_buffer
	mov	ah,40h
	int	21h			; do the function call
	cmp	ax,1			; check to see it was really done.
	jne	put_char1
	clc				; really done. return carry = 0
	ret				; as success signal.
put_char1:
	stc				; not really done. return carry = 1
	ret				; as error signal (device is full).
put_char endp

input_buffer	db	0		
output_buffer	db	0

column		dw	0

err_msg		db	cr,lf
		db	'clean: Disk is full.'
		db	cr,lf
err_msg_len	equ	(this byte)-(offset err_msg)

cseg	ends

	end	clean


