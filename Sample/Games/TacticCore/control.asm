clearDraw	proc near	; Clear Color no use in Screen
	push	dx
	putRectangle mouseX,mouseY,15,20,0
	putRectangle floorX,floorY,25,15,0
	putRectangle whereX,whereY,25,40,0
	mov	dx,floorY
	sub	dx,50
	putRectangle floorX,dx,25,50,0
	putRectangle 270,20,40,40,0
	pop	dx
	ret
clearDraw	endp

checkGameEnd	proc		; Check Game is Finish and Save High Score
	pusha
@checkGameEndHuman:
	cmp	MaxCom,0
	jne	@checkGameEndComputer
	call	saveHighScore
	mov	si,offset Bitmap4
	call	loadbmp
	getch
	mov	endGame,1
	popa
	ret
@checkGameEndComputer:
	cmp	MaxHum,0
	jne	@endCheckGameEnd
	call	saveHighScore
	mov	si,offset Bitmap5
	call	loadbmp
	getch
	mov	endGame,1
	popa
	ret
@endCheckGameEnd:
	popa
	ret
checkGameEnd	endp
upDataStatusGame	proc	; Set Start New Game
	pusha
	xor	si,si
	mov	minPlay,0
	mov	MaxCom,0
	mov	MaxHum,0
	call	clearMap
@upDataNoDie:
	cmp	Hp[si],0
	jg	@upNoDie
	mov	NoDie[si],0
	jmp	@upNext
@upNoDie:
	cmp	whoPlay[si],0
	jne	@upHumanPlay
	inc	MaxCom
	jmp	@upMap
@upHumanPlay:
	inc	MaxHum
	inc	minPlay
@upMap:
	mov	NoDie[si],1
	mov	ax,si
	mov	tempWho,al
	inc	tempWho
	xor	bx,bx
	xor	ax,ax
	mov	bl,hX[si]
	mov	al,hY[si]
	setXYMap bx,ax

@upNext:
	inc	si
	cmp	si,maxPlay
	jnge	@upDataNoDie
	popa
	ret
upDataStatusGame	endp

drawFloor	proc	; This function run from drawChar only!!
	cmp	walk[bx],0
	je	@endDrawFloor

@drawFloorWalk:
	cmp	controlGame,0
	jne	@drawFloorAttack
	putSprite ax,dx,floor3
	jmp	@endDrawFloor
@drawFloorAttack:
	cmp	controlGame,1
	jne	@endDrawFloor
	putSprite ax,dx,floor4
@endDrawFloor:
	ret
drawFloor	endp

drawChar	proc	; Draw Charactor in Table 8 x 8
	push	ax
	push	bx
	push	cx
	push	dx
	
	mov	ax,120	; Set Map X
	mov	dx,50	; Set Map Y
	mov	ch,0	; Set Height Map
	xor	bx,bx
LoopY:
	push	ax
	push	dx
	mov	cl,0	; Set Width Map
LoopX:	
	call	drawFloor
	cmp	map[bx],0
	je	Next2
	call	SaveXYAnimetion
	push	dx
	sub	dx,minus
	call	putSpriteAll
	pop	dx
Next2:
	inc	bx
	add	ax,wPlus
	add	dx,hPlus
	inc	cl
	cmp	cl,8
	jne	LoopX	; Draw Table Grand X
	
	pop	dx
	pop	ax
	sub	ax,wPlus
	add	dx,hPlus
	inc	ch
	cmp	ch,8
	jne	LoopY	; Draw Table Grand Y

	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret
drawChar	endp

putSpriteAll	proc	; Function is call from drawChar Only!!
	pusha
	call	checkSelectNow
	cmp	cl,1
	jne	@nextPutSprite1
	putSprite ax,dx,human1	; bx is address of Charactor
@nextPutSprite1:
	cmp	cl,2
	jne	@nextPutSprite2
	putSprite ax,dx,human2	; bx is address of Charactor
@nextPutSprite2:
	cmp	cl,3
	jne	@nextPutSprite3
	putSprite ax,dx,human3	; bx is address of Charactor
@nextPutSprite3:
	cmp	cl,4
	jne	@nextPutSprite4
	putSprite ax,dx,human4	; bx is address of Charactor
@nextPutSprite4:
	cmp	cl,5
	jne	@nextPutSprite5
	putSprite ax,dx,human5	; bx is address of Charactor
@nextPutSprite5:
	popa
	ret
putSpriteAll	endp

