extrn	z2:far
.model	small
.stack	100h
.data
	msg db "TEST$"
.code
main	proc	near
	mov	ax,@data
	mov	ds,ax

	lea	dx,msg
	call	z2

	mov	ah,4ch
	int	21h
main	endp
	end
