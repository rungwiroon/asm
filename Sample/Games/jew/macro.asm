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
random macro max,ran    ;output is cl
   local l1
l1:
   mov ah,2ch			
   int 21h				
   mov cl,dl
   and cl,ran			
   cmp cl,max			
   ja l1				
endm
random2 macro max,ran    ;output is cl
   local l1
l1:
   mov ah,2ch			
   int 21h				
   mov al,dl
   mov dl,ran
   mul dl
   mov dl,7
   div dl
   mov cl,ah
   and cl,max   
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
gotoxy macro x,y
   save_register <ax,dx>
   mov ah,02h
   mov dl,x
   mov dh,y
   int 10h
   load_register <dx,ax>
endm
showchar macro x,y,char
   save_register <ax,dx>
   mov ah,02h
   mov dl,x
   mov dh,y
   int 10h
   mov dl,char
   mov ah,02h
   int 21h
   load_register <dx,ax>
endm
Printf macro string
        local start,msg
   save_register <ax,dx,ds>
        jmp start
   msg db string,'$'
   start:
        mov ax,cs
        mov ds,ax
        mov ah,09h
        lea dx,msg
        int 21h
   load_register <ds,dx,ax>
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
