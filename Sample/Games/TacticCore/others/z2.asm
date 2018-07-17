public	z2
.model	small
.stack	100h
.data
	
.code
z2	proc	far
	mov	ah,9
	int	21h
	ret
z2	endp
	end
