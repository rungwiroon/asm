PGROUP	Group	PROG
DGROUP	Group	DATA


DATA	Segment	Public	'DATA'

public	brkflag

brkflag	DW	0

DATA	ends

PROG	Segment	Para	Public	'PROG'

public	TrapBrea

assume cs:PGROUP,DS:DGROUP

TrapBrea	proc	near

	push	ds
	push	cs
	pop	ds
	mov	dx,offset PGROUP:Bret
	mov	ah,25h
	mov	al,23h
	int	21h
	pop	ds
	ret

TrapBrea	endp 

Bret	proc	far

	push	ds
	push	ax
	mov	ax,DGROUP
	mov	ds,ax
	mov	brkflag,1
	pop	ax
	pop	ds
	iret

Bret	endp
PROG	ends

	end
