;return CX is position row
;return DX is position column
.data
	mouseX		dw 0
	mouseY		dw 0
	mouseRange	db 0	
	mouseClick	db 0
mouse	db  15, 20
	db 4,4,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 4,4,4,0,0,0,0,0,0,0,0,0,0,0,0
	db 249,249,4,4,0,0,0,0,0,0,0,0,0,0,0
	db 249,249,249,4,4,0,0,0,0,0,0,0,0,0,0
	db 249,249,249,249,4,4,0,0,0,0,0,0,0,0,0
	db 249,249,249,249,249,4,4,0,0,0,0,0,0,0,0
	db 249,249,249,249,249,249,249,4,0,0,0,0,0,0,0
	db 249,249,249,249,249,249,249,249,4,0,0,0,0,0,0
	db 249,249,249,249,249,249,249,249,249,4,0,0,0,0,0
	db 249,249,249,249,215,0,0,0,0,0,0,0,0,0,0
	db 249,249,249,215,0,0,0,0,0,0,0,0,0,0,0
	db 249,249,215,0,0,0,0,0,0,0,0,0,0,0,0
	db 249,215,0,0,0,0,4,4,4,4,0,0,0,0,0
	db 215,0,0,0,0,4,249,249,249,249,4,0,0,0,0
	db 0,0,0,0,249,249,249,249,249,249,249,4,0,0,0
	db 0,0,0,0,249,249,249,249,249,249,249,4,0,0,0
	db 0,0,0,0,249,249,249,249,249,249,249,4,0,0,0
	db 0,0,0,0,215,249,249,249,249,249,249,249,0,0,0
	db 0,0,0,0,0,215,249,249,249,249,249,0,0,0,0
	db 0,0,0,0,0,0,215,249,249,215,0,0,0,0,0
initMouse	macro
	mov	ax,01h	; Init Mouse
	int	33h
	mov	ax,04h	; Set Default X,Y Mouse
	mov	cx,0	; X
	mov	dx,0	; Y
	int	33h	

	mov	ax, 07h	; Mouse Width
	mov	cx, 20	
	mov	dx, 300
	int	33h

	mov	ax, 08h ; Mouse Height
	mov	cx, 20
	mov	dx, 180
	int	33h
	endm
getMouse	macro
	push	ax
	push	cx
	push	dx
	mov	ax,03
	int	33h
	; Output is
	; BX bit
	;	0 = 1 Left Click
	;	1 = 1 Right Click
	;	2 = 1 Center Click
	mov	mouseX,cx
	mov	mouseY,dx
	pop	dx
	pop	cx
	pop	ax
	endm
getClick	macro	button
	mov	ax,06
	mov	bx,button
	int	33h
	; Out Put bx
	endm
putMouse	macro	x, y
	putSprite x,y,mouse
	
	endm
mouseHide	macro
	mov	ax,02
	int	33h
	endm


