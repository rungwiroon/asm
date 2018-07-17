.model tiny
.stack

.data

crlf    db      10,13,36


string  db      256 dup (?)

.code


main:
        cld

        mov     ax,@data
        mov     ds,ax                   ;set default data segment
        mov     es,ax                   ;set extra data segment
        mov     di,offset string        ;set string offset

        mov     cx,255                  ;max 256 char
looper:
        mov     ah,1                    ;input with echo function
        int     21h                     ;call dos
        cmp     al,13                   ;cr?
        je      printit                 ;yes, print it

        stosb                           ;store char

        loop    looper                  ;loop for next char


printit:
        mov     al,36                   ;ascii $
        stosb                           ;store it at end of string

        mov     ah,9                    ;print string function
        mov     dx,offset crlf          ;print a cr/lf
        int     21h                     ;call dos

        mov     ah,9                    ;print string function
        mov     dx,offset string        ;point to string
        int     21h                     ;call dos

        mov     ax,4C00h                ;dos exit with errorlevel=0
        int     21h                     ;call dos

end     main