checkSelectNow	proc	; Check Select Charactor
	push	bx	; Bx is index Map
	push	ax	
	mov	al,map[bx] ; al save index Map ,3
	xor	bx,bx	
	mov	bl,al	; bl = 3
	dec	al
	dec	bl	; bl = 2
	mov	cl,Who[bx] ; cl = 1[bl]
	mov	bx,turnWho
	cmp	al,bl
	jne	@nextCheckSelectNow
	pop	ax
	mov	cl,Who[bx]
	mov	whereX,ax
	mov	whereY,dx
	pop	bx
	ret
@nextCheckSelectNow:
	pop	ax
	pop	bx
	ret
checkSelectNow	endp
SaveXYAnimetion	proc
	push	ax
	push	bx
	push	dx
	push	si
	mov	si, turnWho
@endSaveXY:
	pop	si
	pop	dx
	pop	bx
	pop	ax
	ret
SaveXYAnimetion	endp
drawSelectStatus	proc	; This funtion call from drawStatus only!!
	mov	dx,floorY
	sub	dx,50
	cmp	animetion,5
	jge	@nextDrawSelectAnime1
	putSprite floorX,dx,sel1
	jmp	@nextDrawSelect
@nextDrawSelectAnime1:
	cmp	animetion,10
	jge	@nextDrawSelectAnime2
	putSprite floorX,dx,sel2
	jmp	@nextDrawSelect
@nextDrawSelectAnime2:
	putSprite floorX,dx,sel3
@nextDrawSelect:
	add	animetion,1
	cmp	animetion,15
	jne	@endDrawSelectStatus
	mov	animetion,0
@endDrawSelectStatus:
	ret
drawSelectStatus	endp

drawStatus	proc	; Draw Status Charactor
	pusha
	xor	ax,ax
	xor	bx,bx
	mov	bl,SelectX
	mov	al,SelectY
	getMap	bx,ax
	cmp	tempWho,0		; Check Mouse onOver in Map if have a hero to show status
	je	@drawStatusNormal	
	mov	al,tempWho
	dec	al
	printStatus ax
	call	drawSelectStatus	; Draw Animetion Select
	popa	
	ret
@drawStatusNormal:			; But not have hero to show status hero current turn
	printStatus turnWho
	;call	drawSelectStatus	; Draw Animetion Select
	popa
	ret
drawStatus	endp

drawPictureChar	proc	; call this function from drawStatus Only!!
@nextPictureChar1:
	cmp	cl,1
	jne	@nextPictureChar2
	putSprite 270,20,pich1
	ret
@nextPictureChar2:
	cmp	cl,2
	jne	@nextPictureChar3
	putSprite 270,20,pich2
	ret
@nextPictureChar3:
	cmp	cl,3
	jne	@nextPictureChar4
	putSprite 270,20,pich3
	ret
@nextPictureChar4:
	cmp	cl,4
	jne	@nextPictureChar5
	putSprite 270,20,pich4
	ret
@nextPictureChar5:
	cmp	cl,5
	jne	@nextPictureChar6
	putSprite 270,20,pich5
	ret
@nextPictureChar6:
	ret
drawPictureChar endp

drawTool	proc	; Draw Feature all
	pusha
	putSprite 20,20,bar1			
	putSprite 20,140,bar3
	putSprite 200,20,bar2
	printNumber 310,106,4,score
	putSprite 260,95,textScore
	checkRangeMouse 230,140,320,155		; Draw Button Main Menu
	cmp	mouseRange,0
	jne	@nextDrawExitMenu
	putSprite 230,140,exitMenu1
	jmp	@nextDraw1
@nextDrawExitMenu:
	putSprite 230,140,exitMenu2
	cmp	bx,1
	jne	@nextDraw1
	mov	endGame,1
@nextDraw1:
	checkRangeMouse 230,125,280,140		; Draw Button End Turn
	cmp	mouseRange,0
	jne	@nextDrawEndTurnMenu
	putSprite 230,125,endTurnMenu1
	jmp	@nextDraw2
@nextDrawEndTurnMenu:
	putSprite 230,125,endTurnMenu2
	cmp	bx,1
	jne	@nextDraw2
	cmp	controlGame,1
	je	@nextSkipAttack
	call	findAttack
	jmp	@nextDraw2
@nextSkipAttack:
	mov	controlGame,0
	call	findWalk
@nextDraw2:
	popa
	ret
drawTool	endp


clearWalk	proc	; Clear Walk Table
	push	cx
	push	si
	xor	si,si
	mov	cx,64
clearWalkLoop:
	mov	walk[si],0
	inc	si
	loop	clearWalkLoop
	pop	si
	pop	cx
	ret
clearWalk	endp

clearMap	proc	; Clear Map Table
	push	cx
	push	si
	xor	si,si
	mov	cx,64
