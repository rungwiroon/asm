; Amnaj Meemongkon   Code. 39013259  Computer Engineering 1P
; 24/04/1997 

;--------------------------------------------------------------------
       page      60,132title     program graphice game tetris
;--------------------------------------------------------------------

stacksg      segment  para stack 'stack'
             dw    128 dup (0)
stacksg      ends

datasg       segment  para 'data'
             TableR       db  264  dup (0)
             Block        db  64   dup (0)
             Number_line  db  5    dup (0)
             NamePlayer   db  'Anonymous$$$'
             HighScore    dw  00d 
             FileHandle   dw  ?
             Mode         dw  ?
             Startblock   dw  ?
             Locate       dw  ?
             position     dw  ?
             Mid          dw  ?
             Temp         dw  ?
             Randomblock  dw  ?
             RowB         dw  ?
             Colume       dw  ?
             HeadB1       dw  0000d
             Row          dw  0012d
             PixcelX      dw  0008d
             PixcelY      dw  2560d
             Skip         dw  0120d
             Score        dw  00
             D_Time       dw  00
             Yt_Cut_TableR  dw  00
             Yt_Cut_Display dw  00
             X            db  00d
             Y            db  00d
             Xt           db  00d
             Yt           db  00d
             Xd           db  00d
             Yd           db  00d
             Valuechk     db  0AAh
             ValueKey     db  00
             Point1       dw  00
             Point2       dw  00
             Point3       dw  00
             Point4       dw  00
             Point5       dw  00
             PointDi_T    dw  00
             PointDi_D    dw  00
             Hz           dw  00
             Chk          db  00
             Darkcolor    db  00
             Softcolor    db  00
             Normalcolor  db  00
             Stop_S       db  0ffh
             Stop_True    db  00
             Stop_D_True  db  00
             Stop_L_True  db  00
             Stop_R_True  db  00
             Stop_Ro_True db  00
             ChkLine      db  0BBh
             BlockClear   db  00
             Time         db  00
             Time_Count   db  00
             Set_Block    db  00
             Number_LT    db  00
             Number_B     db  00
             Count_NB     db  00
             Many_Block   db  00
             Swicth_B     db  00
             ColorLine    db  00d
             Counter      db  00d
             CountKey     db  00d
             CountBlock   db  00d
             Now_Block    db  00d
             Next_Block   db  00d
             Level_Count  db  00d
             Show_Count   db  00d
             Chk_line     db  0AAh,0AAh,0AAh,0AAh,0AAh
                          db  0AAh,0AAh,0AAh,0AAh,0AAh

             Blockblack   db  00,00,00,00,00,00,00,00
                          db  00,00,00,00,00,00,00,00
                          db  00,00,00,00,00,00,00,00
                          db  00,00,00,00,00,00,00,00
                          db  00,00,00,00,00,00,00,00
                          db  00,00,00,00,00,00,00,00
                          db  00,00,00,00,00,00,00,00
                          db  00,00,00,00,00,00,00,00

             NameP        db  'Anonymous$$$'
             Str1         db  'Score$'
             Str2         db  'Level$'
             Str3         db  '1$'
             Str4         db  'Welcome to TeTris Game$'
             Str5         db  'Computer Engineering$'
             Str6         db  'KMITL 1997$'
             Str7         db  'Press Key Enter$'
             Str8         db  'Hot Key$'
             Str9         db  'HighScore$'
             Str10        db  'F2:New Game$'
             Str11        db  'F3:Pause$'
             Str12        db  'Esc:Exit$'
             Str13        db  'Player Name$'
             Str14        db  'Pause$'
             Str15        db  'Game Over$'
             Str16        db  'Game TeTris$'
             ZeroStr      db  '00000$'
             FileN        db  'History',0


Background   db  83,83,83,83,83,83,83,83,83,83,83,83,83,83,83,83
             db  83,59,59,59,59,59,59,59,59,59,59,59,59,59,59,00
             db  83,35,35,35,35,35,35,35,35,35,35,35,35,35,35,00
             db  83,35,35,35,35,35,35,35,35,35,35,35,35,35,35,00
             db  83,35,35,35,35,35,35,35,35,35,35,35,35,35,35,00
             db  83,35,35,35,35,35,35,35,35,35,35,35,35,35,35,00
             db  83,35,35,35,35,35,35,35,35,35,35,35,35,35,35,00
             db  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
             db  83,83,83,83,83,83,83,83,83,83,83,83,83,83,83,83
             db  59,59,59,59,59,59,59,00,83,59,59,59,59,59,59,59
             db  35,35,35,35,35,35,35,00,83,35,35,35,35,35,35,35
             db  35,35,35,35,35,35,35,00,83,35,35,35,35,35,35,35
             db  35,35,35,35,35,35,35,00,83,35,35,35,35,35,35,35
             db  35,35,35,35,35,35,35,00,83,35,35,35,35,35,35,35
             db  35,35,35,35,35,35,35,00,83,35,35,35,35,35,35,35
             db  00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00

datasg       ends

codesg       segment  para 'code'

      begin  proc far
             assume cs:codesg ,ds:datasg ,ss:stacksg
             mov   ax,datasg
             mov   ds,ax
             call  GetPlayerName      ; Get Name Command Line
             call  GetHighScoreS      ; Get High Score in File History
             mov   ax,0A000h
             mov   es,ax              ; set ES piont to vedio ram
             mov   mode,0013h         ; set display mode 320*200 ,256 color
             call  set_display
             call  Logo1
             call  BackGround_Screen
             call  Move_BBh
             call  Operation          ; Control Play game
             call  PutHighScoreS      ; Save High Score
             mov   mode,0003h
             call  set_display    ; set display  text mode 80*25  charcetor
             mov   ax,4c00h
             int   21h
      begin  endp

 ;----------------- Set display and ChkKey --------------

      Set_display  proc near
             push  ax
             mov   ax,mode        ; Initial Mode Display
             int   10h
             pop   ax
             ret
      Set_display  endp

      Key_press    proc near
             push  ax
             mov   ax,0700h
             int   21h           ; Get Acsii Charecter for Key
             cmp   al,00d
             jnz   OutLoop
             mov   ax,0700h
             int   21h
    OutLoop: mov   ValueKey,al   ; Put Acsii Charecter to ValueKey
             pop   ax
             ret
      Key_press    endp

   ChkKey  proc  near
            push  ax
            xor   ax,ax
            mov   ah,0bh
            int   21h
            cmp   al,0ffh       ; Check press key if al = 0ff then
            jnz   exit3         ; No Key press
            call  Key_press
    exit3:  pop   ax
            ret
    ChkKey  endp

;-------------------- Logo -------------------------------
      Logo1  proc near
             push ax
             push bx
             push cx
             push dx
             call BackG1             ; Call Function Draw Background (GackG1)
             call Logo2              ; Call Function Draw Logo (Logo2)
 Logo_new:   mov  cx,30d             ; Draw Logo When Entry Game
             mov  ax,17960
        Lo1: mov  HeadB1,ax
             add  ax,08d
             call B_Cross
             call Delay
             call Clear_Block_Move
             call ChkKey
             mov  bl,ValueKey
             cmp  bl,13d
             jnz  Lo_1
             jmp  Logo_Exit
       Lo_1: loop Lo1

             mov  cx,32d
             mov  ax,20512d
        Lo2: mov  HeadB1,ax
             add  ax,08d
             call B_Alone
             call Delay
             call Clear_Block_Move
             call ChkKey
             mov  bl,ValueKey
             cmp  bl,13d
             jnz  Lo_2
             jmp  Logo_Exit
       Lo_2: loop Lo2

             mov  cx,29d
             mov  ax,20512d
        Lo3: mov  HeadB1,ax
             add  ax,08d
             call B_Line_hor
             call Delay
             call Clear_Block_Move
             call ChkKey
             mov  bl,ValueKey
             cmp  bl,13d
             jnz  Lo_3
             jmp  Logo_Exit
       Lo_3: loop Lo3

             mov  cx,30d
             mov  ax,20512d
        Lo4: mov  HeadB1,ax
             add  ax,08d
             call B_L_left
             call Delay
             call Clear_Block_Move
             call ChkKey
             mov  bl,ValueKey
             cmp  bl,13d
             jnz  Lo_4
             jmp  Logo_Exit
       Lo_4: loop Lo4

             mov  cx,30d
             mov  ax,20512d
        Lo5: mov  HeadB1,ax
             add  ax,08d
             call B_L_Rigth
             call Delay
             call Clear_Block_Move
             call ChkKey
             mov  bl,ValueKey
             cmp  bl,13d
             jnz  Lo_5
             jmp  Logo_Exit
       Lo_5: loop Lo5

             mov  cx,30d
             mov  ax,20512d
        Lo6: mov  HeadB1,ax
             add  ax,08d
             call B_T_Connect
             call Delay
             call Clear_Block_Move
             call ChkKey
             mov  bl,ValueKey
             cmp  bl,13d
             jnz  Lo_6
             jmp  Logo_Exit
       Lo_6: loop Lo6

             mov  cx,31d
             mov  ax,20512d
        Lo7: mov  HeadB1,ax
             add  ax,08d
             call B_Rectangle
             call Delay
             call Clear_Block_Move
             call ChkKey
             mov  bl,ValueKey
             cmp  bl,13d
             jz   Logo_Exit
             loop Lo7

             mov  cx,30d
             mov  ax,20520d
        Lo8: mov  HeadB1,ax
             add  ax,08d
             call B_Z_left
             call Delay
             call Clear_Block_Move
             call ChkKey
             mov  bl,ValueKey
             cmp  bl,13d
             jz   Logo_Exit
             loop Lo8

             mov  cx,30d
             mov  ax,20512d
        Lo9: mov  HeadB1,ax
             add  ax,08d
             call B_Z_rigth
             call Delay
             call Clear_Block_Move
             call ChkKey
             mov  bl,ValueKey
             cmp  bl,13d
             jz  Logo_Exit
             loop Lo9
             jmp  Logo_new

  Logo_Exit: pop  dx
             pop  cx
             pop  bx
             pop  ax
             ret
      Logo1  endp

      Logo2  proc near                   ; Print Title Game in Logo
             mov  Skip,00d
             mov  PixcelX,08d
             mov  PixcelY,2560d
             mov  RowB,20d      
             mov  Colume,34d
             mov  HeadB1,5144d
             mov  ColorLine,43d
             call Clear_Block_BG
             mov  X,09d
             mov  Y,04d
             lea  dx,Str4
             call Display_String
             mov  X,10d
             mov  Y,13d
             lea  dx,Str5
             call Display_String
             mov  X,15d
             mov  Y,15d
             lea  dx,Str6
             call Display_String
             mov  X,13d
             mov  Y,19d
             lea  dx,Str7
             call Display_String
             ret
      Logo2  endp

      Clear_Block_Move  proc near        ; Clear Display Area 
             mov  RowB,05d      
             mov  Colume,32d
             mov  HeadB1,17952d
             mov  ColorLine,00d
             call Clear_Block_BG
             ret
      Clear_Block_Move  endp
      
