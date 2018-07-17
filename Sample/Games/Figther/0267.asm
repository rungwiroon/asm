.model	small
.stack	100h

;------------------ extra segment ------------------
;---------------------------------------------------
vbufferseg	segment	
	vbuffer db	64000	dup (0)
vbufferseg	ends

bgbufferseg	segment
	bgbuffer db	64000	dup (0)
bgbufferseg	ends

objbufferseg	segment
	objbuffer db	64000	dup (0)
objbufferseg	ends

;-------------------- include macro -----------------
;-----------------------------------------------------
	include	macro.asm

;----------------- data segment ----------------------
.data
	;------------- charecter ---------------------
	include	dark1_2.asm
	include	dark2_2.asm
	include	dark3_2.asm

	include	light1_2.asm
	include	light2_2.asm
	include	light3_2.asm

	include	digit.asm
	;-------------- life bar ---------------------
	include lifebar.asm
	credit		db	'credit.pic',0
	batt2		db	'batt2.pic',0
	intro		db	'intro.pic',0
	block		db	'block.pic',0
	picstartgame	db	'start1.pic',0
	picsstartgame	db	'start2.pic',0
	pichowtoplay	db	'how1.pic',0
	picshowtoplay	db	'how2.pic',0
	picexitgame	db	'exit1.pic',0
	picsexitgame	db	'exit2.pic',0
	piccredit	db	'credit1.pic',0
	picscredit	db	'credit2.pic',0
	pichigh		db	'high1.pic',0
	picshigh	db	'high2.pic',0
	howd		db	'howd.pic',0
	pictimeup	db	'timeup.pic',0
	highbg		db	'highbg.pic',0
	p1win		db	'lightwin.pic',0
	p2win		db	'darkwin.pic',0

	;------------- loadbmp.asm -------------------
	bmp_x		dw 100
	bmp_y		dw 1
	;------------------ score --------------------
	msgname		db 'Name : $'
	filescore       db 'score.dat',0

	filebuffer1     db 200 dup (0)
	filebuffer2     db 20 dup (0)

	score	dw 10000

	nameplay        db 18 dup (' ')
	namebuffer      db 18 dup (0),'$'
	scorebuffer     dw ?
	msggetname      db 'enter name : $'
	count   db ?
	line    db ?
	numsave db 0
	numshowscore db ?
	;------------------ buffer -------------------
	selectmenu	db	1
	dostime		db	0
	roundtime	db	3

	player1x	dw	50
	player2x	dw	200
	p1life		db	120
	p2life		db	120
	battley		dw	90
	p1width		dw	85
	p2width		dw	110

	p1score		dw	0
	p2score		dw	0

	byte_buffer	db	?	;temp buffer
	gpw1		dw	?	;temp bmp width
	gpw2		dw	?	;temp bmp hight
	
	filehandle	dw	?
	keyesc		db	0
	;---------------- player 2 key ---------------
	keyright	db	0
	keyleft		db	0
	keynum1		db	0
	keynum2		db	0
	;---------------- player 1 key ---------------
	keya		db	0
	keyd		db	0
	keyj		db	0
	keyk		db	0

.code

;------------------------------------------------------
;		main procedure
;------------------------------------------------------
main	proc
	mov	ax,@data
	mov	ds,ax
	mov	es,ax

	mov	ah,00h
	mov	al,13h
	int	10h
	
	lea	si,intro
	call	clrobjbuffer
	call	loadbgbuffer	
	call	swapvideoram
	call	syncvideo

	call	menu
	call	exitgame
	
main	endp

exitgame	proc
	mov	ah,00h	
	mov	al,03h
	int	10h   

	mov	ah,4ch
	int	21h
exitgame	endp


;--------------- include procedure ----------------------
	include graphic.asm
	include	outdex.asm
	include battle.asm
	include	getkey.asm
	include	menu.asm
	include	score.asm
	include	outdec.asm
;--------------------------------------------------------

end	main