	name	clean
	page	55,132
	title	'CLEAN --- Filter text file'

;
; CLEAN --- a utility to filter text files.
; This program removes all control codes except
; for line feeds, carriage returns, and form
; feeds, strips off the high bit of all characters,
; and expands tabs.  Can be used to make a Wordstar
; file acceptable for other screen or line editors,
; and vice versa.
;
; version 1.1    10 Dec 83  Blocking/deblocking 
; version 1.0    25 Nov 83
;
; Copyright (c) 1983 by Ray Duncan

cr	equ	0dh		;ASCII carriage return
lf	equ	0ah		;ASCII line feed
ff	equ	0ch		;ASCII form feed
eof	equ	01ah		;End of file marker
tab	equ	09h		;ASCII tab character

command	equ	80h		;buffer for command tail

blksize	equ	1024		;blocking/deblocking size


cseg	segment	para public 'CODE'

	assume	cs:cseg,ds:data,es:data,ss:stack


clean	proc	far		;entry point from PC-DOS

	push	ds		;save DS:0000 for final
	xor	ax,ax		;return to PC-DOS
	push	ax
	mov	ax,data		;make our data segment
	mov	es,ax		;addressable via ES register
	call	infile		;get path and file spec.
				;for input file
	mov	ax,es		;set DS=ES for remainder
	mov	ds,ax		;of program
	jnc	clean1		;jump, got acceptable name
	mov	dx,offset msg4	;missing or illegal filespec,
	jmp	clean9		;print error message and exit.

clean1:	call	outfile		;set up output file name
	call	open_input	;now try to open input file
	jnc	clean2		;jump,opened input ok
	mov	dx,offset msg1	;open of input file failed,
	jmp	clean9		;print error msg and exit.

clean2:
	call	open_output	;try to open output file.
	jnc	clean25		;jump,opened ok
	mov	dx,offset msg2	;open of output file failed,
	jmp	clean9		;print error message and exit.

clean25:			;set up buffers
	call	init_buffs
	call	sign_on		;print ident and file names
 
				;files successfully opened,		
clean3:				;now filter the file.  
	call	get_char	;read 1 character from input.
	and	al,07fh		;strip off the high bit
	cmp	al,20h		;is it a control code?
	jae	clean4		;no,write it to new file	
				;yes it is control code,
	cmp	al,eof		;is it end of file marker?
	je	clean6		;yes,jump to close files.
	cmp	al,tab		;is it a tab command?
	jz	clean5		;yes,jump to special processing.
	cmp	al,cr		;if control code other than
	je	clean35		;tab or end-of-file mark, throw 
	cmp	al,ff		;it away unless it is a 
	je	clean35		;form feed, carriage return,
	cmp	al,lf		;or line feed.
	jne	clean3		
clean35:			;If it is one of those three,
	mov	column,0	;incidentally initialize
	jmp	clean45		;column count for tab processor.

clean4:				;count alphanumeric chars. sent.
	inc	column

clean45:			;write this character to 
	call	put_char	;output file,
	jnc	clean3		;if CY not set, write was
				;ok so go get next char.
clean47:
	call	close_input	;if CY set, disk is full
	call	close_output	;so close files and exit
	mov	dx,offset msg5  ;with error message.
	jmp	clean9

clean5:				;process tab character
	mov	ax,column	;let DX:AX=column count
	cwd
	mov	cx,8		;divide it by eight...
	idiv	cx
	sub	cx,dx		;remainder is in DX.
	add	column,cx	;update column pointer.
clean55:			;8 minus the remainder 
	push	cx		;gives us the number of
	mov	al,20h		;spaces to send out to
	call	put_char	;move to the next tab position
	pop	cx		;restore space count
	jc	clean47		;jump if disk is full
	loop	clean55
	jmp	short clean3	;get next character 

clean6:				;end of file detected,
	call	put_char	;write end-of-file marker,
	jc	clean47		;jump if disk was full
	call	flush_buffs	;write remaining data to disk
	jc	clean47		;if CY set,disk was full
				;otherwise file was written ok	
	call	close_input	;close input and output 
	call	close_output	;files.
	mov	dx,offset msg3	;addr of success message,