;-------------------- Back Ground ------------------------

      BackGround_Screen  proc near
             call BackG1
             call BackG2

             mov  RowB,04d         ; Show Next Block Items
             mov  Colume,05d
             mov  HeadB1,5160d     ; Initial Position A000:5160d
             mov  ColorLine,47d    ; Draw Block  Color Black size 4*5
             call Clear_Block_BG   ; One Black = 8*8 Pixcel

             mov  RowB,03d         ;  Show Score
             mov  Colume,07d
             mov  HeadB1,5352d     ; Initial Position A000:5352d
             mov  Colorline,47d    ; Draw Block Color Black  size 3*7
             call Clear_Block_BG
             mov  X,70d
             mov  Y,03d
             lea  dx,Str1
             call Display_String
             mov  RowB,03d
             mov  Colume,07d
             mov  HeadB1,15592d
             call Clear_Block_BG   ; Drow Block size 3*7
             mov  X,70d
             mov  Y,07d
             lea  dx,ZeroStr
             call Display_String   ; Print '00000' to Display
                                   
             mov  RowB,03d         ; Show Level
             mov  Colume,07d
             mov  HeadB1,28392d
             call Clear_Block_BG   ; Draw Block size 3*7 
             mov  X,70d             
             mov  Y,12d
             lea  dx,Str2          ; Print 'Level' to Display
             call Display_String
             mov  RowB,03d
             mov  Colume,07d
             mov  HeadB1,38632d
             call Clear_Block_BG   ; Draw Block size 3*7
             mov  X,72d
             mov  Y,16d
             lea  dx,Str3
             call Display_String   ; Print Number Level  1

             mov  X,05             ; Show HighScore
             mov  Y,16d
             lea  dx,ZeroStr
             call Display_String   ; Print Number '00000'

             ret
      BackGround_Screen  endp

      BackG1 proc near
             push ax
             push bx
             push cx
             push dx
             xor  ax,ax
             xor  bx,bx
             xor  cx,cx
             lea  dx,Background     ; Draw  Back Ground
             mov  Startblock,dx
             mov  PixcelX,0016d
             mov  Skip,0000d
       G1:   mov  Xd,bl
             mov  Yd,cl
             call Calculate_display  ; Function Calculate Position of Display
             mov  ax,mid             ; Position of Display in MID
             mov  Locate,ax
             call Write_block        ; Function Draw Block size 8*8 Pixcel
             inc  bl
             cmp  bl,0020d
             jnz  G1
             mov  bl,00d
             inc  cl
             cmp  cl,12d
             jnz G1

             pop  dx
             pop  cx
             pop  bx
             pop  ax
             ret
     BackG1  endp

     BackG2  proc near
             push ax
             push bx
             push cx
             push dx

             lea  dx,BlockBlack      ; Dx point to offset Blockblack
             mov  Startblock,dx
             mov  bl,00d             ; Draw Play Area  (Area Black)
             mov  cl,02d
             mov  PixcelX,0008d
             mov  Skip,0120d
       G2:   mov  Xd,bl
             mov  Yd,cl
             call Calculate_display
             mov  ax,mid
             mov  Locate,ax
             call Write_block
             inc  bl
             cmp  bl,0010d
             jnz  G2
             mov  bl,00d
             inc  cl
             cmp  cl,22d
             jnz G2

             mov  cx,0081d          ; Draw Line Around Play Area
             mov  di,4800d          
             add  di,0119d
             mov  al,83d            ; Color of line is Soft Violet
       G3:   mov  [es:di],al        ; Out Color Soft Violet at ES:DI 
             inc  di
             loop G3
             mov  cx,0082d
             mov  di,56320d
             add  di,0119d
       G4:   mov  [es:di],al
             inc  di
             loop G4
             mov   cx,0161d
             mov   di,4800d  
             add   di,0119d
       G5:   mov   [es:di],al
             add   di,0320d
             loop  G5
             mov   cx,0161d
             mov   di,4800d
             add   di,200
       G6:   mov   [es:di],al
             add   di,0320d
             loop  G6
 
             pop  dx
             pop  cx
             pop  bx
             pop  ax
             ret
     BackG2  endp

      Clear_Block_BG    proc near   ; Function Draw Block Initial Size
             push ax                ; in Variable X is Colume
             push bx                ; in Variable Y is RowB
             push cx                

             lea  dx,Blockblack
             mov  StartBlock,dx
             mov  ax,HeadB1         ; HeadB1 is First Position Draw
             mov  dx,00d
             mov  bx,RowB
        C2:  mov  cx,Colume
        C1:  mov  Locate,ax
             call Write_block
             add  ax,PixcelX
             add  dx,08d
             loop C1
             sub  ax,dx
             add  ax,PixcelY
             mov  dx,00d
             dec  bx
             jnz  C2

             mov  di,HeadB1        ; Draw Line Around Block
             mov  cx,Colume        ; Draw Line  Colume up
             mov  ax,08d
             mul  cx
             mov  cx,ax
             mov  al,ColorLine
       C3:   mov  [es:di],al
             inc  di
             loop C3

             mov  di,HeadB1        ; Draw Line Colume Down
             mov  cx,RowB
             mov  ax,08d
             mul  cx
             mov  cx,320d
             mul  cx
             add  di,ax
             mov  cx,Colume
             mov  ax,08d
             mul  cx
             mov  cx,ax
             inc  cx
             mov  al,ColorLine
        C4:  mov  [es:di],al
             inc  di
             loop C4

             mov  di,HeadB1        ;Draw Line Row Left
             mov  cx,RowB
             mov  ax,08d
             mul  cx
             mov  cx,ax
             mov  al,ColorLine
        C5:  mov  [es:di],al
             add  di,320d
             loop C5

             mov  di,HeadB1        ; Draw Line Row Rigth
             mov  cx,Colume
             mov  ax,08d
             mul  cx
             add  di,ax
             mov  cx,RowB
             mov  ax,08d
             mul  cx
             mov  cx,ax
             mov  al,ColorLine
        C6:  mov  [es:di],al
             add  di,320d
             loop  C6

             pop  cx
             pop  bx
             pop  ax
             ret
      Clear_Block_BG    endp

;--------------------  Real Table ------------------------

       Move_BBh  proc near         ; Function  Put BBh Around Real Table
            push ax                ; BBh is Boundany of Real Table
            push cx
            push dx
            push si

            lea  dx,TableR
            mov  Xt,00d
            mov  Yt,00d
            mov  al,ChkLine
            mov  cx,0012d
            mov  si,dx
     Move1: call Calculate_Table
            mov  [si],al
            inc  Xt
            loop Move1
            mov  Xt,00d
            mov  Yt,00d
            mov  cx,0022d
            mov  si,dx
    Move2:  call Calculate_Table
            mov  [si],al
            inc  Yt
            loop Move2
            mov  Xt,11d
            mov  Yt,00d
            mov  cx,0022d
            mov  si,dx
    Move3:  call Calculate_Table
            mov  [si],al
            inc  Yt
            loop Move3
            mov  Xt,00d
            mov  Yt,0021d
            mov  cx,0012d
            mov  si,dx
     Move4: call Calculate_Table
            mov [si],al
            inc  Xt
            loop Move4

            pop  si
            pop  dx
            pop  cx
            pop  ax
            ret
       Move_BBh  endp


   Operation  proc  near   ; Function Use Control Play Game
              push ax
              push bx
              push cx
              push dx
              push si
              push di

    New_Play: mov  Skip,120d
              mov  Score,00d       ; Initail Score 00d
              mov  Show_Count,00d
              call Random_Block    ; Random Now Block
              mov  al,Set_Block
              add  al,02d
              mov  Now_Block,al
              mov  Time_Count,15d  ; Initail Time_Count 

       T4:    mov  Hz,400d         ; Genarate Sound When Stop Move Down
              call Sound
              call Get_line_Table   ; Function Get Line for Cut
              call Cut_line_TableR  ; Function Cut Line in RealTable
              call Cut_line_display ; Function Cut Line in Display
              call Show_Help

              call Random_Block    ; Function Random Next Block
              mov  al,Set_Block
              mov  Next_Block,al
              call Display_NextBlock ; Function Show Next Block

              mov  al,Now_Block      ; Mov Now Block in al
              mov  Set_Block,al      ; Initail Block for Display
              mov  al,Next_Block     ; Mov Next Block in al
              mov  Now_Block,al
              call Ini_Block         ; Function Initail Position Block to 
              mov  al,Xt             ; Display
              sub  al,01d
              mov  Xd,al
              mov  al,Yt
              add  al,01d
              mov  Yd,al
              mov  BlockClear,01d    ; Flag if BlockClear = 1 is Delete Block
              call Select_Block      ; Function Selsect Block to Display
              call Delay             ; Function Delay

              mov  al,Yt             ; If Yt = 1 and Stop_D_True = 0ff
              cmp  al,01d            ; then Game Over 
              jnz  R1
              mov  al,Stop_S
              cmp  al,Stop_D_True
              jnz  R1
              call Show_Game_Over   ; Function Show Game Over
   Game_over: call ChkKey           ; Function Check press Key
              mov  al,ValueKey
              cmp  al,60d           ; if ValueKey = Key F2 then New Game 
              jnz  Game_Exit
              call New_Game
              jmp  New_Play         ; goto Play game again
   Game_Exit: cmp  al,27d           ; if Valuekey = Key Esc  then Exit Game
              jnz  Game_over
              jmp  Operation_Out    ; Go Exit FunctionOperation

   Help_jmp8: jmp T1

      R1:     call ChkKey            ; Function Check press Key
              mov  ax,0C00h          ; Clear KeyBoard Buffer
              int  21h

              mov  al,75d            ; if Valuekey = Key Arrow left  then
              cmp  al,ValueKey       ; move Block Left
              jz   Help_jmp8
              mov  al,77d            ; if valuekey = key Arrow rigth  then
              cmp  al,ValueKey       ; move Block Rigth
              jz   Help_jmp7
              mov  al,80d            ; if Valuekey = key  Arrow down  then
              cmp  al,ValueKey       ; move Block Down
              jz   Help_jmp3
              mov  al,72d            ; if ValueKey = key  Arrow up  then
              cmp  al,ValueKey       ; Rotate Block
              jz   Help_jmp1
              mov  al,27d
              cmp  al,ValueKey       ; if Valuekey = Key Esc  then Exit Game
              jz   Help_jmp6

              mov  al,60d            ; if Valuekey = Key F2 then  New Game
              cmp  al,ValueKey        
              jnz  Key_F3
              call New_Game
              mov  ValueKey,00d      ; Clear ValueKey to 00d
              jmp  New_Play          ; Goto New game

      Key_F3: mov  al,61d            ; if ValueKey = key F3 then Pause 
              cmp  al,ValueKey
              jnz  Count2
              mov  ValueKey,00d
              call Show_Pause        ; Function Show Pause
       Pause: call ChkKey
              mov  al,61d            ; if ValueKey = Key F3 then Play 
              cmp  al,ValueKey       ; Game Agian
              jz   Clear_S1
              jmp  Pause
    Clear_S1: dec  Show_Count
              call Show_help         ; Function Show Help
              jmp  T3

      Count2: mov  al,CountKey       ; if Counter = Time_Count then 
              cmp  al,Time_Count     ; call Function Delay
              jnz  Count1
              call Level          
              jmp  T3                ; Gogo Move down  Block

      Count1: inc  CountKey          ; Inc CounterKey
              call Delay             ; Call Function Delay
              jmp  R1                ; Go to Check Key again

   Help_jmp1: jmp T5
   Help_jmp3: jmp T3
   Help_jmp6: jmp Operation_out
   Help_jmp7: jmp T2
   Help_jmp9: jmp Count2

       T1:    mov  al,Stop_S         ; If Stop_L_True = Stop_S then then
              cmp  al,Stop_L_True    ; Goto Count2 
              jz   Count2            ; Else Move Block Left
              lea  dx,Blockblack
              mov  Startblock,dx
              mov  BlockClear,00d
              mov  ValueChk,00d
              call Select_Block
              dec  Xd               ; Position Block in Display   Xd-1
              dec  Xt               ; Position Block in RealTable Xt-1
              mov  BlockClear,01d
              mov  ValueChk,0AAh
              call Select_Block     ; Call Function Select Block Show to 
              mov  ValueKey,00d     ; Display 
              jmp  R1

       T2:    mov  al,Stop_S        ; If Stop_R_True = Stop_S then
              cmp  al,Stop_R_True   ; Goto  Count2
              jz   Help_jmp9        ; Else Move Block Rigth
              lea  dx,Blockblack
              mov  Startblock,dx
              mov  BlockClear,00d
              mov  ValueChk,00d
              call Select_Block
              inc  Xd               ; Position Block in Display   Xd+1
              inc  Xt               ; Position Block in RealTable Xt+1
              mov  BlockClear,01d
              mov  ValueChk,0AAh
              call Select_Block     ; Call Function Select Block Show to 
              mov  ValueKey,00d     ; Display
  Help_jmp4:  jmp  R1               ; Go to Check Key again


     T3:      mov  al,Stop_S        ; If Stop_D_True = Stop_S then
              cmp  al,Stop_D_True   ; Goto T4
              jz   Help_jmp2        ; Else  Move Block Down
              lea  dx,Blockblack
              mov  Startblock,dx
              mov  BlockClear,00d
              mov  ValueChk,00d
              call Select_Block
              inc  Yd               ; Position Block in Display   Yd+1
              inc  Yt               ; Position Block in RealTable Yt+1
              mov  BlockClear,01d
              mov  ValueChk,0AAh
              call Select_Block     ; Call Function Select Block Show to
              mov  ValueKey,00d     ; Display
              mov  CountKey,00d
              
              mov  bx,Score         ; When Block Move Down Score = Score + 3
              add  bx,03d
              mov  Score,bx
              mov  ax,bx
              mov  X,75d            ; Initail Position to Print_Num
              mov  Y,07d
              call Print_Num        ; Call Function Print_Num
              jmp  R1               ; Go to  Check Key again

   Help_jmp2: jmp T4
   Help_jmp5: jmp  Count2

        T5:   mov al,Stop_S         ; If Stop_Ro_True = Stop_S then
              cmp al,Stop_Ro_True   ; Goto Count2
              jz  Help_jmp5         ; Else Next expression
              
              mov al,Many_Block     ; If Many_Block = 1 then Goto Count2
              cmp al,01d            ; Else Rotate Block
              jz  Help_jmp5

              lea  dx,Blockblack
              mov  Startblock,dx
              mov  BlockClear,00d
              mov  ValueChk,00d
              call Select_Block    ; Call Function Select Block

              mov  al,Yt           ; If Yt = 01 then  Goto L5_1 
              cmp  al,01d          ; Else  Position Block Yt+1
              jnz  L5_1            ;       Position Block Yd+1
              inc  Yt              ; Check Rotate  Block in Line 1
              inc  Yd

       L5_1:  inc  Number_B        ; Rotate to Next Block 
              mov  cl,Many_Block   ; move Mnay_Block to cl
              mov  ch,Count_NB     ; move Count_Number_Block to ch
              add  cl,ch           ; Cl = Cl + Ch
              cmp  cl,Number_B     ; If Cl = Number_B then 
              jz   Get_Number_B_Temp  ; Goto Get_Number_B_Temp
                                      ;Else  Next line
              mov  BlockClear,01d
              mov  ValueChk,0AAh
              call Select_Block
              mov  ValueKey,00d
              jmp  R1

Get_Number_B_Temp: mov  bh,Count_NB  ; move Count_NB to bh
                   mov  Number_B,bh  ; move bh  to Number_B

                   inc  CountBlock   ; CountBlock = Count + 1

                   mov  BlockClear,01d
                   mov  ValueChk,0AAh
                   call Select_Block
                   mov  ValueKey,00d
                   jmp R1              ; Goto Check Key again

