.data	
	tempTime	db ?
	delayTime	db ?
	hur	db 0
	min	db 0
	sec	db 0
delay	macro	_times
	local	i,j
	mov	delayTime,_times
	mov	ah,2ch
	i:
	int	21h
	and	dl,00000011b
	mov	tempTime,dl
	j:
	int	21h
	and	dl,00000011b
	cmp	dl,tempTime
	je	j	
	dec	delayTime
	cmp	delayTime,0
	jg	i
	endm

getTime	macro
	pusha
	mov	ah,2ch
	int	21h
	mov	hur,ch
	mov	min,cl
	mov	sec,dh
	popa
	endm

printNumber	macro x,y,lenght,_number	; this function is type right to left
	local	i
	pusha
	mov	_xw,x
	mov	_yw,y
	mov	ax,_number
	mov	cx,lenght
	mov	bx,10
	i:
	xor	dx,dx
	div	bx
	call	printCharNum
	sub	_xw,10
	loop	i
	popa
	endm

putNum	macro	x,y,num		; You not use this putNum but use printNumber only
	local	n1,n2,n3,n4,n5,n6,n7,n8,n9,nEnd
	pusha
	mov	dl,num
	cmp	dl,0
	jne	n1
	putSprite x,y,num0
	jmp	nEnd
	n1:
	cmp	dl,1
	jne	n2
	putSprite x,y,num1
	jmp	nEnd
	n2:
	cmp	dl,2
	jne	n3
	putSprite x,y,num2
	jmp	nEnd
	n3:
	cmp	dl,3
	jne	n4
	putSprite x,y,num3
	jmp	nEnd
	n4:
	cmp	dl,4
	jne	n5
	putSprite x,y,num4
	jmp	nEnd
	n5:
	cmp	dl,5
	jne	n6
	putSprite x,y,num5
	jmp	nEnd
	n6:
	cmp	dl,6
	jne	n7
	putSprite x,y,num6
	jmp	nEnd
	n7:
	cmp	dl,7
	jne	n8
	putSprite x,y,num7
	jmp	nEnd
	n8:
	cmp	dl,8
	jne	n9
	putSprite x,y,num8
	jmp	nEnd
	n9:
	cmp	dl,9
	jne	nEnd
	putSprite x,y,num9
	nEnd:
	popa
	endm


exit	macro
	mov	ax,4c00h
	int	21h	
	endm

printStatus	macro Hero
	pusha
	mov	bx,Hero
	xor	cx,cx
	mov	cl,Who[bx]
	call	drawPictureChar
	xor	ax,ax
	mov	al,hp[bx]
	printNumber 310,63,3,ax
	mov	al,at[bx]
	printNumber 310,80,3,ax
	putSprite 260,64,textHp
	putSprite 260,81,textAt
	popa
	endm

checkRangeMouse	macro x1,y1,x2,y2
	local	endChk,outEndChk
	cmp	mouseX,x1
	jnge	endChk
	cmp	mouseX,x2
	jnle	endChk
	cmp	mouseY,y1
	jnge	endChk
	cmp	mouseY,y2
	jnle	endChk
	mov	mouseRange,1
	jmp	outEndChk
	endChk:
	mov	mouseRange,0
	outEndChk:
	endm

savReg	macro
	push	ax
	push	bx
	push	cx
	push	dx
	endm

lodReg	macro
	pop	ax
	pop	bx
	pop	cx
	pop	dx
	endm

addHero	macro	x,y,IDHero
	local	endAddHero,Added
	push	si
	mov	si, MaxPlay
	cmp	si, AllPlayMax
	jge	endAddHero
	push	ax
	push	bx
	xor	ax, ax
	xor	bx, bx
	mov	ax, y
	mov	bx, x
	checkAtMap bx,ax
	cmp	_temp, 0
	jne	Added
	mov	bh, IDhero
	mov	tempWho, bh
	xor	bh, bh
	setXYMap bx,ax			; Set X,Y *is Function use tempWho
	push	cx
	push	dx
	mov	ch, al			; Grand Y
	mov	cl, bl			; Grand X
	inc	MaxPlay
	inc	MinPlay
	inc	TurnWho
	findStatus IDHero
	mov	bx, MaxPlay		; BX is index last add
	dec	bx

	mov	al, [si+0]		; Add Who
	mov	Who[bx], al
	mov	al, [si+9]		; Add Who player
	mov	whoPlay[bx], al
	mov	noDie[bx], 1		; Add hero is no die
	mov	hX[bx], cl		; Add hero is grand X
	mov	hY[bx], ch		; Add hero is grand Y
	mov	al, [si+10]		; Add hero is Health
	mov	Hp[bx], al		
	mov	al, [si+11]		; Add hero is Attack
	mov	At[bx], al
	pop	dx
	pop	cx		
	Added:
	pop	bx
	pop	ax
	endAddHero:	
	pop	si
	endm

