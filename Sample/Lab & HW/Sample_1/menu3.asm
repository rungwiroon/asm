	.model	compact
	.stack	64h
	.data
toprow	EQU	00
botrow	EQU	06
lefcol	EQU	16
col	DB	00
row	DB	00
count	db	?
lines	db	?
attrib	db	?
ninteen	db	19
menu	db	'-------------------'
	db	'|Program1         |'
	db	'|Program2         |'
	db	'|Program3         |'
	db	'|program4         |'
	db	'|exit             |'
	db	'-------------------'
prompt	db	09,'to select an item, use  up/down arrow'
	db	' and press enter.'
	db	13,10,09,'press esc to exit.'
msec	db	?
sec	db	?
min	db	?
hour	db	?
ten	db	10
msgtime	db	'TIME: $'
msgday	db	'DAY:  $'
saveday	db	?
saveweek db	?
savemon	db	?
eleven	db	11
twelve	db	12
daystbl	db	' sunday,$   ',' monday,$   ',' tueday,$   '
	db	' wednesday,$',' thursday,$ ',' friday,$   '
	db	' saturday,$ '
montbl	db	' january$  ',' february$ ',' march$    '
	db	' april$    ',' may$      ',' june$     '
	db	' july$     ',' august$   ',' september$'
	db	' october$  ',' november$ ',' decemder$ '
;-----------------------------------
	.386
	.code
	extrn	mouse:far
	extrn	draw:near
	extrn	rung:near
	extrn	sound:near
	public	begin

begin	proc	far
	mov	ax,@data
	mov	ds,ax
	mov	es,ax
	mov	ah,0
	mov	al,2
	int	10h
	call	q10clr

	mov	row,botrow+12
	mov	col,00
	call	q20curs
	mov	ah,40h
	mov	bx,01
	mov	cx,75
	lea	dx,prompt
	int	21h
;-----------------------------	
	call	day
;-----------------------------	
a10loop:
	call	b10menu
	mov	col,lefcol+1
	call	q20curs
	mov	row,toprow+1
	mov	attrib,16h
	call	h10disp
	call	d10inpt
	cmp	al,0dh
	je	a10loop
	mov	ax,0600h
exit:	call	q10clr
	mov	ah,4ch
	int	21h
begin	endp
;--------------------------------------
;	display full menu
;--------------------------------------
b10menu	proc	near
	mov	row,toprow
	mov	lines,07
	lea	si,menu
	mov	attrib,71h
b20:
	mov	col,lefcol
	mov	count,19

b30:
	call	q20curs
	mov	ah,09
	mov	al,[si]
	mov	bh,00
	mov	bl,71h
	mov	cx,01
	int	10h
	inc	col
	inc	si
	dec	count
	jnz	b30
	inc	row
	dec	lines
	jnz	b20
	ret
b10menu	endp
;-----------------------------------------
d10inpt	proc	near
	
	mov	ah,0ch
	mov	al,0
	int	21h
;------------------------	
	call	time
;------------------------	
	cmp	ah,50h
	je	d20
	cmp	ah,48h
	je	d30
	cmp	al,0dh
	je	d90
	cmp	al,1bh
	je	d90
	jmp	d10inpt
d20:	mov	attrib,71h
	call	h10disp
	inc	row
	cmp	row,botrow-1
	jbe	d40
	mov	row,toprow+1
	jmp	d40
d30:	mov	attrib,71h
	call	h10disp
	dec	row
	cmp	row,toprow+1
	jae	d40
	mov	row,botrow-1
d40:	call	q20curs
	mov	attrib,16h
	call	h10disp
	jmp	d10inpt
d90:	cmp	row,01
	jne	menu2
	call	mouse
	jmp	begin
menu2:	cmp	row,02
	jne	menu3
	call	draw
	jmp	begin
menu3:	cmp	row,03
	jne	menu4
	call	sound
	jmp	begin