Operation_out: pop di
               pop si
               pop dx
               pop cx
               pop bx
               pop ax
               ret
      Operation endp
  ;--------------------  New Game  ---------------------------
     New_Game   proc near         ; Function New Game
                push ax
                push bx
                push cx
                push si
                lea  si,TableR   ; Si Point to offset TableR   
                add  si,13d      ; Si = Si + 13d
                mov  bl,20d      ; Initail bl = 20d
                mov  al,00d
           N2:  mov  cx,10d      ; Initail cx = 10d
           N1:  mov  [si],al     ; Put 00d to [si]
                inc  si
                loop N1          ; if cx = 0 then next line
                add  si,02d      ; else  goto N1
                dec  bl
                jnz  N2          ; if bl = 0 then next line
                call Move_BBh    ; else goto N2
                call BackG2
                mov  X,70d        ; Clear Score t0 00000d
                mov  Y,07d
                lea  dx,ZeroStr     ; dx point offset ZeroStr
                call Display_String ; Function Print String to Display
                pop  si
                pop  cx
                pop  bx
                pop  ax
                ret
     New_Game   endp

     Show_Help  proc near            ; Function Show Help to Display
                push  ax
                mov  Skip,00d
                mov  PixcelX,08d
                mov  PixcelY,2560d
                inc  Show_Count
                mov  al,Show_Count
                mov  RowB,03d         ; Clear Show Hot Key ,HighScore
                mov  Colume,13d
                mov  HeadB1,38408d
                call Clear_Block_BG

                cmp  al,01d
                jnz  Show1
                mov  RowB,03d           ; Show  Game Name
                mov  Colume,13d
                mov  HeadB1,28168d
                call Clear_Block_BG
                mov  X,02d
                mov  Y,12d
                lea  dx,Str16
                call Display_String
                jmp  Show_Exit
        Show1:  cmp  al,02d
                jnz  Show2
                mov  RowB,03d         
                mov  Colume,13d
                mov  HeadB1,28168d
                call Clear_Block_BG
                mov  X,04d
                mov  Y,12d
                lea  dx,Str8
                call Display_String        ; Show Hot key
                mov  X,03            
                mov  Y,16d
                lea  dx,str12
                call Display_String        ; Show Esc: Exit 
                jmp  Show_Exit
        Show2:  cmp  al,03d
                jnz  Show3
                mov  X,04d
                mov  Y,12d
                lea  dx,Str8
                call Display_String        ; Show Hot key
                mov  X,02            
                mov  Y,16d
                lea  dx,str10
                call Display_String        ; Show F2 : New Game
                jmp  Show_Exit
        Show3:  cmp  al,04d
                jnz  Show4
                mov  X,04d
                mov  Y,12d
                lea  dx,Str8
                call Display_String        ; Show Hot key
                mov  X,04
                mov  Y,16d
                lea  dx,Str11
                call Display_String
                jmp  Show_Exit
        Show4:  cmp  al,05d                 ; Show High Score
                jnz  Show5
                mov  RowB,03d           
                mov  Colume,13d
                mov  HeadB1,28168d
                call Clear_Block_BG
                mov  X,03d
                mov  Y,12d
                lea  dx,Str9
                call Display_String        
                mov  bx,HighScore       ; Print HighScore
                mov  ax,bx
                mov  X,06d
                mov  Y,16d
                call Print_Num
                jmp  Show_Exit
        Show5:  mov  RowB,03d            ; Show Player Name
                mov  Colume,13d
                mov  HeadB1,28168d
                call Clear_Block_BG
                mov  X,02d
                mov  Y,12d
                lea  dx,Str13
                call Display_String
                mov  X,03d
                mov  Y,16d
                lea  dx,NameP
                call Display_String     ; Print Player  Name  
                mov  Show_Count,00d

     Show_Exit: mov  Skip,120d
                pop   ax
                ret
     Show_Help  endp

     Show_Pause proc near             ; Function Show Pause When Press key F3
                push dx
                mov  RowB,03d         ; Clear Show Hot Key ,HighScore
                mov  Colume,13d
                mov  HeadB1,38408d
                call Clear_Block_BG

                mov  RowB,03d           
                mov  Colume,13d
                mov  HeadB1,28168d
                call Clear_Block_BG
                lea  dx,Str14
                mov  X,05
                mov  Y,12d
                call Display_String
                pop  dx
                ret
     Show_Pause endp

     Show_Game_over proc near        ; Function Show Game over when Game over
                push ax
                push dx
                
                mov  RowB,03d         ; Clear Show Hot Key ,HighScore
                mov  Colume,13d
                mov  HeadB1,38408d
                call Clear_Block_BG

                mov  RowB,03d
                mov  Colume,13d
                mov  HeadB1,28168d
                call Clear_Block_BG
                lea  dx,Str15
                mov  X,03
                mov  Y,12d
                call Display_String

                mov  ax,HighScore
                cmp  ax,Score
                jg   Show_G_exit
                mov  ax,Score
                mov  HighScore,ax
    Show_G_Exit:pop  dx
                pop  ax
                ret
     Show_Game_over endp


  ;--------------------- Display Next Block -------------------
     Display_NextBlock    proc  near         ; Function Show NextBlock
                          push ax

                          mov  RowB,04d       ; Clear Next Block 
                          mov  Colume,05d
                          mov  HeadB1,5160d
                          call Clear_Block_BG

                          mov  al,01d         ;if al = 01  then Show  0
                          cmp  al,Set_Block
                          jnz  D_Next1
                          mov  HeadB1,9017d
                          call B_Alone
                          jmp  D_Next_Exit   ;                         0
                 D_Next1: mov  al,02d        ; if al = 02  then Show  000
                          cmp  al,Set_Block  ;                         0
                          jnz  D_Next2
                          mov  HeadB1,6457d
                          call B_Cross
                          jmp  D_Next_Exit
                 D_Next2: mov  al,03d       ; if al =  03  then show  0000
                          cmp  al,Set_Block
                          jnz  D_Next3
                          mov  HeadB1,9004d
                          call B_Line_hor
                          jmp  D_Next_Exit                          
                 D_Next3: mov  al,04d       ; if al = 04 then Show   00   
                          cmp  al,Set_Block ;                        00
                          jnz  D_Next4      
                          mov  HeadB1,7732d
                          call B_Rectangle
                          jmp   D_Next_Exit
                 D_Next4: mov  al,05d       ; if al = 05  then show  000
                          cmp  al,Set_Block ;                          0
                          jnz  D_Next5
                          mov  HeadB1,7728d
                          call B_L_left
                          jmp  D_Next_Exit
                 D_Next5: mov  al,06d        ; if al = 06  then show  000
                          cmp  al,Set_Block  ;                        0
                          jnz  D_Next6
                          mov  HeadB1,7728d
                          call B_L_rigth
                          jmp  D_Next_Exit
                 D_Next6: mov  al,07d        ; if al = 07 then show  000
                          cmp  al,Set_Block  ;                        0
                          jnz  D_Next7
                          mov  HeadB1,7728d
                          call B_T_connect
                          jmp  D_Next_Exit
                 D_Next7: mov  al,08d         ; if al = 80 then show  00
                          cmp  al,Set_Block   ;                      00
                          jnz  D_Next8
                          mov  HeadB1,7736d
                          call B_Z_left
                          jmp  D_Next_Exit    ; if al = 09 then show  00  
                D_Next8:  mov  HeadB1,7728d   ;                        00
                          call B_Z_rigth                               
                          
            D_Next_Exit:  pop  ax
                          ret
     Display_NextBlock    endp

     B_Line_hor    proc near      ;0000
             push  ax
             push  bx
             push  cx
             mov  Darkcolor,40d
             call Block_Color
             mov  Startblock,dx
             mov  ax,HeadB1
             mov  cx,0004h
        B_1: mov  Locate,ax
             call Write_block
             add  ax,PixcelX
             loop B_1
             pop  cx
             pop  bx
             pop  ax
             ret
     B_Line_hor    endp

     B_Rectangle  proc  near
             push ax             ; 00
             push bx             ; 00
             push cx
             mov  Darkcolor,35d
             call Block_Color
             mov  Startblock,dx
             mov   ax,HeadB1
             mov   cx,0002
       B_2:  mov   Locate,ax
             call  Write_block
             add   ax,PixcelX
             loop  B_2
             sub   ax,PixcelX
             sub   ax,PixcelX
             add   ax,PixcelY
             mov   cx,0002
      B_3:   mov   Locate,ax
             call  Write_block
             add   ax,PixcelX
             loop  B_3
             pop   cx
             pop   bx
             pop   ax
             ret
     B_Rectangle  endp

     B_L_Left  proc  near
             push  ax            ; 000
             push  bx            ;   0 
             push  cx
             mov  Darkcolor,43d
             call Block_Color
             mov  Startblock,dx
             mov  ax,HeadB1
             mov  cx,0003
      B_4:   mov  Locate,ax
             call Write_block
             add  ax,PixcelX
             loop B_4
             sub  ax,PixcelX
             add  ax,PixcelY
             mov  Locate,ax
             call Write_block
             pop  cx
             pop  bx
             pop  ax
             ret
     B_L_left  endp

     B_L_rigth  proc near     ; 000
             push ax          ; 0
             push bx
             push cx
             mov  Darkcolor,53d
             call Block_Color
             mov  Startblock,dx
             mov  ax,HeadB1
             mov  cx,0003
       B_5:  mov  Locate,ax
             call Write_block
             add  ax,PixcelX
             loop B_5
             sub  ax,PixcelX
             sub  ax,PixcelX
             sub  ax,PixcelX
             add  ax,PIxcelY
             mov  Locate,ax
             call Write_block
             pop  cx
             pop  bx
             pop  ax
             ret
     B_L_rigth  endp

     B_T_Connect proc near
            push ax             ; 000
            push bx             ;  0
            push cx
            mov  Darkcolor,37d
            call Block_Color
            mov  Startblock,dx
            mov   ax,HeadB1
            mov   cx,0003
       B_6: mov   Locate,ax
            call  Write_block
            add   ax,PixcelX
            loop  B_6
            sub   ax,PixcelX
            sub   ax,PixcelX
            add   ax,PixcelY
            mov   Locate,ax
            call  Write_block
            pop   cx
            pop   bx
            pop   ax
            ret
     B_T_Connect endp

     B_Z_left   proc near
            push ax              ;  00
            push bx              ; 00  
            push cx
            mov  Darkcolor,32d
            call Block_Color
            mov  Startblock,dx
            mov   ax,HeadB1
            mov   cx,0002
       B_7: mov   Locate,ax
            call  Write_block
            add   ax,PixcelX
            loop  B_7
            sub   ax,PixcelX
            sub   ax,PixcelX
            sub   ax,PixcelX
            add   ax,PixcelY
            mov   cx,0002
       B_8: mov   Locate,ax
            call  Write_block
            add   ax,PixcelX
            loop  B_8
            pop   cx
            pop   bx
            pop   ax
            ret
     B_Z_left   endp

     B_Z_rigth  proc near
            push ax               ; 00 
            push bx               ;  00
            push cx
            mov  Darkcolor,16d
            call Block_Color
            mov  Startblock,dx
            mov   ax,HeadB1
            mov   cx,0002
       B_9: mov   Locate,ax
            call  Write_block
            add   ax,PixcelX
            loop  B_9
            sub   ax,PixcelX
            add   ax,PixcelY
            mov   cx,0002
      B_10: mov   Locate,ax
            call  Write_block
            add   ax,PixcelX
            loop  B_10
            pop   cx
            pop   bx
            pop   ax
            ret
     B_Z_rigth  endp

     B_Alone    proc  near    
            push ax           ; 0
            push bx
            push cx
            mov  Darkcolor,43d
            call Block_Color
            mov  Startblock,dx
            mov   ax,HeadB1
            mov   Locate,ax
            call  Write_Block
            pop   cx
            pop   bx
            pop   ax
            ret
     B_Alone    endp

     B_Cross    proc near          
            push ax           ;  0
            push bx           ; 000
            push cx           ;  0
            mov  Darkcolor,32d
            call Block_Color
            mov  Startblock,dx
            mov   ax,HeadB1
            mov   Locate,ax
            call  Write_block
            sub   ax,PixcelX
            add   ax,PixcelY
            mov   cx,0003d
     B_11:  mov   Locate,ax
            call  Write_block
            add   ax,PixcelX
            loop  B_11
            sub   ax,0016d
            add   ax,PixcelY
            mov   Locate,ax
            call  Write_block
            pop   cx
            pop   bx
            pop   ax
            ret
     B_Cross    endp

  ;---------   Calculate Location  and Put Value in Table ------

      Calculate_Table proc  near  ; Function Calculate Position in RealTable
              push ax
              push bx             ; Formula =>  si + X + (Yt * Row ) 
              push dx
              xor ax,ax
              xor bx,bx
              lea dx,TableR     ;  dx point Real Table
              mov si,dx
              mov al,Yt
              mul Row
              mov bl,Xt
              add si,bx
              add si,ax
              pop  dx
              pop  bx
              pop  ax
              ret
      Calculate_Table   endp

      Calculate_display  proc near  ; Function Calculate Position in Display
              push ax               ; Formula
              push bx       ; Skip + (Xd * PixcelX) + (Yd * PixcelX * 320)
              push cx
              xor  ax,ax
              xor  bx,bx
              xor  cx,cx
              mov  ax,PixcelX
              mul  Xd
              mov  bx,ax
              mov  ax,PixcelX
              mul  Yd
              mov  cx,ax
              mov  ax,0320d
              mul  cx
              add  ax,Skip
              add  ax,bx
              mov  mid,ax
              pop  cx
              pop  bx
              pop  ax
              ret
      Calculate_display  endp

    PutValue_Table_1B  proc near    ; Function Put AAh in TableR 1 Block
             mov bx,Point1
             mov [si+bx],al
             ret
    PutValue_Table_1B  endp

    PutValue_Table_4B  proc near    ; Function Put AAh in TableR 2 Block
             mov  bx,Point1
             mov  [si+bx],al
             mov  bx,Point2
             mov  [si+bx],al
             mov  bx,Point3
             mov  [si+bx],al
             mov  bx,Point4
             mov  [si+bx],al
             ret
    PutValue_Table_4B  endp

    PutValue_Table_5B  proc near  ; Function Put AAh in TableR 5 Block
             mov  bx,Point1
             mov  [si+bx],al
             mov  bx,Point2
             mov  [si+bx],al
             mov  bx,Point3
             mov  [si+bx],al
             mov  bx,Point4
             mov  [si+bx],al
             mov  bx,Point5
             mov  [si+bx],al
             ret
    PutValue_Table_5B  endp

 ; -------------  Chk Stop Block down left rigth ----------------

    ChkStop_B_4    proc  near   ; Function Check  Move Left ,Rigth ,down
             push ax            ; and Rotate  Return 00h or 0ffh to Stop_True                      
             push si            ; 4 Block
             mov  bx,Point1
             mov  al,[si+bx]
             cmp  al,0AAh
             jz   Stop_B4_True
             mov  bx,Point2
             mov  al,[si+bx]
             cmp  al,0AAh
             jz   Stop_B4_True
             mov  bx,Point3
             mov  al,[si+bx]
             cmp  al,0AAh
             jz   Stop_B4_True
             mov  bx,Point4
             mov  al,[si+bx]
             cmp  al,0AAh
             jz   Stop_B4_True
             mov  bx,Point1
             mov  al,[si+bx]
             cmp  al,ChkLine
             jz   Stop_B4_True
             jmp  Stop_B4
