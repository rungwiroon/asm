;ROUTINE FOR STANDARD INPUT WITHOUT ECHO
;
stdinne       proc far
              mov  ah,8
              int  21h
              ret
stdinne       endp
                                                                                                  