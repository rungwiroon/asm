;ROUTINE FOR STANDARD INPUT WITH ECHO
;
stdin         proc far
              mov  ah,1
              int  21h
              ret
stdin         endp
                                                                                                     