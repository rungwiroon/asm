;ROUTINE TO TURN ON INPUT FROM A COMMUNICATIONS LINE
;
comon         proc far
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
              mov  al,3
              out  dx,al
;
              pop  si
              pop  dx
              pop  ds
              ret
;
comon         endp
                                