Stop_B4_True:mov  Stop_True,0ffh
    Stop_B4: pop  si
             pop  ax
             ret
    ChkStop_B_4    endp

    ChkStop_B_3    proc near  ; Function Check Move Left ,Rigth ,down 
             push ax          ; and Rotate  Return 00h or 0ffh to  Stop_Ture
             push si          ; 3 Block
             mov  bx,Point1
             mov  al,[si+bx]
             cmp  al,0AAh
             jz   Stop_B3_True
             mov  bx,Point2
             mov  al,[si+bx]
             cmp  al,0AAh
             jz   Stop_B3_True
             mov  bx,Point3
             mov  al,[si+bx]
             cmp  al,0AAh
             jz   Stop_B3_True
             mov  bx,Point1
             mov  al,[si+bx]
             cmp  al,ChkLine
             jz   Stop_B3_True
             jmp  Stop_B3
Stop_B3_True:mov  Stop_True,0ffh
    Stop_B3: pop  si
             pop  ax
             ret
    ChkStop_B_3    endp

    ChkStop_B_2   proc near  ; Function Check Move Left , Rigth ,down 
             push ax         ; and Rotate Return 00d or 0ffh in Stop_true
             push si         ; 2 Block
             mov  bx,Point1
             mov  al,[si+bx]
             cmp  al,0AAh
             jz   Stop_B2_True
             mov  bx,Point2
             mov  al,[si+bx]
             cmp  al,0AAh
             jz   Stop_B2_True
             mov  bx,Point1
             mov  al,[si+bx]
             cmp  al,ChkLine
             jz   Stop_B2_True
             jmp  Stop_B2
Stop_B2_True:mov  Stop_True,0ffh
    Stop_B2: pop  si
             pop  ax
             ret
    ChkStop_B_2     endp

    ChkStop_B_1   proc near  ; Function Check Move Left ,Rigth ,down
              push ax        ; and Rotate  Return  00d or 0ffh to Stop_True
              push si        ; 1 block
              mov  bx,Point1
              mov  al,[si+bx]
              cmp  al,0AAh
              jz   Stop_B1_True
              mov  al,[si+bx]
              cmp  al,ChkLine
              jz   Stop_B1_True
              jmp  Stop_B1
Stop_B1_True: mov  Stop_True,0ffh
    Stop_B1:  pop  si
              pop  ax
              ret
    ChkStop_B_1     endp

    ChkStop_Ro_3  proc near    ; Function Check Rotate 3 Block Reture 00d or
             push ax           ; 0ffh to Stop_True
             push si
             mov  bx,Point1
             mov  al,[si+bx]
             cmp  al,0AAh
             jz   Stop_Ro3_True
             mov  bx,Point2
             mov  al,[si+bx]
             cmp  al,0AAh
             jz   Stop_Ro3_True
             mov  bx,Point3
             mov  al,[si+bx]
             cmp  al,0AAh
             jz   Stop_Ro3_True
             mov  bx,Point1
             mov  al,[si+bx]
             cmp  al,ChkLine
             jz   Stop_Ro3_True
             mov  bx,Point2
             mov  al,[si+bx]
             cmp  al,ChkLine
             jz   Stop_Ro3_True
             mov  bx,Point3
             mov  al,[si+bx]
             cmp  al,ChkLine
             jz   Stop_Ro3_True
             jmp  Stop_Ro
Stop_Ro3_True:mov  Stop_True,0ffh
    Stop_Ro: pop  si
             pop  ax
             ret
    ChkStop_Ro_3  endp


 ;-------------  Display Block (mov locatetion in mid) ------------

       Block_Color proc  near    ; Function Draw 8*8 pixcel in offset Block
             push  ax            ; it use when Change Color Block
             push  bx            ; Move Color in DarkColor
             push  cx            
             push  si
             lea   dx,Block
             mov   si,dx
             xor   ax,ax
             mov   al,Darkcolor
             add   al,48d
             mov   Softcolor,al
             mov   al,Darkcolor
             add   al,24d
             mov   normalcolor,al
             mov   al,Softcolor
             mov   cx,0008d
        B1:  mov   [si],al
             inc   si
             loop  B1
             mov   bx,0006d
        B2:  mov   al,Softcolor
             mov   [si],al
             inc   si
             mov   cx,0006d
             mov   al,Normalcolor
        B3:  mov   [si],al
             inc   si
             loop  B3
             mov  al,Darkcolor
             mov  [si],al
             inc  si
             dec  bx
             jnz  B2
             mov  cx,0008d
        B4:  mov  [si],al
             inc  si
             loop B4
             pop  si
             pop  cx
             pop  bx
             pop  ax
             ret
       Block_Color endp

       Write_block  proc  near   ; Function Write Block 8*8 pixcel 
             push  ax            ; position in  StartBlock
             push  bx
             push  cx
             push  di
             push  si
             mov   si,Startblock
             mov   di,Locate
             mov   cx,PixcelX
             mov   ax,PixcelX
       L1:   mov   bl,[si]
             mov   [es:di],bl
             inc   si
             inc   di
             dec   ax
             jnz   L1
             mov   ax,PixcelX
             add   Locate,320
             mov   di,Locate
             loop  L1
             pop   si
             pop   di
             pop   cx
             pop   bx
             pop   ax
             ret
      Write_block  endp

      Line_hor  proc near        ; 0000
             push ax
             push bx
             push cx
             xor  bx,bx
             lea  dx,TableR
             mov  si,dx
             mov  al,01d
             cmp  al,CountBlock
             jnz  Line_hor1
             dec  Xt
             dec  Xd
             inc  Yt
             inc  Yd
             mov  CountBlock,00d

  Line_hor1: call Calculate_Table   ; Put value in Real Table
             mov  al,Valuechk
             mov  Point1,00d
             mov  Point2,01d
             mov  Point3,02d
             mov  Point4,03d
             call Putvalue_Table_4B
             mov  al,00d
             cmp  al,BlockClear
             jz   Line_Exit1

             mov  Point1,12d        ; Check Move  Down
             mov  Point2,13d
             mov  Point3,14d
             mov  Point4,15d
             call ChkStop_B_4
             mov  al,Stop_True
             mov  Stop_D_True,al
             mov  Stop_True,00d

             mov  Point1,-1d        ;  Check Move Left
             call ChkStop_B_1
             mov  al,Stop_True
             mov  Stop_L_True,al
             mov  Stop_True,00d

             mov  Point1,04d        ;  Check Move Rigth
             call ChkStop_B_1
             mov  al,Stop_True
             mov  Stop_R_True,al
             mov  Stop_True,00d

             mov  Point1,25d         ; Check Rotate
             call ChkStop_B_1
             mov  al,Stop_True
             mov  Stop_Ro_True,al
             mov  Stop_True,00d

             call Calculate_display
             mov  Darkcolor,40d
             call Block_Color
             mov  Startblock,dx
 Line_Exit1: mov  ax,mid
             mov  cx,0004h
         L2: mov  Locate,ax
             call Write_block
             add  ax,PixcelX
             loop L2
             pop  cx
             pop  bx
             pop  ax
             ret
      Line_hor   endp

      Line_ver   proc near           ; 0
             push ax                 ; 0
             push bx                 ; 0
             push cx                 ; 0
             xor  bx,bx
             lea  dx,TableR
             mov  si,dx
             mov  al,72d
             cmp  al,ValueKey
             jnz  Line_ver1
             mov  al,Blockclear
             cmp  al,00d
             jz   Line_ver1
             inc  Xt
             inc  Xd
             dec  Yt
             dec  Yd

 Line_ver1:  call Calculate_Table     ; Put value in Real Table
             mov  al,Valuechk
             mov  Point1,00d
             mov  Point2,12d
             mov  Point3,24d
             mov  Point4,36d
             call Putvalue_Table_4B
             mov  al,00d
             cmp  al,BlockClear
             jnz  Line
             jmp  Line_Exit2
  
     Line:   mov  Point1,48d         ; Check Move Down
             call ChkStop_B_1
             mov  al,Stop_True
             mov  Stop_D_True,al
             mov  Stop_True,00d

             mov  Point1,-1d         ; Check Move  Left
             mov  Point2,11d
             mov  Point3,23d
             mov  Point4,35d
             call ChkStop_B_4
             mov  al,Stop_True
             mov  Stop_L_True,al
             mov  Stop_True,00d

             mov  Point1,1d          ; Check Move  Rigth
             mov  Point2,13d
             mov  Point3,25d
             mov  Point4,37d
             call ChkStop_B_4
             mov  al,Stop_True
             mov  Stop_R_True,al
             mov  Stop_True,00d

             mov  Point1,11d           ; Check Rotate 
             mov  Point2,13d
             mov  Point3,14d
             call ChkStop_Ro_3
             mov  al,Stop_True
             mov  Stop_Ro_True,al
             mov  Stop_True,00d

             call Calculate_display
             mov  Darkcolor,40d
             call Block_Color
             mov  Startblock,dx
 Line_Exit2: mov  ax,mid
             mov  cx,0004h
        L3:  mov  Locate,ax
             call Write_block
             add  ax,PixcelY
             loop L3
             pop  cx
             pop  bx
             pop  ax
             ret
      Line_ver   endp

     Rectangle   proc near          ; 00
             push  ax               ; 00
             push  bx
             push  cx
             xor  bx,bx
             lea  dx,TableR
             mov  si,dx
             call Calculate_Table     ; Put value in Real Table
             mov  al,Valuechk
             mov  Point1,00d
             mov  Point2,01d
             mov  Point3,12d
             mov  Point4,13d
             call Putvalue_Table_4B
             mov  al,00d
             cmp  al,BlockClear
             jz   Line_Exit3

             mov  Point1,24d          ; Check Move  Down
             mov  Point2,25d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_D_True,al
             mov  Stop_True,00d

             mov  Point1,-1d          ; Check Move Left
             mov  Point2,11d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_L_True,al
             mov  Stop_True,00d

             mov  Point1,02d          ;  Check Move Rigth
             mov  Point2,14d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_R_True,al
             mov  Stop_True,00d

             call Calculate_display
             mov  Darkcolor,35d
             call Block_Color
             mov  Startblock,dx
 Line_Exit3: mov   ax,mid
             mov   cx,0002
        L4:  mov   Locate,ax
             call  Write_block
             add   ax,PixcelX
             loop  L4
             sub   ax,PixcelX
             sub   ax,PixcelX
             add   ax,PixcelY
             mov   cx,0002
       L5:   mov   Locate,ax
             call  Write_block
             add   ax,PixcelX
             loop  L5
             pop   cx
             pop   bx
             pop   ax
             ret
     Rectangle   endp

     L_left1   proc near         ; 000
             push ax             ;   0
             push bx
             push cx
             xor  bx,bx
             lea  dx,TableR
             mov  si,dx
             mov  al,01d
             cmp  al,CountBlock
             jnz  L_left
             dec  Xt
             dec  Xd
             inc  Yt
             inc  Yd
             mov  CountBlock,00d

   L_left:   call Calculate_Table     ; Put value in Real Table
             mov  al,Valuechk
             mov  Point1,00d
             mov  Point2,01d
             mov  Point3,02d
             mov  Point4,14d
             call Putvalue_Table_4B
             mov  al,00d
             cmp  al,BlockClear
             jz   Line_Exit4

             mov  Point1,26d          ; Check Move  Down
             mov  Point2,12d
             mov  Point3,13d
             call ChkStop_B_3
             mov  al,Stop_True
             mov  Stop_D_True,al
             mov  Stop_True,00d

             mov  Point1,-1d          ; Check Move Left
             mov  Point2,13d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_L_True,al
             mov  Stop_True,00d

             mov  Point1,03d          ;  Check Move Rigth
             call ChkStop_B_1
             mov  al,Stop_True
             mov  Stop_R_True,al
             mov  Stop_True,00d

             mov  Point1,13d          ; Check Rotate
             mov  Point2,12d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_Ro_True,al
             mov  Stop_True,00d

             call Calculate_display
             mov  Darkcolor,43d
             call Block_Color
             mov  Startblock,dx
 Line_Exit4: mov  ax,mid
             mov  cx,0003
       L6:   mov  Locate,ax
             call Write_block
             add  ax,PixcelX
             loop L6
             sub  ax,PixcelX
             add  ax,PixcelY
             mov  Locate,ax
             call Write_block
             pop  cx
             pop  bx
             pop  ax
             ret
     L_left1   endp

     L_left2   proc  near       ;   0
             push ax            ;   0
             push bx            ;  00
             push cx
             xor  bx,bx
             lea  dx,TableR
             mov  si,dx
             mov  al,72d
             cmp  al,ValueKey
             jnz  L_left_2
             mov  al,Blockclear
             cmp  al,00d
             jz   L_left_2
             inc  Xt
             inc  Xd
             dec  Yt
             dec  Yd

  L_left_2:  call Calculate_Table     ; Put value in Real Table
             mov  al,Valuechk
             mov  Point1,00d
             mov  Point2,12d
             mov  Point3,24d
             mov  Point4,23d
             call Putvalue_Table_4B
             mov  al,00d
             cmp  al,BlockClear
             jnz   Left2
             jmp  Line_Exit5

      Left2: mov  Point1,35d          ; Check Move  Down
             mov  Point2,36d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_D_True,al
             mov  Stop_True,00d

             mov  Point1,22d          ; Check Move Left
             mov  Point2,-1d               
             mov  Point3,11d
             call ChkStop_B_3
             mov  al,Stop_True
             mov  Stop_L_True,al
             mov  Stop_True,00d

             mov  Point1,01d          ; Check Move Rigth
             mov  Point2,13d
             mov  Point3,25d
             call ChkStop_B_3
             mov  al,Stop_True
             mov  Stop_R_True,al
             mov  Stop_True,00d

             mov  Point1,13d          ; Check Rotate
             mov  Point2,11d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_Ro_True,al
             mov  Stop_True,00d
             
             mov  Darkcolor,43d
             call Block_Color
             mov  Startblock,dx
             call Calculate_display
