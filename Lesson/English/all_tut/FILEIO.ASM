;fileio.asm

.186
.model  tiny
.stack

.code

handle  dw      ?
filbuf  db      10000 dup (36)
filnam  db      'fileio.asm',0


main    proc
        mov     ax,cs
        mov     ds,ax


        mov     dx,offset filnam        ;open
        mov     ax,3D02h
        int     21h

        mov     handle,ax               ;save handle for later
        mov     bx,ax                   ;get handle

        mov     cx,10000                ;read 10000 bytes or to end of file
        mov     dx,offset filbuf
        mov     ah,3Fh
        int     21h

        mov     ah,3Eh                  ;close
        int     21h

        mov     ah,9h
        mov     dx,offset filbuf
        int     21h

        mov     ax,4C00h
        int     21h

main    endp

end     main
