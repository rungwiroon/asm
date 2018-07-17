;---------------------------------------------------------------------
;			Programmed by GLEN QUINN 1998
;		TO BE USED FOR EDUCATIONAL PURPOSES OR WHAT EVER
; THIS SOURCE CODE CAN BE CHANGED TO SUIT THE NEEDS OF PEOPLE
; CAN RUN ON A 16-bit machine
; COMPILE USE TASM with the /ml option
; The resulting executabile file takes up about 1KB (small eh)
; From the people of TORONTO Canada, I am going back over to that
; great place again!!
;---------------------------------------------------------------------
.model small
.stack 100h
_DATA segment word public 'DATA'
filename  db   'BG1.BMP',0  ; insert the name and location
GLEN	    db   'Programmed by Glen Quinn, BINARY SOFTWARE' ; of the bitmap here
          db   '$'

handle    dw   ?           ; handle is used to store the file pointer
X         dw   ?           ; X and Y is used to fill the screen with pixels
Y         dw   ?
col       db   640 dup(?)  ; col is used as a buffer to do a screen line
                           ; at a time
buff      dw   0
          dw   0
          dw   0
          dw   0
multi     dw   6
          dw   4
          dw   0
          dw   0
num       dw   0
y         dw   409         ; y is used to store where the banks break up
          dw   408
          dw   307
          dw   306
          dw   204
          dw   203
          dw   102
          dw   101

BMPHEAD    struc           ; This is the bitmap structure
   id          db   2 dup(?)
   filesize    dw   2 dup(?)
   reserved    dw   2 dup(?)
   headersize  dw   2 dup(?)
   infosize    dw   2 dup(?)
   width       dw   2 dup(?)
   depth       dw   2 dup(?)
   biplanes    dw   ?
   bits        dw   ?
   bicomp      dw   2 dup(?)
   bisizeim    dw   2 dup(?)
   bixpels     dw   2 dup(?)
   biypels     dw   2 dup(?)
   biclrused   dw   2 dup(?)
   biclrimp    dw   2 dup(?)
BMPHEAD   ends

RGBQUAD   struc            ; This is how the bitmap stores its colours
   blue        db   ?
   green       db   ?
   red         db   ?
   fill        db   ?
RGBQUAD   ends

params BMPHEAD <> ; assigning the structures to these values
param	 RGBQUAD <>
_DATA ends
.code
start:
   mov	ax,@data ; moving all data into required memory position
   mov	ds,ax
   
    mov ah,4fh ; set mode to SVGA (101h i.e 640X480 in 256 colours
   mov al,02h
   mov bx,101h
   int 10h
   
again:
   call	loadbmp  ; calls a procedure called loadbmp

   mov	ah,00h   ; waits for a key to be pressed
   int	16h
   cmp	al,0dh
   jne	again
   
   mov	ah,00h   ; changes the video mode to the normal setting
   mov	al,02h
   int	10h

   mov	ah,09h       ; Prints out a message on the screen
   mov	dx,offset GLEN
   int	21h

   mov	ah,4ch   ; ends the program
   mov	al,0
   int	21h

putpixel	proc	near  ; this procedure is for putting a single pixel any
							; where on the display plane
; The linear address of the display plane is=y*640+x
   mov	ax,Y ; calculating linear=y*640 in 16-bit
   mul	multi
   mov	buff,ax   ; first 16-bit calculation
   mov	ax,100
   mul	buff
   mov	buff,ax
   mov	buff+2,dx

   mov	ax,Y    ; secound 16-bit calculation
   mul 	multi+2
   mov	buff+4,ax
   mov	ax,10
   mul	buff+4
   mov	buff+4,ax
   mov	buff+6,dx

   mov	ax,buff ; now adding the two 16-bit values
   add	ax,buff+4
   mov	buff,ax
   mov	ax,buff+2
   adc	ax,buff+6
   mov	buff+2,ax

   mov	ax,X  ; now adding x to the expression
   add	buff,ax
   adc	buff+2,0   ; expression is now lin=y*640+x

   mov	ax,buff
   mov	dx,buff+2

   mov	cx,16       ; calculating bank number
F1:	sar	dx,1
		rcr	ax,1
      loop	F1
		mov	num,ax

      mov   ax,y    ; testing each of the bank boundaries
      cmp	ax,Y
      je		pass

		mov   ax,y+2
      cmp	ax,Y
      je		pass

      mov   ax,y+4
      cmp	ax,Y
      je		pass

      mov   ax,y+6
      cmp	ax,Y
      je		pass

      mov   ax,y+8
      cmp	ax,Y
      je		pass

      mov   ax,y+10
      cmp	ax,Y
      je		pass

      mov   ax,y+12
      cmp	ax,Y
      je		pass

      mov   ax,y+14
      cmp	ax,Y

      jne	bypass
pass:
   mov ah,4fh   ; adjusting the bank
	mov al,05h
	mov bh,00h
	mov bl,00h
	mov dx,num
	int 10h

bypass:

	mov ax,0A000h      ;writing a single pixel to the display
	mov es,ax
	mov ax,buff
	mov di,ax
	mov al,[si]
	stosb  ; writing pixel ends
	inc si
	ret
	endp

loadbmp	proc	near  ;this procedure is for loading in the bitmap
  

   mov ah,4fh
   mov al,05h
   mov bh,00h
   mov bl,00h
   mov dx,4
   int 10h
   
   mov	ah,3dh   ; file open
   mov	al,00
   mov	dx,offset filename
   int	21h       ; file open end

   mov	handle,ax

   mov	ah,3fh   ; file read
   mov	bx,handle
   mov	cx,54
   mov	dx,offset params
   int	21h      ; file read end

   mov	col,0  ; reading in the palette
G1:
   mov	ah,3fh
   mov	bx,handle
   mov	cx,4
   mov	dx,offset param
   int	21h
   mov	al,col
   mov	dx,3c8h
   out	dx,al
   mov	al,param.red
   shr	al,2
   mov	dx,3c9h
   out	dx,al
   mov	al,param.green
   shr	al,2
   out	dx,al
   mov	al,param.blue
   shr	al,2
   out	dx,al
   cmp	col,255
   inc	col
   jne	G1        ; palette read ends

   mov	Y,479
   mov	X,0
A1:
   mov	ah,3fh   ; file read
   mov	bx,handle
   mov	cx,640
   mov	dx,offset col
   int	21h      ; file read end

   ; writing a single pixel to the display in SVGA
mov	si,offset col
A2:
   call  putpixel
   inc	X
   cmp	X,640
   jne 	A2
   mov	X,0
   dec	Y
   cmp	Y,-1
   jne	A1

   mov	ah,3eh
   mov	bx,handle
   int	21h
   ret
loadbmp	endp

end start