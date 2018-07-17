;MOUSTEST.ASM   Mouse Test

video   equ     0A000h

st_seg  segment stack
        db      100h dup  ('THEstack')
st_seg  ends

datarea segment
buffer  dw      ?

color   db      1
mousx   dw      ?
mousy   dw      ?
mousl   db      ?
mousr   db      ?
mouslx  dw      ?
mously  dw      ?

datarea ends


codeseg segment

main    proc    far
        assume  cs:codeseg,ds:datarea
        push    ds
        sub     ax,ax
        push    ax



        mov     ax,ds                   ;point to bottom of program memory
        mov     es,ax                   ;in es for change
        mov     ah,4Ah                  ;release memory to pool
        mov     bx,1000h                ;retaining 64k
        int     21h

        mov     ax,datarea
        mov     ds,ax

        mov     ah,48h                  ;allocate       buffer
        mov     bx,1000h                ;64k
        int     21h
        mov     buffer,ax
        mov     es,ax                   ;init to 0
        mov     ax,0
        mov     di,0
        mov     cx,32000
        cld
        rep     stosw


        mov     ax,0013h
        int     10h

        mov     ax,0000h                ;test for mouse and reset
        int     33h
        jnc     m0
        jmp     xit
m0:
        mov     ax,0001h                ;init cursor
        int     33h
m1:
        mov     ah,0Bh                  ;test for key
        int     21h
        cmp     al,0FFh
        je      m2
        jmp     m3
m2:
        mov     ah,08h                  ;get key
        int     21h

        cmp     al,' '
        jne     m3
        jmp     xit
m3:
        mov     ax,0003h                ;get mouse stats
        int     33h
        shr     cx,1
        mov     mousx,cx
        mov     mousy,dx
        mov     bh,bl
        and     bl,1
        mov     mousl,bl
        and     bh,2
        shr     bh,1
        mov     mousr,bh

m4:

        call    draw


;        push    ds
;        mov     ax,video
;        mov     es,ax
;        mov     ax,buffer
;        mov     ds,ax
;        mov     si,0
;        mov     di,0
;        mov     cx,32000
;        cld
;        rep     movsw
;        pop     ds




        jmp     m1
m10:


xit:
        mov     ax,0002h
        int     33h

        ret                             ;to DOS
main    endp


draw    proc    near
        cmp     mousl,1
        jne     d1

        mov     ax,0002h
        int     33h

        mov     si,mousx
        mov     di,mousy
        mov     dl,color
        call    pset

        mov     ax,0001h
        int     33h

d1:
        cmp     mousr,1
        jne     d2

        inc     color
d2:
        ret
draw    endp

pset    proc    near
        push    es
        push    ax                      ;call with  si = x     di = y
        push    bx                      ;           dl = color

        mov     ax,video ;buffer
        mov     es,ax


        mov     ax,di                   ;--calc vid adress on x,y
        mov     bl,0
        mov     bh,al                   ;bx=y*256
        shl     ax,1                    ;*2
        shl     ax,1                    ;*4
        shl     ax,1                    ;*8
        shl     ax,1                    ;*16
        shl     ax,1                    ;*32
        shl     ax,1                    ;*64
        add     bx,ax                   ;bx = y*320
        add     bx,si                   ;bx = y*320 + x

        mov     al,dl
        mov     es:[bx],al
        mov     es:[bx],al

        pop     bx
        pop     ax
        pop     es

        ret
pset    endp

pxor    proc    near
        push    es
        push    ax                      ;call with  si = x     di = y
        push    bx                      ;           dl = color

        mov     ax,buffer
        mov     es,ax

        mov     ax,di                   ;--calc vid adress on x,y
        mov     bl,0
        mov     bh,al                   ;bx=y*256
        shl     ax,1                    ;*2
        shl     ax,1                    ;*4
        shl     ax,1                    ;*8
        shl     ax,1                    ;*16
        shl     ax,1                    ;*32
        shl     ax,1                    ;*64
        add     bx,ax                   ;bx = y*320
        add     bx,si                   ;bx = y*320 + x

        mov     al,dl
        xor     es:[bx],al

        pop     bx
        pop     ax
        pop     es
        ret
pxor    endp

codeseg ends

        end     main
