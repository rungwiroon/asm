;ROUTINE TO SEND CR LF TO STANDARD OUTPUT
;
stdcrlf       proc far
              push ax
;
              mov  al,13
              call stdout
              mov  al,10
              call stdout
;
              pop  ax
              ret
stdcrlf       endp
                                                                                                                    