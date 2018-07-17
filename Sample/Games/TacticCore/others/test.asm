.model	small
.stack	100h
.data
	msg	db "Test$"
print	macro	string
	lea	dx,string
	mov	ah,9
	int	21h

	endm
.code
main:
	mov	ax,@data
	mov	ds,ax
	xor	ax,ax
	xor	bx,bx
	mov	bl,-2
	mov	al,-1
	cbw	
	call	outdec
	mov	ax,bx
	cbw
	call	outdec
	mov	si, offset msg
	cmp	byte ptr [si], 'T'
	jne	@end
	print	msg
@end:
	mov	ah,4ch
	int	21h
	
	include	outdec.asm
end