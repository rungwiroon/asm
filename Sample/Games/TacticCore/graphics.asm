;	All Function Graphics Open Mode 13h
;	Modifie by Meff@CS20
.data
	Screen	dw 0a000h
	count	dw 0
	BIN	dw 4 dup(?)
	RGB	db 3 dup(?)
	spriteH	db ?	; Sprite Height
	spriteW	db ?	; Sprite Weidth
	errorFile	db 13,10,"File target is bad.$"

;	waring ES:DI cannot change.
initGraph		macro
	xor	ah,ah	; Video Function 00h
	mov	al,13h
	int	10h	; Init Video mode 13h

	mov	es, Screen
	xor	di, di
	endm

closeGraph	macro
	mov	ax,03h	; Text Mode 3h
	int	10h	
	endm

clearPage	macro	
	local	i
	mov	es, Screen
	xor	di, di
	mov	al, 0
	mov	cx,64000
	i:
	mov	es:[di],al
	inc	di
	loop	i
	endm

setPal		macro	filePal
	local	for,next,exit
	push	ax
	push	bx
	push	cx
	push	dx
	
	mov	ah,3dh	; Function Open file palette
	mov	dx,offset filePal ; File name
	mov	al,0	; Mode Read only
	int	21h	
	jnc	next	; No error to next
	msgErrorFile
	exitErrorGraph
	next:

	mov	bx,ax	; ax and bx is handle
	mov	count,0	; Set Loop Count range 0 - 255
	for:
	mov	ah,3fh	; Function Read file palette
	mov	cx,3	; Read 3 byte from handle
	mov	dx,offset RGB
	int	21h
	
	push	bx

	mov	dx,3c8h	; Set outport 3c8h to target color
	mov	ax,count	; target color
	out	dx,al	
	
	mov	dx,3c9h	; Set outprot 3 time to Red, Green, Blue
	mov	cl,4	; Div

	xor	ax,ax
	mov	al,RGB[0]		; Red Color
	div	cl
	out	dx,al		
	mov	al,RGB[1]		; Green Color
	div	cl
	out	dx,al
	mov	al,RGB[2]		; Blue Color
	div	cl
	out	dx,al

	pop	bx
	inc	count
	cmp	count,256
	jnge	for	; End Loop Count

	mov	ah,3eh	; Close file from handle
	int	21h	; bx is handle

	pop	dx
	pop	cx
	pop	bx
	pop	ax
	endm


putpixel		macro	_x, _y, _color
	push	ax		;Save Register AX
	xor	di, di		;Clear
	add	di, _x		;	di = di + _x
	mov	ax, _y		;	ax = _y
	shl	ax, 6		;	ax = _y * 64
	add	di, ax		;	di = di + ax
	shl	ax, 2		;	ax = ax * 4
	add	di, ax		;result	di to pixel screen
	mov	al,_color	
	mov	es:[di], al	;put Color on screen x,y
	pop	ax		;Get AX old value	pop	ax		;Get AX old value
	endm

getpixel		macro	x, y
	xor	di, di		;Clear
	add	di, _x		;	di = di + _x
	mov	ax, _y		;	ax = _y
	shl	ax, 6		;	ax = _y * 64
	add	di, ax		;	di = di + ax
	shl	ax, 2		;	ax = ax * 4
	add	di, ax		;result	di to pixel screen
	xor	ah,ah
	mov	al,es:[di]	;put Color on screen x,y
	endm

putRectangle		macro	x, y, w, h, color 
	local	i,j
	push	ax
	push	dx
	push	cx

	mov	ax, x
	mov	dx, y
	mov	cx, h
	i:
	push	ax
	push	cx
	mov	cx, w
	j:
	putpixel ax,dx,color
	inc	ax
	loop	j
	pop	cx
	pop	ax
	inc	dx
	loop	i
	
	pop	cx
	pop	dx
	pop	ax
	endm
putSprite		macro	x, y, sprite	; Put Picture in data
	local	i,j,NoPaint
	push	ax
	push	cx
	push	dx
	mov	ax,x
	mov	dx,y
	mov	si,2
	xor	ch,ch
	mov	cl,sprite[1]
	i:
	push	cx
	push	ax
	mov	cl,sprite[0]
	j:
	cmp	sprite[si],0
	je	NoPaint
	putPixel ax,dx,sprite[si]
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

msgErrorFile	macro
	mov	ah,9
	mov	dx,offset errorFile
	int	21h
	endm

exitErrorGraph	macro
	mov	ah,4ch
	int	21h
	endm