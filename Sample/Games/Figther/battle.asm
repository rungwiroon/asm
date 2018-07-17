;---------------------- draw life bar ---------------------------
;	input	: none						;
;---------------------------------------------------------------;
drawbarlife	proc
	pushx	<ax,bx,cx,dx,di,si>
	cmp	p1life,0
	jl	p1knockout
	cmp	p2life,0
	jg	startdrawbarlife
	mov	p2life,0
	jmp	startdrawbarlife
p1knockout:
	mov	p1life,0

startdrawbarlife:

	lea	si,borderlife
	movebmp	180,15,1,12,si
	movebmp	24,15,1,12,si
	
	mov	cx,120
	lea	si,leftlife
	mov	dx,181
	xor	bx,bx
	mov	bl,p2life

@p2life:	
	cmp	bx,0
	jne	@p2rightlife
		lea	si,rightlife
	@p2rightlife:
	
	movebmp	dx,15,1,12,si	
	inc	dx	
	dec	bx
	loop	@p2life

	
	mov	cx,120
	lea	si,leftlife
	mov	dx,25
	xor	bx,bx
	mov	bl,p1life
	
@p1life:	
	cmp	bx,0
	jne	@p1rightlife
		lea	si,rightlife
	@p1rightlife:
	
	movebmp	dx,15,1,12,si	
	inc	dx	
	dec	bx
	loop	@p1life

	lea	si,borderlife
	movebmp	301,15,1,12,si
	movebmp	145,15,1,12,si	

	popx	<si,di,dx,cx,bx,ax>
	ret
drawbarlife	endp

;------------------- check attack ------------------------------;
;	input : ax = x of left side				;
;		bx = x of right side				;
;		dl = 1 : left attack to right			;
;		     2 : right attack to left			;
;	output : al = 1 : ok					;
;		 al = 0 : miss					;
;---------------------------------------------------------------;
checkattack	proc	
	cmp	dl,1
	je	@lefttoright
@righttoleft:	
	cmp	ax,bx
	jl	@miss
	mov	al,1
	jmp	@finishcheck
@lefttoright:
	cmp	ax,bx
	jl	@miss
	mov	al,1
	jmp	@finishcheck
@miss:
	mov	al,0
@finishcheck:
	ret
checkattack	endp

;----------------------- battle --------------------------------;
;								;
;---------------------------------------------------------------;
battle	proc
	pushx	<si,di,dx,cx,bx,ax>

	call	clrobjbuffer

	lea	si,batt2	
	call	loadbgbuffer

	lea	si,light1_2
	lea	di,dark1_2
	mov	p1width,58
	
	mov	dx,battley

	mov	cx,player1x			
	mov	bx,p1width
	movebmp	cx,dx,bx,85,si	;light1
	
	mov	cx,player2x	
	mov	bx,p2width
	movebmp	cx,dx,bx,85,di	;dark
	
	call	drawbarlife
	call	swapvideoram
	call	syncvideo
	
	call	clrobjbuffer
_MOVE:
	
	MOV	AH,1H
	INT	16H		; check keypressed
	Jnz	_KEYPRESSED

	COUNTDOWN
	call	syncvideo
	CMP	ROUNDTIME,0	
	Jne	_MOVE
	jmp	timeup
_KEYPRESSED:
	COUNTDOWN
	call	syncvideo

	call	inkey
	call	chkkey

	mov	ah,0ch		;clear keyboard buffer
	int	21h

	cmp	keyesc,1
	jne	@act1
	mov	keyesc,0
	jmp	finishedgame
@act1:				; player1 punch
	cmp	keyJ,1
	jne	@act2
		mov	keyJ,0
		pushx	<ax,bx,dx>
		mov	ax,player1x	; positoin of player1
		add	ax,p1width
		sub	ax,10
		mov	bx,player2x	; position of player2
		add	bx,27
		mov	dl,1
		call	checkattack	; check	attack
		cmp	al,1		
		jne	@p1punchmiss	; miss
		random	3
		add	dl,2
		sub	p2life,dl	; if ok then decrease player2 life
		add	p1score,100
	@p1punchmiss:
		popx	<dx,bx,ax>
		jmp	@showact
@act2:				; player1 kick
	cmp	keyK,1
	jne	@act3
		mov	keyK,0
		pushx	<ax,bx,dx>
		mov	ax,player1x	; positoin of player1
		add	ax,p1width
		sub	ax,10
		mov	bx,player2x	; position of player2
		add	bx,27
		mov	dl,1
		call	checkattack	; check	attack
		cmp	al,1		
		jne	@p1kickmiss	; miss
		random	3
		add	dl,2
		sub	p2life,dl	; if ok then decrease player2 life		
		add	p1score,100
	@p1kickmiss:
		popx	<dx,bx,ax>

		jmp	@showact
@act3:				; player2 punch
	cmp	keynum1,1
	jne	@act4
		mov	keynum1,0
		pushx	<ax,bx,dx>
		mov	ax,player1x	; positoin of player1
		add	ax,p1width
		sub	ax,21
		mov	bx,player2x	; position of player2
		add	bx,16
		mov	dl,2
		call	checkattack	; check	attack
		cmp	al,1		
		jne	@p2punchmiss	; miss
		random	3
		add	dl,2
		sub	p1life,dl	; if ok then decrease player2 life
		add	p2score,100
	@p2punchmiss:
		popx	<dx,bx,ax>

		jmp	@showact
@act4:					; player2. kick
	cmp	keynum2,1
	jne	@act5
		mov	keynum2,0
		pushx	<ax,bx,dx>
		mov	ax,player1x	; positoin of player1
		add	ax,p1width
		sub	ax,21
		mov	bx,player2x	; position of player2
		add	bx,16
		mov	dl,2
		call	checkattack	; check	attack
		cmp	al,1		
		jne	@p2kickmiss	; miss
		random	3
		add	dl,2
		sub	p1life,dl	; if ok then decrease player2 life
		add	p2score,100
	@p2kickmiss:
		popx	<dx,bx,ax>

		jmp	@showact
@act5:
	jmp	@noact
@showact:
	mov	cx,player1x		
	mov	bx,p1width		
	movebmp	cx,dx,bx,85,si	;light1
	lea	si,light1_2


	mov	bx,p2width
	mov	cx,player2x
	movebmp	cx,dx,bx,85,di	;dark1
	lea	di,dark1_2
	mov	p2width,110

	call	syncvideo

	call	drawbarlife
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	delay	100
@noact:

	mov	dx,battley
	
	mov	bx,p2width
	mov	cx,player2x
	movebmp	cx,dx,bx,85,di	;dark1
	
	mov	cx,player1x		
	mov	bx,p1width
	movebmp	cx,dx,bx,85,si	;light1

	call	drawbarlife
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	
	cmp	p1life,0
	jle	p1lose
	cmp	p2life,0
	jg	jmp_move
	lea	si,p1win
	drawbmp	15,80,289,35,si
	mov	ax,p1score
	add	al,roundtime
	add	al,p1life
	mov	score,ax
	jmp	finishgame
p1lose:
	lea	si,p2win
	drawbmp	15,80,289,35,si
	mov	ax,p2score
	add	al,roundtime
	add	al,p2life
	mov	score,ax	
	jmp	finishgame
jmp_move:
	jmp	_move
timeup:
	lea	si,pictimeup
	drawbmp	15,80,289,35,si
finishgame:
	COUNTDOWN
	call	syncvideo
	delay	2000
	lea	si,block
	drawbmp	30,135,270,47,si
	call	syncvideo

	call	getname
finishedgame:
	
	popx	<ax,bx,cx,dx,di,si>
	ret
battle	endp