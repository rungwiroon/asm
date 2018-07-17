opengraphic macro
   mov ah,00h
   mov al,13h
   int 10h
endm
closegraphic macro
   mov ah,00h
   mov al,03h
   int 10h
endm
save_register macro regs	
   irp d,<regs>		
   push d			
   endm
endm
load_register macro regs	
   irp d,<regs>		
   pop d			 
   endm
endm
pixel macro ganx,gany,maxc,maxr,color	
   local l1
   save_register <ax,cx,dx,si>
   mov cx,ganx			
   mov dx,gany			
l1:
   mov ah,0ch			
   mov al,color
   int 10h				
   inc cx				
   cmp cx,maxc		
   jne l1		
   mov cx,ganx			
   inc dx				
   cmp dx,maxr		
   jne l1			
   load_register <si,dx,cx,ax>	
endm
showpic macro ganx,gany,maxc,maxr,sta,pic	
   local l1
   save_register <ax,cx,dx,si>
   mov si,sta			
   mov cx,ganx			
   mov dx,gany			
l1:
   mov ah,0ch			
   mov al,pic[si]			
   int 10h	
   inc si				
   inc cx				
   cmp cx,maxc		
   jne l1		
   mov cx,ganx			
   inc dx				
   cmp dx,maxr		
   jne l1			
   load_register <si,dx,cx,ax>	
endm
showpicslow macro ganx,gany,width,high,sta,pic	;parameter gan x,gan y,width,long,picture name
        local plot,l1,l2
	save_register <ax,cx,dx,si>
	mov cx,ganx			;cx = column
        mov dx,gany			;dx = row
        cmp sta,0
	jne l1
	mov si,0	                ;initial pointer
        jmp plot
l1:
        cmp sta,
plot :
        mov ah,0ch			;fcn write pixel
        mov al,pic[si]			;save al = pic at si
        int 10h	
        add si,3			;increase si
        add cx,3				;increase cx
        cmp cx,ganx+width		;if cx = end of column
        jb  plot			;no, go to plot
        mov cx,ganx			;yes, initial cx 
	add si,width
        add dx,3			;increase dx
        cmp dx,gany+high		;if dx = end of row
        jb  plot			;no, go to plot

	load_register <si,dx,cx,ax>	
endm
showgame macro startx,starty,stopx,stopy,color,pic
   local l1,l2
   save_register <ax,cx,dx,si>
   mov ax,startx
   mov ganx,ax
   mov ax,starty
   mov gany,ax
   mov si,0
l1:
   mov al,color
   cmp pic[si],al
   je l2
   mov ax,ganx
   inc ax
   mov maxc,ax
   mov ax,gany
   inc ax
   mov maxr,ax
   mov sta,si
   mov cx,ganx
   mov dx,gany
   showpic ganx,gany,maxc,maxr,sta,pic
   mov ganx,cx
   mov gany,dx
l2:
   inc si
   inc ganx
   mov ax,stopx
   cmp ganx,ax
   jne l1
   mov ax,startx
   mov ganx,ax
   inc gany
   mov ax,stopy
   cmp gany,ax
   jne l1
   load_register <si,dx,cx,ax>
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
random macro max,ran 
   local l1
l1:
   mov ah,2ch			
   int 21h				
   mov cl,dl
   and cl,ran			
   cmp cl,max			
   ja l1				
endm
delay macro time			
   local l1,l2
   save_register <ax,cx,dx>
   mov dx,time			
l1:
   mov cx,65535			
l2:
   dec cx				
   jnz l2				
   dec dx				
   jnz l1				
   load_register <dx,cx,ax>
endm
keyplay macro
   local l1,l2
   save_register <ax>
l1:
   mov ah,1
   int 16h
   jz l2
   mov ah,0
   int 16h
   jmp l1
l2:
   in al,60h
   mov key,al
   load_register <ax>
endm
showmessage macro x,y,string
   save_register <ax,dx>
   mov ah,02h
   mov dl,x
   mov dh,y
   int 10h
   lea dx,string
   mov ah,09h
   int 21h
   load_register <dx,ax>
endm
showscore macro score
   save_register <ax,bx,cx,dx,si>   
   mov ax,score
   mov bl,100
   div bl
   mov ch,al				;ch = lak ror
   mov al,ah
   mov ah,0
   mov bl,10
   div bl
   mov cl,al				;cl = lak sib
   mov al,ah
   mov ah,0
   mov bl,1				
   div bl
   mov dh,al				;dh = lak noui
   shownum 
   load_register <si,dx,cx,bx,ax>
endm
shownum macro 
   mov bh,ch
   checknum 1
   mov bh,cl
   checknum 2
   mov bh,dh
   checknum 3
endm
checknum macro num
   local s1,s2,c1,c2,c3,l0,l1,l2,l3,l4,l5,l6,l7,l8,exitp
   mov starty,165
   mov stopy,189 
   mov ax,num
   cmp ax,2
   je c1
   cmp ax,3
   je c2
   mov startx,240
   mov stopx,252
   jmp c3
c1:
   mov startx,265
   mov stopx,277
   jmp c3
c2:
   mov startx,289
   mov stopx,301
c3:
   cmp bh,0
   je l0
   cmp bh,1
   je l1
   cmp bh,2
   je l2
   cmp bh,3
   je l3
   cmp bh,4
   je l4
   cmp bh,5
   je l5
   cmp bh,6
   je l6
   cmp bh,7
   je l7
   cmp bh,8
   je l8
   ;cmp bh,9
   showgame startx,starty,stopx,stopy,016,num9
   jmp exitp
l0:
   showgame startx,starty,stopx,stopy,016,num0
   jmp exitp
l1:
   showgame startx,starty,stopx,stopy,016,num1
   jmp exitp
l2:
   showgame startx,starty,stopx,stopy,016,num2
   jmp exitp
l3:
   showgame startx,starty,stopx,stopy,016,num3
   jmp exitp
l4:
   showgame startx,starty,stopx,stopy,016,num4
   jmp exitp
l5:
   showgame startx,starty,stopx,stopy,016,num5
   jmp exitp
l6:
   showgame startx,starty,stopx,stopy,016,num6
   jmp exitp
l7:
   showgame startx,starty,stopx,stopy,016,num7
   jmp exitp
l8:
   showgame startx,starty,stopx,stopy,016,num8
exitp:
endm
