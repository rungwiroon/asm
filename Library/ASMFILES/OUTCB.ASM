;ROUTINE TO HANDLE OUTPUT FROM A CIRCULAR BUFFER
;
outcbuff      proc     far
;
;check for enough characters in the buffer
              cmp      guage,blksize   ;any characters?
              jl       outcbuffexit    ;exit if no characters
;
empty the buffer
              call     comoff          ;hold the comm line
              call     flushit         ;flush the buffer
              jc       outcbuffret     ;error?
;
outcbuffexit:
              clc      ;clear carry - no exception
outcbuffret:
              ret
;
outbuff       endp
                                                                              