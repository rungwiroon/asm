;ROUTINE FOR DIRECT CONSOLE OUTPUT
;
stdoutdr      proc far
              push dx
;
              cmp  al,0FFh
              je   stdoutdrexit
              mov  dl,al
              mov  ah,6
              int  21h
;
stdoutdrexit:
              pop  dx
              ret
stdoutdr      endp
                                                                              