menu4:	cmp	row,04
	jne	menu5
	call	rung
	jmp	begin
menu5:	cmp	row,05
	jne	return
	jmp	exit
return:	ret
d10inpt	endp
;----------------------------------------
h10disp	proc	near
	mov	ah,00
	mov	al,row
	mul	ninteen
	lea	si,menu+1
	add	si,ax
	mov	count,17
h20:	call	q20curs
	mov	ah,09
	mov	al,[si]
	mov	bh,00
	mov	bl,attrib
	mov	cx,01
	int	10h
	inc	col
	inc	si
	dec	count
	jnz	h20
	mov	col,lefcol+1
	call	q20curs
	ret
h10disp	endp
;---------------------------------------
;	clear screen
;---------------------------------------
q10clr	proc	near
	mov	ax,0600h
	mov	bh,17h
	mov	cx,0000
	mov	dx,184fh
	int	10h
	ret
q10clr	endp
;---------------------------------------
;	set cursor
;---------------------------------------
q20curs	proc	near
	mov	ah,02
	mov	bh,00
	mov	dh,row
	mov	dl,col
	int	10h
	ret
q20curs	endp

;-------------------------------
;	TIME
;-------------------------------
time    proc	near
		
	        
	;mov	ah,00
	;mov	al,0
	;int	10h

	call	setcur
	
start:	MOV     AH,2ch
        INT     21H
	
	mov	msec,dl
	mov	sec,dh
	mov	min,cl
	mov	hour,ch

	call	setcur

	mov	ah,09
	lea	dx,msgtime
	int	21h
	
	call	hours
	call	dotdot
	call	mins
	call	dotdot
	call	second
	call	dotdot
	call	milsec
;-------------------------
	mov	ah,01
	int	16h
	jz	start
;-------------------------	
exit1:	
	ret

time	endp

milsec	proc
	movzx	ax,msec
	div	ten
	or	ax,3030h
	mov	bx,ax
	
	mov	dl,bl
	mov	ah,02
	int	21h
	
	mov	dl,bh
	mov	ah,02
	int	21h
	ret
milsec	endp

second	proc
	movzx	ax,sec
	div	ten
	or	ax,3030h
	mov	bx,ax
	
	mov	dl,bl
	mov	ah,02
	int	21h
	
	mov	dl,bh
	mov	ah,02
	int	21h
	ret
second	endp

mins	proc
	movzx	ax,min
	div	ten
	or	ax,3030h
	mov	bx,ax
	
	mov	dl,bl
	mov	ah,02
	int	21h
	
	mov	dl,bh
	mov	ah,02
	int	21h
	ret
mins	endp

hours	proc
	movzx	ax,hour
	div	ten
	or	ax,3030h
	mov	bx,ax
	
	mov	dl,bl
	mov	ah,02
	int	21h
	
	mov	dl,bh
	mov	ah,02
	int	21h
	ret
hours	endp

setcur	proc
	mov	ah,02
	mov	bh,00
	mov	dh,15
	mov	dl,10
	int	10h
	ret
setcur	endp

dotdot	proc
	mov	dl,3ah
	mov	ah,02
	int	21h
	ret
dotdot	endp

;-------------------------------
;	DAY
;-------------------------------

day	proc	
	
	call	q30curs

	mov	ah,09
	lea	dx,msgday
	int	21h
	
	mov	ah,2ah
	int	21h
	mov	saveweek,al
	mov	savemon,dh
	mov	saveday,dl
	call	d10daymo
	call	b10daywk
	call	c10month
	call	e10inpt
	
	ret
	
day	endp

b10daywk proc
	mov	al,saveweek
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

e10inpt	proc
	;mov	ah,10h
	;int	16h
	ret
e10inpt	endp

q30curs	proc
	mov	ah,02h
	mov	bh,00
	mov	dh,14
	mov	dl,10
	int	10h
	ret
q30curs	endp


	end	begin