;ROUTINE TO PUT ONE BYTE INTO CIRCULAR BUFFER
;
putcbuff      proc     far
;
;put the byte into the buffer
              mov      cbuff[di],al    ;byte goes into buffer
;
;adjust pointer
              inc      di              ;point to the next character
              cmp      di,cbuffsize    ;wrap it around?
              jne      putcbuff1       ;skip if no wrap
              mov      di,0            ;wrap back to zero
;
;count it
putcbuff1:
              inc      gauge           ;count the character
              cmp      gauge,nearfull  ;too many characters?
              jne      putcbuff2       ;skip if not
              call     comoff          ;request to stop flow
putcbuff2:
;
putcbuffret:
              ret
;
putcbcuff     endp
                                                                                                                           