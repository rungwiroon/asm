;ROUTINE TO SEND MESSAGE TO STANDARD OUTPUT
;
stdmessout    proc far
              push si
              push ax
;
stdmessout1:
              mov  al,[si]
              inc  si
              cmp  al,0
              je   stdmessoutexit
              call stdout
              jmp  stdmessout1
;
stdmessoutexit:
              pop  ax
              pop  si
              ret
stdmessout    endp
                                                                                                     