.model tiny
.386
.code
        org 100h
main    proc

        jmp     start

mousxf  dw      ?
mousyf  dw      ?
mousl   dw      ?
mousr   dw      ?

start:
        push    ds
        mov     ax,cs
        mov     ds,ax

        mov     ax,0003h                ;get mouse stats
        int     33h
        xor     ax,ax

        mov     al,bl
        and     bx,1
        mov     mousl,bx
        and     ax,2
        shr     ax,1
        mov     mousr,ax

        mov     ax,000Bh                ;get mouse physical movement
        int     33h

        mov     ax,cx
        cwde
        mov     mousxf,ax

        mov     ax,dx
        cwde
        mov     mousyf,ax

        pop     ds

        push    bp
        mov     bp,sp

        mov     bx,[bp+12]              ;return parms passed as
        mov     ax,cs:mousxf            ; qbasic variables
        mov     [bx],ax

        mov     bx,[bp+10]
        mov     ax,cs:mousyf
        mov     [bx],ax

        mov     bx,[bp+8]
        mov     ax,cs:mousl
        mov     [bx],ax

        mov     bx,[bp+6]
        mov     ax,cs:mousr
        mov     [bx],ax


        POP     BP
        RETF    8                       ;pop 2 bytes per qbasic variable

        ;nop
main endp

        end     main
