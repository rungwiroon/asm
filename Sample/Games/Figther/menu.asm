menu	proc

	call	clrobjbuffer
	jmp	chkmenu
startmenu:
	call	initdata


	mov	si,offset picstartgame
	drawbmp	95,110,105,20,si
	mov	si,offset pichowtoplay
	drawbmp	95,125,105,20,si
	mov	si,offset pichigh
	drawbmp	95,140,105,20,si
	mov	si,offset piccredit
	drawbmp	95,155,105,20,si
	mov	si,offset picexitgame
	drawbmp	95,170,105,20,si
	call	swapvideoram
	call	syncvideo

	mov	ah,0
	int	16h
	
	cmp	al,0dh		;enter
	je	selected
	cmp	ah,48h		;up arrow
	jne	nextarrow
	dec	selectmenu
	jmp	chkloop
startmenubreakpoint:
	jmp	startmenu

nextarrow:
	cmp	ah,50h		;down arrow
	jne	startmenubreakpoint
	inc	selectmenu
chkloop:
	cmp	selectmenu,0
	je	loopdown2
	cmp	selectmenu,6
	jne	jmp_chkmenu2
	mov	selectmenu,1
	jmp	jmp_chkmenu2
loopdown2:
	jmp	loopdown
jmp_chkmenu2:
	jmp	jmp_chkmenu
selected:
	cmp	selectmenu,1	;battle
	jne	nextmenu1
	call	battle

	lea	si,intro
	call	loadbgbuffer
	jmp	chkmenu
nextmenu1:
	cmp	selectmenu,2	;howtoplay
	jne	nextmenu2
	lea	si,howd
	call	loadbgbuffer
	call	clrobjbuffer
	call	swapvideoram
	call	syncvideo
	mov	ah,8
	int	21h
	lea	si,intro
	call	loadbgbuffer
	call	syncvideo
	jmp	chkmenu
nextmenu2:
	cmp	selectmenu,3	;highscore
	jne	nextmenu3
	lea	si,highbg
	call	loadbgbuffer
	call	clrobjbuffer
	call	swapvideoram
	call	syncvideo
	call	showhiscore
	lea	si,intro
	call	loadbgbuffer
	call	syncvideo
	jmp	chkmenu
nextmenu3:
	cmp	selectmenu,4	;credit
	jne	endselect
	lea	si,credit
	call	loadbgbuffer
	call	clrobjbuffer
	call	swapvideoram
	call	syncvideo
	mov	ah,8
	int	21h
	lea	si,intro
	call	loadbgbuffer
	call	syncvideo
	jmp	chkmenu
endselect:
	call	exitgame	;exitgame
loopdown:
	mov	selectmenu,5
jmp_chkmenu:
	jmp	chkmenu
chkmenu:
	call	clrobjbuffer
	cmp	selectmenu,1
	jne	menu2
	mov	si,offset picsstartgame
	drawbmp	95,110,105,20,si
	jmp	startmenubreakpoint
menu2:
	cmp	selectmenu,2
	jne	menu3
	mov	si,offset picshowtoplay
	drawbmp	95,125,105,20,si
	jmp	startmenubreakpoint
menu3:
	cmp	selectmenu,3
	jne	menu4
	mov	si,offset picshigh
	drawbmp	95,140,105,20,si
	jmp	startmenubreakpoint
menu4:
	cmp	selectmenu,4
	jne	menu5
	mov	si,offset picscredit
	drawbmp	95,155,105,20,si
	jmp	startmenubreakpoint

menu5:
	mov	si,offset picsexitgame
	drawbmp	95,170,105,20,si
	jmp	startmenubreakpoint

exittodos:
	ret
menu	endp

initdata	proc
	mov	player1x,30
	mov	player2x,200
	mov	p1life,120
	mov	p2life,120
	mov	battley,90
	mov	p1width,85
	mov	p2width,110

	mov	p1score,0
	mov	p2score,0	
	mov	roundtime,100
	ret
initdata	endp