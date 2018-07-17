;
progseg segment para public 'CODE'
	public	setcom
	assume	cs:progseg, ds:progseg, es:progseg
	org	100h
doscall equ	21h
oldint	equ	16h
;
startup proc	far
	jmp	setup
;
setcom	proc	far
;	jmp	cs:[interupt]
	pushf
	call	cs:[interupt]
	RET 2
setcom	endp
;
save	db	0
interupt label dword
vector	db	8 dup(0)	;only 4 needed 4 more for safety
;
setup:
	mov	ah,35h		;get interupt vector address function
	mov	al,oldint	;keyboard interupt vector
	int	doscall 	;go get it
;
	mov	word ptr vector,bx	 ;save offset
	mov	bx,es		;get segment address
	mov	word ptr vector+2,bx	 ;save segment
;
	mov	dx,offset setcom ;get new vector address
	mov	ax,cs
	mov	ds,ax		;set segment
	mov	ah,25h		;set interupt vector address function
	mov	al,oldint	;set to our new interupt vector
	int	doscall 	;set the interupt
;
	mov	dx,offset setup ;terminate and stay resident
	int	27h
startup endp
progseg ends
;
	end	startup
