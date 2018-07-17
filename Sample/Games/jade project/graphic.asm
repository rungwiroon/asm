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

;--------------- load backgound to bgbufferseg -----------------;
;	input	: si point to offset of background file		;
;---------------------------------------------------------------;

loadbgbuffer	PROC
	PUSHX	<AX,CX,DX,SI,bx,di>	
	xor	di,di
	
	mov	dx,si
	mov	ax,3d00h
	int	21h
	mov	bx,ax
	mov	filehandle,ax

	mov	ax,bgbufferseg
	mov	es,ax

	mov	cx,200
fillbghigh:	
	mov	dx,320
	fillbgwide:
		pushx	<cx,dx,ax>
		mov	ax,3f00h
		mov	bx,filehandle
		mov	cx,1
		lea	dx,byte_buffer
		int	21h
		popx	<ax,dx,cx>

		mov	bl,byte_buffer
		;push	ds
		;mov	ax,0a000h
		;mov	ds,ax
		mov	es:[di],bl			
		;pop	ds

		inc	di	
	dec	dx
	jnz	fillbgwide
loop	fillbghigh
	mov	bx,filehandle
	mov	ax,3e00h
	int	21h
	POPX	<di,bx,SI,DX,CX,AX>
RET
loadbgbuffer	ENDP


;------------ syncvideoram ---------------------------
syncvideo	proc
	pushx	<si,di,cx,ax>
	push	ds

	mov	ax,objbufferseg
	mov	ds,ax
	mov	si,offset objbuffer
	mov	ax,vbufferseg
	mov	es,ax
	mov	di,offset vbuffer

	mov	cx,64000d
loopobjsync:
	mov	al,[si]
	cmp	al,36d
	je	objtransparent
	mov	es:[di],al
	objtransparent:
	inc	si
	inc	di
	loop	loopobjsync

	mov	ax,vbufferseg
	mov	ds,ax
	mov	si,offset vbuffer
	mov	ax,0a000h
	mov	es,ax

	xor	di,di	

	mov	cx,64000d
loopsync:
	mov	al,[si]
	mov	es:[di],al

	inc	si
	inc	di
	loop	loopsync
	pop	ds
	popx	<ax,cx,di,si>
	ret
syncvideo	endp

clrobjbuffer	proc
	pushx	<si,di,cx,ax>
	push	ds

	mov	ax,objbufferseg
	mov	es,ax

	xor	di,di	

	mov	cx,64000d
loopclrobj:
	mov	al,36d
	mov	es:[di],al

	inc	si
	inc	di
	loop	loopclrobj
	pop	ds
	popx	<ax,cx,di,si>
	ret
clrobjbuffer	endp

;---------------------- draw object to objbuffer -------------------------------
;-------------------------------------------------------------------------------
drawobjbuffer	proc
	PUSHX	<AX,CX,DX,SI,bx>	

	mov	ax,objbufferseg
	mov	es,ax

	mov	di,offset objbuffer

	MOV	CX,bmp_Y
	SUB	CX,1
	MOV	DI,bmp_X
findobjy:
	ADD	DI,320D	
	LOOP	findobjy

	mov	cx,gpw2
fillobjhigh:	
	mov	dx,gpw1
	fillobjwide:
		mov	bl,[si]
		cmp	bl,36d
		je	objtransparentcolor
		mov	es:[di],bl			
		objtransparentcolor:
		inc	di	
		inc	si	
	dec	dx
	jnz	fillobjwide

add	di,320
sub	di,gpw1	
loop	fillobjhigh

	POPX	<bx,SI,DX,CX,AX>
	ret
drawobjbuffer	endp

swapvideoram	proc
	pushx	<si,di,cx,ax>
	push	ds
	mov	ax,bgbufferseg
	mov	ds,ax
	mov	si,offset bgbuffer
	mov	ax,vbufferseg
	mov	es,ax
	mov	di,offset vbuffer

	mov	cx,64000d
loopswap:
	mov	al,[si]
	mov	es:[di],al

	inc	si
	inc	di
	loop	loopswap
	pop	ds
	popx	<ax,cx,di,si>
	ret
swapvideoram	endp