.model	small
.stack	100h
.data
	RandSeed dw ?
.code
main	proc
	mov	ax,@data
	mov	ds,ax

	call	randomize
	call	rand
	call	outdec

	mov	ah,4ch
	int	21h

main	endp
	include outdec.asm
Randomize PROC
;IN:	nothing
;OUT:	nothing

	xor ax, ax
	int 1Ah
	mov RandSeed, dx
        ret
Randomize ENDP

Rand PROC
;IN:	nothing
;OUT:	ax = random number

	mov al, 16
	mov dx, RandSeed
r_loop:
	rol dx, 1
	jnc r_skip
	xor dx, 0ah
r_skip:
	dec al
	jne r_loop
	mov ax, dx
	mov RandSeed, dx

	xor dx, dx
	mov cx, 1000			;Limit
	div cx
	mov ax, dx

        ret
Rand ENDP
end