;	All Function Graphics Open Mode 13h
;	Modifie by Meff@CS20
.data
	Screen	dw 0a000h
	tempX	dw ?
	tempY	dw ?
	tempC	db ?
	count	dw 0
	bufferPal	db 4 dup(?)
	errorFile	db 13,10,"File target is bad.$"

;	waring ES:DI cannot change.
initGraph		macro
	xor	ah,ah	; Video Function 00h
	mov	al,13h
	int	10h	; Init Video mode 13h
	mov	es,Screen
	xor	di,di
	endm

closeGraph	macro
	mov	ax,03h
	int	10h
	endm
setPal		macro	filePal
	local	for,next
	mov	count,0

	mov	dx,offset filePal
	mov	ah,3dh
	mov	al,0
	int	21h
	jnc	next
	mov	ah,4ch
	int	21h

	next:
	mov	bx,ax

	for:
	mov	ah,3fh
	mov	cx,4
	mov	dx,offset bufferPal
	int	21h

	push	bx
	mov	bx,count
	mov	[bufferPal+3],4
	xor	ax,ax
	mov	al,[bufferPal+1]
	div	[bufferPal+3]
	mov	ch,al
	mov	al,[bufferPal+0]
	div	[bufferPal+3]
	mov	ch,al
	mov	al,[bufferPal+2]
	div	[bufferPal+3]
	mov	dh,al
	mov	ax,1010h
	int	10h
	inc	count
	pop	bx
	cmp	count,256
	jnge	for
	endm


putpixel		macro	_x, _y, _color
	push	ax		;Save Register AX		
	xor	di,di		;Clear
	add	di,_x		;	di = di + _x

	mov	ax,_y		;	ax = _y
	shl	ax,6		;	ax = _y * 64
	add	di,ax		;	di = di + ax
	shl	ax,2		;	ax = ax * 4
	add	di,ax		;result	di to pixel screen
			
	mov	es:[di],_color	;put Color on screen x,y
	pop	ax		;Get AX old value
	endm


