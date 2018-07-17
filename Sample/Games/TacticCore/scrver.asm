screenServer	proc
	pusha
	mov	ax,mouseX
	mov	bx,mouseY
	cmp	scrMouseX,ax
	jne	@endScreenServer
	cmp	scrMouseY,bx
	jne	@endScreenServer
	dec	scrTime
	cmp	scrTime,0
	je	@RunScreenServer
	popa
	ret
@RunScreenServer:
	call	runScreenServerNow
	clearPage
@endScreenServer:
	mov	scrTime,100
	mov	scrMouseX,ax
	mov	scrMouseY,bx
	popa
	ret
screenSerVer	endp

runScreenServerNow	proc
	pusha
	delay	5
	mov	si,offset Bitmap3	; Screen Server
	call	loadBMP
	call	randomize
@PlayScreenServer:
	getMouse
	mov	ax,mouseX
	mov	bx,mouseY
	cmp	scrMouseX,ax
	jne	@StopScreenServer
	cmp	scrMouseY,bx
	jne	@StopScreenServer
	call	screenPainter
	delay	2
	jmp	@PlayScreenServer
@StopScreenServer:
	popa
	ret
runScreenServerNow	endp

screenPainter	proc
	pusha
	mov	randNum,310
	call	rand
	mov	ax,randNum
	mov	randNum,190
	call	rand
	mov	bx,randNum
	add	ax,5
	add	bx,5
	putPixel ax,bx,4
	popa
	ret
screenPainter	endp
