;game.com


.model tiny
.386
.code

main    proc
        push    cs
        pop     ds
        mov     dx,offset msg
        mov     ah,9
        int     21h

m1:
        xor     ah,ah
        int     16h

        cmp     al,27
        je      xit

        cmp     al,'1'
        jl      m1

        cmp     al,'5'
        jg      m1

        sub     al,43

        mov     ah,al
        int     86h

        jmp     m1

xit:
        mov     ax,4C00h                ;to DOS
        int     21h

msg     db      'push 1 2 3 4 or 5 to play sound fx',10,13,36

main    endp



        end     main
