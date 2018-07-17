	.model	small
	.data
row	db 12
col	db 40
color	db 2
skip	db 1
help	db 'D: Draw, S: Skip, Move: Arrow Keys, '
	db 'R/G/B: Set Color, Q: Quit $'

	.code
	public	draw
draw	proc	near
	mov	ax,@data
	mov	ds,ax
	mov	es,ax
	mov	ah,0
	mov	al,3
	int	10h
	mov	ah,2
	mov	bh,0
	mov	dh,24
	mov	dl,7
	int	10h
	lea	dx,help
	mov	ah,9
	int	21h
	mov	ah,2
	mov	bh,0
	mov	dh,row
	mov	dl,col
	int	10h

readkey: mov	ah,0
	int	16h
	cmp	al,0
	jz	csc
	cmp	al,'A'
	jc	nolc
	cmp	al,'z'+1
	jnc	nolc
	and	al,0dfh
nolc:	cmp	al,'Q'
	jnz	x1
	jmp	exit

x1:	cmp	al,'R'
	jZ	setred
	cmp	al,'G'
	jz	setgreen
	cmp	al,'B'
	jz	setblue
	cmp	al,'S'
	jz	setskip
	cmp	al,'D'
	jz	setdraw
	jmp	readkey

setred:	mov	color,4
	jmp	readkey
setgreen: mov	color,2
	jmp	readkey
setblue: mov	color,1
	jmp	readkey
setskip: mov	skip,1
	jmp	readkey
setdraw:mov	skip,0
	jmp	readkey

csc:	cmp	ah,48h
	jz	goup
	cmp	ah,50h
	jz	godown
	cmp	ah,4bh
	jz	goleft
	cmp	ah,4dh
	jz	goright
	jmp	readkey
goup:	cmp	row,0
	jnz	goup2
	jmp	readkey
goup2:	sub	row,1
	jmp	setcur
godown: cmp	row,23
	jnz	godown2
	jmp	readkey
godown2:add	row,1
	jmp	setcur
goleft:	cmp	col,0
	jnz	goleft2
	jmp	readkey
goleft2:sub	col,1
	jmp	setcur
goright:cmp	col,79
	jnz	goright2
	jmp	readkey
goright2: add	col,1
setcur:	mov	ah,2
	mov	bh,0
	mov	dh,row
	mov	dl,col
	int	10h
	cmp	skip,1
	jz	noc
	mov	al,0dbh
	mov	bl,color
	mov	cx,1
	mov	ah,9
	int	10h
noc:	jmp	readkey

exit:	;call	q10clr
	ret
	;mov	ah,4ch
	;int	21h
	
draw	endp

	end	draw