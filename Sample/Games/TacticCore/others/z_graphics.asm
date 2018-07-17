;	All Function Graphics Open Mode 13h
;	Modifie by Meff@CS20
.data
	Screen	dw 0a000h
	tempX	dw ?
	tempY	dw ?
	tempC	db ?

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

setPal		macro	
	local	for
	mov     dx,3C8h                 ; Set the Shaded Palette.
        xor     al,al
        out     dx,al
	mov	cx,0
	mov	dx,3c9h
	for:
	rept	3	
	mov	al,cl
	out	dx,al
	endm
	inc	cx
	cmp	cx,256
	jne	for
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


