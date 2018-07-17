;fileiow.asm

.186
.model  tiny
.stack

.code

handle  dw      ?
filbuf  db      'This is a test write.'
filnam  db      'filetest.txt',0

string  db      'filetest.txt written',36

main    proc
        mov     ax,cs
        mov     ds,ax


        mov     dx,offset filnam        ;create a file
        mov     cx,0
        mov     ah,3Ch
        int     21h

        mov     handle,ax               ;save handle for later
        mov     bx,ax                   ;get handle

        mov     cx,21                   ;write 21 bytes
        mov     dx,offset filbuf
        mov     ah,40h
        int     21h

        mov     ah,3Eh                  ;close
        int     21h


        mov     dx,offset string
        mov     ah,9h
        int     21h

        mov     ax,4C00h
        int     21h

main    endp

end     main
