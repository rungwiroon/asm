	.model small    
 	.stack 64
	.data
msec	db	?
sec	db	?
min	db	?
hour	db	?
ten	db	10

	.386
	.code
	public	time1
time1    proc	near
		
	mov	ax,@data
	mov	ds,ax
	mov	es,ax
        call	color1

start:	MOV     AH,2ch
        INT     21H
	
	mov	msec,dl
	mov	sec,dh
	mov	min,cl
	mov	hour,ch
	
	call	setcur
	call	hours
	call	dotdot
	call	mins
	call	dotdot
	call	second
	call	dotdot
	call	milsec

	mov	ax,1
	int	33h
rdmse:	mov	ax,3
	int	33h
        cmp     bl,2
	jnz	start

	;mov	ax,2
	;int	33h
	
exit:	
	ret

time1	endp

milsec	proc
	movzx	ax,msec
	div	ten
	or	ax,3030h
	mov	bx,ax
	
	mov	dl,bl
	mov	ah,02
	int	21h
	
	mov	dl,bh
	mov	ah,02
	int	21h
	ret
milsec	endp

second	proc
	movzx	ax,sec
	div	ten             ; ax/10 ; = al +	ah
	or	ax,3030h
	mov	bx,ax
	
	mov	dl,bl
	mov	ah,02
	int	21h
	
	mov	dl,bh
	mov	ah,02
	int	21h
	ret
second	endp

mins	proc
	movzx	ax,min
	div	ten
	or	ax,3030h
	mov	bx,ax
	
	mov	dl,bl
	mov	ah,02
	int	21h
	
	mov	dl,bh
	mov	ah,02
	int	21h
	ret
mins	endp

hours	proc
	movzx	ax,hour
	div	ten
	or	ax,3030h
	mov	bx,ax
	
	mov	dl,bl
	mov	ah,02
	int	21h
	
	mov	dl,bh
	mov	ah,02
	int	21h
	ret
hours	endp

setcur	proc
	mov	ah,02
	mov	bh,00
	mov	dh,13
	mov	dl,32
	int	10h
	ret
setcur	endp

dotdot	proc
	mov	dl,3ah
	mov	ah,02
	int	21h
	ret
dotdot	endp

color1 proc      near
	mov     ah,0
        mov     al,2
        int     10h
  ;----------1----======
        mov     ax,0
        mov     bl,40h
        mov     cx,400
        call    color
   ;========2===========
        mov     dh,5
        mov     dl,0
        call    cursor
        mov     ax,0
        mov     bl,0f0h
        mov     cx,400
        call    color
   ;==========3==========
        mov     dh,10
        mov     dl,0
        call    cursor
        mov     ax,0
        mov     bl,1fh
        mov     cx,480
        call    color
  ;==========4=========
        mov     dh,16
        mov     dl,0
        call    cursor
        mov     ax,0
        mov     bl,0f0h
        mov     cx,400
        call    color
;------------5-------------------
        mov     dh,21
        mov     dl,0
        call    cursor
        mov     ax,0
        mov     bl,40h
        mov     cx,320
        call    color
	ret
 color1  endp 
;--------------------------------------   
color	proc      near
	  mov     ah,9
        mov     bh,0
        int     10h
        ret
 color  endp 
cursor	proc      near
	mov     ah,2
        mov     bh,0
        int     10h
        ret
   cursor  endp 
end     time1
