
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
 ;/////////////////////////////////////////////////////////;



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

  call	initobjects	       ; copy initblock over objects
  call	initmap

  mov	di, objects	       ; player is offset 0
  mov	word[ds:di], 30 shl fak    ; set x-pos
  mov	word[ds:di+2], 40 shl fak  ; y-pos



 ;/////////////////////////////////////////////////////////
 ;/ / / / / / / / / ///// mainloop ////// / / / / / / / / /
 ;/////////////////////////////////////////////////////////

  l00p:

    mov  ax, [lastkey]		 ; check normal keys
    cmp  al, 0x01
    je	 l00pend
    cmp  al, 0x10
    jne  @f
    not  [drawback]
    mov  [lastkey], 0
    @@:


    call moveplayer

    call drawbackground
    cmp  [drawback], 0xff
    jne  @f
    call drawmap
    @@:
    call drawplayer


    call waitretrace
    call flushscreen

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
      movsb
      mov  [ds:di], al	       ; set highbyte to 0
      inc  di
    loop @r
    mov  [mapoffx], 0
    mov  [mapoffy], 0
  ret







 ;/////////////////////////////////////////////////////////
 ;                     M O V E M E N T
 ;/////////////////////////////////////////////////////////

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
     add  [ds:di+2], ax 	 ; add yspeed to position

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
     add  [ds:di], ax		 ; add xspeed to position


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

    ; check bounds for mapoffx,y.  zero is checked above
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
  ; instead the flushscreen-call blanks out this area
  ; this could be differently solved by checking always the
  ; spriteoffsets inside the drawing-loop, or by seperatly
  ; drawing these areas aftwerwards.
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
      imul ax, [mapx]
      shl  ax, 1		 ; word size
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
  starty  dw 0
  sprxs   dw 0
  sprtxs  dw 0			   ; true x-size
  sprys   dw 0

  drawobject:
    mov  ax, [ds:di]		   ; keep the width and height of sprite
    mov  [sprxs], ax
    mov  [sprtxs], ax
    mov  ax, [ds:di+2]
    mov  [sprys], ax
    add  di, 4			   ; move to begin of sprite-data

    ; find out pos to draw and
    ; eventually clip the sprite
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
    sprY:
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
 ; externals
 ;/////////////////////////////////////////////////////////

  include '..\inc\keyhandler.inc'
  include '..\inc\waitR.inc'

 ;/////////////////////////////////////////////////////////
 ; postschiffdata
 ;/////////////////////////////////////////////////////////

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

  drawback db 0xff

  mapx	dw  50
  mapy	dw  30
  defaultmap:
   ;  0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9
   db 01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01,01 ; 0
   db 01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 1
   db 01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 2
   db 01,00,00,00,00,00,00,00,00,00,00,00,03,01,01,01,01,01,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 3
   db 01,00,00,00,00,00,00,00,00,00,00,03,01,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 4
   db 01,00,00,00,00,00,00,00,00,00,01,01,01,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 5
   db 01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 6
   db 01,01,02,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 7
   db 01,01,01,02,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 8
   db 01,01,01,01,02,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 9
   db 01,01,01,01,01,01,01,01,01,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 0
   db 01,00,00,00,00,00,00,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 1
   db 01,00,00,00,00,00,00,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 2
   db 01,00,00,00,00,00,00,01,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,01 ; 3
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
   db 00,00,00,00,00,00,00,00  ; empty
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00
   db 00,00,00,00,00,00,00,00

   db 00,08,08,08,08,08,08,00  ; stone
   db 08,15,15,15,15,07,07,08
   db 08,15,15,07,07,07,07,08
   db 08,15,07,07,07,07,07,08
   db 08,07,07,07,07,07,07,08
   db 08,07,07,07,07,07,07,08
   db 08,07,07,07,07,07,07,08
   db 00,08,08,08,08,08,08,00

   db 00,08,00,00,00,00,00,00  ; stone \
   db 08,15,08,00,00,00,00,00
   db 08,15,07,08,00,00,00,00
   db 08,15,07,07,08,00,00,00
   db 08,07,07,07,07,08,00,00
   db 08,07,07,07,07,07,08,00
   db 08,07,07,07,07,07,07,08
   db 00,08,08,08,08,08,08,00

   db 00,00,00,00,00,00,08,00  ; stone /
   db 00,00,00,00,00,08,15,08
   db 00,00,00,00,08,15,07,08
   db 00,00,00,08,15,07,07,08
   db 00,00,08,15,07,07,07,08
   db 00,08,07,07,07,07,07,08
   db 08,07,07,07,07,07,07,08
   db 00,08,08,08,08,08,08,00

   db 04,04,04,04,04,04,04,04  ; chest
   db 04,04,14,04,14,04,14,04
   db 04,14,04,14,04,14,04,04
   db 04,04,14,04,14,04,14,04
   db 04,14,04,14,04,14,04,04
   db 04,04,14,04,14,04,14,04
   db 04,14,04,14,04,14,04,04
   db 04,04,04,04,04,04,04,04

  sprite0:
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

  ; //////// uninitialized ///////////

  objects:		       ; reserve place for offsets
   rw objectsize*nobjects

  curmapx  rw  1	       ; loop-helpers
  curmapy  rw  1
  mapoffx  rw  1	       ; current view-offset
  mapoffy  rw  1

  collisionmap	rw  1	       ; collsionmap-segment

  themap:		       ; place for map(word)

 ;/////////////////////////////////////////////////////////

 anisierte  = 0x100
 verpeilung = anisierte * 0
