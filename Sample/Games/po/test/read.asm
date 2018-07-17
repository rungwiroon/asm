.model small
 push_reg       macro
                push ax
                push bx
                push cx
                push dx
 endm
 pop_reg        macro
                pop dx
                pop cx
                pop bx
                pop ax
 endm
.stack 100h
.data
 filename db 'score',0
 buffer db 80 dup (' ')
 handle dw ?
.code
 main           proc
                mov ax,@data
                mov ds,ax
                mov ax,0013h
                int 10h
                mov ah,3dh
                lea dx,filename
                mov al,2
                int 21h                 ;open file 'score'
                mov handle,ax

                mov ah,2
                mov bh,0
                mov dh,5
                mov dl,6
                int 10h

 read_:
                mov ah,3fh
                mov bx,handle
                mov cx,80
                lea dx,buffer
                int 21h                 ;read file score
                cmp ax,0
                je  quit                ;eof

                push_reg

                mov cx,ax
                mov si,0
 write_char:    mov ah,0eh
                mov al,buffer[si]
                mov bh,0
                mov bl,14
                int 10h
                inc si
                loop write_char

                pop_reg
                jmp read_

 quit:          mov ah,3eh
                mov bx,handle
                int 21h                 ;close file

                mov ah,0
                int 16h

                mov ax,0003h
                int 10h

                mov ah,4ch
                int 21h                 ;exit program
 main           endp
                end main