clean9:				;print message and return
	mov	ah,9		;control to PC-DOS
	int	21h
	ret

clean	endp


infile	proc	near		;process name of input file
				;DS:SI <- addr command line	
	mov	si,offset command
				;ES:DI <- addr filespec buffer
	mov	di,offset input_name
	cld
	lodsb			;any command line present?
	or	al,al		;return error status if not.
	jz	infile4
infile1:         		;scan over leading blanks
	lodsb			;to file name
	cmp	al,cr		;if we hit carriage return
	jz	infile4 	;filename is missing.
	cmp	al,20h		;is this a blank?
	jz	infile1		;if so keep scanning.

infile2: 			;found first char of name,
	stosb			;move last char. to output
				;file name buffer. 
	lodsb			;check next character, found
	cmp	al,cr		;carriage return yet?  	
	je	infile3		;yes,exit with success code
	cmp	al,20h		;is this a blank?
	jne 	infile2		;if not keep moving chars.

infile3: 			;exit with carry =0
	clc			;for success flag
	ret

infile4: 			;exit with carry =1
	stc			;for error flag
	ret
infile  endp 

outfile	proc	near		;set up path and file
	cld			;name for output file.
	mov	cx,64		;length to move
	mov	si,offset input_name  ;source addr
	mov	di,offset output_name ;dest addr
	rep movsb		;transfer the string
	mov	di,offset output_name
outfile1:			;scan string looking for
	mov	al,[di] 	;"." marking start of extension
	or	al,al		;or zero byte marking name end.
	jz	outfile2	;if either is found,jump.
	cmp	al,'.'
	je	outfile2	;bump string pointer, loop
	inc	di		;if neither '.' or zero found.
	jmp	outfile1	
outfile2:			;found zero or '.',force the
				;extension of the output file	
				;to '.CLN'
	mov	si,offset outfile_ext
	mov	cx,5
	rep movsb
	ret			;back to caller
outfile endp

open_input proc near		;open input file
				;DS:DX=addr filename
	mov	dx,offset input_name
	mov	al,0		;AL=0 for read only
	mov	ah,3dh		;function 3dh=open
	int     21h		;handle returned in AX,
	mov	input_handle,ax ;save it for later.
	ret			;CY is set if error
open_input endp

open_output proc near		;open output file
				;DS:DX=addr filename
	mov	dx,offset output_name
	mov	al,1		;AL=1 for write	only
	mov	ah,3ch		;function 3ch=MAKE or
	int	21h		;truncate existing file
				;handle returned in AX
	mov	output_handle,ax;save it for later.
	ret			;return CY=true if error
open_output endp

close_input proc near		;close input file
	mov	bx,input_handle ;BX=handle
	mov	ah,3eh
	int	21h
	ret
close_input endp

close_output proc near		;close output file
	mov	bx,output_handle;BX=handle
	mov	ah,3eh
	int	21h
	ret
close_output endp

get_char proc 	near		;get one character from input buffer
	mov	bx,input_ptr
	cmp	bx,blksize
	jne	get_char1
	call	read_block
	mov	bx,0
get_char1:
	mov	al,[input_buffer+bx]
	inc	bx
	mov	input_ptr,bx
	ret
get_char endp	

put_char proc	near		;put one character into output buffer
	mov	bx,output_ptr
	mov	[output_buffer+bx],al
	inc	bx
	mov	output_ptr,bx
	cmp	bx,blksize	;buffer full yet?
	jne	put_char1	;no,jump
	call	write_block	;yes,write the block
	ret			;return CY as status code
put_char1:
	clc			;return CY clear for OK status
	ret
put_char endp

read_block proc near
	mov	bx,input_handle ;read first block of input
	mov	cx,blksize
	mov	dx,offset input_buffer
	mov	ah,3fh
	int	21h
	jnc	read_block1	;jump if no error status
	mov	ax,0		;simulate a zero length read if error
read_block1:			
	cmp	ax,blksize	;was full buffer read in?
	je	read_block2	;yes,jump
	mov	bx,ax		;no, store End-of-File mark
	mov	byte ptr [input_buffer+bx],eof
