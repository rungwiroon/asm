
 format MZ

 org anisierte+verpeilung

 ;/////////////////////////////////////////////////////////;
 ;                                                         ;
 ;  small jump'n'run prog by def.gsus '05                  ;
 ;                                                         ;
 ;  i think this code is shit, be aware!                   ;
 ;  just one of many, many to come test-progs              ;
 ;  for designing the best possible low-level-functions    ;
 ;  for my curent life-work  D A S H .                     ;
 ;                                                         ;
 ;  version 0: - draws back-ground-map                     ;
 ;             - moves player                              ;
 ;             - object-struc for easy-2-use               ;
 ;               displacement and stuff                    ;
 ;             - no collision checking or whatever         ;
 ;                                                         ;
 ;  version 1: - added pixel-perfect collision-            ;
 ;               detection with background-map             ;
 ;                                                         ;
 ;/////////////////////////////////////////////////////////;

 debug_C=0		 ; debug collision detection
			 ; if turned on, no detection is done
			 ; but the occupied map-fields
			 ; where highlighted

 ;////////////////////
 ; set graphic mode
 ;////////////////////


  mov  ax, 0x13
  int  0x10


 ;////////////////////
 ; get keyvec
 ;////////////////////

  include '..\inc\keycodes.inc'
  call getvector



 ;////////////////////
 ; init data
 ;////////////////////

  push 0xa000
  pop  gs		       ; graphic segment
  push 0x6000
  pop  fs		       ; fakescreen
  mov  [collisionmap], 0x7000  ; segment for collision-map


  jmp  postcard

  ; /////////// constants ////////////

  ;mapsprites are fixed to 8 by 8

  fak		=     6        ; screen to pos shift
  screenx	=     320
  screeny	=     200
  scrmapx	dw    screenx shr 3
  scrmapy	dw    screeny shr 3

  friction	dw    2
  playerspeed	dw    4
  jumpheight	dw    25


  oplayer	=     0        ; the protagonist



  ; ////////// init objects //////////

  postcard:

  call	initobjects		   ; copy initblock over objects
  call	initmap


  mov  [mapoffx], 0		   ; zero offset
  mov  [mapoffy], 0

  mov	di, objects		   ; player is offset 0
  mov	word[ds:di], 15 shl fak    ; set x-pos
  mov	word[ds:di+2], 15 shl fak  ; y-pos

  mov	[framenr], 0
  mov	[dokeys], 1		   ; turn on keyhandler

 ;/////////////////////////////////////////////////////////
 ;/ / / / / / / / / ///// mainloop ////// / / / / / / / / /
 ;/////////////////////////////////////////////////////////

  l00p:

    mov  ax, [lastkey]		   ; check normal keys
    cmp  al, 0x01
    je	 l00pend
    cmp  al, 0x17		   ; 'i'
    if	 debug_C=0
    jne  $+3
    end  if
    call initmap


    call moveplayer

    call drawbackground
    call drawmap
    call drawplayer
    call adjustmapoffset

    call waitretrace
    call flushscreen

    inc  [framenr]

  jmp l00p
  l00pend:



 ;/////////////////////////////////////////////////////////
 ; get the .... off
 ;/////////////////////////////////////////////////////////

  call restorevector

  mov  ax, 0x4c00
  int  0x21









 ;/////////////////////////////////////////////////////////
 ;                  P R O C E D U R E S
 ;/////////////////////////////////////////////////////////

 ;/////////////////////////////////////////////////////////
 ;                       I N I T S
 ;/////////////////////////////////////////////////////////

  initobjects:		       ; copy initblock over objects
    push ds
    pop  es
    mov  di, objects
    mov  cx, [nobjects]
    @@:
      mov  si, object	       ; initblock
      push cx
      mov  cx, objectsize
      shr  cx, 1
      rep  movsw
      pop  cx
    loop @r
  ret

  initmap:		       ; copy defaultmap(byte) to themap(word)
    push ds
    pop  es
    xor  ax, ax
    mov  cx, [mapx]
    imul cx, [mapy]
    mov  si, defaultmap
    mov  di, themap
    @@:
      movsb		       ; copy block-index
      mov  [ds:di], al	       ; set highbyte to 0
      inc  di
    loop @r
  ret




 ;/////////////////////////////////////////////////////////
 ;                     M O V E M E N T
 ;/////////////////////////////////////////////////////////

  ;/////////////// checkcollision /////////////////////////
  ; give:
  ;   ds:di  <-  object
  ;
  ; returns:
  ;   dx     <-  0=no collision else collision detected
  ;
  ; purpose
  ;  uses x,y-pos, temporarly adds x,y-speed and
  ;  makes a pixel-perfect collision-check with
  ;  backgroundmap.
  ;
  xp   dw   0	   ; some runtimes
  yp   dw   0
  xmp  dw   0
  ymp  dw   0
  xs   dw   0
  ys   dw   0
  curx dw   0
  cury dw   0
  checkcollision:
    push di
    push ax

    mov  ax, [ds:di]	      ; x-pos of sprite
    add  ax, [ds:di+6]	      ; add x-speed
    shr  ax, fak	      ; scale to screen
    sub  ax, 7		      ; for some reason this is
			      ; essential to get the right pos
    mov  [xp], ax	      ; keep pos in [xp]
    shr  ax, 3		      ; scale to map-index
    mov  [xmp], ax	      ; keep in [xmp]

    mov  ax, [ds:di+2]	      ; same for y-pos...
    add  ax, [ds:di+8]
    shr  ax, fak
    sub  ax, 7
    mov  [yp], ax
    mov  [cury], ax
    shr  ax, 3
    mov  [ymp], ax

    mov  si, sprite0	      ; goto sprite
    lodsw		      ; later this will be replaced with
    mov  [xs], ax	      ; the actual sprite of given object
    lodsw
    mov  [ys], ax	      ; si now points to start of spritedata

    ; this checks collision with map-sprites
    ; note: one could check this due a
    ; collsion-map which is drawn at the time
    ; the map is drawn, but as only a certain
    ; area of the map is drawn this would not
    ; work with enemies or whatever which are
    ; off the screen.
    ; works that way:
    ;  for each sprite's pixel which is not
    ; zero, the corresponding pixel of the
    ; background-sprite as determined.
    ; if that is also not zero, a collision
    ; must have occured.
    ; this code could be speed up massively
    ; by not calculating the whole backsprite-
    ; position for every pixel.
    xor  dx, dx 	     ; no collision yet ;)
    mov  cx, [ys]
    YY:
      push cx
      mov  ax, [xp]
      mov  [curx], ax
      mov  cx, [xs]
      XX:
	push cx
	lodsb		     ; read one sprite-pixel
	or   al, al
	jz   alis0	     ; if zero we dont have to check further

	mov  di, themap      ; now read map and then the mapsprite-pixel
	mov  bx, [cury]      ; screen-y-pos of sprite on screen + current y
	shr  bx, 3	     ; scale to map-index (/8)
	imul bx, [mapxw]     ; calc line
	add  di, bx	     ; update di
	mov  bx, [curx]      ; screen-x-pos of sprite
	shr  bx, 2	     ; scale to map, /8 *2 for word size is
	and  bx, 0xfffe      ;  the same as shr 2 and 0xfffe
	add  di, bx	     ; ok, this is the mapfield we wanna check

	mov  bx, [ds:di]     ; read map-sprite nr

	if debug_C=1	     ; if debugmode then show the fields
	mov  byte [ds:di], 4 ; occupied by the sprite
	end if

	mov  di, mapsprites  ; goto mapsprites
	shl  bx, 6	     ; offset = nr*8*8
	add  di, bx	     ; this is topleft of map-sprite we wanna check
	mov  bx, [cury]      ; add current y-position
	and  bx, 7	     ; modulo 8
	shl  bx, 3	     ; *8 for line
	add  di, bx	     ; update di
	mov  bx, [curx]      ; add x-pos
	and  bx, 7	     ; modulo 8
	mov  bl, [ds:di+bx]  ; read that pixel

	if debug_C=1
	push di
	xor  di, di
	mov  [gs:di], bl     ; show the pixel which caused collision
	pop  di
	end if

	or   bl, bl
	jz   alis0	     ; is zero? great... no collision

	if debug_C=0
	pop  cx 	     ; if not,
	pop  cx 	     ; restore stack
	end if
	mov  dx, 0x01	     ; set collision-flag
	if debug_C=0
	jmp  collide	     ; and leave
	end if

	alis0:
	inc  [curx]
	pop  cx
      loop XX
      inc  [cury]
      pop  cx
    loop YY

    collide:

    pop  ax
    pop  di
  ret


  ;///////////////// moveobject ///////////////////////////
  ; give:
  ;   ds:di  <-  object
  ;   bx     <-  speed to move
  ;   cx     <-  friction
  ;   dx     <-  flags:  1 up
  ;                      2 left
  ;                      4 down
  ;                      8 right
  ;                     16 jump
  ;
  ;                    128 0=normal mode : uses x,y speed and
  ;                        adjusts the position
  ;                        1=angle-mode : directions relative to
  ;                        current direction: up means forward
  moveobject:
    test dx, 128
    jnz  byangle
     ; normal up,dn,etc.. mode
     test dx, 1 		 ; UP?
     jz _1
     sub  [ds:di+8], bx 	 ; yspeed--
     _1:
     test dx, 2 		 ; LEFT?
     jz _2
     sub  [ds:di+6], bx 	 ; xspeed--
     _2:
     test dx, 4 		 ; DOWN?
     jz _3
     add  [ds:di+8], bx 	 ; yspeed++
     _3:
     test dx, 8 		 ; RIGHT?
     jz _4
     add  [ds:di+6], bx 	 ; xspeed++
     _4:
     test dx, 16		 ; JUMP?
     jz _5
     mov  ax, [jumpheight]
     sub  [ds:di+8], ax 	 ; yspeed--
     _5:

     mov  ax, [ds:di+8] 	 ; y-speed
     cmp  ax, 0 		 ; test if not 0 -> sub friction
     js   isneg0
     jz   isok0
     sub  ax, cx		 ; sub frac.
     jmp isok0
     isneg0:
     add  ax, cx		 ; or add frac.
     isok0:
     mov  [ds:di+8], ax 	 ; write back

     mov  ax, [ds:di+6] 	 ; x-speed
     cmp  ax, 0 		 ; test if not 0 -> sub friction
     js   isneg1
     jz   isok1
     sub  ax, cx
     jmp  isok1
     isneg1:
     add  ax, cx
     isok1:
     mov  [ds:di+6], ax 	 ; write back

     call checkcollision
     or   dx, dx		 ; check if movement is possible

     if debug_C=0
     jnz  skipadd
     end if
       mov  ax, [ds:di+6]
       add  [ds:di], ax 	 ; add xspeed to position
       mov  ax, [ds:di+8]
       add  [ds:di+2], ax	 ; add yspeed to position
       jmp  movefinished
     skipadd:
       xor  ax, ax
       mov  [ds:di+6], ax
       mov  [ds:di+8], ax

     movefinished:

    jmp  end_byangle
    byangle:
    ; move by angle and speed

    end_byangle:

  ret

  moveplayer:
    mov  si, onkeys	     ; keymap of curently depressed keys

    xor  dx, dx 	     ; set moveflags    0up,1left,2down,3right,4jump
    ;or   dl, [onkeys+keyUP]  ; keyUP to jump
    ;shl  dl, 1
    or	 dl, [onkeys+keyRT]  ; the rest to direction
    shl  dl, 1
    or	 dl, [onkeys+keyDN]
    shl  dl, 1
    or	 dl, [onkeys+keyLF]
    shl  dl, 1
    or	 dl, [onkeys+keyUP]

    mov  di, objects	     ; player is offset 0
    mov  bx, [playerspeed]
    mov  cx, [friction]
    call moveobject
  ret


  ; takes care that player is always
  ; visible on the screen
  adjustmapoffset:
    ; adjust view-offset
    mov  di, objects
    mov  ax, [ds:di]	     ; read playeroff x
    shr  ax, fak
    mov  bx, [mapoffx]	     ; read viewoff x
    push bx
    add  bx, 260
    cmp  ax, bx
    jb	 ok1
      inc  [mapoffx]
    ok1:
    pop  bx
    add  bx, 50
    cmp  ax, bx
    ja	 ok2
      cmp  [mapoffx], 0
      jz   ok2
      dec  [mapoffx]
    ok2:
    mov  ax, [ds:di+2]	     ; read player y
    shr  ax, fak
    mov  bx, [mapoffy]
    push bx
    add  bx, 150
    cmp  ax, bx
    jb	 ok3
      inc  [mapoffy]
    ok3:
    pop  bx
    add  bx, 40
    cmp  ax, bx
    ja	 ok4
      cmp  [mapoffy], 0
      jz   ok4
      dec  [mapoffy]
    ok4:

    ; check bounds for mapoffx,y.  zero got checked above
    mov  ax, [mapx]
    sub  ax, [scrmapx]
    add  ax, 2
    shl  ax, 3
    cmp  [mapoffx], ax
    jb	 ok5
     mov [mapoffx], ax
    ok5:
    mov  ax, [mapy]
    sub  ax, [scrmapy]
    add  ax, 2
    shl  ax, 3
    cmp  [mapoffy], ax
    jb	 ok6
     mov [mapoffy], ax
    ok6:
  ret





 ;/////////////////////////////////////////////////////////
 ;                    G R A P H I X
 ;/////////////////////////////////////////////////////////

  ; move the fake to the graphic-seg
  ; leaves a 8-pixel wide boarder around the screen
  flushscreen:
    mov  di, 320*7+7
    mov  cx, 200-16
    flushloop:
      push cx
      mov  cx, (320-16) shr 2
      @@:
	mov  eax, [fs:di]
	mov  [gs:di], eax
	repeat 4
	inc  di
	end repeat
      loop @r
      add  di, 16
      pop cx
    loop flushloop
  ret


  ;////////// background ////////////
  drawbackground:
    xor  di, di
    mov  cx, 16000
    mov  eax, 0x01010101
    push fs
    pop  es
    rep  stosd
  ret

  ; draw the background-map using the background-sprites
  ; !!mapoffx and y have to be checked before this procedure!!
  ; f.e mapoffx <= (mapx-scrmapx+2)*8
  ; though the virtual screen is 320x200 the
  ; left,right,top and bottom boarders are not drawn acurate
  ; instead the flushscreen-call blanks out this area.
  ; this could be differently solved by checking always the
  ; spriteoffsets inside the drawing-loop (too slow),
  ; or by seperatly drawing these areas aftwerwards (too lazy).
  drawmap:
    xor  di, di
    mov  ax, [mapoffx]
    mov  di, ax
    not  di
    and  di, 7			 ; x-position in fakescreen
    shr  ax, 3			 ; scale by 8
    mov  [curmapx], ax		 ; add xoffset
    mov  ax, [mapoffy]
    mov  bx, ax
    shr  ax, 3			 ; scale by 8
    mov  [curmapy], ax		 ; add yoffset
    not  bx
    and  bx, 7
    imul bx, screenx
    add  di, bx 		 ; y-position in fakescreen
    mov  cx, [scrmapy]
    dec  cx
    MYloop:
      push cx
      mov  si, themap		 ; map to draw
      mov  ax, [curmapy]
      imul ax, [mapxw]		 ; word size
      add  si, ax		 ; goto curent line in map
      add  si, [curmapx]	 ; add x-position
      add  si, [curmapx]	 ; two times for word

      push di			 ; keep x-start for drawing
      mov  cx, [scrmapx]
      dec  cx
      MXloop:
	push cx
	lodsb			 ; read one map-entry
	inc  si

	push si 		 ; keep mapdata
	xor  ah, ah
	mov  si, mapsprites	 ; load graphdata
	shl  ax, 6		 ; goto sprite nr. al
	add  si, ax

	push di 		 ; keep screen-offset
	mov  cl, 8		 ; draw 8 lines of block
	SYloop:

	  push di
	  mov  ch, 8		 ; draw 8 cols
	  SXloop:
	    lodsb		 ; read sprite-data
	    or	 al, al
	    jz	 skipdraw	 ; only draw if not 0
	    mov  [fs:di], al	 ; write to fakescreen
	    skipdraw:
	    inc  di
	    dec  ch
	  jnz SXloop
	  pop  di
	  add  di, screenx	 ; next screen-line

	  dec  cl
	jnz  SYloop
	pop  di
	add  di, 8		 ; draw next block

	pop  si 		 ; restore map data

	pop  cx
      loop MXloop
      pop  di
      add  di, screenx*8	 ; draw next row of blocks

      inc  [curmapy]
      pop  cx
    loop MYloop
  ret


  ; draw object-call
  ; draws a sprite on the fakescreen
  ; what makes this so complicated-looking
  ; is, that the sprites get clipped
  ; give: object in ds:si
  ;       sprite in ds:di
  ;       (normaly would read spritenr from object-struc
  ;        but that is not implemented yet)

  startx  dw 0			   ; some runtime-variables
  starty  dw 0			   ; startx,y - offsets for cliping
  sprxs   dw 0			   ; x-size after cliping
  sprtxs  dw 0			   ; true x-size
  sprys   dw 0			   ; y-size after cliping
  drawobject:
    mov  ax, [ds:di]		   ; keep the width and height of sprite
    mov  [sprxs], ax
    mov  [sprtxs], ax
    mov  ax, [ds:di+2]
    mov  [sprys], ax
    add  di, 4			   ; move to begin of sprite-data

    ; find out pos to draw and
    ; eventually clip the sprite
    ; by altering startx,y and sprxs,ys
    mov  [starty], 0
    mov  ax, [ds:si+2]		   ; read y-pos
    shr  ax, fak
    sub  ax, [mapoffy]		   ; sub view-offset
    jns  y_ok			   ; see if sprite starts out off screen
      mov  bx, ax
      not  bx			   ; make bx positive; now holds lines out of scr.
      cmp  bx, [sprys]
      jae  end_draw		   ; sprite is invisible, skip drawing
      sub  [sprys], bx		   ; else
      mov  [starty], bx 	   ;  adjust values
      imul bx, [sprxs]		   ; calc and
      add  di, bx		   ;  set startoffset in sprite-data
      xor  ax, ax		   ; start drawing at line 0
    y_ok:
    mov  bx, ax 		   ; add y-pos
    mov  ax, screeny		   ; check clipping at y=200
    sub  ax, [sprys]
    cmp  bx, ax
    jb	 y_ok2
      mov  cx, screeny
      sub  cx, bx
      jz  end_draw		   ; if completly out of screen
      js  end_draw		   ;  skip drawing
      mov  [sprys], cx		   ; else decrease y-size
    y_ok2:
    imul bx, screenx
    mov  ax, [ds:si]		   ; read x-pos
    mov  si, bx 		   ; store screenpos yet
    shr  ax, fak
    sub  ax, [mapoffx]		   ; sub view-offset
    jns  x_ok			   ; check neg. out-of-screen for x
      mov  bx, ax
      not  bx
      cmp  bx, [sprtxs]
      jae  end_draw
      sub  [sprxs], bx
      mov  [startx], bx
      add  di, bx
      xor  ax, ax
    x_ok:
    add  si, ax 		   ; add x-position to screen-pos


    mov  cx, [sprys]		   ; drawing starts here!!!!!!!
    sprY:			   ; a rather simple process
      push cx
      push si			   ; keep screen-offset
      push di			   ; keep spriteoffset

      mov  cx, [sprxs]
      sprX:
	mov  al, [ds:di]	   ; read spritedata
	or   al, al
	jz   dontdraw
	mov  byte[fs:si], al
	dontdraw:
	inc  si
	inc  di
      loop sprX
      pop  di
      add  di, [sprtxs] 	   ; next line in sprite
      pop  si
      add  si, screenx		   ; next line on screen

      pop  cx
    loop  sprY
    end_draw:
  ret


  drawplayer:
    mov  si, objects
    mov  di, sprite0
    call drawobject
  ret


 ;/////////////////////////////////////////////////////////
 ;                 K E Y H A N D L E R
 ;/////////////////////////////////////////////////////////

 newkeyvec:
   pushf
   push ax
   cmp	[dokeys], 1
   jne	endofi
   push bx
   push cx
   push dx
   push ds
   push di
   push gs
   push si

   mov	di, onkeys

   xor	ax, ax
   in	al, 0x60
   mov	bl, al
   and	bl, 127
   cmp	bl, 0x60      ; extended?
   jne	noex
   in	al, 0x60
   inc	di	      ; shift in map to extended byte
   noex:
   mov	bl, al
   and	al, 127       ; clear on/off
   mov	[lastkey], ax ; keep al
   shl	ax, 1	      ; two bytes per index (normal/extended)
   add	di, ax
   not	bl
   shr	bl, 7	      ; set to 0/1
   mov	[ds:di], bl   ; write on/off

   pop	si
   pop	gs
   pop	di
   pop	ds
   pop	dx
   pop	cx
   pop	bx

   endofi:

   cli
   mov	ax, 0x20
   out	0x20, al	; send eoi
   sti

   pop	ax
   popf
 iret

 ;--------------------------------------

 getvector:
   push 0x0		 ; do it by hand
   pop	es
   mov	di, 9*4
   mov	ax, [es:di+2]
   mov	[oldkeyes], ax
   mov	ax, [es:di]
   mov	[oldkeybx], ax

   mov	ax, newkeyvec
   cli
   mov	[es:di+2], ds
   mov	[es:di], ax
   sti

   push ds
   pop	es
   mov	di, onkeys
   mov	cx, 256
   xor	ax, ax
   rep	stosw		 ; clear keymap
   mov	[lastkey], 0
 ret

 restorevector:
   push 0x0
   pop	es
   mov	di, 9*4
   mov	ax, [oldkeyes]
   cli
   mov	[es:di+2], ax
   mov	ax, [oldkeybx]
   mov	[es:di], ax
   sti
 ret


 ;/////////////////////////////////////////////////////////
 ; externals
 ;/////////////////////////////////////////////////////////

  include '..\inc\waitR.inc'

 ;/////////////////////////////////////////////////////////
 ; postschiffdata
 ;/////////////////////////////////////////////////////////

  dokeys   dw 0 	      ; 1=process keys; 0=not

  nobjects dw 100

  object:
   dw	   0	    ; x                             0x00
   dw	   0	    ; y                             0x02
   dw	    0	    ; direction angle  0/512=up     0x04
   dw	     0	    ; speed/xspeed                  0x06
   dw	      0     ; yspeed                        0x08
   dw	      0     ; sprite                        0x0a
   dw	     0	    ; special                       0x0c
  objectsize=$-object


  ; this is the initialmap
  ; it gets copied to [themap] changing
  ; its format from byte to word
  mapx	dw  50
  mapxw dw  100     ; word size
  mapy	dw  30
  defaultmap:
   ;  0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9
   db 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01 ; 0
   db 01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01,01,01,01,01,01,01,01,01,01,01,01,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 1
   db 01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01,01,01,01,01,01,01,01,01,01,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 2
   db 01,00,00,00,00,00,00,00,00,00,00,00,03,01,01,01,01,01,01,00,00,00,01,01,01,01,01,01,01,01,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 3
   db 01,00,00,00,00,00,00,00,00,00,00,03,01,01,00,00,00,00,00,00,00,00,00,00,01,01,01,01,01,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 4
   db 01,00,00,00,00,00,00,00,00,00,01,01,01,01,00,00,00,00,00,00,00,00,00,00,00,00,01,01,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 5
   db 01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 6
   db 01,01,02,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 7
   db 01,01,01,02,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 8
   db 01,01,01,01,02,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 9
   db 01,01,01,01,01,01,01,01,01,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 0
   db 01,00,00,00,00,00,00,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 1
   db 01,00,00,00,00,00,00,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 2
   db 01,00,00,00,00,00,00,01,00,00,00,00,00,00,05,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 3
   db 01,00,00,00,00,00,00,01,04,04,04,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 4
   db 01,00,00,00,00,00,00,01,04,04,04,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 5
   db 01,00,00,00,00,00,00,01,01,01,01,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 6
   db 01,00,00,00,04,00,00,00,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 7
   db 01,00,00,00,04,04,00,00,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 8
   db 01,00,00,00,04,04,00,03,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 9
   db 01,00,00,01,01,01,01,01,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 0
   db 01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 1
   db 01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 2
   db 01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 3
   db 01,02,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 4
   db 01,04,02,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 5
   db 01,04,04,02,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 6
   db 01,04,04,04,02,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 7
   db 01,04,04,04,04,02,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 8
   db 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01 ; 9

   nmapsprites	dw  5
   mapsprites:
   db 00,00,00,00,00,00,00,00  ; 0 empty
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00

   db 00,08,08,08,08,08,08,00  ; 1 stone
   db 08,15,15,15,15,07,07,08
   db 08,15,15,07,07,07,07,08
   db 08,15,07,07,07,07,07,08
   db 08,07,07,07,07,07,07,08
   db 08,07,07,07,07,07,07,08
   db 08,07,07,07,07,07,07,08
   db 00,08,08,08,08,08,08,00

   db 00,08,00,00,00,00,00,00  ; 2 stone \
   db 08,15,08,00,00,00,00,00
   db 08,15,07,08,00,00,00,00
   db 08,15,07,07,08,00,00,00
   db 08,07,07,07,07,08,00,00
   db 08,07,07,07,07,07,08,00
   db 08,07,07,07,07,07,07,08
   db 00,08,08,08,08,08,08,00

   db 00,00,00,00,00,00,08,00  ; 3 stone /
   db 00,00,00,00,00,08,15,08
   db 00,00,00,00,08,15,07,08
   db 00,00,00,08,15,07,07,08
   db 00,00,08,15,07,07,07,08
   db 00,08,07,07,07,07,07,08
   db 08,07,07,07,07,07,07,08
   db 00,08,08,08,08,08,08,00

   db 04,04,04,04,04,04,04,04  ; 4 chest
   db 04,04,14,04,14,04,14,04
   db 04,14,04,14,04,14,04,04
   db 04,04,14,04,14,04,14,04
   db 04,14,04,14,04,14,04,04
   db 04,04,14,04,14,04,14,04
   db 04,14,04,14,04,14,04,04
   db 04,04,04,04,04,04,04,04

   db 00,00,00,00,00,00,00,00  ; 5 debug
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,16,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00

  sprite1:
   dw 10   ; width
   dw 12   ; height
   db 00,00,00,02,02,02,02,00,00,00
   db 00,00,02,16,14,14,16,02,00,00
   db 00,00,14,14,14,14,14,14,00,00
   db 00,00,00,14,14,14,14,00,00,00
   db 00,00,00,00,16,16,00,00,00,00
   db 14,16,16,16,16,16,16,16,16,14
   db 00,00,00,16,16,16,16,00,00,00
   db 00,00,00,16,16,16,16,00,00,00
   db 00,00,00,16,16,16,16,00,00,00
   db 00,00,16,16,00,00,16,16,00,00
   db 00,16,16,00,00,00,00,16,16,00
   db 04,04,04,00,00,00,00,04,04,04

  sprite0:
   dw 10,16
   db 00,00,00,00,16,00,00,00,00,00
   db 00,00,00,00,16,00,00,00,00,00
   db 00,00,00,00,16,00,00,00,00,00
   db 16,16,16,16,16,00,00,00,00,00
   db 00,00,00,16,16,16,16,16,16,16
   db 00,00,00,16,00,00,00,00,00,00
   db 00,00,00,16,00,00,00,00,00,00
   db 00,00,00,16,00,00,00,00,00,00
   db 00,00,00,16,00,00,00,00,00,00
   db 00,00,00,16,00,00,00,00,00,00
   db 00,00,00,16,00,00,00,00,00,00
   db 00,00,00,16,00,00,00,00,00,00
   db 00,00,00,16,00,00,00,00,00,00
   db 00,00,00,16,00,00,00,00,00,00
   db 00,00,00,16,00,00,00,00,00,00
   db 00,00,00,16,00,00,00,00,00,00

  ; //////// uninitialized ///////////

  oldkey:		       ; bios keyboard-vector
   oldkeybx rw 1
   oldkeyes rw 1

  onkeys:   rw 256
  lastkey   rw 1

  objects:		       ; reserve place for offsets
   rw objectsize*nobjects

  curmapx   rw	1	       ; loop-helpers
  curmapy   rw	1
  mapoffx   rw	1	       ; current view-offset
  mapoffy   rw	1

  collisionmap	rw  1	       ; collsionmap-segment

  framenr  rw  1	       ; current frame

  themap:		       ; place for map(word)

 ;/////////////////////////////////////////////////////////

 anisierte  = 0x100
 verpeilung = anisierte * 0
