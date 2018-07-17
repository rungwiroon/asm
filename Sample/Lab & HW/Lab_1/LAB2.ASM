code_segment    segment
               assume   cs:code_segment
               org  100h
main1     proc    near
           mov   ax,2000h
           mov   bh,'y'
           mov   bl,'z'
           int      20h
main1    endp
code_segment  ends
end    main1
  