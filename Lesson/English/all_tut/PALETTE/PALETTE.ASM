;palette.asm

comment #

        The VGA palette consists of 256 colors with 3 bytes per color
        one byte for red, green, blue, in that order.  This is 768 bytes
        total.  The file colors.vga is simply a 768 byte file with all
        256 byte 'triplets' in a row.  Load the file, and output to the VGA
        palette registers
#



.model small
.386
.stack
.data

colrtab db      768 dup (?)

filnam1 db      'colors.vga',0

.code

main    proc
        mov     ax,@data                ;standard data segment
        mov     ds,ax

        mov     ax,0013h                ;set graphics 320x200x256
        int     10h

        call    cload                   ;load and set palette from file


        mov     ax,0A000h               ;video segment
        mov     es,ax
        xor     di,di                   ;pointer to first pixel on screen
        mov     cx,256                  ;256 bytes to display
        xor     al,al                   ;start with color 0
m1:
        mov     es:[di],al              ;output 256 bytes of incrementing
        inc     di                      ; value to the screen to show
        inc     al                      ;  the palette
        loop    m1

        xor     ah,ah                   ;wait key
        int     16h

        mov     ax,0003h                ;set text mode
        int     10h

        mov     ax,4C00h                ;exit to DOS
        int     21h
main    endp



cload   proc    near
        push    ax
        push    bx
        push    cx
        push    dx

        mov     dx,offset filnam1       ;open palette file
        mov     ax,3D02h
        int     21h

        mov     bx,ax                   ;load color settings
        mov     cx,768
        mov     dx,offset colrtab
        mov     ah,3Fh
        int     21h
        mov     ah,3Eh
        int     21h

        mov     al,0                    ;set palette
        mov     dx,3C8h
        out     dx,al
        mov     si,offset colrtab
        mov     dx,3C9h
        mov     cx,768
        rep     outsb

        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
cload   endp

        end     main
