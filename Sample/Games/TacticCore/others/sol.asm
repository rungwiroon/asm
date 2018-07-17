.model	small
.386
.stack 100h
.data
	filePal	db 'use.act',0
	include	graphics.asm
	include	various.asm
.code
main	proc
	mov	ax,@data
	mov	ds,ax
@begin:
	initgraph
	xor	cx,cx
@loop1:
	xor	bx,bx
	mov	ax,cx
@loop2:
	putpixel cx,bx,cl
	inc	bx
	cmp	bx,30
	jne	@loop2

	inc	cx
	cmp	cx,256
	jne	@loop1

	mov	ah,7
	int	21h

@end:
	closegraph
	mov	ah,4ch
	int	21h
main	endp
	end