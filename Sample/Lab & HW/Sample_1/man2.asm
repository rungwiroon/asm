	.model small
	.stack 64h
	.data 
toprow1	db	25
botrow1	EQU	05
col1	DB	00
row1	DB	00
lefcol1	DB	?
count1	db	?
lines1	db	?

man1			 db      '   rrrrrrrrrrrr    '
						db      '  rrrrrrrrrrrrrrr  '
	db      '  rrr        rrrr  '
							db      '  rrr        rrrr  '
		db      '  rrrrrrrrrrrrrrr  '
				db      '  rrrrrrrrrrrrrrr  '
					db      '  rrr      rrrr    '
	db      '  rrr       rrrr   '
				db      '  rrr        rrrr  '
	
man2					db      '  uuu         uuu  '
	db      '  uuu         uuu  '
						db      '  uuu         uuu  '
				db      '  uuu         uuu  '
	db      '  uuu         uuu  '
					db      '  uuu         uuu  '
					db      '  uuu         uuu  '
	db      '  uuuuuuuuuuuuuuu  '
					db      '   uuuuuuuuuuuuu   '
	
man3			db      '  nnnn        nnn  '
			db      '  nnnnn       nnn  '
						db      '  nnnnnn      nnn  '
	db      '  nnn  nnn    nnn  '
					db      '  nnn   nnn   nnn  '
		db      '  nnn    nnn  nnn  '
				db      '  nnn      nnnnnn  '
	db      '  nnn       nnnnn  '
					db      '  nnn        nnnn  '
	
man4					db      '    ggggggggggg    '
		db      '   ggggggggggggg   '
	db      '  ggg         ggg  '
			db      '  ggg              '
					db      '  ggg       ggggg  '
	db      '  gggg        ggg  '
				db      '   ggg        ggg  '
		db      '    ggggggggggggg  '
						db      '     ggggggggg  g  '
	
	.code
	public	rung
extrn	delay:near
rung	proc	near
	
	call	q10clr
	call	screen
	mov	toprow1,25
	ret
	
rung	endp

screen	proc	near
moverow: mov	cx,34	
nextmove: push	cx
;----------------------------
	mov	lefcol1,05
	lea	si,man1
	call	print	
;----------------------------
	lea	si,man2
	mov	lefcol1,21
	call	print
;----------------------------
	mov	lefcol1,40
	lea	si,man3
	call	print
;----------------------------
	lea	si,man4
	mov	lefcol1,59
	call	print
;-----------------------------
	call	delay
;-----------------------------
	call	q10clr
;----------------------------
	dec	toprow1
	pop	cx
	loop	nextmove
	ret
screen	endp	
	
print	proc	near
	mov	dl,toprow1
	mov	row1,dl
	mov	lines1,09
b20:	mov	dl,lefcol1
	mov	col1,dl
	mov	count1,19

b30:	call	q20curs
	mov	ah,09
	mov	al,[si]
	mov	bh,0;;;;;;
	mov	bl,0bh
	mov	cx,01
	int	10h
	inc	col1
	inc	si
	dec	count1
	jnz	b30
	inc	row1
	dec	lines1
	jnz	b20
	ret	
print	endp

q20curs	proc	near
	mov	ah,02
	mov	bh,0;;;;;;;;;
	mov	dh,row1
	mov	dl,col1
	int	10h
	ret
q20curs	endp

q10clr	proc	near
	mov	ax,0600h
	mov	bh,07h
	mov	cx,0000
	mov	dx,184fh
	int	10h
	ret
q10clr	endp
	end	rung