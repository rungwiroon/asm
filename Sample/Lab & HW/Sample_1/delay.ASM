	.model small    
 	.code
	public	delay 
delay	proc	near
        mov     cx,10 ;      10=0.5s
del:
        push    cx
        MOV     AH,2ch
        INT     21H
        mov     bh,dl
ma:        
        mov     ah,2ch
        int     21h
        cmp     bh,Dl
        je      ma
        pop     cx
        loop    del   
        ret
delay	endp
	end	delay
	
 