;	Program by Sirisak Jaroonrojwong
;	CS20 KMITNB
;	Tel	: 086-5699563
;	E-Mail	: bameff@hotmail.com

extrn	drawMap:far		; Function draw map ISOMATIC
extrn	SelectX:byte		; Mouse Select at grand X from function drawMap
extrn	SelectY:byte		; Mouse Select at grand Y from function drawMap
extrn	floorX:word		
extrn	floorY:word
extrn	check:byte		; Check Control Mouse from function drawMap
public	mouseX			; Send mouse at grand X to function drawMap
public	mouseY			; Send mouse at grand Y to function drawMap

title Tatic Core ( game flash ) version Assembly v.0.89
.model	small			; small model segment
.386
.stack	100h			; stack buffer 256 byte
.data				; Data Segment
	
	scrTime		dw 0	; Screen Server
	scrMouseX	dw 0	; use in Screen Server
	scrMouseY	dw 0	; use in Screen Server
	RandSeed	dw ?	; Save randomize default
	randNum		dw ?	; in and out put random
	animetion	db 0	; Control animation
	aniDrawX	dw 0	;
	aniDrawY	dw 0	;
	useSelectX	db 0
	useSelectY	db 0
	controlGame	db 0
	_temp		db ?
	_i		db ?	; Temp Loop
	_j		db ?	; Temp Loop
	_xw		dw ?	; Temp Loop
	_yw		dw ?	; Temp Loop
	prompt	db ?
	X_CLICK	dw 0
	Y_CLICK	dw 0
include fileName.asm			; File use in program
include	headBMP.asm			; File header bitmap
include	dataPlay.asm			; Data Play Game.
include	picture.asm			; Data Picture.
include	various.asm			; Function macro 
include	keyboard.asm			; Function Keyboard
include	graphics.asm			; Function Graphic
include	mouse.asm			; Function Mouse
.code					; Code Segment
main	proc	far
	mov	ax,@data
	mov	ds,ax
	mov	es,ax
	initGraph
	initMouse
	mouseHide
	setPal	filePal
@Title:
	call	openHighScore		; Open High Score
	call	sort			; Sort High Score
	mov	si,offset Bitmap1	; Display Title
	call	loadBMP			; Show Title
	delay	20			; Delay a few sec
@mainMenu:
	call	mainMenu
	call	newGame	
	call	upDataStatusGame
	call	findWalk
@gamePlay:	
	;call	screenServer		; Check Screen Server *I close screen server beacuse i not use
	call	clearDraw		; Clear Blank Drawed
	call	drawMap			; Paint Map
	call	drawChar		; Paint Charactor
	call	drawStatus		; Paint Status Charactor
	call	drawTool		; Paint Interface
	call	printTime		; Paint Time
@nextGamePlay:
	getMouse			; Get Mouse Info X,Y
	putMouse mouseX,mouseY		; Paint Mouse
	delay	0			; Delay 0
	call	checkMouseClickNow	; Check Mouse Click Now
	call	whoIsPlayer		; Check Who play computer or human
	call	upDataStatusGame	; Up Data Status Game
	call	checkGameEnd		; Check Game End
	cmp	endGame,1		; Check End Game if yes to Main Menu
	je	@mainMenu
	jmp	@gamePlay		
@endGamePlay:
	closeGraph
	exit
main	endp
include	aicom.asm			; Is not use
include	control.asm			; Control All Map and Player
include	loadbmp.asm			; LoadBmp show on screen *modifie not use palette
include	outdec.asm			; Is not use *use in loadbmp out put error
include	score.asm			; Load and Save High scorce
include	scrver.asm			; Screen Server
include	stdio.asm			; It one funtion put number x,y
	end	
