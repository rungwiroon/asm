video   equ     0B800h

st_seg  segment stack
        db      100h dup  ('THEstack')
st_seg  ends

datarea segment

tbuff   db      '00000'

htab    db      0
vtab    db      0

jsx     dw      0
jsy     dw      0
jsw     dw      0
jsz     dw      0
jb1     dw      0
jb2     dw      0
jb3     dw      0
jb4     dw      0

datarea ends


codeseg segment

main    proc    far
        push    ds
        sub     ax,ax
        push    ax

        assume  cs:codeseg,ds:datarea
        
        mov     ax,datarea
        mov     ds,ax

m1:
        call    joystk

        mov     vtab,1
        mov     htab,1
        call    locate

        mov     dx,jsx
        call    var
        mov     al,32
        call    stdout
        mov     dx,jsy
        call    var
        call    stdout
        mov     dx,jsw
        call    var
        call    stdout
        mov     dx,jsz
        call    var
        call    stdout
        mov     dx,jb1
        call    var
        call    stdout
        mov     dx,jb2
        call    var
        call    stdout
        mov     dx,jb3
        call    var
        call    stdout
        mov     dx,jb4
        call    var
        call    stdout

        mov     ah,0Bh
        int     21h

        cmp     al,0FFh
        je      mex
        jmp     m1
mex:
        ret
main    endp

joystk  proc    near
        mov     jb1,0
        mov     jb2,0
        mov     jb3,0
        mov     jb4,0
        
        mov     ah,84h
        mov     dx,1
        int     15h
        mov     jsx,ax
        mov     jsy,bx
        mov     jsw,cx
        mov     jsz,dx
        
        mov     ah,84h
        mov     dx,0
        int     15h

        test    al,00010000b
        jnz     j1
        mov     jb1,1
j1:
        test    al,00100000b
        jnz     j2
        mov     jb2,1
j2:
        test    al,01000000b
        jnz     j3
        mov     jb3,1
j3:
        test    al,10000000b
        jnz     j4
        mov     jb4,1
j4:
        ret
joystk  endp

locate  proc    near
        push    ax
        push    bx
        push    dx

        mov     ah,02
        mov     bh,0
        mov     dh,vtab
        mov     dl,htab
        int     10h

        pop     dx
        pop     bx
        pop     ax
        ret
locate  endp

print   proc    near
        push    es
        push    ax
        mov     ax,video
        mov     es,ax
;               dx points to string ending in $

        mov     ah,09h
        int     21h

        pop     ax
        pop     es
        ret
print   endp

var     proc    near
;       dx points to var
        push    di
        push    dx
        push    cx
        push    ax
        mov     cx,0
        lea     di,tbuff

dec16out1:
        push    cx
        mov     ax,dx
        mov     dx,0
        mov     cx,10
        div     cx
        xchg    ax,dx
        add     al,30h
        mov     [di],al
        inc     di

        pop     cx
        inc     cx
        cmp     dx,0
        jnz     dec16out1

dec16out2:
        dec     di
        mov     al,[di]
        call    stdout
        loop    dec16out2

        pop     ax
        pop     cx
        pop     dx
        pop     di
        ret
var     endp

stdout  proc    near
        push    dx
        mov     dl,al
        mov     ah,2
        int     21h
        pop     dx
        ret
stdout  endp

codeseg ends

        end     main
