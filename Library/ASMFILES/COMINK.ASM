;ROUTINE TO CHECK FOR INPUT FROM A COMMUNICATIONS LINE
;
cominck       proc far
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
              add  dx,5
              in   al,dx
              test al,1
              jz   cominckexit
;
              mov  dx,[si]
              in   al,dx
cominckexit:
;
              pop  si
              pop  dx
              pop  ds
              ret
;
cominck       endp
                                                       