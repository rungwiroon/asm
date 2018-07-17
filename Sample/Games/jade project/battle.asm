;---------------------- draw life bar ---------------------------
;	input	: none						;
;---------------------------------------------------------------;
drawbarlife	proc
	pushx	<ax,bx,cx,dx,di,si>
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

	lea	si,light1
	lea	di,dark1

	
	mov	dx,battley

	mov	cx,player1x			
	mov	bx,p1width
	movebmp	cx,dx,bx,60,si	;light1
	
	mov	cx,player2x	
	mov	bx,p2width
	movebmp	cx,dx,bx,60,di	;dark
	
	call	drawbarlife
	call	swapvideoram
	call	syncvideo
	
	call	clrobjbuffer
_MOVE:
	
	MOV	AH,1H
	INT	16H		; check keypressed
	Jnz	_KEYPRESSED

	COUNTDOWN
	CMP	ROUNDTIME,0	
	Jne	_MOVE
	call	exitgame
_KEYPRESSED:

	COUNTDOWN
	call	inkey
	call	chkkey

	mov	ah,0ch		;clear keyboard buffer
	int	21h

	cmp	keyesc,1
	jne	@act1
	call	exitgame
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
		sub	p2life,7	; if ok then decrease player2 life		
	@p1punchmiss:
		popx	<dx,bx,ax>
		jmp	@showact
@act2:				; player1 kick
	cmp	keyK,1
	jne	@act3
		mov	keyK,0
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
		sub	p1life,7	; if ok then decrease player2 life

	@p2punchmiss:
		popx	<dx,bx,ax>

		jmp	@showact
@act4:					; player2. kick
	cmp	keynum2,1
	jne	@act5
		mov	keynum2,0
		jmp	@showact
@act5:
	jmp	@noact
@showact:
	mov	cx,player1x		
	mov	bx,p1width		
	movebmp	cx,dx,bx,60,si	;light1
	lea	si,light1
	mov	p1width,50

	mov	bx,p2width
	mov	cx,player2x
	movebmp	cx,dx,bx,60,di	;dark1
	lea	di,dark1
	mov	p2width,77

	call	drawbarlife
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	delay	100
@noact:
	mov	dx,battley
	
	mov	bx,p2width
	mov	cx,player2x
	movebmp	cx,dx,bx,60,di	;dark1
	
	mov	cx,player1x		
	mov	bx,p1width
	movebmp	cx,dx,bx,60,si	;light1

	call	drawbarlife
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	
	jmp	_move	
	popx	<ax,bx,cx,dx,di,si>
	ret
battle	endp