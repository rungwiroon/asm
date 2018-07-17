comment #

[20:22] <Kalms> The loop is:
[20:23] <Kalms> * plot a pixel
[20:23] <Kalms> * move up one pixel
[20:23] <Kalms> * adjust our distance-measure accordingly
[20:23] <Kalms> * if our distance-measure has become too large:
[20:23] <Kalms>   * move left one pixel
[20:23] <Kalms>   * adjust our distance-measure accordingly
[20:23] <Kalms> .

#



.model small
.386
.data

xo      dw      160
yo      dw      100
r       dw      90
color   db      15

dist    dw      ?
newdist dw      ?


.code

main    proc

        mov     ax,@data
        mov     ds,ax
        mov     ax,0A000h
        mov     es,ax


        mov     ax,0013h
        int     10h


        mov     cx,10

m1:
        call    circle

        sub     r,5
        loop    m1


        xor     ah,ah
        int     16h

        mov     ax,0003h
        int     10h

        mov     ax,4C00h
        int     21h
main    endp




circle  proc
        mov     si,r
        mov     di,0


        mov     ax,si                   ;dist=-2r-1  r=x
        shl     ax,1
        neg     ax
        dec     ax
        mov     dist,ax

c1:
        call    cset
        inc     di                      ;y+1

        mov     ax,dist
        add     ax,di
        add     ax,di
        inc     ax
        mov     dist,ax

        cmp     dist,0
        jng     c3

c2:
        dec     si                      ;x-1

        mov     ax,dist                 ;newdist=dist-2x+1
        sub     ax,si
        sub     ax,si
        inc     ax
        mov     dist,ax
c3:
        cmp     di,si
        jle      c1

c4:
        ret
circle  endp


cset    proc
        push    si
        push    di

        mov     ax,di                   ;octant 1
        add     ax,yo
        shl     ax,6
        mov     bx,ax
        shl     ax,2
        add     bx,ax
        add     bx,si
        add     bx,xo
        mov     al,color
        mov     es:[bx],al

        sub     bx,si                   ;4
        sub     bx,si
        mov     es:[bx],al

        xchg    si,di

        mov     ax,di                   ;2
        add     ax,yo
        shl     ax,6
        mov     bx,ax
        shl     ax,2
        add     bx,ax
        add     bx,si
        add     bx,xo
        mov     al,color
        mov     es:[bx],al

        sub     bx,si                   ;3
        sub     bx,si
        mov     es:[bx],al

        neg     di

        mov     ax,di                   ;8
        add     ax,yo
        shl     ax,6
        mov     bx,ax
        shl     ax,2
        add     bx,ax
        add     bx,si
        add     bx,xo
        mov     al,color
        mov     es:[bx],al

        sub     bx,si                   ;5
        sub     bx,si
        mov     es:[bx],al

        xchg   si,di
        neg     si
        neg     di

        mov     ax,di                   ;7
        add     ax,yo
        shl     ax,6
        mov     bx,ax
        shl     ax,2
        add     bx,ax
        add     bx,si
        add     bx,xo
        mov     al,color
        mov     es:[bx],al

        sub     bx,si                   ;6
        sub     bx,si
        mov     es:[bx],al

        pop     di
        pop     si

        ret
cset    endp

pset    proc
        mov     ax,di
        add     ax,yo
        shl     ax,6
        mov     bx,ax
        shl     ax,2
        add     bx,ax
        add     bx,si
        add     bx,xo
        mov     al,color
        mov     es:[bx],al
        ret
pset    endp


        end     main
