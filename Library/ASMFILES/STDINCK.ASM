;ROUTINE TO CHECK FOR STANDARD INPUT
;
stdinck       proc far
              push dx
              mov  dl,0FFh
              mov  ah,06h
              int  21h
              pop  dx
              ret
stdinck       endp
                          