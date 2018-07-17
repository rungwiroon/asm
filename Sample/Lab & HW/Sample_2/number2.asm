 	.model small 
	.stack 100h
	.data
st0	db  'E   (click "E"to exit) $' 
st1	db  'Run (click)     :      Stop (right click)$' 	
	.code
public	number2 
extrn	delay:far
;;;--------------------------------------------
number2  proc      near
	mov	ax,@data
	mov	ds,ax
start:  mov     ah,0
        mov     al,2
        int     10h
	
	mov	ax,0600h
	mov	bh,9fh
	mov	cx,0000
	mov	dx,184fh
	int	10h
        ;--------------
	mov     ah,09 
	lea	dx,st0
        int     21h
	mov	dl,33 
	mov	dh,2
	mov	bh,0
	mov	ah,2
	int	10h
	mov     ah,09 
	lea	dx,st1
        int     21h
main:	
	
	mov	dl,21  
	mov	dh,9
	mov	bh,0
	mov	ah,2
	int	10h
	;
	mov     dl,30h
        mov     ah,2
        int     21h
	;
	mov	ax,1
	int	33h	
rdmse1:	mov	ax,3
	int	33h
	cmp     bl,2
	jnz	nex0	  ;no click
	jmp	chk 
	;
nex0:	mov	dl,21  
	mov	dh,9
	mov	bh,0
	mov	ah,2
	int	10h
	;
	mov     dl,31h
        mov     ah,2
        int     21h
	;
	mov	ax,1
	int	33h	
rdmse2:	mov	ax,3
	int	33h
	cmp     bl,2
	jnz	nex1	  ;no click
	jmp	chk
	;
nex1:	mov	dl,21  
	mov	dh,9
	mov	bh,0
	mov	ah,2
	int	10h
	;
	mov     dl,32h
        mov     ah,2
        int     21h
	;
	mov	ax,1
	int	33h	
rdmse3:	mov	ax,3
	int	33h
	cmp     bl,2
	jnz	nex2	  ;no click
	jmp	chk 
	;
nex2:	mov	dl,21  
	mov	dh,9
	mov	bh,0
	mov	ah,2
	int	10h
	;
	mov     dl,33h
        mov     ah,2
        int     21h
	
	mov	ax,1
	int	33h	
rdmse4:	mov	ax,3
	int	33h
	cmp     bl,2
	jnz	nex3	  ;no click
	jmp	chk 
	;
nex3:	mov	dl,21  
	mov	dh,9
	mov	bh,0
	mov	ah,2
	int	10h
	;
	mov     dl,34h
        mov     ah,2
        int     21h
	;
	mov	ax,1
	int	33h	
rdmse5:	mov	ax,3
	int	33h
	cmp     bl,2
	jnz	nex4	  ;no click
	jmp	chk
	;
nex4:	mov	dl,21  
	mov	dh,9
	mov	bh,0
	mov	ah,2
	int	10h
	mov     dl,35h
        mov     ah,2
        int     21h
	;
	mov	ax,1
	int	33h	
rdmse6:	mov	ax,3
	int	33h
	cmp     bl,2
	jnz	nex5	  ;no click
	jmp	chk 
	;
nex5:	mov	dl,21  
	mov	dh,9
	mov	bh,0
	mov	ah,2
	int	10h
	;
	mov     dl,36h
        mov     ah,2
        int     21h

	mov	ax,1	;คลิกซ้าย
	int	33h	
rdmse7:	mov	ax,3
	int	33h
	cmp     bl,2
	jnz	nex6	;ไม่มีการกดทำต่อ
	jmp	chk	;กดเช็ก	
nex6:	jmp	main
;--------main  check--------------------------
chk:	cmp	cx,00h	;กดที 00?
	jne	main1	;ไม่ใช้ไปที่main1
;--------sub check--------------------------	
press:	cmp	dx,00h	;มีการกดที่00ดูที่dxเป็น00ด้วยไหม
	jne	main1	;ไม่ใช้ไปmain1
	jmp	exit	;\\\\\\\\\\\
;------------------------------------
main1:	
	mov	ax,1	
	int	33h
	mov	bl,0
rdmse:	mov	ax,3	;
	int	33h
        cmp     bl,1	;คลิกขวา	ไปต่อ
	jnz	rdmse	;ไม่คลิกไปmain1
;------------------------------------------
chk0:	cmp	cx,00h
;--------sub check--------------------------		
	jne	nex6
	cmp	dx,00h
	jne	nex6
	jmp	exit
;-------------------------------
exit:  mov	ax,2
	int	33h
	ret
.exit 
number2      endp
;-----------------------
ma:	jmp	main 
;==========================
     end       number2 
