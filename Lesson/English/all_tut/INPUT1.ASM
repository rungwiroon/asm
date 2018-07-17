.model tiny
.stack

.data

crlf    db      10,13,36


string  db      254,?,255 dup ('$')

.code


main:
        cld

        mov     ax,@data
        mov     ds,ax                   ;set default data segment


        mov     ah,0Ah                  ;input string
        mov     dx,offset string
        int     21h

        mov     ah,9                    ;print a cr/lf
        mov     dx,offset crlf
        int     21h

        mov     ah,9                    ;print string
        mov     dx,offset string
        add     dx,2
        int     21h

        mov     ax,4C00h                ;to dos
        int     21h

end     main
