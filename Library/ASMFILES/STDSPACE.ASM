;ROUTINE TO SEND SPACE TO STANDARD OUTPUT
;
;A space is sent to the standard outout device
;
stdspace      proc far
              push ax
;
              mov  al,32
              call stdout
;
              pop  ax
              ret
stdspace      endp
                                                                                                                      