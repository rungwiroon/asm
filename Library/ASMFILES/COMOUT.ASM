;ROUTINE TO SEND OUTPUT TO A COMMUNICATIONS LINE
;
comout        proc far
;
              mov  ah,1
              int  14h
              ret
;
comout        endp
                                                                                    