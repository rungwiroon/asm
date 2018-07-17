pushx	macro	regs
	irp	r,<regs>
	push	r
	endm
endm

popx	macro	regs
	irp	r,<regs>
	pop	r
	endm
endm

drawbmp	macro	x,y,w,h,bitmap
	local	x,y,w,h,bitmap
	pushx	<si,di>
	mov	bmp_x,x
	mov	bmp_y,y
	mov	gpw1,w
	mov	gpw2,h
	mov	si,bitmap
	call	objbufferloadpic
	popx	<di,si>
endm

movebmp	macro	x,y,w,h,offsetbitmap
	local	x,y,w,h,offsetbitmap
	pushx	<si,di>
	mov	bmp_x,x
	mov	bmp_y,y
	mov	gpw1,w
	mov	gpw2,h
	mov	si,offsetbitmap
	call	drawobjbuffer
	popx	<di,si>
endm

delay macro time
	local time,eattime
	push ax
	push bx
	push cx
	push dx

	mov ax,0
	mov bx,0
	mov cx,0

eattime :
	inc ax
	cmp ax,1000
	jle eattime
	inc bx
	cmp bx,32766
	jle eattime
	inc cx
	cmp cx,time
	jle eattime

	pop dx
	pop cx
	pop bx
	pop ax
endm

random macro range
	local range
	local srand,clear,set,calran
        mov ah,2ch      ;use to get time from computer
        push cx
        int 21h
        mov al,dl
        pop cx
        xor ah,ah
srand :                 ;and use basic random algorithm from homework
        shl ax,1        ;the algorithm is
        push ax         ;replace bit 0 by xor of bit 14 and 15
        mov bx,ax       ;clear bit 15
        shl ax,1
        xor ax,bx
        rol ax,1
        and ax,1h
        cmp ax,0
        je clear
        cmp ax,1
        je set
clear :
        pop ax
        and ax,0fffeh
        and ax,7fffh
        jmp calran
set :
        pop ax
        or ax,1h
        and ax,7fffh
        jmp calran
calran :
        xor dx,dx
	mov cx,range
        div cx
	inc dx
endm

gotoxy	macro	gtx,gty
	local	gtx,gty
	pushx	<ax,dx,bx>
	mov	ah,2
	mov	dl,gtx
	mov	dh,gty
	mov	bh,0
	int	10h
	popx	<bx,dx,ax>
endm

printdec  macro	decimal
	local	decimal
	push	ax
	xor	ax,ax
	mov	al,decimal
mov	bmp_x,156
mov	bmp_y,16
	call	outdex
mov	bmp_x,25
mov	bmp_y,3
	mov	ax,p1score
	call	outdex
mov	bmp_x,270
mov	bmp_y,3
	mov	ax,p2score
	call	outdex
mov	bmp_x,156
mov	bmp_y,16

	pop	ax
endm

countdown	macro	
	local	@noupdatetime
	pushx	<ax,dx,si>
	mov	ah,2ch
	int	21h

	cmp	dh,dostime
	jz	@noupdatetime
	mov	dostime,dh
	dec	roundtime
@noupdatetime:
	printdec roundtime	
	popx	<si,dx,ax>
endm


openfile        macro
        mov     ah,3dh
        lea     dx,filescore
        mov     al,2
        int     21h
        mov     filehandle,ax
endm

closefile       macro
        mov     ah,3eh
        mov     bx,filehandle
        int     21h
endm
