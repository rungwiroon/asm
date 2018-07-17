
video   equ     0A000h

st_seg  segment stack
        db      100h dup  ('THEstack')
st_seg  ends

datarea segment

param   dw      0                       ;environment ptr
        dw      ctail                   ;command tail ptr
        dw      datarea                 ;
        dw      0                       ;fcb1
        dw      0                       ;
        dw      0                       ;fcb2
        dw      0                       ;
filnam  db      'keytest.exe',0
ctail   db      08h,' aldress',13
datarea ends

codeseg segment

main    proc    far

        assume  cs:codeseg,ds:datarea

        push    ds                      ;set stack for return to dos
        sub     ax,ax
        push    ax

        mov     ax,ds                   ;point to bottom of program memory
        mov     es,ax                   ;in es for change
        mov     ah,4Ah                  ;release memory to pool
        mov     bx,140h                 ;retaining 5k
        int     21h


        mov     ax,datarea
        mov     ds,ax
        mov     es,ax

        push    ss
        push    sp
        push    ds
        push    es


        mov     bx,offset param
        mov     dx,offset filnam
        mov     ax,4B00h
        int     21h
        jnc     exok
        add     al,65
        mov     ah,02h
        mov     dl,al
        int     21h
exok:
        pop     es
        pop     ds
        pop     sp
        pop     ss
        ret                             ;to dos

main    endp

codeseg ends

        end     main
