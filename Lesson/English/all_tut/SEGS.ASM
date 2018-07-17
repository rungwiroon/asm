;segs.asm       demonstration of program memory block size adjustment
;               segment allocation and double buffer usage

.model small
.386
.stack

video   equ     0A000h                  ;vga ram segment


.data


vidbuf  dw      ?                       ;video buffer pointer


.code

main    proc

        mov     ax,ds                   ;deallocate all but 64k mem
        mov     es,ax
        mov     ah,4Ah
        mov     bx,1000h
        int     21h

        mov     ax,@data                ;set standard data segment
        mov     ds,ax

        cld                             ;set forward mem copies

        mov     ah,48h                  ;allocate       vidbuf
        mov     bx,1000h                ;64k
        int     21h

        mov     vidbuf,ax               ;save the pointer

        mov     es,ax                   ;init to yellow
        mov     ax,0E0Eh
        mov     di,0
        mov     cx,32000
        cld
        rep     stosw




        mov     ax,0013h                ;graphics mode
        int     10h



m1:
        ;insert code to
        ;draw stuff on the buffer using es=vidbuf here...............


        push    ds                      ;dump buffer to video
        push    es
        mov     ax,vidbuf
        mov     ds,ax
        mov     ax,video
        mov     es,ax
        mov     si,0
        mov     di,0
        mov     cx,16000
        rep     movsd
        pop     es
        pop     ds


        xor     ah,ah                   ;wait key
        int     16h


        mov     ax,0003h                ;text mode
        int     10h

        mov     ax,4C00h
        int     21h

main    endp

        end     main
