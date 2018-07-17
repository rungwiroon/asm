 format MZ

 org anisierte+verpeilung

 ;/////////////////////////////////////////////////////////;
 ;                                                         ;
 ;  small jump'n'run prog by def.gsus '05                  ;
 ;                                        (flat assembler) ;
 ;                                                         ;
 ;  i think this code is shit, be aware!                   ;
 ;  just one of many, many to come test-progs              ;
 ;  for designing the best possible low-level-functions    ;
 ;  for my current life-work  D A S H .                    ;
 ;                                                         ;
 ;  version 0: - draws back-ground-map                     ;
 ;  (08.10.05) - moves player                              ;
 ;             - object-struc for easy-2-use               ;
 ;               displacement and stuff                    ;
 ;             - no collision checking or whatever         ;
 ;             - very dangerous memory-usage               ;
 ;                                                         ;
 ;  version 1: - added pixel-perfect collision-            ;
 ;  (08.10.05)   detection with background-map             ;
 ;                                                         ;
 ;  version 2: - the player can be moved like in a         ;
 ;  (10.10.05)   real jump'n'run now, that means:          ;
 ;               added gravity and jumping.                ;
 ;               walking up some hills (1 pixel steps)     ;
 ;               seems to be buggy at the moment and       ;
 ;               is therefore only implemented for going   ;
 ;               left. movement-routines will be completly ;
 ;               rewritten, later.                         ;
 ;             - fixed multiple object struc.              ;
 ;               had not been testet and did obviously     ;
 ;               not work before this version.             ;
 ;               now some 'enemies' with same sprite as    ;
 ;               player are hopping around. however        ;
 ;               collision-checking seem to work fast      ;
 ;               enough for 20 sprites.                    ;
 ;               further feature will be better memory-    ;
 ;               management and testing with a LOT more    ;
 ;               sprites....                               ;
 ;                                                         ;
 ;  (11.10.03) - have been ill :[                          ;
 ;                                                         ;
 ;  version 3: - consider this as the first real version.  ;
 ;  (12.10.05) - all data moved to external files!!        ;
 ;               (except the objects for now)              ;
 ;             - memory split into several usefull segs.   ;
 ;             - 256 possible sprites, with 256 possible   ;
 ;               frames each. overall size can be 64K.     ;
 ;               as an example, the players and the        ;
 ;               'hoppers' have two frames each, one for   ;
 ;               staying and walking and one for jumping   ;
 ;               or flying. this is updated by the         ;
 ;               moveobject-call (without checking if the  ;
 ;               sprite actually contains a 2nd frame!!).  ;
 ;               the collision-check still works with the  ;
 ;               first frame, otherwise the guys would     ;
 ;               just get stuck into the ground because    ;
 ;               the jump-frame has some free(zero) lines  ;
 ;               at the bottom. so when a sprite is coming ;
 ;               down and it touches the ground, frame 0   ;
 ;               gets activated, which would make the      ;
 ;               sprite apear some lines IN the ground.    ;
 ;               i have to think about that..              ;
 ;             - the map can be up to 64K, too, which      ;
 ;               means a total of f.e. 256x128 squares.    ;
 ;               note: i use only a word to hold the       ;
 ;               positions of an object. with the current  ;
 ;               pos-shift of 6 this makes a maximum width ;
 ;               or height of 0xffff shr 6 shl 3 + 1       ;
 ;               = 128!! since the position-on-screen can  ;
 ;               not be more than 1024. don't worry...     ;
 ;               i'll fix that with sticky-tape and        ;
 ;               dword-size for positions.                 ;
 ;               2nd note... just tried a pos-shift of 5   ;
 ;               which gives a total of 2048 for position  ;
 ;               and 256 blocks. but movement (which is    ;
 ;               still a pain) gets much more painfull.    ;
 ;               since one could draw a map like 1024x32   ;
 ;               or so, fooling with the pos-shift isn't   ;
 ;               even near any solution.                   ;
 ;               anyways... i'll rewrite the movement      ;
 ;               especially for the player, because there  ;
 ;               are a few differences between the player  ;
 ;               and all the rest, which are currently     ;
 ;               not considered by the moveobject func.    ;
 ;             - mapsprites have their own segment, though ;
 ;               they only take 16K of mem, since they are ;
 ;               limited to 256, mhhh... gives some room   ;
 ;               for additional crap. maybe i'll move the  ;
 ;               objects there. (but wouldn't be nice,     ;
 ;               anyway to always swap the segment)        ;
 ;                                                         ;
 ;  version 4: - ok, rewrote the movement for the player   ;
 ;  (13.10.05)   and added some frames for animation.      ;
 ;               now, left and right doesnt inc/dec the    ;
 ;               xspeed but the position instead. that,    ;
 ;               ofcourse disables smooth fadeout of speed ;
 ;               but gives a much better handling of the   ;
 ;               player. [ctrl] doubles move-speed.        ;
 ;               jumping and gravity work still the same.  ;
 ;             - object-position now is hold in d-words!   ;
 ;               was a nice trial to rewrite this shit.    ;
 ;               now more than 8 million blocks are        ;
 ;               addresable! almost a shame with a 64K-map ;
 ;             - the pos-shift of 6 is just very nice.     ;
 ;               by adding or subtracting 1 to or from     ;
 ;               the position, this gives a movement of    ;
 ;               about one pixel-on-screen per second      ;
 ;               (that is i.o.w. 64 retraces per pixel),   ;
 ;               even good enough for animating a snail =) ;
 ;               you can increase the pos-shift value,     ;
 ;               though. but adjust the gravity, friction  ;
 ;               and jumpheight-values. i, myself see no   ;
 ;               reason at the moment.                     ;
 ;             - mhh.. keyhandler seems to be too slow     ;
 ;               or there's another problem which causes   ;
 ;               the player for example to jump a few ms.  ;
 ;               after already releasing the jump-key .(   ;
 ;               since i was too lazy to rewrite it and    ;
 ;               rather used some old code which is of a   ;
 ;               more general character, it may be just    ;
 ;               that. a rewrite for only the necessary    ;
 ;               keys could be helpful.                    ;
 ;             - startet a map- & sprite-editor in delphi. ;
 ;               a native-windows-app. 'cause i'm working  ;
 ;               under windows anway, and mousehandling 'n ;
 ;               stuff is much easier.                     ;
 ;             - testet a lot of sprites!! (just inc/dec   ;
 ;               their number by pressing 'q'/'a' in the   ;
 ;               game.                                     ;
 ;                                                         ;
 ;/////////////////////////////////////////////////////////;

 debug_P	 = 0		 ; print position of player
		 ; note:  the print function uses the vga-bios
		 ; out-character-function which means for
		 ; printing two dwords it takes 32!!! interupts
		 ; per frame (look there how i wrote it).
		 ; in result: my keyboardhandler looses track
		 ; and some keys keep hanging... anyways, this'
		 ; just for debugging ... and positioning seem
		 ; to work fine...

 use16

 ;////////////////////
 ; set graphic mode
 ;////////////////////


  mov  ax, 0x13
  int  0x10


 ;////////////////////
 ; get keyvec
 ;////////////////////

  include '..\..\inc\keycodes.inc'
  call getvector



 ;////////////////////
 ; init data
 ;////////////////////

  push 0xa000
  pop  gs		       ; graphic segment
  push fakeseg
  pop  fs		       ; fakescreen

  jmp  postcard

  ; /////////// constants ////////////

  ; mapsprites are fixed to 8 by 8 pixels

  fak		=     6 		 ; screen to pos shift
  fakt		=     1 shl fak 	 ; one pixel on screen
  screenx	=     320		 ; screen width
  screeny	=     200		 ; height
  para1ax	=     1 		 ; bit-shift for backplane-
					 ; position
  scrmapx	dw    screenx shr 3	 ; visible map width (+2)
  scrmapy	dw    screeny shr 3	 ; visible map height (+2)
		      ; (the 2, which appears here and there in the
		      ; code is caused by the area which is blanked
		      ; out at the boarders)
  artblocks	dw    190		 ; all mapsprites from this value
					 ; to 255 are treated as artwork
					 ; and cause no collision

  nenemies	dw    2 		 ; nr of 'hoppers'

  friction	db    3 		 ; friction in air
  g_friction	db    3 		 ; friction on ground
  gravity	db    6 		 ; overall gravity
  pmoveslow	dd    1 shl fak 	 ; move player normal
  pmovefast	dd    4 shl fak 	 ; move fast
  jumpheight	dd    200		 ; speed-add for jump

  oplayer	=     0 		 ; offset of the protagonist
					 ; means player is first object
					 ; in objects-struc. i guess i'll
					 ; never use this variable, because
					 ; i KNOW where the player is :)

		      ; offsets in object-struc
  Ox		=     0 		 ; x-position (dword)
  Oy		=     4 		 ; y-position (dword)
  Odir		=     8 		 ; direction (not used yet)
  Oxs		=     10		 ; x-speed (dword)
  Oys		=     14		 ; y-speed (dword)
  Osp		=     18		 ; sprite (lowB) / frame (heighB)
  Oadd		=     20		 ; additional crap (not used yet)



  ; ////////// init objects //////////

  postcard:

  call	loadall 		   ; load all external files
  call	initobjects		   ; copy initblock over objects


  mov  [mapoffx], 0		   ; zero offset
  mov  [mapoffy], 0		   ; for viewing-window

  mov  di, objects		   ; player is offset 0
  mov  dword[ds:di+Ox], 50 shl fak ; set x-pos
  mov  dword[ds:di+Oy], 180 shl fak ; y-pos

  mov  eax, 8 shl fak
  mov  cx, 2000 		   ; init the hoppers
  @@:
    add  di, [objectsize]	   ; next object ...
    mov  [ds:di+Ox], eax	   ; set x-pos
    mov  dword[ds:di+Oy], 200 shl fak
				   ; y-pos
    add  eax, fakt
    mov  dword[ds:di+Osp], 1	   ; spritenr
  loop @r

  mov  [framenr], 0
  mov  [dokeys], 1		   ; turn on keyhandler




 ;/////////////////////////////////////////////////////////
 ;/ / / / / / / / / ///// mainloop ////// / / / / / / / / /
 ;/////////////////////////////////////////////////////////

  l00p:

    mov  ax, [lastkey]		   ; check normal keys
    cmp  al, 0x01
    je	 l00pend
    cmp  al, 0x17		   ; 'i'
    jne  dontcall
    call initmap
    dontcall:

    test byte [onkeys+(0x10*2)], 0x1	     ; 'q' pressed
    jz	 @f
    inc  [nenemies]
    @@:
    test byte [onkeys+(0x1e*2)], 0x1	     ; 'a' ...
    jz	 @f
    cmp  [nenemies],1
    je	 @f
    dec  [nenemies]
    @@:


    test [framenr], 2
    jz	 skipnewf
    mov  [newframe], 0
    skipnewf:

    call moveenemies
    call moveplayer

    call drawbackground
    call drawmap
    call drawenemies
    call drawplayer
    call adjustmapoffset

    call waitretrace
    call flushscreen

    if debug_P=1
    call printpos
    end if

    inc  [framenr]

  jmp l00p
  l00pend:



 ;/////////////////////////////////////////////////////////
 ; get the .... off
 ;/////////////////////////////////////////////////////////

  getoff:

  call restorevector
  mov  ax, 0x0003
  int  0x10
  mov  ax, 0x4c00
  int  0x21

  ;////////////////////////////////////////////////////////
  ;
  ; debug: print player-position
  ;
  if debug_P=1
  hexval db '0123456789abcdef'
  printpos:
    mov  si, objects
    mov  edx, [ds:si+Ox]       ; print x
    mov  si, 0		       ; set screen-offset for
    call printedx	       ; printing
    mov  si, objects
    mov  edx, [ds:si+Oy]       ; print y
    mov  si, 10
  printedx:		       ; print edx at offset si(0-30)
    mov  cx, 8		       ; 8 digits
    @@:
      push cx
      push edx
      mov  ax, 0x0200	       ; set cursor
      xor  bx, bx
      mov  dh, 24	       ; line 25
      mov  dl, cl	       ; column
      add  dx, si	       ; add start-offset
      int  0x10
      pop  edx
      push edx
      mov  di, hexval	       ; goto hex-table
      and  edx, 0x0f	       ; maskout one digit
      add  di, dx	       ; goto char in table
      mov  ax, 0x0900	       ; out character func
      mov  al, [ds:di]	       ; select char from hexval
      mov  bx, 0x000f	       ; attribute
      mov  cx, 1	       ; number of times to write
      int  0x10 	       ; call the police
      pop  edx
      shr  edx, 4	       ; shift one digit
      pop  cx
    loop @r
  ret
  end if

 ;/////////////////////////////////////////////////////////
 ;                  P R O C E D U R E S
 ;/////////////////////////////////////////////////////////

 ;/////////////////////////////////////////////////////////
 ;                       F I L E S
 ;/////////////////////////////////////////////////////////

 fhandle dw 0

 ; give name in ds:dx as asciiZ-string
 loadmap:
   mov	ax, 0x3d00	       ; open file, read only
   int	0x21
   jc	fileerror	       ; in carry, out error and exit

   mov	[fhandle], ax

   mov	bx, ax		       ; give handle
   mov	ax, 0x3f00	       ; read some bytes
   mov	dx, mapxs	       ; read mapxs and mapys
   mov	cx, 4		       ; 4 bytes
   int	0x21
   mov	ax, [mapxs]
   shl	ax, 1
   mov	[mapxsw], ax	       ; keep a local with word-width

   if 1=0
   ; since the mapfile is in byte format (which will be
   ; changed anyhow), and i rather use word-format for
   ; free space for further developement, i just read
   ; 1 byte and convert it then.
   mov	cx, [mapxs]
   imul cx, [mapys]	       ; number of bytes to read
   xor	dx, dx
   @@:
     push cx
     mov  ax, 0x3f00
     mov  bx, [fhandle]
     push ds
     push mapseg
     pop  ds		       ; switch to mapsegment
     mov  cx, 1 	       ; 1 byte
     int  0x21
     inc  dx
     inc  dx
     pop  ds

     pop  cx
   loop @r
   end if

   mov	cx, [mapxs]
   imul cx, [mapys]	       ; number of bytes to read
   xor	dx, dx
   shl	cx, 1
   mov	ax, 0x3f00
   mov	bx, [fhandle]
   push ds
   push mapseg
   pop	ds
   int	0x21
   pop	ds

   mov	ax, 0x3e00	       ; close file
   mov	bx, [fhandle]
   int	0x21
 ret

 ; again give name in ds:dx
 loadmapsprites:
   mov	ax, 0x3d00
   int	0x21
   jc	fileerror
   mov	[fhandle], ax

   mov	bx, ax
   mov	ax, 0x3f00
   mov	cx, 2
   mov	dx, nmapsp
   int	0x21		       ; read number of mapsprites

   mov	cx, [nmapsp]
   shl	cx, 6		       ; calc bytes to read (nr*64)
   push ds
   push mapspseg
   pop	ds		       ; move to mapsprite-segment
   xor	dx, dx
   mov	ax, 0x3f00
   int	0x21

   pop	ds

   mov	ax, 0x3e00	       ; close file
   mov	bx, [fhandle]
   int	0x21
 ret

 ; yeah right, ds:dx
 loadsprites:
   mov	ax, 0x3d00
   int	0x21
   jc	fileerror
   mov	[fhandle], ax

   mov	bx, ax
   mov	ax, 0x3f00
   mov	cx, 2
   mov	dx, nsprites
   int	0x21		       ; read number of sprites

   xor	cx, cx
   mov	[xp], cx	       ; use local [xp] for offset
   @@:			       ; get'em
     push cx

     mov  di, [xp]	       ; di <- current offset in spritseg
     mov  ax, 0x3f00
     mov  bx, [fhandle]
     mov  cx, 6 	       ; 3 words
     mov  dx, di	       ; load width, height, frames...
     push ds
     push spriteseg
     pop  ds
     int  0x21		       ; ...into spriteseg

     mov  cx, [ds:di]	       ; width
     imul cx, [ds:di+2]        ; height
     imul cx, [ds:di+4]        ; no frames
     mov  ax, 0x3f00
     add  di, 6 	       ; skip offset
     mov  dx, di	       ; set write-pointer
     int  0x21
     mov  dx, cx	       ; keep length in dx
     add  dx, 6

     pop  ds		       ; return to local

     pop  cx
     mov  di, spriteptr
     mov  bx, cx
     shl  bx, 1
     mov  ax, [xp]
     mov  [ds:di+bx], ax       ; save offset for that sprite
     add  [xp], dx	       ; move ahead

     inc  cx
     cmp  cx, [nsprites]
   jb @r

   mov	ax, 0x3e00	       ; close file
   mov	bx, [fhandle]
   int	0x21
 ret

 loadall:		       ; just reads all necessary
   mov	dx, mapname	       ; files
   call loadmap

   mov	dx, mapspname
   call loadmapsprites

   mov	dx, spritesname
   call loadsprites
 ret

 ;/////////////////////////////////////////////////////////
 ;                       I N I T S
 ;/////////////////////////////////////////////////////////

  initobjects:		       ; copy initblock over objects
    push ds
    pop  es
    mov  di, objects
    mov  cx, nobjects
    @@:
      mov  si, object	       ; initblock
      push cx
      mov  cx, [objectsize]
      shr  cx, 1
      rep  movsw
      pop  cx
    loop @r
  ret

  initmap:		       ; load map (name in [mapname])
    mov  dx, mapname
    jmp  loadmap




 ;/////////////////////////////////////////////////////////
 ;                     M O V E M E N T
 ;/////////////////////////////////////////////////////////


  ;/////////////// checkcollision /////////////////////////
  ; give:
  ;   ds:di  <-  object
  ;   es:si  <-  spritedata (including width,height...)
  ;   ecx    <-  xspeed (xoffset/signed)
  ;   edx    <-  yspeed (yoffset/signed)
  ;
  ; returns:
  ;   dl     <-  collision with backgroundmap
  ;   ZF     <-  if set, collision detected
  ;
  ; preserves:
  ;   eax, ebx, si, di, fs, gs
  ;
  ; purpose
  ;  uses x,y-pos, temporarly adds x,y-offset and
  ;  makes a pixel-perfect collision-check with
  ;  backgroundmap.
  ;
  xp   dw   0	   ; some locals
  yp   dw   0
  xs   dw   0
  ys   dw   0
  curx dw   0
  cury dw   0
  checkcollision:
    push si
    push di
    push eax
    push ebx
    push gs		      ; keep graphseg
    push mapseg
    pop  gs		      ; and load with mapseg
    push fs		      ; keep fakeseg
    push mapspseg
    pop  fs		      ; and load with mapsprites

    mov  eax, [ds:di+Ox]      ; x-pos of object
    add  eax, ecx	      ; add x-speed
    shr  eax, fak	      ; scale to screen
    sub  ax, 7		      ; for some reason this is
			      ; essential to get the right pos
			      ; (the blanked-out area)
    mov  [xp], ax	      ; keep pos in [xp]

    mov  eax, [ds:di+Oy]      ; same for y-pos...
    add  eax, edx
    shr  eax, fak
    sub  ax, 7
    mov  [yp], ax
    mov  [cury], ax

    mov  ax, [es:si]	      ; read sprite's width
    mov  [xs], ax
    mov  ax, [es:si+2]	      ; read sprite's height
    mov  [ys], ax
    add  si, 6		      ; skip to actual data

 ;   mov  ax, [ds:di+Osp]     ; this code would actually jump
 ;   shr  ax, 8               ; to the sprite's frame as set in the object.
 ;   imul ax, [xs]            ; however, it doesn't work nice, because the
 ;   imul ax, [ys]            ; player gets stuck into the ground after
 ;   add  si, ax              ; landing from a jump. this is ofcourse quite
			      ; logical but i dont know how to fix that
			      ; at the moment.

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
    ; position for every pixel.....
    xor  dx, dx 	     ; no collision yet ;)
    mov  cx, [ys]
    YY:
      push cx
      mov  ax, [xp]
      mov  [curx], ax
      mov  cx, [xs]
      XX:
	push cx
	mov  ax, [es:si]     ; read one sprite-pixel
	inc  si
	or   al, al
	jz   alis0	     ; if zero we dont have to check further

			     ; now read map and then the mapsprite-pixel
	mov  bx, [cury]      ; screen-y-pos of sprite on screen + current y
	shr  bx, 3	     ; scale to map-index (/8)
	imul bx, [mapxsw]    ; calc line
	mov  di, bx	     ; update di
	mov  bx, [curx]      ; screen-x-pos of sprite
	shr  bx, 2	     ; scale to map, /8 *2 for word size is
	and  bx, 0xfffe      ;  the same as shr 2 and 0xfffe
	add  di, bx	     ; ok, this is the mapfield we wanna check

	mov  bx, [gs:di]     ; read map-sprite nr
	cmp  bx, [artblocks] ; see if it's only some artwork
	jae  alis0	     ; yes?, skip detection

			     ; goto mapsprites
	shl  bx, 6	     ; offset = nr*8*8
	mov  di, bx	     ; this is topleft of map-sprite we wanna check
	mov  bx, [cury]      ; add current y-position
	and  bx, 7	     ; modulo 8
	shl  bx, 3	     ; *8 for line
	add  di, bx	     ; update di
	mov  bx, [curx]      ; add x-pos
	and  bx, 7	     ; modulo 8
	mov  bl, [fs:di+bx]  ; read that pixel

	or   bl, bl
	jz   alis0	     ; is zero? great... no collision

	pop  cx 	     ; if not,
	pop  cx 	     ; restore stack
	mov  dx, 0x01	     ; set collision-flag
	jmp  collide	     ; and leave

	alis0:
	inc  [curx]
	pop  cx
      loop XX
      inc  [cury]
      pop  cx
    loop YY

    collide:

    or	 dx, dx 	     ; update zero-flag

    pop  fs
    pop  gs
    pop  ebx
    pop  eax
    pop  di
    pop  si
  ret


  ;///////////////// moveobject ///////////////////////////
  ; give:
  ;   ds:di  <-  object
  ;   es     <-  sprite-segment
  ;   ebx    <-  speed to move (unsigned!)
  ;   cl     <-  friction
  ;   ch     <-  gravity
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
  ;                        (not implemented but sounds nice=)
  ; alters:
  ;   si, ax, cx, dx
  moveflag    dw 0
  groundflag  dw 0
  moveobject:
    push cx
    mov  [moveflag], dx
    test dx, 128
    jnz  byangle
				 ; set si to sprite of object
     mov  ax, [ds:di+Osp]	 ; read spritenr
     xor  ah, ah		 ; kill frame
     shl  ax, 1
     mov  si, spriteptr 	 ; lookuptable
     add  si, ax
     mov  si, [ds:si]		 ; si <- current sprite

     ; first see if object stands on ground
     xor  ecx, ecx		 ; xoff=0
     mov  edx, fakt		 ; yoff=+1
     call checkcollision
     mov  [groundflag], dx	 ; restult in dx
     xor  dl, 1
     mov  [ds:di+Osp+1], dl	 ; set frame to wheter 0 or 1

     ; normal up,dn,etc.. mode
     test word [moveflag], 1	 ; UP?
     jz _1
       xor  ecx, ecx
       mov  edx, ecx
       sub  edx, ebx
       call checkcollision	 ; check if requested direction
       jnz  _1			 ;  is possible
       sub  [ds:di+Oys], ebx	 ; yspeed--
     _1:
     test word [moveflag], 2	 ; LEFT?
     jz _2
       xor  ecx, ecx
       mov  edx, ecx
       sub  ecx, ebx
       call checkcollision	 ; check if requested direction
       jz   _2doit		 ;  is possible
       xor  ecx, ecx
       sub  ecx, ebx
       mov  edx, -fakt		 ; if not, may try left and one
       call checkcollision	 ; pixel up, for climbing hills
       jnz  _2
       sub  dword[ds:di+Oys], fakt
				 ; yspeed - step
				 ; player is more jumping than
				 ; walking. anyhow, this is good
				 ; enough for those enemies...
       _2doit:
       sub  [ds:di+Oxs], ebx	 ; xspeed--
     _2:
     test word [moveflag], 4	 ; DOWN?
     jz _3
       xor  ecx, ecx
       mov  edx, ebx
       call checkcollision	 ; check if requested direction
       jnz  _3			 ;  is possible
       add  [ds:di+Oys], ebx	 ; yspeed++
     _3:
     test word [moveflag], 8	 ; RIGHT?
     jz _4
       mov  ecx, ebx
       xor  edx, edx
       call checkcollision	 ; check if requested direction
       jnz  _4			 ;  is possible
       add  [ds:di+Oxs], ebx	 ; xspeed++
     _4:
     test [moveflag], 16	 ; JUMP?
     jz _5
       mov  ax, [groundflag]
       or   ax, ax
       jz   _5
       mov  eax, [jumpheight]
       sub  [ds:di+Oys], eax	 ; yspeed--
     _5:

     xor  ecx, ecx
     mov  edx, ecx
     pop  cx
     mov  dx, cx		 ; split friction/gravity
     shr  cx, 8 		 ; gravity
     and  dx, 0xff		 ; friction
     mov  ax, [groundflag]
     or   ax, ax		 ; see if on-ground, then use
     jz   skipfric		 ; [g_friction]
     mov  dl, [g_friction]	 ; since the friction is passed
				 ; as an argument to this function
				 ; it's kindof stupid to overwrite
				 ; it here with [g_friction]...
				 ; but for now, that's how it works.
     skipfric:

     mov  ax, [groundflag]	 ; if not on ground...
     or   ax, ax
     jnz  skipgrav
     mov  eax, [ds:di+Oys]	 ; read y-speed
     add  eax, ecx		 ; add gravity
     mov  [ds:di+Oys], eax	 ; write back
     skipgrav:

     mov  eax, [ds:di+Oxs]	 ; x-speed
     cmp  eax, 0		 ; test if not 0 -> sub friction
     js   isneg1
     jz   isok1
     sub  eax, edx
     jmp  isok1
     isneg1:
     add  eax, edx
     isok1:
     mov  [ds:di+Oxs], eax	 ; write back

     mov  eax, [ds:di+Oxs]	 ; check for left/right collision
     mov  ecx, eax
     xor  edx, edx
     call checkcollision
     jz   LRok
     xor  eax, eax		 ; zero speed
     LRok:
     mov  [ds:di+Oxs], eax	 ; write back
     add  [ds:di+Ox], eax	 ; and add to position

     mov  eax, [ds:di+Oys]	 ; check for up/dn collision
     xor  ecx, ecx
     mov  edx, eax
     call checkcollision
     jz   UDok
     xor  eax, eax		 ; zero speed
     UDok:
     mov  [ds:di+Oys], eax	 ; write back
     add  [ds:di+Oy], eax	 ; and add to position


     movefinished:

    jmp  end_byangle
    byangle:			 ; move by angle and speed
      pop  cx

    end_byangle:

  ret


  ;//////////////////////////////////////////////////////////////////
  ;
  ;  player movement
  ;
  ;
  PFnorm   = 0			       ; normal frame
  PFwalkR1 = 1			       ; first walk-right frame
  PFwalkR2 = 8			       ; last walk-right frame
  PFwalkL1 = 9			       ; first walk-left frame
  PFwalkL2 = 15 		       ; last walk-left frame
  PFjump   = 16 		       ; jump up
  PFjumpR  = 17 		       ; jump right
  PFjumpL  = 18 		       ; jump left

  newframe  dw 0
  incwalkframeR:		       ; adjust the walk-frames for right
    mov  bx, [newframe] 	       ; first check for new screen
    or	 bx, bx 		       ; if not, just leave
    jnz  dontinc
    mov  bl, [ds:di+Osp+1]	       ; read current frame
    cmp  bl, PFwalkR1		       ; see if fits into walk-frames
    jb	 settoone
    cmp  bl, PFjump		       ; when jumping,
    je	 setjumpR		       ; set to jump with direction
    cmp  bl, PFwalkR2
    jae  settoone
    inc  byte[ds:di+Osp+1]	       ; increas walkframe
    jmp  dontinc
    settoone:
    mov  byte[ds:di+Osp+1], PFwalkR1   ; start over again
    dontinc:
    mov  [newframe], 1		       ; set flag for this screen
  ret
    setjumpR:
    mov  byte[ds:di+Osp+1], PFjumpR    ; set jump with direction
  ret

  incwalkframeL:		       ; adjust the walk-frames
    mov  bx, [newframe] 	       ; first check for new screen
    or	 bx, bx 		       ; if not, just leave
    jnz  dontincL
    mov  bl, [ds:di+Osp+1]	       ; read current frame
    cmp  bl, PFwalkL1		       ; see if fits into walk-frames
    jb	 settooneL
    cmp  bl, PFjump		       ; when jumping,
    je	 setjumpL		       ; set to jump with direction
    cmp  bl, PFwalkL2
    jae  settooneL
    inc  byte[ds:di+Osp+1]	       ; increas walkframe
    jmp  dontinc
    settooneL:
    mov  byte[ds:di+Osp+1], PFwalkL1   ; start over again
    dontincL:
    mov  [newframe], 1		       ; set flag for this screen
  ret
    setjumpL:
    mov  byte[ds:di+Osp+1], PFjumpL    ; set jump with direction
  ret

  ;/////////////// move player ////////////////////////////
  ;
  ;
  moveplayer:
    xor  edx, edx		       ; clear the high words
    mov  ecx, edx
    mov  eax, edx
    mov  [moveflag], dx 	       ; clear moveflag
    mov  di, objects		       ; player is offset 0
    push spriteseg
    pop  es			       ; es <- spriteseg
    mov  bx, [ds:di+Osp]
    xor  bh, bh
    shl  bx, 1
    mov  si, spriteptr
    mov  si, [ds:si+bx] 	       ; si <- sprite

    xor  ecx, ecx		       ; check if player stands on ground
    mov  edx, fakt		       ; y+1
    call checkcollision 	       ; ?
    jz	 skipjump		       ; if not, skip jumping and add gravity

    test byte[onkeys+keyUP], 1	       ; check for jump-key
    jz	 skipgravity
    mov  eax, [jumpheight]
    sub  [ds:di+Oys], eax	       ; set yspeed
    or	 [moveflag], 16 	       ; set moveflag
    mov  byte[ds:di+Osp+1], PFjump     ; set jump-frame
    jmp  skipgravity
    skipjump:

    xor  eax, eax
    mov  al, [gravity]
    add  [ds:di+Oys], eax	       ; if not on ground, add gravity
    or	 [moveflag], 4
    mov  byte[ds:di+Osp+1], PFjump     ; set jump-frame

    skipgravity:

    mov  eax, [pmoveslow]	       ; set speed according to
    test byte[onkeys+keyCtrl], 1       ; ctrl-key
    jz	 skipfast
    mov  eax, [pmovefast]	       ; ax <- speed to move
    skipfast:

    test byte[onkeys+keyRT], 1	       ; check right
    jz	 skipRT
    mov  ecx, eax		       ; cx <- speed
    xor  edx, edx		       ; dx <- 0
    call checkcollision
    jnz  skip_RT		       ; if collision, go skip_RT
    add  [ds:di+Ox], eax	       ; add speed to x-pos
    or	 [moveflag], 8
    call incwalkframeR
    jmp  skipRT 		       ; finish
    skip_RT:			       ; if collision, then try
    mov  ecx, eax		       ; cx <- speed
    xor  edx, edx		       ; dx <- -speed
    sub  edx, eax		       ; which means, climbing up
    call checkcollision 	       ; a hill or something
    jnz  skipRT
    add  [ds:di+Ox], eax	       ; update x-y position
    sub  [ds:di+Oy], eax
    or	 [moveflag], 8
    call incwalkframeR
    skipRT:

    test byte[onkeys+keyLF], 1	       ; same for left...
    jz	 skipLF
    xor  ecx, ecx
    sub  ecx, eax
    xor  edx, edx
    call checkcollision
    jnz  skip_LF
    sub  [ds:di+Ox], eax
    or	 [moveflag], 2
    call incwalkframeL
    jmp  skipLF
    skip_LF:
    xor  ecx, ecx
    sub  ecx, eax
    mov  edx, ecx
    call checkcollision
    jnz  skipLF
    sub  [ds:di+Ox], eax
    sub  [ds:di+Oy], eax
    or	 [moveflag], 2
    call incwalkframeL
    skipLF:


    xor  ecx, ecx		       ; check if y-speed moves
    mov  edx, [ds:di+Oys]	       ; into collision
    call checkcollision
    jz	 __y
    mov  dword[ds:di+Oys], 0	       ; if yes, kill y-speed
    __y:

    mov  eax, [ds:di+Oys]	       ; add y-speed to
    add  [ds:di+Oy], eax	       ; y-position

    mov  ax, [moveflag] 	       ; check what player is
    or	 ax, ax 		       ; doing...
    jnz  skipstand		       ; if doing nothing then
    mov  byte[ds:di+Osp+1], PFnorm     ; set frame 0
    skipstand:

  ret




  moveenemies:
    push spriteseg
    pop  es		     ; es <- spriteseg

    mov  ebx, fakt	     ; initial speed to move
			     ; since the 'hoppers' are
			     ; only hopping (jump-flag)
			     ; this value isn't used...
    mov  di, objects
    mov  cx, [nenemies]
    @@:
      add  di, [objectsize]
      push di
      push cx

      mov  cl, [friction]
      mov  ch, [gravity]
      mov  dx, 16	      ; set jump-flag
      call moveobject

      pop  cx
      pop  di
    loop @r
  ret





  ; takes care that player is always
  ; visible on the screen
  xmin=90		     ; player is always inside
  xmax=230		     ; this area
  ymin=60
  ymax=140
  adjustmapoffset:
    ; adjust view-offset
    mov  di, objects
    mov  eax, [ds:di+Ox]     ; read playeroff x
    shr  eax, fak
    mov  bx, [mapoffx]	     ; read viewoff x
    push bx
    add  bx, xmax
    cmp  ax, bx 	     ; check left
    jb	 ok1
      mov  cx, ax	     ; calc a value for increasing
      sub  cx, bx	     ; the mapoffx
      add  [mapoffx], cx
    ok1:
    pop  bx
    add  bx, xmin
    cmp  ax, bx 	     ; check right
    ja	 ok2
      cmp  [mapoffx], 0
      jz   ok2
      mov  cx, bx	     ; calc value
      sub  cx, ax	     ;
      js   ok2		     ; if signed skip
      sub  [mapoffx], cx
      jns  ok2
      mov  [mapoffx], 0      ; if mapoffx neg?, make it 0
    ok2:

    mov  eax, [ds:di+Oy]     ; read player y
    shr  eax, fak
    mov  bx, [mapoffy]
    push bx
    add  bx, ymax
    cmp  ax, bx 	     ; check top
    jb	 ok3
      mov  cx, ax
      sub  cx, bx
      add  [mapoffy], cx
    ok3:
    pop  bx
    add  bx, ymin
    cmp  ax, bx 	     ; check bottom
    ja	 ok4
      mov  cx, bx
      sub  cx, ax
      js   ok4
      sub  [mapoffy], cx
      jns  ok4
      mov  [mapoffy], 0
    ok4:

    ; check bounds for mapoffx,y.  zero got checked above
    mov  ax, [mapxs]
    sub  ax, [scrmapx]
    add  ax, 2
    shl  ax, 3
    cmp  [mapoffx], ax
    jb	 ok5
     mov [mapoffx], ax
    ok5:
    mov  ax, [mapys]
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

  waitretrace:
   mov	dx, 0x3da
   @@:
    in	 al, dx
    test al, 0x8
   jnz	@r
   @@:
    in	 al, dx
    test al, 0x8
   jz	@r
  ret

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


  doaddy=0
  ;////////// background ////////////
  drawbackground:
    enter 6,0
    push bp
    push spriteseg
    pop  es		     ; es <- spriteseg

    if doaddy=1
     mov  si, objects
     mov  eax, [ds:si+Oy]    ;
     shr  eax, fak	     ;
     sub  ax, [mapoffy]      ;
     shr  ax, 2
     mov  [cury], ax	     ; load player-y
    end if
    ; setup
    xor  di, di 	     ; screenstart
    mov  si, spriteptr
    mov  bx, 2 * 2	     ; use sprite nr 3
    mov  si, [ds:si+bx]
    mov  bx, [es:si]	     ; keep x
    mov  dx, [es:si+2]	     ; keep y
    add  si, 6		     ; goto pixel-data
    mov  bp, si 	     ; keep

    ; paralax scroll position
    push dx
    mov  cx, dx
    mov  ax, [mapoffy]	     ; load map-offset y
    shr  ax, para1ax
    if doaddy=1
     push cx
     mov  cx, [cury]	     ; load player y
     add  ax, cx	     ; add
     pop  cx
    end if
    cwd 		     ; ax->dx:ax
    idiv cx		     ; modulo
    mov  [cury], dx	     ; starty in sprite

    mov  ax, [mapoffx]
    shr  ax, para1ax
    cwd
    idiv bx
    mov  [curx], dx	     ; startx in sprite

    pop  dx

    mov  cx, screeny
    scY:
      push cx
      mov  cx, screenx

      mov  si, bp	     ; start of sprite
      mov  ax, [cury]	     ; load y
      imul ax, bx	     ; mul x-size
      add  ax, [curx]	     ; load x
      add  si, ax	     ; start in sprite

      mov  cx, screenx
      scX:
	mov  al, [es:si]     ;
	mov  [fs:di], al     ; copy pixel
	inc  si
	inc  di
	mov  ax, [curx]      ;
	inc  ax 	     ;
	cmp  ax, bx	     ; check x in sprite
	jb   @f
	xor  ax, ax	     ; reset [curx]
	sub  si, bx	     ; set back x in sprite
	@@:
	mov  [curx], ax      ; write back
      loop scX

      mov  ax, [cury]	     ;
      inc  ax		     ;
      cmp  ax, dx	     ; check y in sprite
      jb   @f
      xor  ax, ax	     ; reset
      @@:
      mov  [cury], ax

      pop  cx
    loop scY

    pop  bp
    leave
  ret

  _drawbackground:
    xor  di, di
    mov  cx, 16000
    mov  eax, 0x03030303
    push fs
    pop  es
    rep  stosd
  ret

  ;///////////////////////////////////////////////////////////
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
    push gs			 ; keep graphseg
    push mapseg
    pop  gs			 ; gs now holds segement of map
    push mapspseg
    pop  es			 ; es holds map-sprites

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
      xor  si, si		 ; upper-left of map
      mov  ax, [curmapy]
      imul ax, [mapxsw] 	 ; word size
      add  si, ax		 ; goto curent line in map
      add  si, [curmapx]	 ; add x-position
      add  si, [curmapx]	 ; two times for word

      push di			 ; keep x-start for drawing
      mov  cx, [scrmapx]
      dec  cx
      MXloop:
	push cx
	mov  ax, [gs:si]	 ; read one map-entry
	inc  si
	inc  si

	push si 		 ; keep mapdata
	xor  ah, ah
	shl  ax, 6		 ; goto sprite nr. al
	mov  si, ax		 ; in mapsprite-data

	push di 		 ; keep screen-offset
	mov  cl, 8		 ; draw 8 lines of block
	SYloop:

	  push di
	  mov  ch, 8		 ; draw 8 cols
	  SXloop:
	    mov  ax, [es:si]	 ; read sprite-data
	    inc  si
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
    pop  gs			 ; restore graphseg
  ret


  ;////////////////////////////////////////////////
  ; draw object
  ; draws a sprite on the fakescreen
  ; what makes this so complicated-looking
  ; is, that the sprites get clipped
  ; give: object in ds:si
  ;       uses sprite from that object
  ;
  ; alters: si, di, ax, bx, cx, es
  ;
  startx  dw 0			   ; some runtime-variables
  starty  dw 0			   ; startx,y - offsets for cliping
  sprxs   dw 0			   ; x-size after cliping
  sprtxs  dw 0			   ; true x-size
  sprys   dw 0			   ; y-size after cliping
  drawobject:
    push spriteseg
    pop  es			   ; es <- sprites

    mov  bx, [ds:si+Osp]	   ; read sprite-nr
    xor  bh, bh 		   ; clear frame nr
    shl  bx, 1
    mov  di, spriteptr
    mov  di, [ds:di+bx] 	   ; di <- startoffset of sprite

    mov  ax, [es:di]		   ; keep the width and height of sprite
    mov  [sprxs], ax
    mov  [sprtxs], ax
    mov  bx, [es:di+2]
    mov  [sprys], bx
    imul ax, bx 		   ; calc size
    mov  bx, [ds:si+Osp]
    shr  bx, 8			   ; read frame-nr
    add  di, 6			   ; move to begin of sprite-data
    imul ax, bx
    add  di, ax 		   ; add frame-offset

    ; find out pos to draw and
    ; eventually clip the sprite
    ; by altering startx,y and sprxs,ys
    mov  [starty], 0
    mov  eax, [ds:si+Oy]	   ; read y-pos
    shr  eax, fak
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
    mov  eax, [ds:si+Ox]	   ; read x-pos
    mov  si, bx 		   ; store screenpos yet
    shr  eax, fak
    sub  ax, [mapoffx]		   ; sub view-offset
    jns  x_ok			   ; check neg. out-of-screen for x
      mov  bx, ax
      not  bx
      cmp  bx, [sprtxs]
      jae  end_draw
      sub  [sprxs], bx
      mov  [startx], bx
      add  di, bx
      xor  ax, ax		   ; start drawing col 0
    x_ok:
    mov  bx, screenx
    sub  bx, [sprxs]
    cmp  ax, bx
    jb	x_ok2			   ; too much right?
      mov  bx, screenx
      sub  bx, ax
      jz   end_draw
      js   end_draw
      mov  [sprxs], bx
    x_ok2:
    add  si, ax 		   ; add x-position to screen-pos


    mov  cx, [sprys]		   ; drawing starts here!!!!!!!
    sprY:			   ; >a rather simple process<
      push cx
      push si			   ; keep screen-offset
      push di			   ; keep spriteoffset

      mov  cx, [sprxs]
      sprX:
	mov  al, [es:di]	   ; read spritedata
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
    call drawobject
  ret

  drawenemies:
    mov  si, objects
    mov  cx, [nenemies]
    @@:
      add  si, [objectsize]
      push di
      push si
      push cx
      call drawobject
      pop  cx
      pop  si
      pop  di
    loop @r
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
 ; error'handling'
 ;/////////////////////////////////////////////////////////

 ; on any fileerror, display stupid messy and leave
 fileerror:
   mov	dx, fileerrortext
   mov	ax, 0x0900
   int	0x21
 jmp  getoff


 ;/////////////////////////////////////////////////////////
 ; externals
 ;/////////////////////////////////////////////////////////



 ;/////////////////////////////////////////////////////////
 ; postschiffdata
 ;/////////////////////////////////////////////////////////

  fileerrortext db 'error opening file...',13,10,'$'
  mapname	db 'map01.map',0
  mapspname	db 'map01.spr',0
  spritesname	db 'sprite01.bin',0

  dokeys   dw 0 	      ; 1=process keys; 0=not

  nobjects = 2001
  object:
   dd	   0	    ; x                             0x00
   dd	   0	    ; y                             0x04
   dw	    0	    ; direction angle  0/512=up     0x08
   dw	     0	    ; speed/xspeed                  0x0a
   dd	      0     ; yspeed                        0x0c
   dd	      0     ; sprite                        0x10
   dw	     0	    ; special                       0x14
  objectsize dw 22

  ; //////// uninitialized ///////////

  oldkey:			; bios keyboard-vector
   oldkeybx  rw  1
   oldkeyes  rw  1

  onkeys:    rw  256
  lastkey    rw  1

  curmapx    rw  1		; loop-helpers
  curmapy    rw  1
  mapoffx    rw  1		; current view-offset
  mapoffy    rw  1

  framenr    rw  1		; current frame
  oldframenr rw  1		; for checking a new frame

  mapxs      rw  1		; x and
  mapys      rw  1		; y size of map
  mapxsw     rw  1		; word-x-size, just double of x

  nmapsp     rw  1		; nr of map-sprites
				; (not really needed actually)

  nsprites   rw  1		; number of sprites
  spriteptr  rw  256		; offsets of sprites...
				; since they all can have
				; different sizes, there's
				; no other way than keeping
				; a table with their positions

  objects:			; reserve place for objects
   rb 22*nobjects

  ;---------------------------------------------------------------
  segment spriteseg
  ;---------------------------------------------------------------

  rb 0x10000	     ; reserve place for sprites

  ;---------------------------------------------------------------
  segment mapseg
  ;---------------------------------------------------------------

  rb 0x10000	     ; reserve place for map

  ;---------------------------------------------------------------
  segment mapspseg
  ;---------------------------------------------------------------

  rb 0x10000	     ; reserve place for mapsprites

  ;---------------------------------------------------------------
  segment fakeseg
  ;---------------------------------------------------------------

  rb 64000	     ; reserve place for fakescreen-buffer

 ;/////////////////////////////////////////////////////////

 anisierte  = 0x100
 verpeilung = anisierte * 0
