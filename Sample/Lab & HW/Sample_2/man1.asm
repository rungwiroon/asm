	.model small
	.stack 64h
	.data 

botrow1	EQU	25
lefcol1	Equ	25
toprow1	db	?
col1	DB	00
row1	DB	00
count1	db	?
lines1	db	?
pages	db	?
man01   db      '            xxxxx            '
	db      '           xxoxoxx           '
	db      '            xxxxx            '
	db      '      xxxxxxxxxxxxxxxxx      '
	db      '      xxxxxxxxxxxxxxxxx      '
	db      '      xxx xxxxxxxxx xxx      '
	db      '      xxx xxxxxxxxx xxx      '
	db      '      xxx xxxxxxxxx xxx      '
	db      '         xxxxxxxxxxx         '
	db      '         xxxxxxxxxxx         '
	db      '         xxxx   xxxx         '
	db      '         xxxx   xxxx         '
	db      '         xxxx   xxxx         '
	db      '       xxxxxx   xxxxxx       '
	
man02	db      '            xxxxx            '
	db      '           xx0xoxx           '
	db      '            xxxxx            '
	db      ' xxxxxxxxxxxxxxxxxxxxxxxxxxxx'
	db      ' xxxxxxxxxxxxxxxxxxxxxxxxxxxx'
	db      '          xxxxxxxxx          '
	db      '          xxxxxxxxx          '
	db      '          xxxxxxxxx          '
	db      '         xxxxxxxxxxx         '
	db      '        xxxx     xxxx        '
	db      '       xxxx       xxxx       '
	db      '      xxxx         xxxx      '
	db      '    xxxxxx         xxxxxx    '
	db      '                             '
	
man03	db	'      xxx           xxx      '
	db      '      xxx   xxxxx   xxx      '
	db      '      xxx  xxox0xx  xxx      '
	db      '      xxx   xxxxx   xxx      '
	db	'      xxxxxxxxxxxxxxxxx      '
	db	'      xxxxxxxxxxxxxxxxx      '
	db      '          xxxxxxxxx          '
	db      '          xxxxxxxxx          '
	db      '          xxxxxxxxx          '
	db      '         xxxxxxxxxxx         '
	db      '         xxxx   xxxx         '
	db      '         xxxx   xxxx         '
	db      '         xxxx   xxxx         '
	db      '       xxxxxx   xxxxxx       '
	.code
	public	man1
	extrn	delay:near
man1	proc	near
	mov	ax,@data
	mov	ds,ax
	
	mov	ah,00
	mov	al,02
	int	10h
	call	q10clr
	call	screen
	ret	
man1	endp

screen	proc	near
;------------man01------page1----------
	mov	ah,05h
	mov	al,1
	int	10h
	lea	si,man01
	mov	bl,6	;toprow1
	mov	pages,1
	call	print	
	call	delay
;-------------man02--------page2-------
	mov	ah,05h
	mov	al,2
	int	10h
	lea	si,man02
	mov	bl,6	;toprow1
	mov	pages,2
	call	print
	call	delay
;--------------man03------page3--------
	mov	ah,05h
	mov	al,3
	int	10h
	lea	si,man03
	mov	bl,5	;toprow1
	mov	pages,3
	call	print
	call	delay
;-------------page 2---------------
	mov	ah,05h
	mov	al,2
	int	10h
;-------------page 1---------------
	call	delay
	mov	ah,05h
	mov	al,1
	int	10h
	call	delay
;-------------------return---------------------
	call	q10clr
	ret
screen	endp	
;----------------------------	
print	proc	near
	mov	lines1,14
	mov	row1,bl	;toprow1
b20:	mov	col1,lefcol1
	mov	count1,29
b30:	call	q20curs
	mov	ah,09
	mov	al,[si]
	mov	bh,pages
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
	mov	bh,pages
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
	end	man1