read_block2:
	xor	ax,ax		;initialize input buffer pointer
	mov	input_ptr,ax	
	ret
read_block endp

write_block proc near		;write blocked output (blksize bytes)
	mov	dx,offset output_buffer
	mov	cx,blksize
	mov	bx,output_handle
	mov	ah,40h
	int	21h
	xor	bx,bx		;initialize pointer to blocking buffer
	mov	output_ptr,bx
	cmp	ax,blksize	;was correct length written?
	jne	write_block1	;no,disk must be full
	clc			;yes,return CY=0 indicating all OK
	ret
write_block1:			;disk is full, return CY =1
	stc			;as error code
	ret
write_block endp

init_buffs proc near
	call	read_block	;read 1st block of input
	xor	ax,ax		;initialize pointer to output
	mov	output_ptr,ax	;output blocking buffer
	ret
init_buffs endp

flush_buffs proc near		;write any data in output buffer to disk
	mov	cx,output_ptr
	or	cx,cx
	jz	flush_buffs1	;jump,buffer is empty
	mov	bx,output_handle
	mov	dx,offset output_buffer
	mov	ah,40h
	int	21h
	cmp	ax,output_ptr	;was write successful?
	jnz	flush_buffs2	;no,jump
flush_buffs1: 
	clc			;yes,return CY=0 for
	ret			;success flag
flush_buffs2:			;disk was full so write failed,
	stc			;return CY=1 as error flag
	ret
flush_buffs endp

sign_on proc	near		;print sign-on message
	mov	dx,offset msg6	;title...
	mov	ah,9
	int	21h
	mov	dx,offset msg7	;input file:
	mov	ah,9
	int	21h
	mov	dx,offset input_name
	call	pasciiz
	mov	dx,offset msg8	;output file:
	mov	ah,9
	int	21h
	mov	dx,offset output_name
	call	pasciiz
	mov	dx,offset msg9
	mov	ah,9
	int	21h
	ret
sign_on	endp

pasciiz	proc	near		;call DX=offset of ASCIIZ string
	mov	bx,dx		;which will be printed on standard output
pasciiz1:
	mov	dl,[bx]
	or	dl,dl
	jz	pasciiz9
	cmp	dl,'A'
	jb	pasciiz2
	cmp	dl,'Z'
	ja	pasciiz2
	or	dl,20h
pasciiz2:
	mov	ah,2
	int	21h
	inc	bx
	jmp	pasciiz1
pasciiz9:
	ret
pasciiz endp

cseg	ends


data	segment	para public 'DATA'

input_name	db	64 dup (0)	;buffer for input filespec
output_name	db	64 dup (0)	;buffer for output filespec	

input_handle	dw	0		;token returned by PCDOS
output_handle	dw	0		;token returned by PCDOS

input_ptr	dw	0		;pointer to input blocking buffer
output_ptr	dw	0		;pointer to output blocking buffer

outfile_ext	db 	'.CLN',0	;extension for filtered file

column		dw	0		;column count for tab processing

msg1		db	cr,lf
		db	'Cannot find input file.'
		db	cr,lf,'$'

msg2		db	cr,lf
		db	'Failed to open output file.'
		db	cr,lf,'$'

msg3		db	cr,lf
		db	'File processing completed'
		db	cr,lf,'$'

msg4		db	cr,lf
		db	'Missing file name.'
		db	cr,lf,'$'

msg5		db	cr,lf
		db	'Disk is full.'
		db	cr,lf,'$'

msg6		db	cr,lf
		db	'Clean Word Processing File'
		db	cr,lf
		db	'Copyright (c) 1983 Laboratory Microsystems Inc.'
		db	cr,lf,'$'

msg7		db	cr,lf,'Input file:   $'

msg8		db	cr,lf,'Output file:  $'

msg9		db	cr,lf,'$'


input_buffer	db	blksize dup (?)	;buffer for deblocking of data
					;from input file

output_buffer	db	blksize dup (?)	;buffer for blocking of data
					;sent to output file

data 	ends	


stack	segment	para stack 'STACK'
	db	64 dup (?)
stack	ends

	end	clean