clearMapLoop:
	mov	Map[si],0
	inc	si
	loop	clearMapLoop
	pop	si
	pop	cx
	ret
clearMap	endp

findNext	proc	; Find Next Player on board
	push	si
	cmp	MaxHum,0
	je	@endFindNext
	mov	si,turnWho
@FirstFind:
	inc	si
	cmp	si,maxPlay
	jnge	@checkDie
	xor	si,si
@checkDie:
	cmp	noDie[si],1
	jne	@FirstFind
	mov	turnWho,si
@endFindNext:
	pop	si
	ret
findNext	endp

findWalk	proc	; Find Table Walk
	pusha
	push	si
	mov	controlGame,0
	call	clearWalk
	call	findNext
	cmp	minPlay,0
	je	@endFindWalk
	xor	ax,ax
	xor	bx,bx
	xor	cx,cx
	xor	dx,dx
	mov	si,turnWho
	mov	bl,hX[si]	; dx is Table X1
	sub	bx,1
	mov	al,hY[si]	; ax is Table Y1
	sub	ax,1
	mov	cx,bx		; cx is Table X2
	add	cx,2
	mov	dx,ax		; bx is Table Y2
	add	dx,2
	changeWalk   bx,ax,cx,dx
	mov	controlGame,0
@endFindWalk:
	pop	si
	popa
	ret
findWalk	endp

printTime	proc		; Function output Time on Screen
	pusha
	mov	ah,2ch
	int	21h
	cmp	sec,dh
	je	DontCarePrintTime
	getTime
	xor	ax,ax
	mov	al,hur		; Hur
	printNumber 270,2,2,ax
	mov	al,min		; Min
	printNumber 290,2,2,ax
	mov	al,sec		; Sec
	printNumber 310,2,2,ax
	putPixel 280,7,4
	putPixel 280,12,4
	putPixel 300,7,4
	putPixel 300,12,4
DontCarePrintTime:
	popa
	ret
printTime	endp

checkMouseClickNow	proc	; Check mouse Click yes or no output bx
	xor	bx,bx
	getClick 0	; Get Click Left
	ret
checkMouseClickNow	endp

whoIsPlayer	proc	; Check who play
	push	si
	mov	si,turnWho
@HumanPlayer:
	cmp	whoPlay[si],1
	jne	@ComputerPlayer
	call	HumanPlay		; Check Human Event Game
	jmp	@endPlayer
@ComputerPlayer:
	call	HumanPlay		; Check Ai Event Game
@endPlayer:
	pop	si
	ret
whoIsPlayer	endp

ComputerPlay	proc			; Ai is basic function no finish
	pusha
	call	findWalk
	popa
	ret
ComputerPlay	endp

HumanPlay	proc		; Check Click Walk of Charactor
	pusha
	cmp	bx,1		; Check Mouse Click bx = 0 is not click
	jne	@endCheckClickGame
	cmp	check,0		; Check is extern from drawMap of map.asm
	je	@endCheckClickGame
	checkClickWalk
	cmp	mouseClick,1
	jne	@endCheckClickGame
@humanPlayWalk:
	cmp	controlGame,0	; 0 = Event Game is Walk
	jne	@humanPlayAttack
	call	upDataGameWalk
	call	findAttack
	jmp	@endCheckClickGame
@humanPlayAttack:
	call	upDataGameAttack
	call	findWalk
@endCheckClickGame:
	popa
	ret
HumanPlay	endp

resetGame	proc
	mov	endGame,0
	mov	MaxHum, 0
	mov	MaxCom, 0
	mov	MaxPlay,0
	mov	MinPlay,0
	mov	turnWho,0
	mov	endGame,0
	mov	score , 0
	call	clearWalk
	call	clearMap
	ret
resetGame	endp

newGame		proc
	call	resetGame
	addHero 7,4,_Ninja
	addHero 0,3,_Dragon
	addHero 7,3,_Mong
	addHero 1,3,_Wiz
	addHero 1,4,_Wiz
	addHero 6,5,_Mong
	addHero 3,3,_Fight
	addHero 6,6,_Mong
	addHero 3,6,_Fight
	ret
newGame		endp
upDataGameAttack	proc	; UpDate game Attack
	pusha
	mov	dx,floorX
	sub	dx,3
	mov	_xw,dx
	mov	ax,floorY
	sub	ax,minus
	mov	_yw,ax		; Attack Animetion
	putSprite _xw,_yw,attack1
	delay	1
	putSprite _xw,_yw,attack2
	delay	2
	putSprite _xw,_yw,attack3
	delay	3
	xor	bx,bx
	xor	ax,ax
	mov	bl,SelectX	; Check X,Y on table have monster
	mov	al,SelectY	
	checkAtMap bx,ax
	cmp	_temp,0
	je	@endUpDataGameAttack
	mov	bl,_temp	; Set Bx to Target Attack
	dec	bl
	mov	si,turnWho	; Set Si to Start Attack
	mov	al,At[si]
	sub	Hp[bx],al
	cmp	Hp[bx],0
	jg	@endUpDataGameAttack
	mov	noDie[bx],0	
	call	upDataScore