Line_Exit5:  mov  ax,mid
             mov  cx,0003
       L8:   mov  Locate,ax
             call Write_block
             add  ax,PixcelY
             loop L8
             sub  ax,PixcelY
             sub  ax,Pixcelx
             mov  Locate,ax
             call Write_block
             pop  cx
             pop  bx
             pop  ax
             ret
     L_left2   endp

     L_left3  proc near           ;  0
             push  ax             ;  000
             push  bx
             push  cx
             xor  bx,bx
             lea  dx,TableR
             mov  si,dx
             mov  al,72d
             cmp  al,ValueKey
             jnz  L_left_3
             mov  al,Blockclear
             cmp  al,00d
             jz   L_left_3
             dec  Xt
             dec  Xd

   L_left_3: call Calculate_Table     ; Put value in Real Table
             mov  al,Valuechk
             mov  Point1,00d
             mov  Point2,12d
             mov  Point3,13d
             mov  Point4,14d
             call Putvalue_Table_4B
             mov  al,00d
             cmp  al,BlockClear
             jz   Line_Exit6

             mov  Point1,24d          ; Check Move  Down
             mov  Point2,25d
             mov  Point3,26d
             call ChkStop_B_3
             mov  al,Stop_True
             mov  Stop_D_True,al
             mov  Stop_True,00d

             mov  Point1,-1d          ; Check Move Left
             mov  Point2,11d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_L_True,al
             mov  Stop_True,00d

             mov  Point1,15d          ;  Check Move Rigth
             mov  Point2,1d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_R_True,al
             mov  Stop_True,00d

             mov  Point1,25d          ; Check Rotate
             call ChkStop_B_1
             mov  al,Stop_True
             mov  Stop_Ro_True,al
             mov  Stop_True,00d

             mov  Darkcolor,43d
             call Block_Color
             mov  Startblock,dx
             call  Calculate_display
Line_Exit6:  mov   ax,mid
             mov   Locate,ax
             call  Write_block
             add   ax,PixcelY
             mov   cx,0003d
       L29:  mov   Locate,ax
             call  Write_block
             add   ax,PixcelX
             loop  L29
             pop   cx
             pop   bx
             pop   ax
             ret
     L_left3  endp

     L_left4  proc  near        ;  00
             push ax            ;  0
             push bx            ;  0
             push cx
             xor  bx,bx
             lea  dx,TableR
             mov  si,dx
             mov  al,72d
             cmp  al,ValueKey
             jnz  L_left_4
             mov  al,Blockclear
             cmp  al,00d
             jz   L_left_4
             inc  Xt
             inc  Xd

   L_left_4: call Calculate_Table     ; Put value in Real Table
             mov  al,Valuechk
             mov  Point1,00d
             mov  Point2,12d
             mov  Point3,24d
             mov  Point4,01d
             call Putvalue_Table_4B
             mov  al,00d
             cmp  al,BlockClear
             jnz  Left4
             jmp  Line_Exit7

     Left4:  mov  Point1,36d           ; Check Move  Down
             mov  Point2,13d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_D_True,al
             mov  Stop_True,00d

             mov  Point1,-1d           ; Check Move Left
             mov  Point2,11d
             mov  Point3,23d
             call ChkStop_B_3
             mov  al,Stop_True
             mov  Stop_L_True,al
             mov  Stop_True,00d

             mov  Point1,2d           ;  Check Move Rigth
             mov  Point2,13d
             mov  Point3,25d
             call ChkStop_B_3
             mov  al,Stop_True
             mov  Stop_R_True,al
             mov  Stop_True,00d

             mov  Point1,11d          ; Check Rotate
             mov  Point2,13d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_Ro_True,al
             mov  Stop_True,00d

             mov  Darkcolor,43d
             call Block_Color
             mov  Startblock,dx
             call Calculate_display
Line_Exit7:  mov  ax,mid
             mov  cx,0003
       L9:   mov  Locate,ax
             call Write_block
             add  ax,PixcelY
             loop L9
             sub  ax,PixcelY
             sub  ax,PixcelY
             sub  ax,PixcelY
             add  ax,PixcelX
             mov  Locate,ax
             call Write_block
             pop  cx
             pop  bx
             pop  ax
             ret
     L_left4  endp

     L_rigth1  proc near         ;  000
             push ax             ;  0
             push bx
             push cx
             xor  bx,bx
             lea  dx,TableR
             mov  si,dx
             mov  al,01d
             cmp  al,CountBlock
             jnz  L_rigth
             mov  al,Blockclear
             cmp  al,00d
             jz   L_rigth
             inc  Yt
             inc  Yd
             mov  CountBlock,00d

    L_rigth: call Calculate_Table     ; Put value in Real Table
             mov  al,Valuechk
             mov  Point1,00d
             mov  Point2,01d
             mov  Point3,02d
             mov  Point4,12d
             call Putvalue_Table_4B
             mov  al,00d
             cmp  al,BlockClear
             jz   Line_Exit8

             mov  Point1,24d         ; Check Move  Down
             mov  Point2,13d
             mov  Point3,14d
             call ChkStop_B_3
             mov  al,Stop_True
             mov  Stop_D_True,al
             mov  Stop_True,00d

             mov  Point1,-1d          ; Check Move Left
             mov  Point2,11d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_L_True,al
             mov  Stop_True,00d

             mov  Point1,03d          ;  Check Move Rigth
             mov  Point2,13d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_R_True,al
             mov  Stop_True,00d

             mov  Point1,13d          ; Check Rotate
             mov  Point2,14d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_Ro_True,al
             mov  Stop_True,00d

             call Calculate_display
             mov  Darkcolor,53d
             call Block_Color
             mov  Startblock,dx
Line_Exit8:  mov  ax,mid
             mov  cx,0003
       L10:  mov  Locate,ax
             call Write_block
             add  ax,PixcelX
             loop L10
             sub  ax,PixcelX
             sub  ax,PixcelX
             sub  ax,PixcelX
             add  ax,PIxcelY
             mov  Locate,ax
             call Write_block
             pop  cx
             pop  bx
             pop  ax
             ret
     L_rigth1  endp

     L_rigth2  proc near        ; 0
             push ax            ; 0
             push bx            ; 00
             push cx
             xor  bx,bx
             lea  dx,TableR
             mov  si,dx
             mov  al,72d
             cmp  al,ValueKey
             jnz  L_rigth_2
             mov  al,Blockclear
             cmp  al,00d
             jz   L_rigth_2
             inc  Xt
             inc  Xd
             dec  Yt
             dec  Yd

  L_rigth_2: call Calculate_Table     ; Put value in Real Table
             mov  al,Valuechk
             mov  Point1,00d
             mov  Point2,12d
             mov  Point3,24d
             mov  Point4,25d
             call Putvalue_Table_4B
             mov  al,00d
             cmp  al,BlockClear
             jnz  Rigth2
             jmp  Line_Exit9

    Rigth2:  mov  Point1,36d         ; Check Move  Down
             mov  Point2,37d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_D_True,al
             mov  Stop_True,00d

             mov  Point1,-1d          ; Check Move Left
             mov  Point2,11d
             mov  Point3,23d
             call ChkStop_B_3
             mov  al,Stop_True
             mov  Stop_L_True,al
             mov  Stop_True,00d

             mov  Point1,26d          ; Check Move Rigth
             mov  Point2,01d
             mov  Point3,13d
             call ChkStop_B_3
             mov  al,Stop_True
             mov  Stop_R_True,al
             mov  Stop_True,00d

             mov  Point1,11d          ; Check Rotate
             mov  Point2,13d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_Ro_True,al
             mov  Stop_True,00d

             mov  Darkcolor,53d
             call Block_Color
             mov  Startblock,dx
             call Calculate_display
Line_Exit9:  mov  ax,mid
             mov  cx,0003
       L11:  mov  Locate,ax
             call Write_block
             add  ax,PixcelY
             loop L11
             sub  ax,PixcelY
             add  ax,PixcelX
             mov  Locate,ax
             call Write_block
             pop  cx
             pop  bx
             pop  ax
             ret
     L_rigth2  endp

     L_rigth3  proc near           ;    0
             push  ax              ;  000
             push  bx
             push  cx
             xor  bx,bx
             lea  dx,TableR
             mov  si,dx
             mov  al,72d
             cmp  al,ValueKey
             jnz  L_rigth_3
             mov  al,Blockclear
             cmp  al,00d
             jz   L_rigth_3
             inc  Xt
             inc  Xd

  L_rigth_3: call Calculate_Table     ; Put value in Real Table
             mov  al,Valuechk
             mov  Point1,00d
             mov  Point2,10d
             mov  Point3,11d
             mov  Point4,12d
             call Putvalue_Table_4B
             mov  al,00d
             cmp  al,BlockClear
             jz   Line_Exit10

             mov  Point1,22d         ; Check Move  Down
             mov  Point2,23d
             mov  Point3,24d
             call ChkStop_B_3
             mov  al,Stop_True
             mov  Stop_D_True,al
             mov  Stop_True,00d

             mov  Point1,09d         ; Check Move Left
             mov  Point2,-1d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_L_True,al
             mov  Stop_True,00d

             mov  Point1,01d          ; Check Move Rigth
             mov  Point2,13d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_R_True,al
             mov  Stop_True,00d

             mov  Point1,23d          ; Check Rotate
             call ChkStop_B_1
             mov  al,Stop_True
             mov  Stop_Ro_True,al
             mov  Stop_True,00d

             mov  Darkcolor,53d
             call Block_Color
             mov  Startblock,dx
             call  Calculate_display
Line_Exit10: mov   ax,mid
             mov   Locate,ax
             call  Write_block
             add   ax,PixcelY
             sub   ax,0016d
             mov   cx,0003d
       L30:  mov   Locate,ax
             call  Write_block
             add   ax,PixcelX
             loop  L30
             pop   cx
             pop   bx
             pop   ax
             ret
     L_rigth3  endp

     L_rigth4  proc near            ; 00
             push ax                ;  0
             push bx                ;  0
             push cx
             xor  bx,bx
             lea  dx,TableR
             mov  si,dx
             mov  al,72d
             cmp  al,ValueKey
             jnz  L_rigth_4
             mov  al,Blockclear
             cmp  al,00d
             jz   L_rigth_4
             dec  Xt
             dec  Xt
             dec  Xd
             dec  Xd
  L_rigth_4: call Calculate_Table     ; Put value in Real Table
             mov  al,Valuechk
             mov  Point1,00d
             mov  Point2,01d
             mov  Point3,13d
             mov  Point4,25d
             call Putvalue_Table_4B
             mov  al,00d
             cmp  al,BlockClear
             jnz   Rigth4
             jmp  Line_Exit11

     Rigth4: mov  Point1,37d            ; Check Move Down
             mov  Point2,12d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_D_True,al
             mov  Stop_True,00d

             mov  Point1,-1d            ; Check Move Left
             mov  Point2,12d
             mov  Point3,24d
             call ChkStop_B_3
             mov  al,Stop_True
             mov  Stop_L_True,al
             mov  Stop_True,00d

             mov  Point1,02d            ; Check Move Rigth
             mov  Point2,14d
             mov  Point3,26d
             call ChkStop_B_3
             mov  al,Stop_True
             mov  Stop_R_True,al
             mov  Stop_True,00d

             mov  Point1,14d             ; Check Rotate
             mov  Point2,12d
             call ChkStop_B_2
             mov  al,Stop_True
             mov  Stop_Ro_True,al
             mov  Stop_True,00d

             mov  Darkcolor,53d
             call Block_Color
             mov  Startblock,dx
             call Calculate_display
