.model  small
.386
.stack

.data


.code

main    proc
        mov     ax,@data
        mov     ds,ax
        mov     es,ax


m1:

        mov     eax,1234
        call    var

        mov     eax,1234
        call    hex

        mov     eax,0FFFFFFFFh
        call    var

        mov     eax,0FFFFFFFFh
        call    hex

        mov     eax,9ABCDEFh
        call    hex

        mov     eax,0
        call    var

        xor     ah,ah
        int     16h

xit:
        mov     ax,4C00h
        int     21h
main    endp

var     proc                            ;bin-->dec, call with eax=var
        push    eax
        push    ebx
        push    ecx
        push    edi
        push    es


        mov     ecx,0
var1:
        mov     edx,0
        mov     ebx,10
        div     ebx

        inc     ecx

        add     dl,48
        push    edx

        cmp     eax,0
        je      var2

        jmp     var1

var2:
        cmp     ecx,0
        je      var3

        pop     edx
        mov     ah,2
        int     21h
        dec     ecx
        jmp     var2

var3:
        mov     ah,2
        mov     dl,32
        int     21h


        pop     es
        pop     edi
        pop     ecx
        pop     ebx
        pop     eax
        ret
var     endp

hex     proc                            ;bin-->hex, call with eax=var
        push    eax
        push    ebx
        push    ecx
        push    edi
        push    es


        mov     ecx,0
hex1:
        mov     edx,0
        mov     ebx,16
        div     ebx

        inc     ecx

        cmp     dl,9
        jng     hex1a
        add     dl,7
hex1a:
        add     dl,48

        push    edx

        cmp     eax,0
        je      hex2

        jmp     hex1

hex2:
        cmp     ecx,0
        je      hex3

        pop     edx
        mov     ah,2
        int     21h
        dec     ecx
        jmp     hex2

hex3:
        mov     ah,2
        mov     dl,32
        int     21h


        pop     es
        pop     edi
        pop     ecx
        pop     ebx
        pop     eax
        ret
hex     endp

        end     main