findStatus	macro index		; Is function find address data of hero return address in SI
	local	endFindStatus,statusHero,skipAttack
	push	cx
	push	dx
	mov	dl, index
	mov	cl, _Head
	mov	si, offset _Head	
	cmp	byte ptr [si], cl	; Check Data is true if false to endFindStatus
	jne	endFindStatus
	inc	si			; Skip Head to First Status
	xor	cx, cx
	mov	cl, dl
	cmp	cl, 1			; Check Index is First Status if yes to endFindStatus
	je	endFindStatus
	mov	cx, 1
	statusHero:
	add	si, SeekAttack		; Seek To Attack
	push	cx
	mov	cl, [si]		; Read Total Table Attack
	inc	si
	skipAttack:
	add	si, 2
	loop	skipAttack		; Skip Attack of current hero
	pop	cx
	inc	cl
	cmp	[si],dl
	jne	statusHero		
	endFindStatus:
	pop	dx
	pop	cx
	endm
	
changeWalkXY	macro x,y		; changeWalkXY set table walk (x,y) = 1
	local	nextChange,changeIt	; is function use AX = Y; BX = X  ONLY !!
	pusha
	xor	si,si
	mov	ax,y
	cmp	ax,0
	jl	nextChange
	cmp	ax,7
	jg	nextChange
	mov	cx,8
	mul	cx
	mov	cx,x
	cmp	cx,0
	jl	nextChange
	cmp	cx,7
	jg	nextChange
	add	si,cx
	add	si,ax
	cmp	controlGame,1
	je	changeIt
	cmp	map[si],0
	jne	nextChange
	changeIt:
	mov	walk[si],1
	nextChange:
	popa
	endm


changeWalk	macro x1,y1,x2,y2	; Change Walk table
	local	i,j,next1,next2,next3
	pusha
	mov	_xw,x2
	cmp	_xw,7	; Check Table width > 8
	jng	next1
	mov	_xw,7	
	next1:
	mov	_yw,y2
	cmp	_yw,7	; Check Table height > 8
	jng	next2
	mov	_yw,7
	next2:
	mov	bx,x1	
	cmp	bx,0	; Check Table x < 0
	jnl	next3
	mov	bx,0
	next3:
	mov	ax,y1
	cmp	ax,0	; Check Table y < 0
	jnl	i
	mov	ax,0
	i:
	push	bx
	j:
	changeWalkXY bx,ax
	inc	bx
	cmp	bx,_xw
	jng	j
	pop	bx
	inc	ax
	cmp	ax,_yw
	jng	i
	popa
	endm

cbwAB	macro		; This function change byte to word ( AX and BX ) only
	xor	ah,ah
	xor	bh,bh
	push	ax
	mov	ax,bx
	cbw
	mov	bx,ax
	pop	ax
	cbw
	endm

checkClickWalk	macro	; Check Mouse Click when walk
	local	nextEnd_
	pusha
	xor	bx,bx
	xor	ax,ax
	mov	bl,SelectX
	mov	al,SelectY
	mov	cx,8
	mul	cx
	add	bx,ax
	mov	mouseClick,0
	cmp	walk[bx],1
	jne	nextEnd_
	mov	mouseClick,1
	nextEnd_:
	popa
	endm	

checkAtMap	macro	x,y	; return Data At map X,Y
	pusha			; output _temp
	mov	bx,x
	mov	ax,y
	mov	cx,8
	mul	cx
	add	bx,ax
	mov	cl,map[bx]
	mov	_temp,cl
	popa
	endm

getXYMap	macro	x,y	; Get Data Charactor in Map
	pusha
	mov	bx,x
	mov	ax,y
	mov	cx,8
	mul	cx
	add	bx,ax
	mov	al,map[bx]
	mov	tempWho,al
	mov	map[bx],0
	popa
	endm
getMap	macro	x,y		; Get Data Charactor but not pop data
	pusha
	mov	bx,x
	mov	ax,y
	mov	cx,8
	mul	cx
	add	bx,ax
	mov	al,map[bx]
	mov	tempWho,al
	popa
	endm

setXYMap	macro	x,y	; Set Data at X,Y
	pusha
	mov	bx,x
	mov	ax,y
	mov	cx,8
	mul	cx
	add	bx,ax
	mov	cl,tempWho
	mov	map[bx],cl
	popa
	endm

