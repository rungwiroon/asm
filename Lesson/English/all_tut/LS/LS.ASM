;ls.asm         shows files of type spec'd in command line
;               does *.* if none given

.model tiny
.386
.stack
.data

filspec db      '*.*',10 dup (0)        ;search file spec
filnam  db      13 dup (0)              ;found file

crlf    db      13,10,36
handle  dw      ?                       ;file handle

dta     db      128 dup (0)

.code


main    proc
        mov     ax,@data                ;set default data segment
        mov     ds,ax
        mov     es,ax

        call    ctail                   ;get command tail

        cmp     filspec,0
        jne     m0
        mov     dword ptr filspec,'*.*'
m0:
        mov     dx,offset dta           ;set dta
        mov     ah,1Ah
        int     21h

        mov     cx,0                    ;normal file attrib
        mov     dx,offset filspec       ;find first
        mov     ah,4Eh
        int     21h

        jnc     m1                      ;continue if found
        jmp     xit                     ;exit if not
m1:
        mov     si,offset dta           ;copy to found file
        add     si,1Eh
        mov     di,offset filnam
        mov     cx,13
m2:
        lodsb                           ;get a byte from dta
        cmp     al,0                    ;if last one
        je      m3                      ;start padding

        stosb                           ;otherwise keep copying
        loop    m2                      ;next byte
m3:
        stosb                           ;pad to end
        loop    m3                      ;next byte

        mov     dx,offset filnam        ;print results
        mov     ah,9
        int     21h

        mov     ah,4Fh                  ;find next
        int     21h
        jc      xit                     ;if not found, exit
        jmp     m1                      ;found, process it

xit:


        mov     ax,4C00h                ;exit to dos
        int     21h
main    endp




ctail   proc    near                    ;get file name from command tail

        push    ds                      ;save seg registers
        push    es                      ;

        mov     di,offset filspec       ;destination offset is file spec
        mov     ax,@data                ;destination segment
        mov     es,ax                   ;

        mov     si,82h                  ;source offset is command tail
        mov     ah,62h                  ;get PSP segment
        int     21h                     ;
        mov     ds,bx                   ;destination segment

        cld                             ;clear df, forward byte copy
        mov     cx,12                   ;max 12 bytes
ctail1:
        lodsb                           ;copy file name til cr
        cmp     al,13                   ;
        je      ctailx                  ;
        stosb

        loop    ctail1                  ;
ctailx:
        mov     al,0                    ;terminate with 0
        stosb                           ;

        pop     es
        pop     ds
        ret
ctail   endp



        end     main
