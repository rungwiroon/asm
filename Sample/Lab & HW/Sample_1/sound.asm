	.model small
	.code
	public	sound
sound	proc	near	
	mov	ax,0
	mov	ds,ax
	
	mov	ah,0ch
	int	21h
		
	in	al,61h
	or	al,3
	out	61h,al

	mov	ah,00
	mov	al,2
	int	10h
	
	mov	bh,17h
	call	clear
	mov	bx,0020

	call	main2
	
exit:	mov	ah,0ch
	int	21h	
	
	in	al,61h
	xor	al,3
	out	61h,al
	
	ret	;return to menu

sound	endp
;------------------------------
main2	proc	
	
	mov	ax,1
	int	33h

	mov	ah,00
	int	16h

check0:	cmp	al,30h
	jne	check1
	call	sound0
check1:	cmp	al,31h
	jne	check2
	call	sound1
check2:	cmp	al,32h
	jne	check3
	call	sound2
check3:	cmp	al,33h
	jne	check4
	call	sound3
check4:	cmp	al,34h
	jne	check5
	call	sound4
check5:	cmp	al,35h
	jne	check6
	call	sound5
check6:	cmp	al,36h
	jne	check7
	call	sound6
check7:	cmp	al,37h
	jne	check8
	call	sound7
check8:	cmp	al,38h
	jne	check9
	call	sound8
check9:	cmp	al,39h
	jne	check10
	call	sound9
check10: cmp	al,2eh
	jne	checke
	call	sound10
checke:	cmp	al,0dh
	jne	main2
	ret

sound0:	mov	bx,500
	call	beep
	mov	bh,00h
	call	clear
	jmp	main2
	
sound1:	mov	bx,700
	call	beep
	mov	bh,10h
	call	clear
	jmp	main2

sound2:	mov	bx,1000
	call	beep
	mov	bh,20h
	call	clear
	jmp	main2

sound3:	mov	bx,1500
	call	beep
	mov	bh,30h
	call	clear
	jmp	main2

sound4:	mov	bx,2000
	call	beep
	mov	bh,40h
	call	clear
	jmp	main2

sound5:	mov	bx,2500
	call	beep
	mov	bh,50h
	call	clear
	jmp	main2

sound6:	mov	bx,3000
	call	beep
	mov	bh,0ch
	call	clear
	jmp	main2

sound7:	mov	bx,4000
	call	beep
	mov	bh,60h
	call	clear
	jmp	main2

sound8:	mov	bx,5000
	call	beep
	mov	bh,70h
	call	clear
	jmp	main2

sound9: mov	bx,7000
	call	beep
	mov	bh,80h
	call	clear
	jmp	main2

sound10: mov	bx,0020
	call	beep
	jmp	main2	

main2	endp
;-----------------------------	
clear	proc	near	
	mov	ax,0600h
	mov	cx,0000
	mov	dx,184fh
	int	10h
	ret
clear	endp
;-----------------------------
beep	proc	near
	mov	ax,34dch
	mov	dx,12h
	div	bx
	out	42h,al
	mov	al,ah
	out	42h,al
	call	waits
	ret
beep	endp

waits	proc	near
	mov	dx,6
	mov	bx,0
	add	dx,ds:[46ch]
	adc	bx,ds:[46eh]
wait1:	mov	bp,ds:[46ch]
	mov	ax,ds:[46eh]
	sub	bp,dx
	sbb	ax,bx
	jc	wait1
	ret
waits	endp

	end	sound