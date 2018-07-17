getch		macro
	push	dx
	push	ax
	mov	ah,7
	int	21h
	mov	dl,al
	pop	ax
	mov	al,dl
	pop	dx
	endm
