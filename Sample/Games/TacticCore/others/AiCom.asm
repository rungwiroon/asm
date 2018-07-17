computerAttack	proc
	pusha
	mov	si,turnWho
	xor	ax,ax
	xor	bx,bx
	mov	al,hy[si]
	mov	bl,hx[si]
	dec	al
	call	computerCheckAttack
	cmp	tempWho,1
	jne	@nextComAt1
@nextComAt1:
	popa
	ret
computerAttack	endp

computerCheckAttack	proc
	pusha
	mov	cx,8
	mul	cx
	add	bx,ax
	mov	al,map[bx]
	mov	bx,ax
	dec	bx
	cmp	whoPlay[bx],0
	je	@nextComputerCheckAttack
	mov	tempWho,0
	popa
	ret
@nextComputerCheckAttack:
	mov	tempWho,1
	popa
	ret
computerCheckAttack	endp

