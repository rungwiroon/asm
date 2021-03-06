;
              extrn  stdinck:far
              extrn  emessout:far,getspec:far
              extrn  createfile:far,closefile:far
              extrn  cominit:far,comon:far,comoff:far
              extrn  initcbuff:far,incbuff:far,outcbuff:far
              extrn  flushit:far
              extrn  dta:dword
;
;***************************************************************
;
datas   datas         segment          public
;
namebuff      db     256 dup(0)
;
data          ends
;
;***************************************************************
;
stacks        segment                  stack
              db                       20dup('stack')
stacks        ends
;
;***************************************************************
;
codes         segment
;
              assume cs;codes,ds:datas
;
;ROUTINE TO SAVE FILE FROM COMMUNICATIONS LINE TO DISK
;
save          proc   far
;
;set up return
              push   ds                ;save for proper return
              mov    ax,0              ;points to beginning of segment
              push   ax                ;for the offset
;
;set up segments
              mov    dx,ds             ;program segment prefix was data seg
              mov    ax,datas          ;new data segment
              mov    ds,ax             ;put in DS
              mov    es,ax             ;put in ES
              mov    dta+2,dx          ;set the segment of the data
;
;set up the file
              lea    dx,namebuff       ;point to the ASCIIZ buffer
              call   getspec           ;get file specifications
              jc     exception         ;error?
              lea    dx,namebuff       ;ASCIIZ buffer has file specifiers
              call   createfile        ;set up the file
              jc     exception         ;error?
              mov    bx,ax             get the file handle
;
;set up the communications line
              mov    dx,1              ;for com2:
              mov    al,oBBh           ;2400:E:8:1
              call   cominit           ;intialize it
              call   outcbuff          ;check to send it out
              jc     exception         ;error?
              jmp    saveloop
;
;handle exceptions
exception:
              cmp    ax,19             ;end of file?
              je     save1             ;if so close it up and return
;
              call   emessout          ;report the error
              jmp    saveexit          ;and return
;
;normal return
save1:
              call   comoff            ;com line off
              call   flushit           ;flush the buffer
              jc     exception         ;error?
              call   closefile         close the file
              jc     exception         ;error?
              jmp    saveexit          ;exit
;
;saveexit:
              call   comon             ;com line on
              ret
;
save          endp
codes         ends                     ;end code segement
              end    save
                                       