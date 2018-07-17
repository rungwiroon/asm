extrn	mouseX:word
extrn	mouseY:word
public	SelectX
public	SelectY
public	floorX
public	floorY
public	drawMap
public	check
title 
.model	small
.386

.stack	100h
.data
HeightB	db 0
WidthB	db 0
map	db  0
check	db  0
SelectX	db 0
SelectY	db 0
floorX	dw 0
floorY	dw 0
floor1	db  25, 15
	db 0,0,0,0,0,0,0,0,0,110,111,111,5,5,111,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,110,109,109,107,107,109,109,107,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,108,108,107,107,107,108,108,108,108,108,109,0,0,0,0,0,0,0
	db 0,0,0,0,0,107,106,107,106,107,107,106,107,106,107,107,106,108,110,106,0,0,0,0,0
	db 0,0,0,106,107,107,106,107,108,106,107,105,105,107,107,108,108,107,107,108,109,0,0,0,0
	db 0,0,109,106,107,107,107,107,107,105,106,107,106,105,105,106,107,106,107,108,108,108,106,0,0
	db 106,109,107,107,107,107,107,105,106,107,105,107,105,107,105,107,105,106,107,107,108,107,107,108,0
	db 5,5,109,107,108,108,106,107,106,105,106,107,106,107,106,107,106,107,107,108,108,106,107,109,109
	db 109,5,111,109,108,107,107,107,108,106,107,105,105,105,107,106,107,108,107,107,107,109,108,109,109
	db 0,0,111,111,109,109,108,107,106,108,107,106,107,106,107,107,107,107,108,109,109,110,109,108,0
	db 0,0,0,107,109,5,111,109,108,107,108,108,107,107,107,108,109,109,109,111,109,107,0,0,0
	db 0,0,0,0,0,107,109,111,1,109,109,109,108,108,108,109,111,239,109,107,0,0,0,0,0
	db 0,0,0,0,0,0,0,107,109,6,1,111,111,5,5,5,109,108,107,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,108,109,6,1,5,1,109,108,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,107,108,109,5,109,107,0,0,0,0,0,0,0,0,0
floor2	db  25, 15
	db 0,0,0,0,0,0,0,0,0,0,0,78,163,231,231,165,8,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,163,231,74,0,12,163,231,163,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,8,8,0,0,0,77,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,12,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,8,165,231,164,0,0,0,0,0,0,0,0,0,0,0,0,0,231,163,11,0,0
	db 0,0,75,231,164,126,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,165,231,166,8
	db 12,127,165,125,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,127,231,163
	db 5,12,163,231,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,165
	db 109,0,0,163,231,165,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,164,231
	db 0,0,0,0,12,163,231,0,0,0,0,0,0,0,0,0,0,0,0,0,0,164,231,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,77,0,0,0,0,0,0,75,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,163,231,164,8,0,0,77,231,163,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,164,231,76,163,231,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,8,0,163,231,164,0,0,0,0,0,0,0,0,0,0
include	graphics.asm

putSpriteSelect		macro	x, y, sprite
	local	i,j,NoPaint
	push	ax
	push	cx
	push	dx
	mov	ax,x
	mov	dx,y
	mov	si,2
	xor	ch,ch
	mov	cl,[sprite+1]
	i:
	push	cx
	push	ax
	mov	cl,[sprite+0]
	j:
	cmp	[sprite+si],0
	je	NoPaint
	putPixel ax,dx,[sprite+si]
	cmp	check,0		; Check mouse Select
	jne	NoPaint
	cmp	mouseX,ax
	jne	NoPaint
	cmp	mouseY,dx
	jne	NoPaint
	mov	check,1
	jmp	NoPaint

	NoPaint:
	inc	ax
	inc	si
	loop	j
	pop	ax
	pop	cx
	inc	dx
	loop	i
	pop	dx
	pop	cx
	pop	ax
	endm
.code
drawMap	proc	far
	push	ax
	push	bx
	push	cx
	push	dx
	
	mov	check,0
	mov	ax,120	; Set Map X
	mov	dx,50	; Set Map Y
	mov	ch,0	; Set Height Map
LoopY:
	push	ax
	push	dx
	mov	cl,0	; Set Width Map
LoopX:
	putSpriteSelect ax,dx,floor1
	cmp	check,1
	jne	Next
	mov	check,2	; this check = 2 beacuse putSpriteSelect use check
	call	saveStatus
	putSpriteSelect ax,dx,floor2
Next:
	add	ax,15
	add	dx,8
	inc	cl
	cmp	cl,8
	jne	LoopX
	
	pop	dx
	pop	ax
	sub	ax,15
	add	dx,8
	inc	ch
	cmp	ch,8
	jne	LoopY

	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret
drawMap	endp
saveStatus	proc
	mov	SelectX,cl
	mov	SelectY,ch
	mov	floorX,ax
	mov	floorY,dx
	ret
saveStatus	endp
	end