@endUpDataGameAttack:
	popa
	ret
upDataGameAttack	endp

upDataScore		proc	; This function is call from upDataGameAttack only!!
	findStatus Who[bx]
	add	si, SeekScore
	mov	bx, [si]
	add	score, bx
	ret
upDataScore		endp

upDataGameWalk	proc	; UpDate game Walk
	pusha
	push	si
	xor	ax,ax
	xor	bx,bx
	mov	si,turnWho
	mov	bl,hX[si]
	mov	al,hY[si]
	getXYMap bx,ax
	mov	bl,SelectX	; SelectX ,Y is Where mouse click on table
	mov	al,SelectY
	mov	hX[si],bl
	mov	hY[si],al
	setXYMap bx,ax
	pop	si
	popa
	ret
upDataGameWalk	endp

findAttack	proc		; Find Table range Attack
	pusha
	mov	controlGame,1	; Changer Turn Attack Game
	xor	ax,ax
	xor	bx,bx
	call	clearWalk
	mov	si,turnWho
	mov	bl,hX[si]
	mov	al,hY[si]
	findStatus Who[si]
	call	plotAttack
	popa
	ret
findAttack	endp

plotAttack	proc			; This function call from findAttack Only!!
	xor	cx, cx
	add	si, seekAttack
	mov	cl, [si]
	inc	si
@nextPlotAttack:
	push	ax
	push	bx
	add	bl, [si+0]
	add	al, [si+1]
	cbwAB
	changeWalkXY bx,ax
	add	si, 2	
	pop	bx
	pop	ax
	loop	@nextPlotAttack
	ret
plotAttack	endp

drawHighScore	proc			; Print High Score
	pusha
@drawHighScore:
	mov	si,offset Bitmap6	; mainMenu
	call	loadBMP
	printNumber	200,48,4,HighScore[0]
	printNumber	200,68,4,HighScore[2]
	printNumber	200,88,4,HighScore[4]
	printNumber	200,108,4,HighScore[6]
	printNumber	200,128,4,HighScore[8]
	getCh
@endHighScore:
	popa
	ret
drawHighScore	endp

mainMenu	proc			; Function Main Menu Game
	pusha
	push	si
@mainMenuRun:
	mov	si,offset Bitmap2	; mainMenu
	call	loadBMP
	getMouse
	call	screenServer
	call	checkMouseClickNow
@mainMenuNext0:				; Menu Play Game
	checkRangeMouse 40,60,120,80
	cmp	mouseRange,0
	je	@mainMenuNext1
	putSprite 15,56,arrow
	cmp	bx,1
	jne	@mainMenuNext1
	jmp	@endMainMenu
@mainMenuNext1:				; Menu Scorce
	checkRangeMouse 40,80,120,100
	cmp	mouseRange,0
	je	@mainMenuNext2
	putSprite 15,76,arrow
	cmp	bx,1
	jne	@mainMenuNext2
	call	drawHighScore
	jmp	@mainMenuRun
@mainMenuNext2:				; Menu Exit Game
	checkRangeMouse 40,100,120,120
	cmp	mouseRange,0
	je	@mainMenuNext3
	putSprite 15,96,arrow
	cmp	bx,1
	jne	@mainMenuNext3
	call	saveHighScore
	closeGraph
	exit
@mainMenuNext3:
	putMouse mouseX,mouseY
	delay	0

	jmp	@mainMenuRun
@endMainMenu:
	clearPage
	pop	si
	popa
	xor	bx,bx			; Clear BX is mouse left
	ret
mainMenu	endp



;	Randomize is function not me
Randomize proc				; Set default Random 
	pusha
	xor	ax, ax
	int	1Ah			; interrupt time is return some number to dx
	mov	RandSeed, dx
	popa
        ret
Randomize endp				

Rand	proc				; Random range in randNum
	pusha
	mov	al, 16
	mov	dx, RandSeed
r_loop:
	rol	dx, 1
	jnc	r_skip
	xor	dx, 0ah
r_skip:
	dec	al
	jne	r_loop
	mov	ax, dx
	mov	RandSeed, dx
	xor	dx, dx
	mov	cx, randNum			;Limit
	div	cx
	mov	randNum, dx
	popa
        ret
Rand	endp