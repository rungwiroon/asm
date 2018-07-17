.386

video   equ     0B800h

st_seg  segment use16 stack
        db      100h dup  ('THEstack')
st_seg  ends



datarea segment use16

old_int9 dd     ?
ktab    db      256 dup (0)             ;key table
keyis   db      0
done    db      0                       ;0 = program not done, not0 = done

datarea ends

codeseg segment use16

main    proc    far
        assume  cs:codeseg,ds:datarea
        push    ds
        sub     ax,ax
        push    ax

        mov     ax,ds                   ;deallocate all but 64k mem
        mov     es,ax
        mov     ah,4Ah
        mov     bx,1000h
        int     21h

        mov     ax,datarea              ;set standard data segment
        mov     ds,ax

        mov     ah,35h                  ;get and save old int 09h vector
        mov     al,09h
        int     21h
        mov     word ptr old_int9[0],bx
        mov     word ptr old_int9[2],es

        push    ds                      ;set new int 09h vector
        mov     ax,cs
        mov     ds,ax
        mov     dx,offset key_int
        mov     ah,25h
        mov     al,09h
        int     21h
        pop     ds

        mov     ax,video
        mov     es,ax
        mov     si,0

m0:
        call    keytest

m1:
        mov     al,keyis
        add     al,32
        mov     es:[si],al

        cmp     done,0                  ;if done<>0 then exit to DOS
        jne     xit
        jmp     m0
xit:
        push    ds                      ;restore old int 09h vector
        lds     dx,old_int9
        mov     ah,25h
        mov     al,09h
        int     21h
        pop     ds

        ret                             ;to DOS
main    endp


keytest proc    near

        cmp     ktab[1],1               ;ESC
        jne     k1
        mov     done,1
        jmp     keyx
k1:

                                        ;more keys....

keyx:
        ret
keytest endp




key_int proc    far
        sti                             ;ISR 09h keyboard
        push    ds
        push    ax
        push    bx

        mov     ax,datarea
        mov     ds,ax

        in      al,60h                  ;get keyboard byte
        xor     ah,ah                   ; only al valid
        mov     bx,ax                   ; into bx for table index to key state
        in      al,61h                  ;get control byte
        or      al,82h                  ; set it to 82h
        out     61h,al                  ; back to control reg
        and     al,7Fh                  ; set it to 7Fh
        out     61h,al                  ; back to control reg
        mov     al,20h                  ;reset ints
        out     20h,al                  ; in interupt controler

        cmp     bx,128                  ;release or press?
        jl      k_i1                    ;skip if press
        sub     bx,128                  ;sub 128 if release
        mov     al,0                    ; and set table value to 0
        jmp     k_i2
k_i1:
        mov     al,1                    ;key is pressed, table value is 1
k_i2:
        mov     ds:ktab[bx],al          ;update table for key

        mov     ds:keyis,bl

        pop     bx
        pop     ax
        pop     ds
        iret
key_int endp

codeseg ends

        end     main