Line_Exit11: mov  ax,mid
             mov  Locate,ax
             call Write_block
             add  ax,PixcelX
             mov  cx,0003
       L12:  mov  Locate,ax
             call Write_block
             add  ax,PixcelY
             loop L12
             pop  cx
             pop  bx
             pop  ax
             ret
     L_rigth4  endp

    T_connect1  proc near        ;  000
            push  ax             ;   0
            push  bx
            push  cx
            xor  bx,bx
            lea  dx,TableR
            mov  si,dx
            mov  al,01d
            cmp  al,CountBlock
            jnz  T_connect
            dec  Xt
            dec  Xd
            inc  Yt
            inc  Yd
            mov  CountBlock,00d

 T_Connect: call Calculate_Table     ; Put value in Real Table
            mov  al,Valuechk
            mov  Point1,00d
            mov  Point2,01d
            mov  Point3,02d
            mov  Point4,13d
            call Putvalue_Table_4B
            mov  al,00d
            cmp  al,BlockClear
            jz   Line_Exit12

            mov  Point1,25d           ; Check Move  Down
            mov  Point2,12d
            mov  Point3,14d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_D_True,al
            mov  Stop_True,00d

            mov  Point1,-1d          ; Check Move Left
            mov  Point2,12d
            call ChkStop_B_2
            mov  al,Stop_True
            mov  Stop_L_True,al
            mov  Stop_True,00d

            mov  Point1,03d          ;  Check Move Rigth
            mov  Point2,14d
            call ChkStop_B_2
            mov  al,Stop_True
            mov  Stop_R_True,al
            mov  Stop_True,00d
            mov  Stop_Ro_True,00h

            call  Calculate_display
            mov  Darkcolor,37d
            call Block_Color
            mov  Startblock,dx
Line_Exit12:mov   ax,mid
            mov   cx,0003
       L13: mov   Locate,ax
            call  Write_block
            add   ax,PixcelX
            loop  L13
            sub   ax,PixcelX
            sub   ax,PixcelX
            add   ax,PixcelY
            mov   Locate,ax
            call  Write_block
            pop   cx
            pop   bx
            pop   ax
            ret
    T_connect1  endp

    T_connect2  proc near       ;    0
            push  ax            ;    00
            push  bx            ;    0
            push  cx            
            xor  bx,bx
            lea  dx,TableR
            mov  si,dx
            mov  al,72d
            cmp  al,ValueKey
            jnz  T_connect_2
            mov  al,Blockclear
            cmp  al,00d
            jz   T_connect_2
            inc  Xt
            inc  Xd
            dec  Yt
            dec  Yd

T_connect_2:call Calculate_Table     ; Put value in Real Table
            mov  al,Valuechk
            mov  Point1,00d
            mov  Point2,12d
            mov  Point3,13d
            mov  Point4,24d
            call Putvalue_Table_4B
            mov  al,00d
            cmp  al,BlockClear
            jz   Line_Exit13

            mov  Point1,36d           ; Check Move  Down
            mov  Point2,25d
            call ChkStop_B_2
            mov  al,Stop_True
            mov  Stop_D_True,al
            mov  Stop_True,00d

            mov  Point1,-1d            ; Check Move Left
            mov  Point2,11d
            mov  Point3,23d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_L_True,al
            mov  Stop_True,00d

            mov  Point1,14d            ; Check Move Rigth
            mov  Point2,01d
            mov  Point3,25d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_R_True,al
            mov  Stop_True,00d

            mov  Point1,11d            ; Check Rotate
            call ChkStop_B_1
            mov  al,Stop_True
            mov  Stop_Ro_True,al
            mov  Stop_True,00d

            mov  Darkcolor,37d
            call Block_Color
            mov  Startblock,dx
            call  Calculate_display
Line_Exit13:mov   ax,mid
            mov   cx,0003
       L14: mov   Locate,ax
            call  Write_block
            add   ax,PixcelY
            loop  L14
            sub   ax,PixcelY
            sub   ax,PixcelY
            add   ax,PixcelX
            mov   Locate,ax
            call  Write_block
            pop   cx
            pop   bx
            pop   ax
            ret
    T_connect2  endp
   

    T_connect3  proc near       ;   0
            push  ax            ;  000
            push  bx
            push  cx
            xor  bx,bx
            lea  dx,TableR
            mov  si,dx

            call Calculate_Table     ; Put value in Real Table
            mov  al,Valuechk
            mov  Point1,00d
            mov  Point2,11d
            mov  Point3,12d
            mov  Point4,13d
            call Putvalue_Table_4B
            mov  al,00d
            cmp  al,BlockClear
            jz   Line_Exit14

            mov  Point1,23d          ; Check Move  Down
            mov  Point2,24d
            mov  Point3,25d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_D_True,al
            mov  Stop_True,00d

            mov  Point1,10d          ; Check Move Left
            mov  Point2,-1d
            call ChkStop_B_2
            mov  al,Stop_True
            mov  Stop_L_True,al
            mov  Stop_True,00d

            mov  Point1,14d          ; Check Move Rigth
            mov  Point2,01d
            call ChkStop_B_2
            mov  al,Stop_True
            mov  Stop_R_True,al
            mov  Stop_True,00d

            mov  Point1,24d          ; Check Rotate
            call ChkStop_B_1
            mov  al,Stop_True
            mov  Stop_Ro_True,al
            mov  Stop_True,00d

            mov  Darkcolor,37d
            call Block_Color
            mov  Startblock,dx
            call Calculate_display
Line_Exit14:mov   ax,mid
            mov   Locate,ax
            call  Write_block
            sub   ax,PixcelX
            add   ax,PixcelY
            mov   cx,0003
       L15: mov   Locate,ax
            call  Write_block
            add   ax,PixcelX
            loop  L15
            pop   cx
            pop   bx
            pop   ax
            ret
    T_connect3  endp


    T_connect4  proc near        ;  0
            push  ax             ; 00
            push  bx             ;  0
            push  cx             
            xor  bx,bx
            lea  dx,TableR
            mov  si,dx
            call Calculate_Table     ; Put value in Real Table
            mov  al,Valuechk
            mov  Point1,00d
            mov  Point2,11d
            mov  Point3,12d
            mov  Point4,24d
            call Putvalue_Table_4B
            mov  al,00d
            cmp  al,BlockClear
            jz   Line_Exit15

            mov  Point1,36d          ; Check Move  Down
            mov  Point2,23d
            call ChkStop_B_2
            mov  al,Stop_True
            mov  Stop_D_True,al
            mov  Stop_True,00d

            mov  Point1,10d          ; Check Move Left
            mov  Point2,-1d
            mov  Point3,23d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_L_True,al
            mov  Stop_True,00d

            mov  Point1,01d          ;  Check Move Rigth
            mov  Point2,13d
            mov  Point3,25d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_R_True,al
            mov  Stop_True,00d

            mov  Point1,13d          ; Check Rotate
            call ChkStop_B_1
            mov  al,Stop_True
            mov  Stop_Ro_True,al
            mov  Stop_True,00d

            mov  Darkcolor,37d
            call Block_Color
            mov  Startblock,dx
            call  Calculate_display
Line_Exit15:mov   ax,mid
            mov   cx,0003
       L16: mov   Locate,ax
            call  Write_block
            add   ax,PixcelY
            loop  L16
            sub   ax,PixcelY
            sub   ax,PixcelY
            sub   ax,PixcelX
            mov   Locate,ax
            call  Write_block
            pop   cx
            pop   bx
            pop   ax
            ret
    T_connect4  endp

    Z_left1  proc near               ;  00  
            push  ax                 ; 00  
            push  bx
            push  cx
            xor  bx,bx
            lea  dx,TableR
            mov  si,dx
            call Calculate_Table     ; Put value in Real Table
            mov  al,Valuechk
            mov  Point1,00d
            mov  Point2,01d
            mov  Point3,11d
            mov  Point4,12d
            call Putvalue_Table_4B
            mov  al,00d
            cmp  al,BlockClear
            jz   Line_Exit16

            mov  Point1,23d          ; Check Move  Down
            mov  Point2,24d
            mov  Point3,13d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_D_True,al
            mov  Stop_True,00d

            mov  Point1,10d          ; Check Move Left
            mov  Point2,-1d
            call ChkStop_B_2
            mov  al,Stop_True
            mov  Stop_L_True,al
            mov  Stop_True,00d

            mov  Point1,02d          ;  Check Move Rigth
            mov  Point2,13d
            call ChkStop_B_2
            mov  al,Stop_True
            mov  Stop_R_True,al
            mov  Stop_True,00d

            mov  Point1,24d          ; Check Rotate
            call ChkStop_B_1
            mov  al,Stop_True
            mov  Stop_Ro_True,al
            mov  Stop_True,00d

            call  Calculate_display
            mov  Darkcolor,32d
            call Block_Color
            mov  Startblock,dx
Line_Exit16:mov   ax,mid
            mov   cx,0002
       L17: mov   Locate,ax
            call  Write_block
            add   ax,PixcelX
            loop  L17
            sub   ax,PixcelX
            sub   ax,PixcelX
            sub   ax,PixcelX
            add   ax,PixcelY
            mov   cx,0002
       L18: mov   Locate,ax
            call  Write_block
            add   ax,PixcelX
            loop  L18
            pop   cx
            pop   bx
            pop   ax
            ret
    Z_left1  endp

    Z_left2  proc near            ; 0 
            push  ax              ; 00
            push  bx              ;  0
            push  cx              
            xor  bx,bx
            lea  dx,TableR
            mov  si,dx
            call Calculate_Table     ; Put value in Real Table
            mov  al,Valuechk
            mov  Point1,00d
            mov  Point2,12d
            mov  Point3,13d
            mov  Point4,25d
            call Putvalue_Table_4B
            mov  al,00d
            cmp  al,BlockClear
            jnz  Z_left
            jmp  Line_Exit17

    Z_left: mov  Point1,37d         ; Check Move  Down
            mov  Point2,24d
            call ChkStop_B_2
            mov  al,Stop_True
            mov  Stop_D_True,al
            mov  Stop_True,00d

            mov  Point1,-1d          ; Check Move Left
            mov  Point2,11d
            mov  Point3,24d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_L_True,al
            mov  Stop_True,00d

            mov  Point1,14d          ; Check Move Rigth
            mov  Point2,26d
            mov  Point3,01d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_R_True,al
            mov  Stop_True,00d

            mov  Point1,14d          ; Check Rotate
            mov  Point2,14d
            mov  Point3,23d
            call ChkStop_Ro_3
            mov  al,Stop_True
            mov  Stop_Ro_True,al
            mov  Stop_True,00d

            mov  Darkcolor,32d
            call Block_Color
            mov  Startblock,dx
            call  Calculate_display
Line_Exit17:mov   ax,mid
            mov   cx,0002d
       L19: mov   Locate,ax
            call  Write_block
            add   ax,PixcelY
            loop  L19
            sub   ax,PixcelY
            add   ax,PixcelX
            mov   cx,0002
       L20: mov   Locate,ax
            call  Write_block
            add   ax,PixcelY
            loop  L20
            pop   cx
            pop   bx
            pop   ax
            ret
    Z_left2  endp

    Z_rigth1  proc near           ;  00
            push  ax              ;   00
            push  bx
            push  cx
            xor  bx,bx
            lea  dx,TableR
            mov  si,dx
            mov  al,01d
            cmp  al,CountBlock
            jnz  Z_rigth
            dec  Xt
            dec  Xd
            mov  CountBlock,00d

  Z_rigth:  call Calculate_Table     ; Put value in Real Table
            mov  al,Valuechk
            mov  Point1,00d
            mov  Point2,01d
            mov  Point3,13d
            mov  Point4,14d
            call Putvalue_Table_4B
            mov  al,00d
            cmp  al,BlockClear
            jz   Line_Exit18

            mov  Point1,25d          ; Check Move  Down
            mov  Point2,26d
            mov  Point3,12d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_D_True,al
            mov  Stop_True,00d

            mov  Point1,-1d          ; Check Move Left
            mov  Point2,12d
            call ChkStop_B_2
            mov  al,Stop_True
            mov  Stop_L_True,al
            mov  Stop_True,00d

            mov  Point1,15d          ; Check Move Rigth
            mov  Point2,02d
            call ChkStop_B_2
            mov  al,Stop_True
            mov  Stop_R_True,al
            mov  Stop_True,00d

            mov  Point1,24d         ; Check Rotate
            call ChkStop_B_1
            mov  al,Stop_True
            mov  Stop_Ro_True,al
            mov  Stop_True,00d

            call  Calculate_display
            mov  Darkcolor,16d
            call Block_Color
            mov  Startblock,dx
