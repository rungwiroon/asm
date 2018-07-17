;----------------------------------------------------------------------
;show bmp function
;input : bmp_x, bmp_y, gpw1 is width, gpw2 is hight, si point to array
;----------------------------------------------------------------------
BMP	PROC
	PUSHX	<AX,CX,DX,SI,bx>	
	xor	di,di

	MOV	CX,bmp_Y
	SUB	CX,1
	MOV	DI,bmp_X
findbmpy:
	ADD	DI,320D	
	LOOP	findbmpy

	mov	cx,gpw2
fillhigh:	
	mov	dx,gpw1
	fillwide:
		mov	bl,[si]
		cmp	bl,36d
		je	transparentcolor
		push	ds
		mov	ax,0a000h
		mov	ds,ax
		mov	[di],bl			
		pop	ds
		transparentcolor:
		inc	di	
		inc	si	
	dec	dx
	jnz	fillwide

add	di,320
sub	di,gpw1	
loop	fillhigh

	POPX	<bx,SI,DX,CX,AX>
RET
BMP	ENDP


clrBMP	PROC
	PUSHX	<AX,CX,DX,SI,bx>	
	xor	di,di

	MOV	CX,bmp_Y
	SUB	CX,1
	MOV	DI,bmp_X
findclrbmpy:
	ADD	DI,320D	
	LOOP	findclrbmpy

	mov	cx,gpw2
clrfillhigh:	
	mov	dx,gpw1
	clrfillwide:
		mov	bl,[si]
		push	ds
		mov	ax,0a000h
		mov	ds,ax
		cmp	[di],bl
		jz	skip
		mov	bl,0
		mov	[di],bl
	skip:
		pop	ds
		inc	di	
		inc	si	
	dec	dx
	jnz	clrfillwide

add	di,320
sub	di,gpw1	
loop	clrfillhigh

	POPX	<bx,SI,DX,CX,AX>

RET
clrBMP	ENDP




;----------------------------------------------------------------------
;show bmp function
;input : bmp_x, bmp_y, gpw1 is width, gpw2 is hight, si point to array
;----------------------------------------------------------------------
loadpic	PROC
	PUSHX	<AX,CX,DX,SI,bx,di>	
	xor	di,di
	
	mov	dx,si
	mov	ax,3d00h
	int	21h
	mov	bx,ax
	mov	filehandle,ax

	
	MOV	CX,bmp_Y
	SUB	CX,1
	MOV	di,bmp_X
findpicy:
	ADD	di,320D	
	LOOP	findpicy

	mov	cx,gpw2
fillpichigh:	
	mov	dx,gpw1
	fillpicwide:
		pushx	<cx,dx,ax>
		mov	ax,3f00h
		mov	bx,filehandle
		mov	cx,1
		lea	dx,byte_buffer
		int	21h
		popx	<ax,dx,cx>

		mov	bl,byte_buffer
		cmp	bl,36d
		je	transparentcolorpic
		push	ds
		mov	ax,0a000h
		mov	ds,ax
		mov	[di],bl			
		pop	ds
		transparentcolorpic:
		inc	di	
	dec	dx
	jnz	fillpicwide
add	di,320
sub	di,gpw1	
loop	fillpichigh
	mov	bx,filehandle
	mov	ax,3e00h
	int	21h
	POPX	<di,bx,SI,DX,CX,AX>
RET
loadpic	ENDP
