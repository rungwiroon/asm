	.model small
	.stack 64
	.data
saveday	db	?
savemon	db	?
ten	db	10
eleven	db	11
twelve	db	12
daystbl	db	'sunday,$    ','monday,$    '
	db	'tueday,$    ','wednesday,$ '
	db	'thursday, $ ','friday, $   '
	db	'saturday, $'
montbl	db	'january $  ','february $ ','march $    '
	db	'april $    ','may $      ','june $     '
	db	'july $     ','august $   ','september $'
	db	'october $  ','november $ ','decemder $ '

	.386
	.code
public	day0
day0	proc
	mov	ax,@data
	mov	ds,ax
	mov	es,ax

	mov	ax,0600h
	call	q10scr
	call	q20curs
	mov	ah,2ah
	int	21h
	mov	savemon,dh
	mov	saveday,dl
	call	b10daywk
	call	c10month
	call	d10daymo

	mov	ax,1
	int	33h
rdmse:	mov	ax,3
	int	33h
        cmp     bl,2
	jnz	rdmse

	mov	ax,2
	int	33h

	call	q10scr
	ret
day0	endp

b10daywk proc
	mul	twelve
	lea	dx,daystbl
	add	dx,ax
	mov	ah,09h
	int	21h
	ret
b10daywk endp

c10month proc
	mov	al,savemon
	dec	al
	mul	eleven
	lea	dx,montbl
	add	dx,ax
	mov	ah,09h
	int	21h
	ret
c10month endp

d10daymo proc
	movzx	ax,saveday
	div	ten
	or	ax,3030h
	mov	bx,ax
	mov	ah,02h
	mov	dl,bl
	int	21h
	mov	ah,02h
	mov	dl,bh
	int	21h
	ret
d10daymo endp

q10scr	proc
	mov	ax,0600h
	mov	bh,0f4h
	mov	cx,0000
	mov	dx,184fh
	int	10h
	ret
q10scr	endp
q20curs	proc
	mov	ah,02h
	mov	bh,00
	mov	dh,10
	mov	dl,24
	int	10h
	ret
q20curs	endp
	end	day0