.model small
.386
.code

main    proc

        push    cs
        pop     ds

        mov     ax,0A000h               ;video segment
        mov     es,ax

        mov     ax,0013h                ;320x200x256
        int     10h


        mov     si,5                    ;x
        mov     di,15                   ;y
        mov     dl,15                   ;color
        call    pset

        mov     ah,0                    ;wait key
        int     16h
                                        ;text mode
        mov     ax,0003h
        int     10h

        mov     ax,4C00h                ;to DOS
        int     21h

main    endp


pset    proc    near
        push    ax                      ;call with  si = x     di = y
        push    bx                      ;           dl = color

        mov     ax,di                   ;--calc vid adress on x,y
        xor     bl,bl
        mov     bh,al                   ;bx=y*256
        shl     ax,6                    ;ax=y*64
        add     bx,ax                   ;bx = y*320
        add     bx,si                   ;bx = y*320 + x

        mov     es:[bx],dl

        pop     bx
        pop     ax
        ret
pset    endp

        end     main
