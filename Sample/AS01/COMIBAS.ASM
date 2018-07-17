;
;	Serial communications port interupt intercepter        AHA 8502.27
;
;	Example:
;		call setcom(func)
;		Where func=0 to disable and func=1 to enable
;
;	Functions:
;	al=0 then Disable communications interupt vector
;	al=1 then Enable communications interupt vector
;	Issue and int 44h
;
progseg segment para public 'CODE'
	public	setcom
	assume	cs:progseg, ds:progseg, es:progseg
;
setcom	proc	far
	push	bp
	mov	bp,sp
	mov	bx,[bp+6]
	mov	al,[bx]
	int	44h
	pop	bp
	ret	2
setcom	endp
progseg ends
	end
