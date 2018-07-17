.model small
.386
.stack
.data

x1      dw      ?                       ;line sub variables
y1      dw      ?
x2      dw      ?
y2      dw      ?
deldy   dw      ?
deldx   dw      ?
dels    dw      ?
delp    dw      ?
delse   dw      ?
delde   dw      ?
delsx   dw      ?
delsy   dw      ?

color   dw      ?

.code

main    proc

        mov     ax,@data                ;data segment
        mov     ds,ax
        mov     ax,0A000h               ;video segment
        mov     es,ax

        mov     ax,0013h                ;320x200x256
        int     10h


        mov     si,5                    ;x
        mov     di,15                   ;y
        mov     dl,15                   ;color
        call    pset

        mov     x1,0
        mov     y1,0
        mov     x2,319
        mov     y2,199
        mov     color,32
        call    line

        mov     x1,200
        mov     x2,220
        mov     y1,10
        mov     y2,30
        mov     color,36
        call    boxf



        mov     ah,0                    ;wait key
        int     16h
                                        ;text mode
        mov     ax,0003h
        int     10h

        mov     ax,4C00h                ;to DOS
        int     21h

main    endp


pset    proc
        push    ax                      ;call with  si = x     di = y
        push    bx                      ;           dl = color

        mov     ax,di                   ;--calc vid adress on x,y
        shl     ax,6
        mov     bx,ax                   ;bx=y*64
        shl     ax,2                    ;ax=y*256
        add     bx,ax                   ;bx = y*320
        add     bx,si                   ;bx = y*320 + x

        mov     es:[bx],dl

        pop     bx
        pop     ax
        ret
pset    endp

line    proc    near                    ;call with x1,y1 = point 1
        push    bx                      ;          x2,y2 = point 2
        push    cx                      ;          color = color
        push    dx
        push    si
        push    di
        push    ax
        mov     si,1
        mov     di,1
        mov     dx,y2
        sub     dx,y1
        jge     storey
        neg     di
        neg     dx
storey:
        mov     deldy,di
        mov     cx,x2
        sub     cx,x1
        jge     storex
        neg     si
        neg     cx
storex: mov     deldx,si
        cmp     cx,dx
        jge     setdiag
        mov     si,0
        xchg    cx,dx
        jmp     storedelsxy
setdiag:
        mov     di,0
storedelsxy:
        mov     dels,cx
        mov     delp,dx
        mov     delsx,si
        mov     delsy,di
        mov     si,x1
        mov     di,y1
        mov     ax,delp
        sal     ax,1
        mov     delse,ax
        sub     ax,cx
        mov     bx,ax
        sub     ax,cx
        mov     delde,ax
        inc     cx
        mov     dx,color
lineloop:
        call    pset
        cmp     bx,0
        jge     diagonal
straight:
        add     si,delsx
        add     di,delsy
        add     bx,delse
        loop    lineloop
        jmp     lineexit
diagonal:
        add     si,deldx
        add     di,deldy
        add     bx,delde
        loop    lineloop
lineexit:
        pop     ax
        pop     di
        pop     si
        pop     dx
        pop     cx
        pop     bx
        ret
line    endp


boxf    proc                            ;box filled
        mov     ax,y1
        shl     ax,6
        mov     di,ax
        shl     ax,2
        add     di,ax
        add     di,x1

        mov     ax,color

        mov     dx,x2                   ;set up dx as width
        sub     dx,x1

        mov     cx,y2                   ;set up cx as length
        sub     cx,y1
boxrow:
        push    cx
        push    di

        mov     cx,dx                   ;get width

        rep     stosb                   ;store x2-x1 # of bytes per line

        pop     di
        add     di,320
        pop     cx
        loop    boxrow


        ret
boxf    endp


        end     main
