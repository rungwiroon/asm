	.model small
 	.data
nodrv	db	'no mouse driver installed.$'
nomse	db	'mouse not responding.$'
mexit	db	'press left mouse button to exit...$'
spos	equ	 12*160 
	
	.code  
	.startup
	public	mouse
mouse	proc	far
	push	ax
	push	bx
	push	cx
	push	dx
	mov	ax,@data
	mov	ds,ax
	mov	ah,35h
	mov	al,33h
	int	21h
	mov	ax,es
	or	ax,bx
	jnz	go
	lea	dx,nodrv
errd:	mov	ah,9
	int	21h
	jmp	exit
go:	sub	ax,ax
	int	33h
	or	ax,ax
	jnz	next
	lea	dx,nomse
	jmp	errd
next:	mov	cx,79
clrsc:	mov	dl,0ah
	mov	ah,2
	int	21h
	loop	clrsc
	lea	dx,mexit
	mov	ah,9
	int	21h
	mov	ax,1
	int	33h
	mov	ax,0b800h
	mov	ds,ax
	mov	si,spos
	mov	byte ptr [si+54],'x'
	mov	byte ptr [si+56],':'
	mov	byte ptr [si+94],'y'
	mov	byte ptr [si+96],':'
rdmse:	mov	ax,3
	int	33h
	mov	ax,cx
	mov	di,spos+60
	call	disp
        mov     ax,dx
        mov     di,spos+100
        call    disp
        cmp     bl,1
	jnz	rdmse
	mov	ax,2
	int	33h
exit:   pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret     	
	
disp	proc	near
	push	cx
	
	mov	cx,4
nybl:	rol	ax,1
	rol	ax,1
	rol	ax,1
	rol	ax,1
	push	ax
	and	al,0fh
	add	al,30h
	cmp	al,3ah
	jc	no7
	add	al,7
no7:	mov	[di],al
	pop	ax
	add	di,2
	loop	nybl
	pop	cx
	ret
disp	endp
mouse	endp
end	mouse