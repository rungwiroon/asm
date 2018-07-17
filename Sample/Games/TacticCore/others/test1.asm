public	test1
public	test2
.model small

.code
test1	proc near
	mov	ah,9
	int	21h
	ret


test1	endp

test2	proc near
	mov	ah,2
	int	21h
	ret
test2	endp
	end