Line_Exit18:mov   ax,mid
            mov   cx,0002
       L21: mov   Locate,ax
            call  Write_block
            add   ax,PixcelX
            loop  L21
            sub   ax,PixcelX
            add   ax,PixcelY
            mov   cx,0002
       L22: mov   Locate,ax
            call  Write_block
            add   ax,PixcelX
            loop  L22
            pop   cx
            pop   bx
            pop   ax
            ret
    Z_rigth1  endp

    Z_rigth2  proc near         ;   0
            push  ax            ;  00
            push  bx            ;  0
            push  cx            
            xor  bx,bx
            lea  dx,TableR
            mov  si,dx
            mov  al,72
            cmp  al,ValueKey
            jnz  Z_rigth_2
            mov  al,Blockclear
            cmp  al,00d
            jz   Z_rigth_2
            inc  Xt
            inc  Xd

 Z_rigth_2: call Calculate_Table     ; Put value in Real Table
            mov  al,Valuechk
            mov  Point1,00d
            mov  Point2,11d
            mov  Point3,12d
            mov  Point4,23d
            call Putvalue_Table_4B
            mov  al,00d
            cmp  al,BlockClear
            jnz  Z
            jmp  Line_Exit19

        Z:  mov  Point1,35d          ; Check Move  Down
            mov  Point2,24d
            call ChkStop_B_2
            mov  al,Stop_True
            mov  Stop_D_True,al
            mov  Stop_True,00d
                          
            mov  Point1,10d          ; Check Move Left
            mov  Point2,22d
            mov  Point3,-1
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_L_True,al
            mov  Stop_True,00d

            mov  Point1,01d          ; Check Move Rigth
            mov  Point2,13d
            mov  Point3,24d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_R_True,al
            mov  Stop_True,00d

            mov  Point1,01d         ; Check Rotate
            mov  Point2,10d
            call ChkStop_B_2
            mov  al,Stop_True
            mov  Stop_Ro_True,al
            mov  Stop_True,00d

            mov  Darkcolor,16d
            call Block_Color
            mov  Startblock,dx
            call  Calculate_display

Line_Exit19:mov   ax,mid
            mov   cx,0002
       L23: mov   Locate,ax
            call  Write_block
            add   ax,PixcelY
            loop  L23
            sub   ax,PixcelY
            sub   ax,PixcelX
            mov   cx,0002
       L24: mov   Locate,ax
            call  Write_block
            add   ax,PixcelY
            loop  L24
            pop   cx
            pop   bx
            pop   ax
            ret
    Z_rigth2  endp

    Block_Alone proc near   ; 0
            push  ax
            push  bx
            push  cx
            xor  bx,bx
            lea  dx,TableR
            mov  si,dx
            call Calculate_Table     ; Put value in Real Table
            mov  al,Valuechk
            mov  Point1,00d
            call Putvalue_Table_1B
            mov  al,00d
            cmp  al,BlockClear
            jz   Line_Exit20

            mov  Point1,12d          ; Check Move  Down
            call ChkStop_B_1
            mov  al,Stop_True
            mov  Stop_D_True,al
            mov  Stop_True,00d
                          
            mov  Point1,-1d          ; Check Move Left
            call ChkStop_B_1
            mov  al,Stop_True
            mov  Stop_L_True,al
            mov  Stop_True,00d

            mov  Point1,01d          ;  Check Move Rigth
            call ChkStop_B_1
            mov  al,Stop_True
            mov  Stop_R_True,al
            mov  Stop_True,00d

            call  Calculate_display
            mov  Darkcolor,43d
            call Block_Color
            mov  Startblock,dx
Line_Exit20:mov   ax,mid
            mov   Locate,ax
            call  Write_Block
            pop   cx
            pop   bx
            pop   ax
            ret
    Block_Alone endp

    Cross   proc  near          ;   0
            push  ax            ;  000
            push  bx            ;   0
            push  cx
            xor  bx,bx
            lea  dx,TableR
            mov  si,dx
            call Calculate_Table     ; Put value in Real Table
            mov  al,Valuechk
            mov  Point1,00d
            mov  Point2,11d
            mov  Point3,12d
            mov  Point4,13d
            mov  Point5,24d
            call Putvalue_Table_5B
            mov  al,00d
            cmp  al,BlockClear
            jz   Line_Exit21

            mov  Point1,36d          ; Check Move  Down
            mov  Point2,23d
            mov  Point3,25d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_D_True,al
            mov  Stop_True,00d

            mov  Point1,10d          ; Check Move Left
            mov  Point2,-1d
            mov  Point3,23d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_L_True,al
            mov  Stop_True,00d

            mov  Point1,14d          ;  Check Move Rigth
            mov  Point2,1d
            mov  Point3,25d
            call ChkStop_B_3
            mov  al,Stop_True
            mov  Stop_R_True,al
            mov  Stop_True,00d

            call  Calculate_display
            mov  Darkcolor,32d
            call Block_Color
            mov  Startblock,dx
Line_Exit21:mov   ax,mid
            mov   Locate,ax
            call  Write_block
            sub   ax,PixcelX
            add   ax,PixcelY
            mov   cx,0003d
      L31:  mov   Locate,ax
            call  Write_block
            add   ax,PixcelX
            loop  L31
            sub   ax,0016d
            add   ax,PixcelY
            mov   Locate,ax
            call  Write_block
            pop   cx
            pop   bx
            pop   ax
            ret
    Cross   endp

 ; -------------------  Random  Block ----------------------
   Get_Time proc near          ; Function Get time form Computer
            push  ax
            push  cx
            push  dx
            mov   ax,2c00h
            int   21h
            mov   Time,dl      ; put sec in Time
            pop   dx
            pop   cx
            pop   ax
            ret
   Get_Time endp

  Random_Block   proc near     ; Function Random Block to  Display
                 push ax
                 call Get_Time ; Call Function Get Time
                 mov  al,89d   ; if 99 > al > 89 then Select Block Alone
                 cmp  Time,al
                 jg   Set_Block_Alone
                 mov  al,79d   ; if 89 > al > 79 then Select Block Cross
                 cmp  Time,al
                 jg   Set_Cross
                 mov  al,69d   ; if 79 > al > 69 then Select Block Line
                 cmp  Time,al
                 jg   Set_Line
                 mov  al,59d   ; if 69 > al > 59 then Select Block Rectangle
                 cmp  Time,al                                    
                 jg   Set_Rectangle
                 mov  al,49d   ; if 59 > al > 49 then Select Block L_left
                 cmp  Time,al
                 jg   Set_L_left
                 mov  al,39d   ; if 49 > al > 39 then Select Block L_rigth
                 cmp  Time,al
                 jg   Set_L_rigth
                 mov  al,29d   ; if 39 > al > 29 then Select Block T_connect
                 cmp  Time,al
                 jg   Set_T_connect
                 mov  al,17d   ; if 29 > al >17 then  Select Block Z_left
                 cmp  Time,al
                 jg   Set_Z_left
                 mov  al,00d   ; if 17 > al > 00 then Select Block Z_rigth
                 cmp  Time,al
                 jg   Set_Z_rigth

Set_Block_Alone: mov  Set_Block,01d      ; 1 item
                 jmp  Random_Exit
      Set_Cross: mov  Set_Block,02d      ; 1 item
                 jmp  Random_Exit
       Set_Line: mov  Set_Block,03d      ; 2 item
                 jmp  Random_Exit
  Set_Rectangle: mov  Set_Block,04d      ; 1 item
                 jmp  Random_Exit
     Set_L_left: mov  Set_Block,05d      ; 4 item
                 jmp  Random_Exit
    Set_L_rigth: mov  Set_Block,06d      ; 4 item
                 jmp  Random_Exit
  Set_T_connect: mov  Set_Block,07d      ; 4 item
                 jmp  Random_Exit
     Set_Z_left: mov  Set_Block,08d      ; 2 item
                 jmp  Random_Exit
    Set_Z_rigth: mov  Set_Block,09d      ; 2 item

Random_Exit:    pop  ax
                ret
   Random_Block   endp

   Ini_Block  proc near       ; Function Initail Position Start Show to
            push ax           ; Display
            mov  al,01d       ; Variable Xt put value Position X in Table
            cmp  al,Set_Block ; Variable Number_B put value Number of Block
            jz   ini_Block1   ; Variable Many_Block put value Many of Block
            mov  al,02d       ; Variable Count_NB  put value Count Number 
            cmp  al,Set_Block ; Block
            jz   ini_Block2
            mov  al,03d
            cmp  al,Set_Block
            jz   ini_Block3
            mov  al,04d
            cmp  al,Set_Block
            jz   ini_Block4
            mov  al,05d
            cmp  al,Set_Block
            jz   Help_jmp_Ini4
            mov  al,06d
            cmp  al,Set_Block
            jz   Help_jmp_Ini3
            mov  al,07d
            cmp  al,Set_Block
            jz   Help_jmp_Ini1
            mov  al,08d
            cmp  al,Set_block
            jz   Help_jmp_Ini2

            mov  Xt,05d       ; ini_Block9
            mov  Number_B,20d
            mov  Many_Block,02d
            mov  Count_NB,20d
            jmp  Ini_Exit 

Help_jmp_Ini1: jmp ini_Block7
Help_jmp_Ini2: jmp ini_Block8
Help_jmp_Ini3: jmp ini_Block6
Help_jmp_Ini4: jmp ini_Block5

ini_Block1: mov  Xt,05d
            mov  Number_B,01d
            mov  Many_Block,01d
            jmp  Ini_Exit
ini_Block2: mov  Xt,05d
            mov  Number_B,02d
            mov  Many_Block,01d
            jmp  Ini_Exit
ini_Block3: mov  Xt,05d
            mov  Number_B,03d
            mov  Many_Block,02d
            mov  Count_NB,03d
            jmp  Ini_Exit
ini_Block4: mov  Xt,05d
            mov  Number_B,05d
            mov  Many_Block,01d
            jmp  Ini_Exit
ini_Block5: mov  Xt,05d
            mov  Number_B,06d
            mov  Many_Block,04d
            mov  Count_NB,06d
            jmp  Ini_Exit
ini_Block6: mov  Xt,05d
            mov  Number_B,10d
            mov  Many_Block,04d
            mov  Count_NB,10d
            jmp  Ini_Exit
ini_Block7: mov  Xt,05d
            mov  Number_B,14d
            mov  Many_Block,04d
            mov  Count_NB,14d
            jmp  Ini_Exit
