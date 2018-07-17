;ctail.asm      Example command tail processing of first
;               command line parm. In this case, a filename.
;               real mode. tasm.

;               This program will print on screen the command tail until
;               cr is encountered.  A file name is expected and will be
;               processed correctly.  In the event the user does not
;               enter a file name, the first 12 characters entered will
;               be displayed.



.model tiny
.386
.stack
.data

filnam  db      13 dup (0)              ;the file name 'FILENAME.EXT',0

crlf    db      13,10,36
handle  dw      ?                       ;file handle




.code


main:
        mov     ax,@data                ;set default data segment
        mov     ds,ax


        call    ctail                   ;get command tail

        mov     dx,offset filnam        ;print contents of 'filnam'
        mov     ah,9
        int     21h


        mov     ax,4C00h                ;exit to dos
        int     21h





ctail   proc    near                    ;get file name from command tail

        push    ds                      ;save seg registers
        push    es                      ;

        mov     di,offset filnam        ;destination offset is file name
        mov     ax,@data                ;segment is datarea
        mov     es,ax                   ;

        mov     si,82h                  ;source offset is command tail
        mov     ah,62h                  ;get PSP segment
        int     21h                     ;
        mov     ds,bx                   ;

        cld                             ;clear direction for byte copy
        mov     cx,12                   ;max 13 bytes
ctail1:
        lodsb                           ;copy file name til cr/
        cmp     al,13                   ;
        je      ctailx                  ;
        stosb                           ;
        loop    ctail1                  ;
ctailx:
        mov     al,0                    ;terminate with 0
        stosb                           ;

        pop     es
        pop     ds
        ret
ctail   endp



        end main
