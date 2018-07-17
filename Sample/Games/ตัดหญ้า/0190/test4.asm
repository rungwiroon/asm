.model small
.stack 100h
.186
.code

PUBLIC ShowBMP

ShowBMP proc
pusha
call OpenInputFile
jc FileErr
mov bx,ax
call ReadHeader
jc InvalidBMP
call ReadPal
push es
call InitVid
call SendPal
call LoadBMP
call CloseFile
pop es
jmp ProcDone

FileErr:
mov ah,9
mov dx,offset msgFileErr
int 21h
jmp ProcDone

InvalidBMP:
mov ah,9
mov dx,offset msgInvBMP
int 21h

ProcDone:
popa
ret
ShowBMP endp

CheckValid proc
clc
mov si,offset Header
mov di,offset BMPStart
mov cx,2

CVloop:
mov al,[si]
mov dl,[di]
cmp al,dl
jne NotValid
inc si
inc di
loop CVloop
jmp CVdone

NotValid:
stc

CVdone:
ret
CheckValid endp

GetBMPInfo proc
mov ax,header[0ah]
sub ax,54
shr ax,2
mov PalSize,ax
mov ax,header[12h]
mov BMPWidth,ax
mov ax,header[16h]
mov BMPHeight,ax
ret
GetBMPInfo endp

InitVid proc
mov ax,13h
int 10h
push 0a00h
pop es
ret
InitVid endp

LoadBMP proc
mov cx,BMPHeight

ShowLoop:
push cx
mov di,cx
shl cx,6
shl di,8
add di,cx

mov ah,3fh
mov cx,BMPWidth
mov dx,offset Scrline
int 21h

cld
mov cx,BMPWidth
mov si,offset Scrline
rep movsb

pop cx
loop Showloop
ret
LoadBMP endp

ReadHeader proc
mov ah,3fh
mov cx,54
mov dx,offset Header
int 21h

call CheckValid
jc RHdone
call GetBMPinfo

RHdone:
ret
ReadHeader endp

ReadPal proc
mov ah,3fh
mov cx,PalSize
shl cx,2

mov dx,offset palbuff
int 21h
ret
ReadPal endp

OpenInputFile proc
mov dx,offset My_file
mov ah,4Dh
mov al,1
int 21h

mov handle,ax
OpenInputFile endp


CloseFile proc
mov bx,Handle
mov ah,3Eh
int 21h

CloseFile endp

SendPal proc
mov si,offset palBuff
mov cx,PalSize
mov dx,3c8h
mov al,0
out dx,al
inc dx

sndLoop:
mov al,[si+2]
shr al,2
out dx,al
mov al,[si+1]
shr al,2
out dx,al
mov al,[si]
shr al,2
out dx,al

add si,4

loop sndLoop
ret
SendPal endp

.data
My_file db 'c:\new.bmp',0
Handle dw ?
Header label word
HeadBuff db 54 dup('H')
palBuff db 1024 dup('P')
Scrline db 320 dup(0)
BMPStart db 'BM'
PalSize dw ?
BMPHeight dw ?
BMPWidth dw ?
msgInvBMP db "Not a valid BMP file.",7,0dh,0ah,24
msgFileErr db "Error opening file.",7,0dh,0ah,24
end