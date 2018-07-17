controlMainGame	proc
gameRun:
	cmp	pageNow,4
	jne	endCheck
	call	clearDraw
	call	drawMap
	call	drawChar
endCheck:
	getMouse
	putMouse mouseX,mouseY
controlMainGame	endp