;bubble.asm                             ;simple bubble sort

.model small
.386
.stack

n       equ     26                      ;number of elements


.data


sstate  db      0                       ;sort state, 1 of element switched
tabl    dw      n,n dup (?)             ;n count, n elements


.code


main    proc
        mov     ax,@data                ;set standard data segment
        mov     ds,ax

        call    showtab                 ;show table values

        call    sort                    ;sort them

        call    showtab                 ;show table values sorted


        mov     ax,4C00h                ;to DOS
        int     21h
main    endp


sort    proc
        push    ax                      ;save regs
	push	bx
	push	cx
	push	dx

sortstart:
        mov     bx, offset tabl         ;point to table
        mov     cx,[bx]                 ;get number of elements
        dec     cx                      ; -1, only loop to elements-1
        add     bx,2                    ;point to first element
        mov     sstate,0                ;start with sort state = not switched
sort1:

        mov     ax,[bx]                 ;get element
        mov     dx,[bx+2]               ; and next element

        cmp     ax,dx                   ;out of order?
        jna     noswitch                ;no, next

        mov     sstate,1                ;yes, set sort state to switched

        xchg    ax,dx                   ;exchange the elemnts

        mov     [bx],ax                 ;store them
        mov     [bx+2],dx

noswitch:
        add     bx,2                    ;next element
        loop    sort1

        cmp     sstate,0                ;were any elements switched?
        je      sortdone                ;no, done
        jmp     sortstart               ;yes, sort again
sortdone:
        pop     dx                      ;restore regs
	pop	cx
        pop     bx
        pop     ax
	ret
sort    endp


showtab proc

        mov     cx,n                    ;display n # of elements
        mov     bx,offset tabl          ;point to table
        add     bx,2                    ;skip over n
show1:
        xor     eax,eax                 ;clear
        mov     ax,[bx]                 ;get element to show

        call    var32                   ;print it

        add     bx,2

        loop    show1                   ;next


        mov     ah,2                    ;new line
        mov     dl,13
        int     21h
        mov     ah,2
        mov     dl,10
        int     21h

        mov     ah,2                    ;new line
        mov     dl,13
        int     21h
        mov     ah,2
        mov     dl,10
        int     21h


        ret
showtab endp



var32   proc                            ;bin-->ascii numeric print
        push    eax                     ;call with eax=value to print
        push    ebx
        push    ecx
        push    edi
        push    es


        mov     ecx,0
var32a:
        mov     edx,0
        mov     ebx,10
        div     ebx

        inc     ecx

        add     dl,48
        push    edx

        cmp     eax,0
        je      var32b

        jmp     var32a

var32b:
        cmp     ecx,0
        je      var32c

        pop     edx
        mov     ah,2
        int     21h
        dec     ecx
        jmp     var32b

var32c:
        mov     ah,2
        mov     dl,32
        int     21h


        pop     es
        pop     edi
        pop     ecx
        pop     ebx
        pop     eax
        ret
var32   endp



        end     main