ini_Block8: mov  Xt,05d
            mov  Number_B,18d
            mov  Many_Block,02d
            mov  Count_NB,18d
 Ini_Exit:  mov Yt,01d
            pop  ax
            ret
   Ini_Block  endp

   Select_Block  proc near
            push ax
            mov  al,01d
            cmp  al,Number_B
            jnz   S_B1
            call  Block_Alone
            jmp   S_exit
      S_B1: mov   al,02d
            cmp   al,Number_B
            jnz   S_B2
            call  Cross
            jmp   S_exit
      S_B2: mov   al,03d
            cmp   al,Number_B
            jnz   S_B3
            call  Line_hor
            jmp   S_exit
      S_B3: mov   al,04d
            cmp   al,Number_B
            jnz   S_B4
            call  Line_ver
            jmp   S_exit
      S_B4: mov  al,05d
            cmp  al,Number_B
            jnz   S_B5
            call  Rectangle
            jmp   S_exit
      S_B5: mov   al,06d
            cmp   al,Number_B
            jnz   S_B6
            call  L_left1
            jmp   S_exit
      S_B6: mov   al,07d
            cmp   al,Number_B
            jnz   S_B7
            call  L_left2
            jmp   S_exit
      S_B7: mov   al,08d
            cmp   al,Number_B
            jnz   S_B8
            call  L_left3
            jmp   S_exit
      S_B8: mov  al,09d
            cmp  al,Number_B
            jnz   S_B9
            call  L_left4
            jmp   S_exit
      S_B9: mov   al,10d
            cmp   al,Number_B
            jnz   S_B10
            call  L_rigth1
            jmp   S_exit
     S_B10: mov   al,11d
            cmp   al,Number_B
            jnz   S_B11
            call  L_rigth2
            jmp   S_exit
     S_B11: mov   al,12d
            cmp   al,Number_B
            jnz   S_B12
            call  L_rigth3
            jmp   S_exit
     S_B12: mov  al,13d
            cmp  al,Number_B
            jnz   S_B13
            call  L_rigth4
            jmp   S_exit
     S_B13: mov   al,14d
            cmp   al,Number_B
            jnz   S_B14
            call  T_connect1
            jmp   S_exit
     S_B14: mov   al,15d
            cmp   al,Number_B
            jnz   S_B15
            call  T_connect2
            jmp   S_exit
     S_B15: mov   al,16d
            cmp   al,Number_B
            jnz   S_B16
            call  T_connect3
            jmp   S_exit
     S_B16: mov   al,17d
            cmp   al,Number_B
            jnz   S_B17
            call  T_connect4
            jmp   S_exit
     S_B17: mov   al,18d
            cmp   al,Number_B
            jnz   S_B18
            call  Z_left1
            jmp   S_exit
     S_B18: mov  al,19d
            cmp  al,Number_B
            jnz   S_B19
            call  Z_left2
            jmp   S_exit
     S_B19: mov   al,20d
            cmp   al,Number_B
            jnz   S_B20
            call  Z_rigth1
            jmp   S_exit
     S_B20: call  Z_rigth2

    S_Exit:  pop  ax
              ret
   Select_Block  endp

 ; ------------------- Cut Line ----------------------------

    Get_line_Table   proc near    ; Function get Line For Cut in TableR
                    push ax
                    push bx
                    push cx
                    push dx
                    push si
                    push di
                    mov  ax,ds     ; Put data segment to ax
                    mov  es,ax     ; Put es <-- ax
                    mov  bx,241d
                    xor  ax,ax
                    mov  al,20d
                    lea  dx,Number_line ; dx point offset Number_line

           Chk1:    lea  si,TableR      ; si point offset TableR
                    add  si,bx
                    mov  cx,10d
                    lea  di,Chk_line    ; di point offset Chk_line
                    cld                 ; Clear direction Flag
                    repe cmpsb          ; Compar String Byte Between si , di
                    jne  Chk2           ; if si <> di then goto  Chk2 
                    push si             ; else  put al in Number_line
                    mov  si,dx
                    mov  [si],al
                    inc  dx
                    pop  si
           Chk2:    sub  bx,12d
                    dec  ax
                    cmp  al,00d
                    jnz  Chk1

                    mov  ax,0A000h
                    mov  es,ax
                    pop  di
                    pop  si                            
                    pop  dx
                    pop  cx
                    pop  bx
                    pop  ax
                    ret
   Get_line_Table   endp

   Cut_line_TableR  proc near    ; Function Cut line in TableR
                    push ax
                    push bx
                    push cx
                    push dx
                    push di
                    push si
                    mov ax,ds   ; put data segment to ax 
                    mov es,ax   ; put es <-- ax
                    
                    lea  si,Number_line  ; si point offset Number_line
                    inc  si              ; si = si + 1
                    mov  dh,01d          ; put dh <-- 01d

          Cut_T_5:  mov  al,[si]         ; if [si] = 0 then goto Cut_T_4
                    cmp  al,00d          ; Else put [si] <--  al+ dh
                    jz   Cut_T_4
                    add  al,dh           ; al = al + ah
                    inc  dh              ; dh = dh + 1
                    mov  [si],al
                    inc  si
                    jmp  Cut_T_5        ; goto Cut_T_5

           Cut_T_4: xor  ax,ax           ; Clear ax to 0000
                    lea  si,Number_line  ; si point offset Number_line
                    dec  si

           Cut_T_2: inc  si             ; if [si] = 00 then Goto Cut_T_Exit
                    mov  al,[si]        ; Else Next line
                    cmp  al,00d
                    jz   Cut_T_exit

                    mov  dl,al          ; al <-- ( al * 12 ) + 1  
                    mov  bl,12d
                    mul  bl
                    add  al,01d
                                                                                                                                                                                             lea  di,TableR
                    Add  di,ax          ; di <-- di + ax

          Cut_T_1:  dec  dl
                    cmp  dl,0001d       ; if dl = 01 then goto Cut_T_2
                    jz   Cut_T_2        ; Else Next line
                    push si
                    mov  cx,0010d       ; Initail cx = 10d
                    mov  si,di
                    sub  si,0012d       ; si <-- di - 12d
                    cld                 ; Clear direction Flag
                    rep  movsb          ; Move String Byte
                    sub  di,22d         ; di <-- di - 22d
                    pop  si
                    jmp  Cut_T_1        ; Goto Cut_T_1

     Cut_T_exit:    mov  ax,0A000h      ; Put ax,0A000h
                    mov  es,ax          ; Put es <-- ax
                    lea  si,TableR      ; si point offset TableR
                    add  si,13d
                    mov  cx,10d
                    mov  al,00d
           Cut_T_3: mov  [si],al       ; Clear  line 1  in TableR
                    inc   si
                    loop  Cut_T_3      ; Goto Cut_T_3

                    pop  si
                    pop  di
                    pop  dx
                    pop  cx
                    pop  bx
                    pop  ax
                    ret
   Cut_line_TableR  endp

   Cut_line_Display  proc near
                     push ax
                     push bx
                     push cx
                     push dx
                     push di
                     push si

                     mov  ax,0A000h        ; put ax <-- 0A000h
                     mov  es,ax            ; put es <-- ax
                     lea  si,Number_line   ; si point Number line
                     dec  si

            Cut_D_1: inc  si               ; if [si] = 00 then goto 
                     mov  al,[si]          ; Cut_D_Exit
                     mov  bl,al
                     cmp  al,00d
                     jz   Cut_D_exit
          
          ;---------------------------------------------
                    push ax
                    push bx
                    mov  bx,Score     ; Add Score   30d
                    add  bx,30d
                    mov  Score,bx
                    mov  ax,bx
                    mov  X,75d
                    mov  Y,07d
                    call Print_Num
                    mov  Hz,0500d
                    call Sound       ; Sound to SpK
                    pop  bx
                    pop  ax
         ;-----------------------------------------------

                     sub  al,01d
                     mov  bh,08d
                     mul  bh
                     mov  Counter,al       

                     mov  ax,00d
                     mov  al,bl
                     mov  bx,2560d
                     mul  bx
                     add  ax,5240d
                     sub  ax,320d
                     mov  di,ax
                     mov  dh,Counter

                     push si
                     mov  ax,0A000h     ; put ax <-- 0A000h
                     mov  ds,ax         ; put data segment <-- ax
          Cut_D_2:   mov  si,di         ; put si <-- si
                     sub  si,2560d      ; si = si - 2560d
                     mov  cx,80d        ; Initail cx <-- 80d
                     cld                ; Clear direction Flag
                     rep  movsb         ; Move String Byty
                     sub  di,320d       ; di = di - 320d
                     sub  di,80d        ; di = di - 80d
                     dec  dh            
                     cmp  dh,00d
                     jnz  Cut_D_2       ; if Dh <>  00d then Goto Cut_D_2
                     pop  si
                     mov  ax,datasg     ; put ax <-- Data segment
                     mov  ds,ax         ; put ds <-- ax
                     jmp  Cut_D_1       ; goto Cut_D_1

         Cut_D_exit: call Clear_Number_line   ; Call Function ClaerNumberline

                     pop  si
                     pop  di
                     pop  dx
                     pop  cx
                     pop  bx
                     pop  ax
                     ret
   Cut_line_Display  endp

   Clear_Number_line proc near    ; Function Clear Number Line to 00d
                     push ax
                     push cx
                     push si
                     mov  cx,05d      ; Initail cx <-- 05d
                     mov  al,00d      ; Put al <-- 00d
                     lea  si,Number_line  ; si point offset Number_line
            Clear:   mov  [si],al         ; [si] <-- al
                     inc   si
                     loop  Clear
                     pop  si
                     pop  cx
                     pop  ax
                     ret
   Clear_Number_line endp

 ; ---------------  Print Number  and Text ---------------

    print_char      proc near     ; Function Print Charecter to Display
                    push ax
                    push bx
                    push cx
                    call set_cursor
                    call attribute
                    mov  al,dl
                    mov  bh,00d
                    mov  bl,14d
                    mov  cx,01d
                    mov  ah,09h
                    int 10h
                    pop  cx
                    pop  bx
                    pop  ax
                    ret
    print_char      endp

    print_num      proc near     ; Function Print Number to Display
                   push ax
                   push bx
                   push cx
                   push dx
                   push si
                   mov  si,10d    ; conver to decimal
                   mov  cx,0
           print2: mov  dx,0
                   div  si
                   push dx
                   inc  cx
                   or   ax,ax
                   jne  print2

                   mov  bl,X
                   cmp  cx,02d
                   jnz  p1
                   sub  bl,02
                   mov  X,bl
                   jmp  print3
               p1: cmp  cx,03d
                   jnz  p2
                   sub  bl,03d
                   mov  X,bl
                   jmp  print3
               p2: cmp  cx,04d
                   jnz  p3
                   sub  bl,04d
                   mov  X,bl
                   jmp  print3
               p3: dec  X

           print3: pop dx
                   add dl,'0'
                   call print_char
                   inc  X
                   loop print3
                   pop si
                   pop dx
                   pop cx
                   pop bx
                   pop ax
                   ret
   print_num       endp

   display_string  proc nare    ; Function Print String to Display
                   push ax
                   push bx
                   push cx
                   push dx
                   mov  si,dx
                   mov  ah,0ah
                   mov  bh,00
                   mov  cx,01
            D_St:  mov  dl,[si]
                   cmp  dl,'$'
                   jz   St_exit  
                   call Print_Char
                   inc  si
                   inc  X
                   jmp  D_St
        St_exit:   pop  dx
                   pop  cx
                   pop  bx
                   pop  ax
                   ret
     display_string  endp

     attribute  proc near        ; Function Initail attribute of Charecter
            push ax
            push bx
            push cx
            push dx
            mov ah,09
            mov al,[si]
            mov bh,00
            mov bl,14d
            mov cx,01
            int 10h
            pop dx
            pop cx
            pop bx
            pop ax
            ret
     attribute  endp

     set_cursor  proc near     ; Function Set Position to Print Number or
            push ax            ; Charecter
            push bx
            push dx
            mov  ah,02
            mov  bh,00
            mov  dh,y
            mov  dl,x
            int  10h
            pop  dx
            pop  bx
            pop  ax
            ret
    set_cursor endp



 ; -------------------  Ini Level ------------------------------
       Level  proc near     ; Function Initail Level
              push ax
              push bx
              push dx
              mov  ax,Score        ; put ax <-- Score

              cmp  ax,3000d        ; if  ax < 3000d then Level 1
              jg   Le1
              mov  Time_Count,15d
              mov  Level_Count,'1'
              jmp  Level_Exit
         Le1: cmp  ax,6000d        ; if ax < 6000d then Level 2
              jg   Le2
              mov  Time_Count,13d
              mov  Level_Count,'2'
              jmp  Level_Exit
         Le2: cmp  ax,9000d
              jg   Le3            ; if ax < 9000d then Level 3
              mov  Time_Count,10d
              mov  Level_Count,'3'
              jmp  Level_Exit 
         Le3: cmp  ax,15000d      ; if ax <15000d then Level 4
              jg   Le4
              mov  Time_Count,08d
              mov  Level_Count,'4'
              jmp  Level_Exit 
         Le4: cmp  ax,25000d      ; if ax < 25000d then Level 5
              jg   Le5
              mov  Time_Count,06d
              mov  Level_Count,'5'
              jmp  Level_Exit 
         Le5: cmp  ax,35000d     ; if ax <  35000d then Level 6
              jg   Le6
              mov  Time_Count,02d
              mov  Level_Count,'6'
              jmp  Level_Exit
         Le6: mov  Time_Count,01d  ; if ax < 65000d then Level 7
              mov  Level_Count,'7'

      ;  ----------------------------------------------
  Level_Exit: mov  dl,Level_Count     ; Display Level  
              mov  X,72d
              mov  Y,16d
              Call Print_Char
      ;  ----------------------------------------------      
              pop  dx
              pop  bx
              pop  ax
              ret
   Level      endp

 ;--------------------- Delay Time --------------------

   Delay   proc near
           push cx
           mov  cx,02d
       D1: call Delay_Time
           loop D1
           pop  cx
           ret
   Delay   endp

   Delay_Time    proc near     ; Delay Time  1 / 18.2 S
             push  ax
             push  dx
             push  cx
     D_loop: mov  ah,00h
             int  1Ah
             cmp  dx,D_Time
             je   D_loop
             mov  D_Time,dx
             pop  cx
             pop  dx
             pop  ax
             ret
   Delay_Time    endp

 ;---------------------  File Operation ---------------------
    PutHighScores proc near       ; This function is for keep high scores
        mov     ah,03ch         ; from variable to file as name _hs.dat
        mov     dx,offset FileN
        mov     cx,00h
        int     21h             ; Creat file
        mov     dx,offset NamePlayer
        mov     cx,15d
        mov     bx,ax
        mov     ah,40h
        int     21h             ; Write file
        mov     ah,03eh
        int     21h             ; Close file
        ret
  PutHighScores endp

  GetHighScores proc near       ; This function is for read high scores
        mov     ah,03dh         ; from file _hs.dat to variable
        mov     al,00h
        mov     dx,offset FileN
        int     21h             ; Open file
        jnc     L1_getHighScores
        mov     [NamePLayer],'$'
        mov     [HighScore],0h
        jmp     End_getHighScores
    L1_GetHighScores:
        mov     dx,offset NamePlayer
        mov     cx,15           ; read 15 bytes from file to variable
        mov     bx,ax           ; BX <- file handle
        mov     ah,03fh
        int     21h
        mov     ah,03eh         
        int     21h             ; Close file
    End_GetHighScores:
        ret
  GetHighScores endp

  GetPlayerName proc near          ; This function is for read argument
        mov     di,offset NameP ; (player's name) from byte No.80h
        mov     si,80h             ; of PSP
        mov     ch,0
        mov     cl,es:[si]      ; cl <- Lenght of argument from command line
        mov     si,82h          ; si point to first charecter of argument
        cmp     cx,0            ; if cx=0 that is without command line
        jg      L1_getPlayerName
        add     di,9d           ; Without argment
        jmp     End_getPlayerName
    L1_GetPlayerName:           ; Have argument
        cmp     cx,12d          ; Read string from PSP less than 13 charecter
        jl      Again_GetPlayerName
        mov     cx,11d
    Again_GetPlayerName:
        mov     dh,es:[si]
        cmp     dh,13d
        je      End_getPlayerName
        mov     [di],dh
        inc     di
        inc     si
        dec     cx
        jnz     Again_getPlayerName
    End_GetPlayerName:
        mov     dh,'$'          ; Put '$' to end of string
        mov     [di],dh         ;
        ret
  GetPlayerName endp
 ;--------------------- Sound ----------------------------------

     sound    proc  near
              push  ax
              push  cx
              mov   al,0b6h           ; Initial timer
              out   43h,al
              mov   ax,Hz             ; Frequency [Hz]
              out   42h,al            ;   Freq = count of time
              mov   al,ah             ;   low , high byte
              out   42h,al
              in    al,61h            ; Control Port
              and   al,0fch           ; Set Control Bit
              out   61h,al            ; Open Speaker
              mov   cx,1fffh          ; Counter
      sound1: or    al,02d            ; Control bit turn on [toggle bit 1]
              out   61h,al            ; Because bit 1 = control speaker
              mov   al,0fdh
              out   61h,al            ; Close Speaker
              loop  sound1
              pop   cx
              pop   ax
              ret
   sound     endp
 ;--------------------------------------------------------------

codesg       ends
             end begin





