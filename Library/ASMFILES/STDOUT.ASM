;ROUTINE FOR STANDARD OUTPUT
;
stdout        proc far
              push dx
              mov  dl,al
              mov  ah,2
              int  21h
              pop  dx
              ret
stdout        endp
                                      