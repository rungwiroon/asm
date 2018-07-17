.data
	score		dw 0    ; Set new score
	HighScore	dw 0,0,0,0,0,0
.code
saveHighScore	proc	; Function Save High Score
	pusha
	mov	ax,score
	mov	HighScore[8],ax
	call	sort
	mov	ah,3ch	; Create New File
	xor	cx,cx	; File is normal
	mov	dx,offset fileScore
	int	21h

	mov	ah,3dh	; Open file
	mov	al,1	; Write mode
	mov	dx,offset fileScore
	int	21h
	mov	fileHandle,ax ; File Handle

	mov	ah,40h	; Write File
	mov	cx,10	; Write 10 byte from HighScore
	mov	dx,offset HighScore
	mov	bx,fileHandle
	int	21h

	mov	ah,3eh	; Close File
	mov	bx,fileHandle
	int	21h
	popa
	ret
saveHighScore	endp

openHighScore	proc
	pusha
	mov	ah,3dh	; Open file
	mov	al,0	; Read mode
	mov	dx,offset fileScore
	int	21h
	mov	fileHandle,ax ; File Handle

	mov	ah,3fh	; Read File
	mov	cx,10	; 10 byte
	mov	dx,offset HighScore
	mov	bx,fileHandle
	int	21h

	mov	ah,3eh	; Close File
	mov	bx,fileHandle
	int	21h

	popa
	ret
openHighScore	endp

sort	proc	; Selection Sort
	push	ax
	push	di
	push	si
	push	es
	mov	ax,ds
	mov	es,ax
	mov	di,0
@sortI:

	mov	si,0
@sortJ:
	mov	ax,HighScore[di]	; Sort Top to Last
	cmp	ax,HighScore[si]
	jng	@nextSort
	call	swapHighScore
@nextSort:
	add	si,2
	cmp	si,10
	jnge	@sortJ
	add	di,2
	cmp	di,10
	jnge	@sortI
	pop	es
	pop	si
	pop	di
	pop	ax
	ret
sort	endp

swapHighScore	proc	; Swap Index Reg
	push	ax
	mov	ax,HighScore[di]
	push	ax
	mov	ax,HighScore[si]
	mov	HighScore[di],ax
	pop	ax
	mov	HighScore[si],ax
	pop	ax
	ret
swapHighScore	endp

