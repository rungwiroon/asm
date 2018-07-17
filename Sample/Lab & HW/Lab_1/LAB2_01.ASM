code_segment  segment
assume  cs:code_segment
       ORG 100h
 main1  proc  near
        mov  bx,2000h
        mov  cx,10100110b
        mov  dx,-4567
        mov  al,'A'
        mov  ah,'a'
        mov  ax,4c00h
        int  20h
 main1  endp
 code_segment  ends
 end  main1


