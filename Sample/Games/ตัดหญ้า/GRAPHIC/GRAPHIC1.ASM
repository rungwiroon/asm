;=========================================================
;load bmp imgae file to buffer segment
;Input : AX point to buffer segment
;Output : Data in buffer
;=========================================================
BMP	PROC
	PUSHA	
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

	POPA
RET
BMP	ENDP

;---------------------- draw object to objbuffer -------------------------------
;-------------------------------------------------------------------------------
drawobjbuffer	proc
	PUSHA	

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

	POPA
	ret
drawobjbuffer	endp

;----------------------------------------------------------------------
;show bmp function
;input : bmp_x, bmp_y, gpw1 is width, gpw2 is hight, si point to array
;----------------------------------------------------------------------
objbufferloadpic	PROC
	PUSHA		
	xor	di,di
	
	mov	dx,si
	mov	ax,3d00h
	int	21h
	mov	bx,ax
	mov	filehandle,ax

	mov	ax,objbufferseg
	mov	es,ax
	lea	di,objbuffer

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
		pushA
		mov	ax,3f00h
		mov	bx,filehandle
		mov	cx,1
		lea	dx,byte_buffer
		int	21h
		popA

		mov	bl,byte_buffer
		cmp	bl,36d
		je	transparentcolorpic
		mov	es:[di],bl	
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

	POPA
RET
objbufferloadpic	ENDP


;--------------- load backgound to bgbufferseg -----------------;
;	input	: si point to offset of background file		;
;---------------------------------------------------------------;

loadbgbuffer	PROC
	PUSHA	
	xor	di,di
	
	mov	dx,si 	 ;dx = input	
	mov	ax,3d00h ;1 open file
	int	21h	 ;end 1
	mov	bx,ax	 
	mov	filehandle,ax ; filehandle = var

	mov	ax,bgbufferseg
	mov	es,ax

	mov	cx,200
fillbghigh:	
	mov	dx,320
	fillbgwide:
		pushA
		mov	ax,3f00h
		mov	bx,filehandle
		mov	cx,1
		lea	dx,byte_buffer
		int	21h
		popA
		mov	bl,byte_buffer
		mov	es:[di],bl
		inc	di	
	dec	dx
	jnz	fillbgwide
loop	fillbghigh
	mov	bx,filehandle
	mov	ax,3e00h
	int	21h
	POPA
RET
loadbgbuffer	ENDP


;------------ syncvideoram ---------------------------
syncvideo	proc
	pushA
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
	popA
	ret
syncvideo	endp

clrobjbuffer	proc
	pushA
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
	popA
	ret
clrobjbuffer	endp


swapvideoram	proc
	pushA
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
	popA
	ret
swapvideoram	endp