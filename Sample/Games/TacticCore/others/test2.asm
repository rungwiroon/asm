.model small
.386
.stack 100h
.data
	filePal	db 'test2.act',0
pics	db  30, 50
	db 51,129,252,129,249,7,248,248,247,50,50,8,14,50,8,14,246,250,249,87,87,51,51,52,249,9,45,51,86,93
	db 94,252,251,129,129,43,50,44,43,248,50,44,44,14,44,247,43,249,50,50,51,87,52,51,93,10,87,87,51,50
	db 172,136,129,251,251,247,44,7,8,248,50,8,7,43,7,7,8,247,86,7,247,44,87,51,51,51,250,93,52,43
	db 172,136,87,248,129,87,7,50,248,50,8,8,51,8,15,44,8,14,247,248,7,43,49,87,52,93,129,51,50,7
	db 94,253,44,245,248,251,50,248,50,9,51,15,51,15,51,15,51,50,8,248,7,50,44,136,130,87,93,45,7,7
	db 94,172,86,245,245,251,87,50,51,15,51,15,14,50,15,44,15,51,15,8,247,247,93,172,172,50,87,51,8,7
	db 93,252,93,245,0,247,86,50,8,51,15,44,8,8,44,14,7,9,50,7,50,246,136,172,172,252,136,94,50,7
	db 93,93,136,247,0,0,246,8,15,14,51,8,8,43,7,8,43,8,51,8,43,247,172,172,136,172,252,251,251,7
	db 130,249,130,172,87,50,245,8,44,15,50,7,43,43,43,246,7,8,44,8,7,249,136,136,136,253,252,251,93,245
	db 136,93,130,172,94,129,246,8,8,51,50,8,246,43,43,7,248,43,8,50,44,250,93,130,251,136,252,252,50,246
	db 172,252,136,136,94,50,246,50,8,86,248,7,246,7,43,44,50,247,7,43,8,248,136,130,129,136,251,252,43,245
	db 172,172,252,93,252,248,7,44,7,50,50,43,7,50,44,50,43,247,7,43,43,44,172,93,250,136,252,252,7,246
	db 172,179,172,86,136,247,7,44,43,44,50,248,7,247,44,50,50,50,247,43,8,247,136,250,129,130,252,251,1,246
	db 252,172,136,86,251,247,246,7,247,8,50,50,44,50,8,86,8,87,50,43,7,247,252,93,136,251,252,93,245,7
	db 252,252,172,249,249,247,246,246,86,7,44,50,44,50,50,50,86,93,248,7,43,247,251,250,136,252,252,44,245,7
	db 252,252,172,93,248,50,245,246,248,93,130,50,50,50,50,87,253,93,129,7,246,247,250,136,94,252,252,7,7,7
	db 252,252,172,252,44,247,245,246,86,129,172,251,7,51,8,248,172,136,129,7,43,248,249,252,93,252,93,245,7,8
	db 252,252,136,172,44,247,245,246,50,249,130,93,7,7,7,7,129,130,50,43,246,86,86,253,94,252,50,246,7,8
	db 250,172,87,172,8,247,7,246,249,50,93,86,8,7,246,7,93,51,44,43,7,86,50,172,129,249,248,7,8,7
	db 7,252,51,94,50,248,7,44,86,50,247,7,7,246,1,7,7,245,50,43,8,249,51,172,136,247,247,44,7,7
	db 246,52,87,87,93,50,44,44,50,87,1,7,7,7,7,7,7,245,87,7,44,86,50,172,93,50,86,86,8,7
	db 44,45,93,93,51,93,44,50,50,93,44,7,7,44,8,43,245,50,51,50,44,86,51,136,7,44,92,86,86,44
	db 14,45,51,87,87,93,50,51,44,93,93,44,7,8,43,7,44,87,50,50,50,50,87,43,246,7,249,250,136,250
	db 45,8,44,50,93,129,87,51,50,93,87,51,50,8,7,44,49,51,50,44,51,93,50,7,7,8,8,93,251,248
	db 45,45,44,7,87,50,136,14,51,93,50,51,14,51,50,51,245,87,50,51,93,44,7,245,7,8,8,7,87,50
	db 9,44,8,8,7,44,50,50,93,87,51,86,8,14,50,7,7,249,51,87,249,7,7,7,8,8,8,50,43,50
	db 51,8,45,44,8,50,7,44,51,93,86,87,50,8,8,7,7,250,50,50,86,7,7,8,7,8,7,248,50,43
	db 10,45,9,8,8,43,8,7,50,93,8,92,7,8,8,7,8,250,50,7,87,7,7,44,8,7,50,44,86,50
	db 46,50,9,8,8,8,7,8,50,50,8,249,50,8,8,7,86,50,7,7,87,7,8,8,7,44,247,247,50,86
	db 10,45,9,44,7,8,8,8,87,50,7,50,250,50,44,50,249,7,8,7,87,7,50,8,7,136,247,50,248,86
	db 16,45,9,93,8,8,44,7,87,7,7,44,50,129,247,129,50,7,246,7,249,7,15,8,93,172,248,43,93,250
	db 51,45,10,87,251,8,50,50,50,7,246,246,8,51,50,44,44,7,246,7,87,50,8,44,172,252,86,7,129,86
	db 136,94,10,44,172,93,8,93,8,7,245,246,50,7,7,247,7,43,246,7,249,8,14,87,172,129,50,43,249,86
	db 172,172,10,9,172,173,50,129,8,8,246,245,43,50,8,86,8,246,7,7,250,43,14,93,253,86,50,86,248,248
	db 172,172,10,10,136,172,252,93,8,8,7,246,245,87,250,50,7,7,44,7,250,87,50,93,253,246,43,86,249,86
	db 172,172,51,46,93,173,129,249,50,44,7,7,245,43,56,8,8,44,43,93,250,92,247,130,250,50,43,50,86,86
	db 250,172,94,94,87,136,250,129,250,247,43,7,7,8,51,50,247,247,86,249,43,246,247,251,247,50,7,86,247,248
	db 247,251,172,253,137,252,86,248,86,249,248,247,246,43,93,43,249,86,43,245,7,245,246,86,247,43,43,249,248,248
	db 86,248,252,172,253,129,248,85,43,43,247,248,249,247,248,250,92,43,43,43,13,246,7,248,50,7,7,86,85,248
	db 250,43,249,136,253,250,85,247,246,246,246,43,249,250,249,249,248,49,7,246,13,43,7,50,43,246,43,250,248,248
	db 129,49,247,43,252,129,248,248,42,245,246,245,246,86,86,85,49,43,246,245,43,245,246,249,246,7,247,249,248,86
	db 248,86,247,43,249,129,86,85,43,245,245,246,246,86,249,247,247,247,246,7,246,246,248,43,44,246,248,250,93,93
	db 247,248,249,86,129,247,86,248,247,245,245,246,43,248,128,86,43,247,246,13,7,246,129,43,7,44,50,93,87,51
	db 50,247,86,248,50,50,249,85,247,43,246,246,247,86,250,249,86,249,247,49,247,86,50,44,43,50,249,93,249,86
	db 247,247,7,50,247,247,248,249,86,248,247,86,249,129,249,86,86,249,129,86,248,43,248,43,50,247,129,129,86,247
	db 43,44,43,7,44,247,50,248,249,248,248,129,249,249,249,86,85,249,249,247,247,248,50,247,50,249,251,93,93,250
	db 247,247,247,43,7,43,247,50,129,86,250,129,129,249,250,249,249,129,86,249,86,251,50,249,86,93,93,87,51,51
	db 43,50,247,7,43,7,8,247,252,250,252,128,172,250,129,250,248,129,248,129,249,250,250,250,93,87,93,51,93,51
	db 93,248,50,86,44,43,43,7,250,251,129,250,249,50,248,86,50,44,50,86,251,86,249,93,93,94,57,51,51,51
	db 93,129,250,93,87,86,50,86,87,86,249,129,249,50,7,8,44,248,129,92,43,249,250,250,93,93,94,93,51,51
	include	graphics.asm
.code
main	proc
	mov	ax,@data
	mov	ds,ax

	initGraph
	setPal	filePal

	putSprite 10,100,pics

	mov	ah,7
	int	21h
	closeGraph

	mov	ah,4ch
	int	21h

main	endp
	end