3.MODEL	small
.STACK	100H

;------------------ extra segment ------------------
;---------------------------------------------------
vBUFFERSEG	SEGMENT	
	VBUFFER DB	64000	DUP (0)
vBUFFERSEG	ENDS

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
	include	dark1.asm
	include	dark2.asm
	include	dark3.asm
	include	light1.asm
	include	light2.asm
	include	light3.asm

	;-------------- life bar ---------------------
	include lifebar.asm
	batt2		db	'batt2.pic',0
	intro		db	'intro.pic',0
	;------------- loadbmp.asm -------------------
	bmp_x		dw 100
	bmp_y		dw 1
	
	;------------------ buffer -------------------
	dostime		db	0
	roundtime	db	100

	player1x	dw	50
	player2x	dw	200
	p1life		db	120
	p2life		db	120
	battley		dw	100
	p1width		dw	50
	p2width		dw	77

	p1score		dw	0
	p2score		dw	0

	byte_buffer	db	?	;temp buffer
	GPW1		DW	?	;temp bmp width
	GPW2		DW	?	;temp bmp hight
	
	filehandle	dw	?
	keyesc		db	0
	;---------------- player 2 key ---------------
	keyright	db	0
	keyleft		db	0
	keynum1		db	0
	keynum2		db	0
	;---------------- player 1 key ---------------
	keyA		db	0
	keyD		db	0
	keyJ		db	0
	keyK		db	0

.CODE

;------------------------------------------------------
;		main procedure
;------------------------------------------------------
MAIN	PROC
	MOV	AX,@data
	MOV	DS,AX
	MOV	ES,AX

	MOV	AH,00H
	MOV	AL,13H
	INT	10H
	
	lea	si,intro
	call	clrobjbuffer
	call	loadbgbuffer	
	call	swapvideoram
	call	syncvideo

	
	mov	ah,8
	int	21h

	call	battle

	MOV	AH,1
	INT	21H
	call	exitgame
	
MAIN	ENDP

exitgame	proc
	MOV	AH,00H	
	MOV	AL,03H
	INT	10H   

	MOV	AH,4CH
	INT	21H
exitgame	endp


;--------------- include procedure ----------------------
	INCLUDE graphic.ASM
	INCLUDE	OUTDEC.ASM
	INCLUDE BATTLE.ASM
	include	getkey.asm
;--------------------------------------------------------

END	MAIN