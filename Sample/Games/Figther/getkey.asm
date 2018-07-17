;--------------------------------------------------------
;	action form key
;--------------------------------------------------------

chkkey	proc
	push	ax
	push	bx
	cmp	keyA,1
	jne	@chk2
		mov	keyA,0
		sub	player1x,2
		cmp	player1x,5
		jg	@chk2
		mov	player1x,5
@chk2:
	cmp	keyD,1
	jne	@chk3
		mov	keyD,0
		add	player1x,2
		mov	ax,player2x
		sub	ax,p1width
		add	ax,40
		cmp	player1x,ax
		jl	@chk3
		mov	player1x,ax
@chk3:
	cmp	keyright,1
	jne	@chk4
		mov	keyright,0
		add	player2x,2
		mov	ax,315
		sub	ax,p2width
		add	ax,20
		cmp	player2x,ax
		jl	@chk4
		mov	player2x,ax
@chk4:
	cmp	keyleft,1
	jne	@chk5
		mov	keyleft,0
		sub	player2x,2
		mov	ax,player1x
		add	ax,p1width
		sub	ax,40
		cmp	player2x,ax
		jg	@chk5
		mov	player2x,ax

@chk5:
	cmp	keyJ,1
	jne	@chk6	
		lea	si,light2_2
		mov	p1width,58
@chk6:
	cmp	keyK,1
	jne	@chk7	
		lea	si,light3_2
		mov	p1width,58
@chk7:
	cmp	keynum1,1
	jne	@chk8
		lea	di,dark2_2
		mov	p2width,110
@chk8:
	cmp	keynum2,1
	jne	@chk9
		lea	di,dark3_2
		mov	p2width,110
@chk9:
	pop	bx
	pop	ax
	ret
chkkey	endp

;--------------------------------------------------------
;	check input keyboard
;--------------------------------------------------------
inkey	proc
	push	ax

	MOV	AH,0		
	INT	16H		; check key

	CMP	AL,0
	jne	@normalkey
	cmp	ah,04dh		; righ arrow
	jne	@skey2
	mov	keyright,1
@skey2:
	cmp	ah,04bh		;left arrow
	jne	@normalkey
	mov	keyleft,1
@normalkey:
	CMP	AL,27D		; ESC	
	jne	@key2
	mov	keyesc,1
@key2:
	CMP	AL,65D		; A
	jne	@key3	
	mov	keyA,1
@key3:
	CMP	AL,68D		; D
	jne	@key4	
	mov	keyD,1
@key4:
	CMP	AL,97D		; a
	jne	@key5	
	mov	keyA,1
@key5:
	CMP	AL,100D		; d
	jne	@key6	
	mov	keyD,1
@key6:
	CMP	AL,106D		; j
	jne	@key7
	mov	keyJ,1
@key7:
	CMP	AL,74d		; J
	jne	@key8
	mov	keyJ,1
@key8:
	CMP	AL,107D		; k
	jne	@key9
	mov	keyK,1
@key9:
	CMP	AL,75d		; K
	jne	@key10
	mov	keyK,1
@key10:
	CMP	AL,49d		; 1
	jne	@key11
	mov	keynum1,1
@key11:
	CMP	AL,50d		; 2
	jne	@finishkey
	mov	keynum2,1

@finishkey:
	pop	ax
	ret
inkey	endp
