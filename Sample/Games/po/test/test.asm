.model small
 picachu_pic    macro
                local print
                mov bx,0
                mov cx,20
                mov dx,20
                mov di,60
                mov si,00
 print:         mov ah,0ch
                mov al,pic[si]
                int 10h
                inc si
                inc cx
                cmp si,di
                jbe print
                mov cx,20
                inc dx
                add di,61
                cmp dx,46
                jbe print
 endm

.stack 100h
.data
pic db 0,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0
db 0,0,0,0,0,0,0,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0
db 0,0,0,0,0,0,3,3,0,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0
db 0,0,0,0,0,3,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,0,0,0
db 0,0,0,0,3,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,0,0,3,0,0
db 0,0,0,3,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,3,0
db 0,0,3,3,0,3,3,3,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,3,3
db 0,3,3,0,0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,0,0,0,0,0,0,3,3
db 3,3,0,0,0,0,0,0,0,0,0,0,0,3,3,3,0,0,3,3,3,3,0,0,0,3,3,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0,3
db 3,0,0,0,0,3,0,0,0,0,3,3,0,0,0,0,3,3,0,0,0,0,0,0,0,0,3,3,0,0,0
db 0,0,0,0,0,0,0,0,0,3,0,0,0,3,3,3,3,3,3,0,0,0,3,0,0,0,0,0,0,3
db 3,0,0,0,0,3,0,0,0,0,0,0,3,3,3,3,0,0,0,3,3,3,3,0,0,3,0,3,3,0,0
db 0,0,0,0,0,0,0,0,3,3,0,3,3,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,3
db 3,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,3,0,3,3,0
db 0,0,3,0,0,0,0,3,3,3,3,0,0,0,0,0,0,3,3,0,0,0,0,0,3,0,0,0,0,3
db 3,0,0,3,0,0,3,3,3,3,0,0,3,0,0,0,0,0,0,0,3,0,0,0,0,0,0,3,3,3,0
db 0,3,3,3,0,0,3,0,0,3,0,3,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,3
db 3,0,3,3,3,3,0,0,0,0,3,3,3,3,3,3,3,3,0,0,3,3,0,0,0,0,0,0,0,0,0
db 0,0,0,0,3,3,0,0,0,0,3,0,0,0,0,0,0,0,3,0,0,0,3,3,3,3,3,3,3,3
db 3,3,3,3,0,0,0,0,0,0,0,3,3,3,0,0,0,0,3,3,3,3,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,3,3,0,0,3,3,3,3,0,3,0,3,3,3,0,0,0,0,3,3,0
db 3,3,3,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,3,3,3,3,3,3,3,3,3,0,0,0
db 0,0,0,0,0,0,0,3,3,3,0,3,3,0,0,0,0,3,3,3,3,3,0,0,0,0,0,3,0,0
db 0,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0,0,3,3,3,0,0
db 0,0,0,0,0,3,3,3,3,3,3,0,0,0,0,0,0,3,3,3,3,0,0,0,0,0,0,0,0,0
db 0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,3,3,0
db 0,0,0,3,3,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0
db 0,0,3,3,3,0,0,0,0,0,3,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3
db 0,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3
db 3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3
db 3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3
db 3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0



.code
 main           proc
                mov ax,@data
                mov ds,ax
                mov ah,0
                mov al,13h
                int 10h
                picachu_pic
 quit:          mov ah,10h
                int 16h
                mov ah,0
                mov al,3
                int 10h
                mov ah,4ch
                int 21h
 main           endp
                end main


