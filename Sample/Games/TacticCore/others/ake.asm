title
.model	small
.stack	100h
.data
BMP_WIDTH	DW 	?
BMP_HEIGHT	DW 	?
BMP_BUFFER	DB 	4 DUP(0)
BMP_COUNT	DW 	?
BMP_X		DW 	?
BMP_Y		DW 	?
	namePicture1	db 'ake.bmp',0
	namePicture2	db 'ake2.bmp',0
.code
main	proc
	mov	ax,@data
	mov	ds,ax
	MOV 	AH,00H		;function 0(set screen mode)
	MOV 	AL,13H		;mode 13(320*200:256 colors)
	INT 	10H
@begin:

	mov	bmp_x,20
	mov	bmp_y,30
	lea	si,namePicture1
	call	loadbmp



	mov	bmp_x,10
	mov	bmp_y,0
	lea	si,namePicture2
	call	loadbmp
	
	mov	ah,7
	int	21h

@end:
	MOV	AX,0003H	;function graphic mode 3
	INT	10H
	mov	ah,4ch
	int	21h
main	endp
	include	loadbmp.asm
	include	outdec.asm
	end