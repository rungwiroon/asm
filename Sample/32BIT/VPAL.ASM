        .386
        locals
        include pmc.inc
        ideal

; VGA 256 Colour Palette Manipulation Routines
; Handle single colours as well as buffered palette sets

; Copyright (c) 1994 Kumanan Yogaratnam
; Released to FreeWare

PALWRIT equ     03c8h
PALDATA equ     03c9h
CRTREG  equ     03dah

struc   parms1
        dd      2 dup (?)       ; pushed EBP and ret addr
pbuf    dd      ?               ; ptr to palette buffer
ends

struc   parms2
        dd      2 dup (?)
stpal   dd      ?
numpal  dd      ?
pbuf    dd      ?
ends

        @cseg

macro   WaitSync
        mov dx, CRTREG
@@1:
        in al, dx
        test al, 08h
        jz @@1
@@2:
        in al, dx
        test al, 08h
        jnz @@2
endm

public  _SetAllPalette, _SetIndexedPalette

proc    _SetAllPalette  near
        push ebp
        mov ebp, esp
        push esi

        mov esi, [ebp+offset (parms1).pbuf]
        mov dx, PALWRIT                 ; setup palette write
        mov al, 0
        out dx, al
        mov ecx, (256*3) shr 2          ; read in dwords

        WaitSync

        mov dx, PALDATA                 ; set component port
@@go:
        lodsd                           ; read 4 bytes at a time
        out dx, al
        mov al, ah
        out dx, al
        shr eax, 16                     ; move hi word to lo word
        out dx, al
        mov al, ah
        out dx, al
        loop @@go

        pop esi
        pop ebp
        ret
endp

proc    _SetIndexedPalette      near
        push ebp
        mov ebp, esp
        push esi

        mov esi, [ebp+offset (parms2).pbuf]
        mov dx, PALWRIT                 ; setup pal write
        mov eax, [ebp+offset (parms2).stpal]
        out dx, al                      ; set start pal ent
        mov ecx, [ebp+offset (parms2).numpal]

        WaitSync

        mov dx, PALDATA
@@go:
        lodsb
        out dx, al
        loop @@go

        pop esi
        pop ebp
        ret
endp

ends
end

