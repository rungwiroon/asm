;
; asc!i-j'n'r
;
fak=6			   ; bitshift for internal-pos and screen-pos
normspeed=    2 	   ; normal speed add
fastspeed=    6 	   ; speed add while ctrl is pressed
jumpheight= -25 	   ; jump add
speedlimp=    1 shl fak-1  ; speed must not be greater than that or the player will skip one field
speedlimn=    -speedlimp
screenx=      80
screeny=      25

space=	      '.'
E1right=      '>'
E1left=       '<'

include '..\inc\keycodes.inc'

org 0x0000000000000000000000000000000000000000000000000000000000000100

 push 0xb800
 pop  gs

 mov  ax, 0x13
 int  0x10
 mov  ax, 0x03
 int  0x10

 call getvector

 bigloop:

   call waitretrace
   call drawlevel

   call processlevel
   call adjustplayer
   call adjustoffset
   call movekeys



   inc	[framecount]
   cmp [lastkey], 0x01
   je  quit
 jmp bigloop

 quit:


 call restorevector

 mov  ax, 0x4c00
 int  0x21

 ;--------------------------------------------------------------------

 adjustplayer:
   mov	ax, [px]
   shr	ax, fak
   mov	bx, [py]
   shr	bx, fak
   mov	dx, bx		  ; add y
   imul dx, [levelx]
   add	dx, ax		  ; add x
   mov	si, level
   add	si, dx		  ; si-> mappos
			  ; ax-> x
			  ; bx-> y
   call checkarround

   cmp	[pxspeed], 0	  ; check for left and right
   jl	xspneg
   test [isright], 1
   jz  xspok
   mov	[pxspeed], 0
   jmp	xspok
   xspneg:
   test [isleft], 1
   jz	xspok
   mov	[pxspeed], 0
   xspok:

   cmp	[pyspeed], 0	  ; check for ceiling
   jnl	f1_
   test byte [isup], 1
   jz	f1_
   mov	[pyspeed], 0
   f1_:

   cmp	[isdown], 0	  ; check for falling
   jne	killyspeed
   inc	[pyspeed]
   jmp	yspeedf
   killyspeed:
   cmp	[pyspeed], 0
   jl	yspeedf
   mov	[pyspeed], 0
   yspeedf:

   cmp [pxspeed], speedlimp   ; limit speed
   jng sk1
   mov [pxspeed], speedlimp
   sk1:
   cmp [pxspeed], speedlimn
   jnl sk2
   mov [pxspeed], speedlimn
   sk2:

   mov	ax, [pxspeed]	      ; move player
   add	[px], ax
   cmp	[pxspeed], 0	      ; decrease xspeed
   jl	spneg
   ja	sppos
   jmp	spf
   spneg: add  [pxspeed], 1
	  jmp  spf
   sppos: sub  [pxspeed], 1
   spf:

   mov	ax, [pyspeed]
   add	[py], ax
 ret

 checkarround:
   push si
   sub	si, [levelx]
   mov	cl, [ds:si]
   cmp	cl, space
   je	freeup
   mov	[isup], 1
   jmp	upf
   freeup:
   mov	[isup], 0
   upf:

   pop	si
   push si
   add	si, [levelx]
   mov	cl, [ds:si]
   cmp	cl, space
   je	freedown
   mov	[isdown], 1
   jmp	downf
   freedown:
   mov	[isdown], 0
   downf:

   pop	si
   dec	si
   mov	cl, [ds:si]
   cmp	cl, space
   je	freeleft
   mov	[isleft], 1
   jmp	leftf
   freeleft:
   mov	[isleft], 0
   leftf:

   inc	si
   inc	si
   mov	cl, [ds:si]
   cmp	cl, space
   je	freeright
   mov	[isright], 1
   jmp	rightf
   freeright:
   mov	[isright], 0
   rightf:
 ret

 movekeys:
   mov	bx, normspeed
   test byte [onkeys+keyCtrl], 1       ; speed up with ctrl
   jz  _0
   mov	bx, fastspeed
   _0:

   test byte [onkeys+keyUP], 1
   jz  _1
   test [isdown], 1
   jz  _1
   mov [pyspeed], jumpheight
   _1:

   test byte [onkeys+keyLF], 1
   jz  _2
   sub [pxspeed], bx
   _2:

   test byte [onkeys+keyRT], 1
   jz  _3
   add [pxspeed], bx
   _3:
 ret

 adjustoffset:
   mov	ax, [px]
   shr	ax, fak
   mov	bx, [ofsx]
   push bx
   add	bx, 60
   cmp	ax, bx
   jna	s1_
   inc	[ofsx]
   s1_:
   pop	bx
   add	bx, 20
   cmp	ax, bx
   jnl	s2_
   dec	[ofsx]
   s2_:

   cmp	[ofsx], 0
   jnl	ofxok1
   mov	[ofsx], 0
   ofxok1:
   mov	ax, [levelx]
   sub	ax, screenx
   cmp	[ofsx], ax
   jna	ofxok2
   mov	[ofsx], ax
   ofxok2:

   mov	ax, [py]
   shr	ax, fak
   mov	bx, [ofsy]
   push bx
   add	bx, 17
   cmp	ax, bx
   jna	s1y_
   inc	[ofsy]
   s1y_:
   pop	bx
   add	bx, 8
   cmp	ax, bx
   jnl	s2y_
   dec	[ofsy]
   s2y_:

   cmp	[ofsy], 0
   jnl	ofyok1
   mov	[ofsy], 0
   ofyok1:
   mov	ax, [levely]
   sub	ax, screeny
   cmp	[ofsy], ax
   jna	ofyok2
   mov	[ofsy], ax
   ofyok2:
 ret

 ;--------------------------------------------------------------------

 processlevel:
   push  ds			 ; first clear processed-flags
   pop	 es
   mov	di, processed
   mov	cx, [levelx]
   imul cx, [levely]
   push cx
   shr	cx, 1
   xor	ax, ax
   rep	stosw

   pop	cx
   mov	si, level
   mov	di, processed
   @@:
     mov  al, [ds:di]
     test al, 1
     jnz  endproc		 ; only if not been processed already
     mov  al, [ds:si]
     cmp  al, space
     je   endproc
     cmp  al, E1right
     jne  skipA
     cmp  byte [ds:si+1], space
     jne  turn1
     mov  byte [ds:si], space
     mov  byte [ds:si+1], E1right
     mov  byte [ds:di+1], 1	 ; set processed-flag
     jmp  skipA
     turn1:
     mov  byte [ds:si], E1left
     mov  byte [ds:di], 1
     skipA:

     cmp  al, E1left
     jne  skipB
     cmp  byte [ds:si-1], space
     jne  turn2
     mov  byte [ds:si], space
     mov  byte [ds:si-1], E1left
     mov  byte [ds:di-1], 1	 ; set processed-flag
     jmp  skipB
     turn2:
     mov  byte [ds:si], E1right
     mov  byte [ds:di], 1
     skipB:

     endproc:
     inc  di
     inc  si
   loop @r
 ret

 ;--------------------------------------------------------------------

 drawlevel:
   xor	di, di
   mov	[cury], di
   mov	ax, 0x0f00
   mov	cx, 25
   yloop:
     mov  si, [cury]
     add  si, [ofsy]
     imul si, [levelx]
     add  si, [ofsx]
     add  si, level
     mov  dx, 80
     xloop:
       mov  al, [ds:si]
       cmp  al, space
       jne  skip_
       mov  al, 32
       skip_:
       mov  [gs:di], ax
       inc  si
       inc  di
       inc  di
       dec  dx
     jnz xloop
     inc  [cury]
   loop yloop
   ; draw player
   mov	di, [py]
   shr	di, fak
   sub	di, [ofsy]
   imul di, [levelx]
   mov	ax, [px]
   shr	ax, fak
   sub	ax, [ofsx]
   shl	ax, 1
   add	di, ax
   mov	al, 1
   mov	[gs:di], al
 ret


 levelx dw 160
 levely dw 30
 level:
 db '|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|'
 db '|..............................................................................................................................................................|'
 db '|...OOOOOOOOOOOOO0o0oASC!I-JUMP&RUN(C)def:gsus-o0o0OOOOOOOOOOOOOOOOOOOOOOOOOOOOOO................OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO.....|'
 db '|.........O.........................................................................................................OO.........................................|'
 db '|OOOOOO...O....O..............................................................................O......................OO...ooooooooooooooooooooooooooooooooooooo|'
 db '|.........O....O>............OOOOOOOO.........................................................O.......................OO.......................................|'
 db '|...OOOOOOO....OOOOOOOOOOOOOOO............OO..................................................O........................OOOOOOOOOOOOOOOOOOO.....................|'
 db '|.........O................................................OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO.......................................OO....................|'
 db '|OOOOOO...O............................................................................O.........OO.......................................OO...................|'
 db '|.........O.......................................................................................OO.......................................OOOOOOOOOOO.........|'
 db '|.........O...................................................O......................................................................................OO........|'
 db '|....OOOOOO.........OOOOOOOOOOOOOOOOOOOOOO....................O........................O..............................................................OO.......|'
 db '|.............................................................O........................O...............................................................O.......|'
 db '|O...............................................O............O...................OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO.............................OOOO....|'
 db '|................................................O............O...................O...........................O........................................O.......|'
 db '|....OOOOOOOOOOOOOOOOOOO.........................O.>..........O...................O...........................O...................................OOOOOO.......|'
 db '|................................................OOOOOOOOOOOOOO...................OOOOOOOOOOOOOO..............O..................................OO............|'
 db '|...............................................................................................O.............O.........0o0o0o0o.................O.............|'
 db '|................................................................................................O............O..................................O.......OOOOOO|'
 db '|.................................................................................................O...........O.................................OO.............|'
 db '|OOOOOOO............OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO........OOOOOOOOOO.............O....................................OOOOOOOOO..............|'
 db '|.................................................................................O.................OO.................................OO......................|'
 db '|.................................................................................O.........................~~O~~......................O.................O.....|'
 db '|.................................................................................O...........................O........................OOOOOOOOOOOOOOOOOOO.....|'
 db '|................................................O............O...................O...........................O...........OOOOOOOOOOOOOO.......................|'
 db '|.....OOOOOOOOOOOOOOO............................O............O...................OOOOOOOOOOOOOOOOOOOOOOO.....O................................................|'
 db '|...................O............................O............O...............................................O.....................................OOOOOOOOOOO|'
 db '|...................OOOOOOOOOOO..................O............O...............................................O................................................|'
 db '|................................................O............O...............................................O................................................|'
 db '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'

 px dw (40 shl fak)
 py dw (1 shl fak)
 pxspeed dw 0
 pyspeed dw 0

 ofsx dw 0
 ofsy dw 0

 include '..\inc\waitR.inc'
 include '..\inc\keyhandler.inc'

 framecount rw 0
 isup	 rb 1
 isdown  rb 1
 isleft  rb 1
 isright rb 1

 cury rw 1

 processed:	      ; map with info about which enemies/objects already've been processed
		      ; during a frame
