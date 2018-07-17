.model small


save_register macro regs	;parameter register
	irp d,<regs>		;indefinite repeat
	push d			;save register 
	endm
endm


load_register macro regs	;parameter register
	irp d,<regs>		;indefinite repeat
	pop d			;load register 
	endm
endm

showpicture macro ganx,gany,width,high,pic	;parameter gan x,gan y,width,long,picture name
        local plot
	save_register <ax,cx,dx,si>

	mov si,0			;initial pointer
        mov cx,ganx			;cx = column
        mov dx,gany			;dx = row
plot :
        mov ah,0ch			;fcn write pixel
        mov al,pic[si]			;save al = pic at si
        int 10h	
        inc si				;increase si
        inc cx				;increase cx
        cmp cx,ganx+width		;if cx = end of column
        jne plot			;no, go to plot
        mov cx,ganx			;yes, initial cx 
        inc dx				;increase dx
        cmp dx,gany+high		;if dx = end of row
        jne plot			;no, go to plot

	load_register <si,dx,cx,ax>	
endm
delay macro time			;parameter  time to delay
	local p1,p2
	save_register <ax,cx,dx>

	mov dx,time			;pass time to dx
p1:	mov cx,65535			;save 65535 to cx

p2:	dec cx				;decrease cx
	jnz p2				;if cx = 0?   no, go to p2
	dec dx				;decrease dx
	jnz p1				;if dx = 0?   no, go to p1

	load_register <dx,cx,ax>
endm

jump_snow macro 
	local jew
	save_register <cx>

	xor cx,cx
	mov cx,10h
jew:	
	mov ah,00h
	mov ah,13h
	int 10h
	showpicture 10,50,40,32,greenwin
	delay 200
	showpicture 10,50,40,32,greenwin2
	delay 200
	showpicture 10,50,40,32,greenwin3
	delay 200
	dec cx
	cmp cx,0
	jnz jew
	
	load_register <cx>
	
endm

square macro ganx,gany,maxc,maxr,c1,c2
   local l1,l2,l3,l4
   save_register <ax,cx,dx>
   mov cx,ganx
   mov dx,gany
l1:
   cmp cx,ganx
   je l2
   cmp dx,gany
   je l2
   cmp cx,maxc
   je l3
   cmp dx,maxr
   je l3
   jmp l4
l2:
   mov ah,0ch
   mov al,c1
   int 10h
   jmp l4
l3:
   mov ah,0ch
   mov al,c2
   int 10h
l4:
   inc cx
   cmp cx,maxc+1
   jne l1
   mov cx,ganx
   inc dx
   cmp dx,maxr+1
   jne l1
   load_register <dx,cx,ax>
endm

.stack 100h
.data 
include picture.asm
.code
main proc
        mov ax,@data
	mov ds,ax
        mov ah,00h
        mov al,13h
        int 10h

	mov ah,6	;clear screen
	xor al,al
	xor cx,cx
	mov dx,184fh
	mov bh,15
	int 10h  

	square 1,1,318,198,4,4
	square 2,2,319,199,4,4

	;jump_snow
	showpicture 10,20,40,32,green1
	showpicture 55,20,40,32,green2  
	showpicture 100,20,40,32,green3
	showpicture 150,20,40,32,green4
	showpicture 200,20,40,32,green5
	
	showpicture 10,50,40,32,greenwin
	;delay 500

	showpicture 55,50,40,32,greenwin2
	showpicture 10,50,40,32,greenwin2
	;delay 500
	showpicture 100,50,40,32,greenwin3
	showpicture 10,50,40,32,greenwin3
	;delay 500
	showpicture 100,50,40,32,greended

	showpicture 10,150,160,32,season
	showpicture 200,150,16,16,snow
	showpicture 10,80,20,16,snow1
	showpicture 55,80,24,18,snow2
	showpicture 100,80,40,24,snow3
	showpicture 150,80,40,24,snow4

	showpicture 10,110,40,32,redded
	showpicture 55,110,40,32,red1
	showpicture 100,110,40,32,red2	
	showpicture 150,110,40,32,red3	
	showpicture 200,110,40,32,red4	
	showpicture 250,110,40,32,red5		

	delay 10000
	mov ah,4ch
	int 21h

main endp
end main




