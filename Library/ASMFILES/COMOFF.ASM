;ROUTINE TO TURN OFF INPUT FROM A COMMUNICATIONS LINE
;
comoff        proc far
;
              push ds
              push dx
              push si
;
              mov  si,dx
              add  si,si
              mov  dx,40h
              mov  ds,dx
              mov  dx,[si]
              add  dx,4
              mov  al,2
              out  dx,al
;
              pop  si
              pop  dx
              pop  ds
              ret
;
comoff        endp
                               