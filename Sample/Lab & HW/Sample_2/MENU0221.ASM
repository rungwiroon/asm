	.model compact
	.stack 100h
	.data
main	db	'Please select program$'
menu1	db	'1.Time$'
menu2	db	'2.Random Number$'
menu3	db	'3.Day$'
menu4	db	'4.Man $'
menu5	db	'5.Exit$'
	.code
	public	menu0221
	extrn	delay:far
	extrn	number2:far
	extrn	time1:far
	extrn	man1:near
	extrn	day0:far
menu0221	proc	 near
	mov	ax,@data
	mov	ds,ax
	call	sta
	;
exit:	mov	ax,2
	int	33h
	mov	ah,0
	mov	al,2
	int	10h
	call	clear
	mov	ah,4ch
	int	21h
menu0221	endp

sta	proc	 near
	mov	ah,0
	mov	al,2
	int	10h
	
        mov	ax,0600h
	mov	bh,6fh
	mov	cx,0000
	mov	dx,184fh
	int	10h

	mov	ax,1
	int	33h
;--------------------------------------
	
	mov	dl,21  
	mov	dh,5
	call	movec

	lea	dx,main
	mov	ah,9
	int	21h

	mov	dl,30
	mov	dh,8
	call    movec

	lea	dx,menu1
	mov	ah,9
	int	21h

	mov	dl,30
	mov	dh,10
	call	movec

	lea	dx,menu2
	mov	ah,9
	int	21h

	mov	dl,30
	mov	dh,12
	call	movec

	lea	dx,menu3
	mov	ah,9
	int	21h

	mov	dl,30
	mov	dh,14
	call	movec

	lea	dx,menu4
	mov	ah,9
	int	21h

	mov	dl,30
	mov	dh,16
	call	movec

	lea	dx,menu5
	mov	ah,9
	int	21h
;--------------------------------------
rdmse:	mov	ax,3
	int	33h
        cmp     bl,1
	jnz	rdmse
;--------main  check--------------------------
next0:	cmp	cx,00f0h
	je	press1
	cmp	cx,00f1h
	je	press1	
	cmp	cx,00f2h
	je	press1	
	cmp	cx,00f3h
	je	press1	
	cmp	cx,00f4h
	je	press1	
	cmp	cx,00f4h
	je	press1	
	cmp	cx,00f4h
	je	press1	
	cmp	cx,00f4h
	jne	rdmse
;--------sub check--------------------------	
press1:	cmp	dx,0040h
	je	program01
	cmp	dx,0041h
	je	program01
	cmp	dx,0042h
	je	program01
	cmp	dx,0043h
	je	program01
	cmp	dx,0044h
	je	program01
	cmp	dx,0045h
	je	program01
	cmp	dx,0046h
	je	program01
	cmp	dx,0047h
	jne	press2
program01:
	call	time1		;\\\\\\\\\\\	
	jmp	sta
;---------------------------------------------
press2:	cmp	dx,0050h
	je	program02
	cmp	dx,0051h
	je	program02
	cmp	dx,0052h
	je	program02
	cmp	dx,0053h
	je	program02
	cmp	dx,0054h
	je	program02
	cmp	dx,0055h
	je	program02
	cmp	dx,0056h
	je	program02
	cmp	dx,0057h
	jne	press3
program02:	
	call	number2		;\\\\\\\\\\\\\\	
	jmp	sta
;----------------------------------------------------
press3: cmp	dx,0060h
	je	program03
	cmp	dx,0061h
	je	program03
	cmp	dx,0062h
	je	program03
	cmp	dx,0063h
	je	program03
	cmp	dx,0064h
	je	program03
	cmp	dx,0065h
	je	program03
	cmp	dx,0066h
	je	program03
	cmp	dx,0067h
	jne	press4
program03:						
	call	day0
	jmp	sta
;---------------------------------
press4:	cmp	dx,0070h
	je	program04
	cmp	dx,0071h
	je	program04
	cmp	dx,0072h
	je	program04
	cmp	dx,0073h
	je	program04
	cmp	dx,0074h
	je	program04
	cmp	dx,0075h
	je	program04
	cmp	dx,0076h
	je	program04
	cmp	dx,0077h
	jne	press5
program04:
	call	man1
	jmp	sta
;------------------------------------------
press5:	cmp	dx,0080h
	je	program05
	cmp	dx,0081h
	je	program05
	cmp	dx,0082h
	je	program05
	cmp	dx,0083h
	je	program05
	cmp	dx,0084h
	je	program05
	cmp	dx,0085h
	je	program05
	cmp	dx,0086h
	je	program05
	cmp	dx,0087h
	je	program05
	jmp	rdmse
program05:		
;-----------end chek--------------------------	
	ret
;===============================

chknum:	mov	ah,8
	int	21h
	ret

movec:	mov	bh,0
	mov	ah,2
	int	10h
	ret	

movec1:	mov	dl,29
	mov	dh,12
	ret

movec2:	mov	dl,29
	mov	dh,14
	ret

movec3:	mov	dl,29
	mov	dh,16
	ret

clearc:	mov	dl,0
	mov	ah,2
	int	21h
	ret

cursor	proc	near
	push	ax
	push	dx
	mov	dl,10h
	mov	ah,2
	int	21h
	pop	dx
	pop	ax
	ret
cursor	endp

clear	proc	near
	mov	ah,06
	mov	al,00
	mov	ah,07
	mov	cx,0
	mov	dx,184fh
	int	10h
	ret
clear	endp
;--------------------------------
disp	proc	near
	push	cx
	
	mov	cx,4
nybl:	rol	ax,1
	rol	ax,1
	rol	ax,1
	rol	ax,1
	push	ax
	and	al,0fh
	add	al,30h
	cmp	al,3ah
	jc	no7
	add	al,7
no7:	mov	[di],al
	pop	ax
	add	di,2
	loop	nybl
	pop	cx
	ret
disp	endp
;-------------------------------
sta	endp
end	menu0221