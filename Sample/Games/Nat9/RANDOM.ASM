public random,buffer

.model small
.stack 100h
.data
        buffer db ?
.code
random  proc
        push ax
        push dx
again:
        mov ah,2ch
        int 21h
        and dh,1
        add dl,dh
        and dl,000111b
        cmp dl,6
        jg again
        cmp buffer,dl
        je again
        mov buffer,dl

        pop dx
        pop ax
        ret
random endp
end 
        
