;ROUTINE TO INITIALIZE A COMMUNICATIONS LINE
;
cominit       proc far
;
              mov  ah,0
              int  14h
              ret
;
cominit       endp
                                                                                        