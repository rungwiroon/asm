;ROUTINE TO FLUSH A CIRCULAR BUFFER
;
flushit       proc   far
;
              push   di                ;save registers
              push   dx
              push   cx
;
;get the bytes from the buffer
              mov    cx,guage          ;get the count
              jcxz   flushitexit       ;check for empty
              mov    di,0              ;initialize destination
;
;loop to get all the bytes
flushit1:
              mov    al,cbuff[si]      ;get the character
              inc    si                ;increment the pointer
              cmp    si,cbuffsize      ;wrap it?
              jne    flushit2          ;skip if no wrap
              mov    si,0              ;wrap the buffer pointer
;
flushit2:
              mov    lbuff[di],al      ;put byte in linear buffer
              inc    di
              loop   flushit1          ;loop until all bytes in lbuff
;
;send the linear buffer to the disk
              mov    cx,guage          ;this is the number of bytes
              lea    dx,lbuff          ;this is where they are
              call   writefile         ;send them out
              mov    guage,0           ;set circular buffer empty
;
flushitexit:
              pop    cx                ;restore registers
              pop    dx
              pop    di
              ret
;
flushit       endp
                                             