;-----------------------------------------------
;   Program : 3D BALL                         
;   Create  : 1 / April / 97                  
;   Last Update : 7 / April / 97                        
;   Comment : Game Project 1P                 
;   Symbol  : === is Code                     
;           : ### is Procedure                
;           : *** is Macro                    
;           : --- is Comment & Segment Comment
;------------------------------------------------
;                 Define Area                                   
;------------------------------------------------
            
Data Segment Para 'data'                          
  Xmin      equ 7        ;Min x ball
  Xmax      equ 300      ;Max                         
  Ymax      equ 155      ;Max Y ball
  Ymin      equ 9        ;Min                         
  Start_x   dw  16       ;Start Ball
  Start_y   dw  155
  Mou_max   dw  277      ;Boundnary Mouse
  Mou_min   dw  4
  Mou_mov   dw  0        ;Cursor Mouse
  MaxBall   db  5        ;Default ball
  x_score   db  21       ;Position Score                         
  h_score   db  28       ;         Hiscore
  def_h_sc  db  28       ;default Position Hiscore
  x         dw  0        ;Position Ball                               
  y         dw  0                                      
  _x        dw  5        ;Inc,Dec Ball                              
  _y        dw  6                                                          
  xbar      dw  4        ;Position Bar
  ybar      dw  3                                      
  UserBall  dw  30       ;Bal Total
  Restart   db  0        ;Flag Restart                              
  Freq      dw  793      ;Sound Freqency                               
  NotBar    db  74 dup (0)        ;Clear Bar
  Cg_HiSc   db  0                 ;Flag Save High Score
  Name_Hi   db  15 dup ('$')      ;Name High Score                        
  Scr_Hi    dd  0                 ;Score High                        
  Def_Shi   dd  100000            ;Default Score High
  Def_Nhi   db  'Paradon$'        ;Default Name High
  Hiscore   db  'HIGH SCORE$'                             
  Fhandle   dw  ?                 ;File Handle                        
  Msg       db  'Anonymous$'      ;Default User Name
  Hi        db  '      :) Hi! $'  ;Say Hi
  Tell      db  'Press Key or Click Mouse = Continue$'    
  Escap     db  '< Esc = Exit > < SpaceBar = Pause >$'
  Space     db  '> Enter = Sell Ball If Ball > 15  <$'
  Escext    db  '          ! Esc = Exit !           $'
  No_Mouse  db  'No Mouse Installed Check Mouse !$'       
  Pause1    db  '            Pause Game             $'     
  Score     db  'Score            $'
  Vers      db  'Ver 1.2$'
  Gameover  db  ' OH! No More Ball Ha! Ha! ..$'
  KPress    db  '   Press A Key Little Baby  $'
  X3dball   db  '< 3D BALL >$'    ;Game name
  ScoreHi   db  'ScoreHi.dat',0   ;FileName HiScore
  NameHi    db  'NameHi.dat',0    ;      Name,Score
  BallScore db  36                ;Position Write Total Ball                         
  Userscore dd  0                 ;Score Max = 4.2G
  Equal     db  '=    $'                                  
  Clear     db  32000 dup(0)      ;For Fill Black To Screen
  Gray      db  320 dup (19)      ;Line  Table
  Black     db  100 dup (0)       ;Black Ball To clear
  UFO1      db  140               ;Default of picture  -UFO  up
  UFO2      db  80                ;                    -UFO  down
  UFO3      db  180               ;                    -Chinjung down
  Chin_j    db  40                ;                    -Chinjung up
  Charac    dw  0                 ;Temp Of Print Title
  User      db  50 dup ('$')      ;Has Parameter?
  Num_Score db  2  dup ('$')      ;Buffer Print Score
  Stone     db  195 dup (4,4,15,1,1,15)      ;Line  Side
  Line      db  320 dup (81,81,81,82,82,82,83,83,83,89,89,89)   
  Bar       db  74 dup (62,62,62,60,60,60,63,63,63,61,61,61,61,61)
  Ball      db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h           
            db 000h,037h,01Fh,022h,01Bh,03Ch,031h,038h,000h,000h           
            db 032h,01Eh,026h,030h,02Ah,02Fh,034h,03Fh,024h,032h           
            db 033h,036h,03Eh,01Bh,030h,02Ch,03Dh,027h,030h,039h           
            db 020h,01Eh,02Dh,022h,031h,026h,01Bh,026h,026h,023h           
            db 01Ch,02Eh,01Fh,023h,036h,024h,024h,028h,029h,01Fh           
            db 01Dh,01Ah,020h,03Bh,021h,01Fh,01Eh,03Ah,021h,02Bh           
            db 000h,01Ch,01Ah,01Ah,01Ah,025h,025h,025h,01Ch,000h           
            db 000h,000h,01Dh,01Ch,01Ah,01Ch,01Ch,01Dh,000h,000h           
            db 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h
 ;--------------------------------------------------------------
 Pal        db 000h,000h,000h                  ;Pcx Palate color              
            db 020h,000h,000h                                              
            db 000h,020h,000h                                          
            db 020h,020h,000h                                    
            db 000h,000h,020h                                    
            db 020h,000h,020h                                    
            db 000h,020h,020h                                    
            db 030h,030h,030h                                    
            db 030h,037h,030h                                    
            db 029h,032h,03Ch                                    
            db 036h,026h,02Ah                                    
            db 000h,03Eh,02Ah
            db 032h,000h,02Ch                                     
            db 03Eh,000h,02Ch                                    
            db 014h,002h,02Ch                                    
            db 07Fh,07Fh,07Fh
            db 030h,000h,010h    
            db 0f0h,0f0h,000h  
            db 03Eh,014h,02Eh                                    
            db 016h,018h,02Eh                                    
            db 00Ch,01Ch,02Eh                                              
            db 028h,01Eh,02Eh                                    
            db 018h,022h,02Eh                                          
            db 026h,028h,02Eh                             
            db 000h,02Eh,02Eh                             
            db 018h,00Eh,02Eh                             
            db 000h,009h,009h                             
            db 012h,02Ah,02Bh                             
            db 000h,007h,007h                             
            db 000h,004h,004h                             
            db 00Ah,019h,019h                             
            db 009h,016h,017h                             
            db 002h,00Bh,00Bh                                     
            db 008h,015h,015h                             
            db 010h,025h,025h                             
            db 00Ch,01Dh,01Dh                             
            db 00Fh,022h,023h                             
            db 001h,00Ah,00Ah                             
            db 012h,029h,029h                             
            db 015h,02Eh,02Eh                             
            db 00Fh,023h,024h                                              
            db 00Eh,021h,021h                             
            db 016h,031h,031h                                          
            db 003h,009h,00Ah                             
            db 02Ch,03Ah,03Ah                             
            db 00Dh,020h,020h                             
            db 004h,00Fh,00Fh                             
            db 01Ch,035h,036h                             
            db 014h,02Dh,02Eh                             
            db 011h,027h,028h                             
            db 001h,003h,003h                             
            db 004h,00Ch,00Ch                             
            db 018h,033h,034h                                     
            db 015h,02Fh,030h                             
            db 00Dh,01Fh,01Fh                             
            db 002h,005h,005h                             
            db 00Bh,01Ah,01Ah                             
            db 00Ah,017h,017h                             
            db 009h,017h,018h                             
            db 005h,010h,010h                             
            db 013h,02Bh,02Ch                                              
            db 01Eh,034h,035h                             
            db 010h,026h,026h                                          
            db 016h,032h,032h                             
            db 011h,028h,028h                             
            db 030h,03Ch,000h
            
 UFO        DB 07h,07h,07h,07h,07h,07h,07h,00h,00h,00h,00h,00h,00h,07h,07h,07h,07h,07h,07h,07h
            DB 07h,12h,00h,00h,07h,00h,00h,00h,16h,16h,16h,16h,00h,00h,00h,07h,07h,00h,12h,07h 
            DB 07h,07h,07h,00h,00h,00h,16h,00h,16h,16h,16h,16h,00h,16h,00h,00h,00h,00h,07h,07h
            DB 07h,07h,07h,00h,00h,16h,16h,00h,00h,16h,16h,00h,00h,16h,16h,00h,00h,07h,07h,07h
            DB 07h,07h,00h,00h,16h,16h,00h,07h,00h,16h,16h,00h,07h,00h,16h,16h,00h,00h,07h,07h
            DB 07h,00h,00h,16h,16h,16h,00h,00h,00h,16h,16h,00h,00h,00h,16h,16h,16h,00h,00h,07h
            DB 07h,00h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,16h,00h,07h
            DB 07h,00h,16h,16h,16h,16h,16h,16h,16h,01h,01h,16h,16h,16h,16h,16h,16h,16h,00h,07h
            DB 07h,00h,16h,16h,16h,16h,16h,16h,16h,01h,01h,16h,16h,16h,16h,16h,16h,16h,00h,07h
            DB 07h,07h,00h,00h,00h,00h,00h,16h,00h,01h,01h,00h,16h,00h,00h,00h,00h,00h,07h,07h
            DB 07h,07h,07h,07h,00h,00h,16h,16h,16h,00h,00h,16h,16h,16h,00h,00h,07h,07h,07h,07h
            DB 07h,07h,07h,07h,07h,00h,00h,16h,16h,16h,16h,16h,16h,00h,00h,07h,07h,07h,07h,07h
            DB 07h,07h,07h,07h,07h,07h,00h,00h,16h,16h,16h,16h,00h,00h,07h,07h,07h,07h,07h,07h
            DB 07h,07h,07h,07h,07h,07h,44h,00h,16h,00h,00h,16h,00h,44h,07h,07h,07h,07h,07h,07h
            DB 07h,07h,07h,07h,07h,07h,44h,00h,00h,89h,89h,00h,00h,44h,07h,07h,07h,07h,07h,07h
            DB 07h,07h,07h,07h,07h,07h,14h,00h,16h,16h,16h,16h,00h,14h,07h,07h,07h,07h,07h,07h
            DB 07h,07h,07h,07h,07h,07h,14h,00h,16h,16h,16h,16h,00h,14h,07h,07h,07h,07h,07h,07h
            DB 07h,07h,07h,00h,00h,00h,00h,00h,00h,16h,16h,00h,00h,00h,00h,00h,00h,07h,07h,07h
            DB 07h,00h,00h,00h,4Bh,4Bh,4Bh,4Bh,00h,00h,00h,00h,44h,44h,44h,44h,00h,00h,00h,07h
            DB 00h,4Bh,4Bh,4Bh,4Bh,4Bh,4Bh,4Bh,4Bh,00h,00h,44h,44h,44h,44h,44h,44h,44h,44h,00h

 Chinjung   DB 07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h
            DB 07h,07h,07h,07h,07h,07h,07h,00h,00h,00h,00h,00h,00h,00h,00h,07h,07h,07h,07h,07h
            DB 07h,07h,07h,07h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,07h,07h,07h
            DB 07h,07h,07h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,07h,07h
            DB 07h,07h,07h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h,07h,07h,07h
            DB 07h,07h,07h,00h,0Fh,00h,00h,00h,0Fh,0Fh,0Fh,00h,00h,00h,0Fh,0Fh,00h,00h,07h,07h
            DB 07h,07h,07h,00h,00h,00h,00h,00h,00h,0Fh,00h,00h,00h,00h,00h,0Fh,00h,00h,07h,07h
            DB 07h,07h,07h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,07h,07h
            DB 07h,07h,00h,0Fh,00h,00h,00h,00h,0Fh,0Fh,00h,00h,00h,00h,0Fh,0Fh,0Fh,00h,07h,07h
            DB 07h,00h,0Fh,00h,0Fh,0Fh,00h,00h,0Fh,0Fh,00h,00h,0Fh,0Fh,00h,0Fh,0Fh,0Fh,00h,07h
            DB 00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h
            DB 00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h
            DB 00h,0Fh,0Fh,0Fh,0Fh,0Fh,00h,0Fh,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h
            DB 00h,0Fh,0Fh,0Fh,0Fh,0Fh,00h,01h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h,07h
            DB 07h,00h,0Fh,0Fh,0Fh,0Fh,00h,01h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,07h,07h,07h
            DB 07h,07h,00h,0Fh,0Fh,0Fh,0Fh,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,07h,07h,07h,07h
            DB 07h,07h,07h,00h,00h,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,0Fh,00h,00h,07h,07h,07h,07h,07h
            DB 07h,07h,07h,07h,00h,00h,00h,00h,00h,00h,00h,00h,00h,07h,07h,07h,07h,07h,07h,07h
            DB 07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h
            DB 07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h,07h

Data  Ends                                         
                                                                    
Stacks Segment Stack 'stack'                   ;Define for Future
Stacks Ends                                        
                                                   
;=============================================                    
;              MACRO AREA                                   
;---------------------------------------------
                
  ;*********************** For put Picture On screen
  Put_picture Macro  x_size,y_size,picture              
             Local Loop_y                             
                PUSH AX                            
                PUSH DX                            
                PUSH CX                                    
                Call Calculus                                          
                MOV SI,offset picture                      
                MOV DX,y_size                              
      Loop_y:   MOV CX,x_size                      
                REP MOVSB                          
                ADD DI,320 - x_size                                 
                DEC DX                                     
                JNZ loop_y                                 
                POP CX                                     
                POP DX                                  
                POP AX                                            
             Endm                                          
                                              
  ;*********************** For put Bar On screen
  Put_bar Macro  x_size,y_size,picture                
             Local Loop_y                               
                PUSH AX                               
                PUSH DX                           
                PUSH CX                                    
                Call Calbar                           
                MOV SI,offset picture                                  
                MOV DX,y_size                              
      Loop_y:   MOV CX,x_size                     
                REP MOVSB                         
                ADD DI,320 - x_size                                 
                DEC DX                                     
                JNZ loop_y                                 
                POP CX                                     
                POP DX                     
                POP AX                                    
             Endm                                                 
                                                           
  ;********************** For Write String At Row Column
  Printf Macro Column,Row,Message,Color       
          LOCAL Again                                 
          LOCAL END_P                                   
          PUSH AX                                     
          PUSH DX                                 
          MOV AH,02H             ;Move cursor
          MOV BH,0                                    
          MOV DH,Row                                                   
          MOV DL,Column                           
          INT 10H                                 
          MOV SI,Offset Message                   
  Again:  MOV AL,[si]            ;It is Character 
          MOV DL,[si+1]          ;It is '$' ?     
          PUSH DX                                 
          MOV AH,14                               
          MOV BH,0                                
          MOV BL,Color                                  
          INT 10H                                                 
          POP DX                                           
          CMP DL,'$'                              
          JE  End_P                               
          INC SI                                      
          JMP Again                                     
  End_P:  POP DX                                      
          POP AX                                  
        ENDM
                                     
;---------------------------------------------   
;             Main Program area                          
;---------------------------------------------   
Code Segment Para 'code'                                 
     Assume  CS:CODE , DS:DATA , SS:STACKS
;---------------------------------------------
             JMP Start    ;Start up of Program    
;---------------------------------------------                   
;            PROCEDURE  AREA                               
;---------------------------------------------                    
  ;##################### For Clear screen
     Clrscr Proc near                                 
             MOV  AX,0600H    ;Rotate Active Page
             MOV  CX,0000H    ;row,col up-left                    
             MOV  DX,2480H    ;row,col down-right                    
             MOV  BX,0700H    ;attribute                    
             INT  10H                                 
             RET                                                       
     Clrscr endp                                  
                                                  
  ;##################### For Readkey,Mouse Pressed
     Readkey  Proc near                                 
                XOR AX,AX                                     
                INT 16H                                        
     Readkey  endp                               
                                                  
  ;##################### For Calculus Picture Position
     Calculus Proc  near                                         
           PUSH AX             ;Di = y*320+x
           PUSH DX                                                
           MOV AX,y                                      
           MOV DX,320                                    
           MUL DX                                        
           MOV DI,x                                      
           ADD DI,AX                                     
           POP DX                                        
           POP AX                                     
           Ret                                                         
    Calculus Endp                                     
                                                        
  ;#################### For  Calculus Bar Position
    Calbar  Proc  near                           
           PUSH AX             ;DI = ybar*320+xbar
           PUSH DX                                       
           MOV AX,ybar                                      
           MOV DX,320                                    
           MUL DX                                        
           MOV DI,xbar                                           
           ADD DI,AX                                       
           POP DX                                                 
           POP AX                                   
           Ret                                                 
    Calbar Endp                                                
                                                               
 ;##################### Create File Name Score                 
   Create_New_Name Proc near                                   
             PUSH AX                                           
             XOR AX,AX                                                 
             MOV AH,3CH                                        
             MOV DX,offset NameHi         ;Name High Score     
             MOV CL,0                                          
             INT 21H       
             MOV Fhandle,AX                                          
             MOV BX,Fhandle               ;Write File
             MOV CX,10                    ;Mov Filehandle To BX         
             MOV DX,Offset Def_Nhi                             
             MOV AH,40H                                        
             INT 21H                                           
             MOV BX,Fhandle              ;Close file           
             MOV AH,3EH                                        
             INT 21H                                                   
             POP AX                                            
             Ret                                               
   Create_New_Name endp                                        
                                                               
 ;##################### Create New File High Score
   Create_New_Scr  Proc near                                   
             MOV DX,offset ScoreHi       ;High Score           
             MOV AH,3CH                                        
             MOV CL,0                                            
             INT 21H       
             MOV Fhandle,AX                                    
             MOV BX,Fhandle                  ;Mov FileHandle to BX
             MOV CX,12                                         
             MOV DX,Offset Def_Shi                             
             MOV AH,40H                                        
             INT 21H                                           
             MOV BX,Fhandle              ;Close file           
             MOV AH,3EH                                        
             INT 21H                                           
             Ret                                                 
   Create_New_Scr endp                                         
                                                                  
 ;##################### Open File High Score
   Open_High_Score Proc near                                   
             PUSH AX                             
    N_open:  MOV AH,3DH                          
             MOV DX,Offset NameHi      ;NameHi= File name of
             MOV AL,0                    ;   name high score
             INT 21H                                                   
             MOV Fhandle,AX                                    
             JNC N_ok                                          
             Call Create_New_Name                          
             JMP N_open                                    
      N_ok:  MOV AH,3FH                  ;if (open) do read(buffer)
             MOV DX,Offset Name_Hi       ;   else create newfile            
             MOV CX,10                                          
             MOV BX,Fhandle                                
             INT 21H                                       
             MOV BX,Fhandle              ;Close file              
             MOV AH,3EH                                    
             INT 21H                                       
             ;*********                                    
    S_open:  MOV AH,3DH                                    
             MOV DX,Offset ScoreHi       ;ScoreHi=File name of
             MOV AL,0                    ;        high score
             INT 21H                                                   
             MOV Fhandle,AX                                     
             JNC S_Ok                                      
             Call Create_New_Scr         ;if (open) do read(buffer)
             JMP S_open                                    
      S_ok:  MOV AH,3FH                  ;   else create newfile
             MOV DX,Offset Scr_Hi                              
             MOV CX,10                                          
             MOV BX,Fhandle                                     
             INT 21H                                             
             MOV BX,Fhandle              ;Close file              
             MOV AH,3EH                             
             INT 21H                        
             POP AX                      
             Ret                              
   Open_High_Score endp                                        
                                             
 ;#####################   
   Change_Hi_Score Proc near                                           
             PUSH AX                         
             XOR AX,AX                       
             MOV AH,3DH                         
             MOV DX,Offset ScoreHi      ;Fscr   = File name of
             MOV AL,1                   ;          high score
             INT 21H                                           
             MOV Fhandle,AX                                    
             MOV BX,Fhandle                         
             MOV CX,12                              
             MOV DX,Offset UserScore    ;Save UserScore   
             MOV AH,40H                                
             INT 21H                                
             MOV BX,Fhandle              ;Close file
             MOV AH,3EH                             
             INT 21H                                
             XOR AX,AX                              
             MOV AH,3DH                             
             MOV DX,Offset NameHi       ;ScoreHi  = File name of
             MOV AL,1                   ;        Name high score
             INT 21H                                                   
             MOV Fhandle,AX             ;Open to Write                       
             MOV BX,Fhandle                       
             MOV CX,12                        
             MOV DX,Offset Msg          ;Save Name
             MOV AH,40H                                
             INT 21H                               
             MOV BX,Fhandle             ;Close file   
             MOV AH,3EH                             
             INT 21H                               
             POP AX                                
             Ret                                   
    Change_Hi_Score  endp                          
                                                                 
 ;##################### For Update Mouse Cursor 
   Update_Mouse Proc near                                      
           PUSH AX                                             
           MOV  AX,0004                             
           MOV  CX,XBar                             
           MOV  Mou_mov,CX                            
           MOV  DX,20                ; Default y = 20                  
           INT  33H                  ; Move X only
           POP  AX                     
           Ret                                     
   Update_Mouse Endp                               
                                                                 
 ;##################### For Check Mouse & Set bar
   Check_Mouse_Mov Proc near                                      
           PUSH AX                                         
           PUSH BX                                 
           MOV  AX,0003              ; read position
           INT  33H                                   
           CMP  Mou_mov,CX           ; Mou_mov = Last update
           JNE  Yes_mov              ; if (move) do Yes_mov
           JMP  No_mov               ;      else do No_mov
  Yes_mov: MOV  Mou_mov,CX           ; update Position mouse
           MOV  YBar,167               
           Put_Bar 37 2 Notbar       ; clear bar
           MOV  YBar,3                          
           Put_Bar 37 2 Notbar
           MOV  XBar,CX              ; update Position Bar
           Put_Bar 37 2 Bar
           MOV  YBar,167                                  
           Put_Bar 37 2 Bar
  No_mov:  POP  BX                                        
           POP  AX                                               
           Ret                                            
   Check_Mouse_mov endp                                           
                                                           
 ;##################### For Uses Time delay 
    TimeDelay  Proc near                              
           PUSH AX                                    
           PUSH BX                                    
           PUSH CX                                    
           PUSH DX                                      
           MOV  AH,00H              ;Read time of Day              
           INT  1AH                 ;     DX - Low  byte
           MOV  BX,DX               ;     CX - High byte    
 loop_de:  MOV  AH,00H                                  
           INT  1AH                                   
           CMP  BX,DX               ; cmp until BX <> DX               
           JZ   Loop_de             ;    Low byte change
           POP  DX                                       
           POP  CX                                      
           POP  BX                                    
           POP  AX                                               
           Ret                                        
    Timedelay   Endp                                              
                                                           
 ;##################### For Make Sound
    Sound  Proc near                                  
            PUSH AX                                   
            MOV AL,0B6H      ; Initial timer           
            OUT 43H,AL                                
            MOV AX,Freq      ; Frequency [Hz]         
            OUT 42H,AL       ;   Freq = count of time               
            MOV AL,AH        ;   low , high byte               
            OUT 42H,AL                                
            IN AL,61h        ; Control Port           
            AND AL,0fch      ; Set Control Bit        
            OUT 61h,al       ; Open Speaker                            
            MOV CX,1fffh     ; Counter                
     Again: OR  AL,2         ; Control bit turn on                
            OUT 61h,AL       ;   Because bit 1 = control speaker
            MOV AL,0fdh                               
            OUT 61h,AL       ; Close Speaker                     
            LOOP Again                                
            POP AX                                                
            Ret                                              
    Sound  endp
                                       
 ;##################### Table Of Message
    Table_Msg   Proc  near                     
             PUSH Y                            
             PUSH X                            
             MOV X,9                           
             MOV Y,58                          
             Put_Picture  300 1 Stone   ;Line ------
             Put_Picture  1 82 Stone    ;Line |
             MOV Y,140                             
             Put_Picture  300 1 Stone   ;Line ------                   
             MOV X,309                                                 
             MOV Y,58                                                  
             Put_Picture  1 82 Stone   ;Line  |
             Call Sound                
             POP X                     
             POP Y                     
             Ret                       
    Table_Msg endp                     
                                       
 ;##################### Clear Msg
    Clear_Table Proc near              
             PUSH X                    
             PUSH Y                    
             MOV X,5                   
             MOV Y,50                   
             Put_Picture 310 100 Clear  
             POP Y                     
             POP X                     
             Ret                       
    Clear_Table endp
                   
 ;##################### Pause Game
    Pause_Game Proc near                                                       
             PUSH AX                                  
             PUSH BX
             Call Clear_Table
             Printf 2  8  Pause1 18                   
             Printf 2  10 Tell 2       
             Printf 2  12 Escap  6     
             Call Show_High_Score      
             Call Table_Msg            
             Call Sound                                                
    Mou_Clk: Call Check_Int_Key    ; check key input
             JNZ Keyin             ; if keypressed check it            
             MOV AX,0005h          ; else             
             XOR BX,BX             ; check click mouse           
             INT 33H               ;       any switch                     
             OR  AL,AL             ;       if click => start                 
             JZ  Mou_clk                                         
             JMP NotEsc                                          
     Keyin:  MOV AH,0              ;Read Keyboard Buffer          
             INT 16h                                        
             CMP AH,1              ;If Key = Esc Then Exit  
             JNZ  NotEsc
             JMP  Newgam
     NotEsc: Call Clear_Table          
             POP BX                                   
             POP AX                                   
             Ret                                      
    Pause_Game endp                                   
                                                      
 ;##################### For Check Parameter In Command
    Read_Parameter Proc near                          
             XOR CX,CX                                
             LEA DI,User             ; Get Parameter  
             MOV BX,0082H                             
             MOV CL,ES:[0080H]       ; How many Parameter         
             CMP CX,0000H            ; If no Parameter return                     
             JNE  Getnext            ; else read it                        
             Ret                                      
   Getnext:  MOV AX,ES:[BX]          ; Get One Parameter       
             MOV BYTE PTR DS:[DI],AL ; Keep it                   
             INC BX                  ; next parameter 
             INC DI                                   
             LOOP GetNext                             
             XOR CX,CX                                
             MOV BYTE PTR CL,ES:[0080H]               
             DEC CX                                   
             CMP CX,004fH            ; Parameter is over?
             JLE In_limit            ;          max = 50                    
             MOV CX,004fh                             
   In_limit: MOV AX,DATA             ; loop for cut space in parameter       
             MOV ES,AX                                                
             MOV AL,' '                                      
             MOV DI,Offset User      ; Load it in User                      
             REPZ SCASB                                      
             JNZ  Has_Para                                       
             Ret                                                 
   Has_Para: LEA SI,[DI-1]           ; if have parameter                      
             INC CL                  ;    load it in msg and msg
             CMP CL,10               ;    has default = anonymous
             JL  No10                                 
             MOV CL,9                                 
   No10:     INC CL                                   
             MOV DI,Offset Msg       ; change it then we cut
             CLD                     ; max parameter = 10 char                           
             REP MOVSB                                           
             MOV BYTE PTR ES:[DI-1],'$'  ; put last = '$' for print
             Ret                                                   
    Read_Parameter endp                               
                                                      
 ;##################### For Check Interrupt Keyboard
    Check_int_Key Proc near                                
             Push AX                                   
             PUSH DS                                   
             WAIT                                     
             MOV  AX,0040H      ; read keyboard buffer                       
             MOV  DS,AX         ; at 0040:001A                   
             MOV  AX,DS:[1AH]   ; compare with 0040:001C          
             CMP  AX,DS:[1CH]   ; if (keypressed) Flag Z=1       
             POP  DS                                             
             POP  AX                                             
             RET                                                 
    Check_int_Key endp                                           
                                                                 
 ;##################### For Write Table Game
    Block  Proc near
             PUSH X
             PUSH Y
             MOV X,1                                             
             MOV Y,0                                             
             Put_Picture  315 1 Stone   ;Line ------             
             MOV Y,1                                             
             Put_Picture  315 1 Line    ;Line ------                   
             MOV Y,2                                             
             Put_Picture  315 1 Gray    ;Line ------             
             Put_Picture  1 195 Line    ;Line |                  
             MOV X,1                                             
             MOV Y,195                                           
             Put_Picture  315 2 Line    ;Line ------             
             MOV Y,197                                            
             Put_Picture  315 1 Stone   ;Line ------             
             MOV Y,193                                           
             Put_Picture  315 2 Line    ;Line ------             
             MOV Y,192                                           
             Put_Picture  315 1 Stone   ;Line ------             
             MOV X,315                                           
             MOV Y,1                                             
             Put_Picture  1 195 Line    ;Line      |             
             MOV X,1                                             
             MOV Y,169                                           
             Put_Picture  315 1 Gray    ;Line ------             
             MOV Y,170                                           
             Put_Picture  315 1 Line    ;Line ------                   
             MOV X,0                                             
             MOV Y,1                                             
             Put_Picture  1 195 Stone   ;Line |   
             MOV X,316                                           
             MOV Y,1                                             
             Put_Picture  1 195 Stone   ;Line     |
             MOV X,255                        
             MOV Y,176                                           
             Put_Picture  10 10 Ball    ;Write Total Ball Picture                   
             Printf 34 22 Equal 57      ;Write '='
             Printf 14 24 X3dBall 44
             Call Total_Ball
             POP Y
             POP X
             Ret                                                 
    Block endp                                                   
                                                                 
 ;##################### For Initial Ball
   Set_Default_Ball Proc near                                    
             PUSH AX                                             
             MOV AX,Start_x                                      
             MOV X,AX              ; Start Of X                  
             MOV AX,Start_y                                            
             MOV Y,AX              ; Start Of Y                  
             POP AX                                              
             Ret                                                 
   Set_Default_Ball endp                                         
                                                                 
  ;#################### Init Mouse                               
   Init_Mouse Proc near                                           
             PUSH AX                                             
             MOV AX,0007           ; Set Mouse                   
             MOV CX,Mou_min        ; Set Min x                   
             MOV DX,Mou_max        ; Set Max x                   
             INT 33H                                             
             POP AX                                              
             Ret                                                 
   Init_Mouse endp                                               
                                                                 
 ;##################### For Set Default Mouse
   Set_Default_Mouse  Proc near                                        
             PUSH AX                                                   
             MOV AX,0004H          ; Set default mouse                          
             MOV CX,0004           ; at column = 6
             MOV DX,0020           ;    row = 20                       
             INT 33h               ;    in pixcel                      
             POP AX                                                    
             Ret                                                       
   Set_Default_Mouse endp                                              
                                                                       
 ;#################### For Set Position Bar,Ball
   Start_Bar_Ball  Proc near                                           
             PUSH AX                                                   
             Put_bar 37 2 Bar      ; Start Bar  X=6 Y=3
             MOV XBAR,4            ; Start Ball X=100 Y=100
             MOV YBAR,167                                              
             Put_bar 37 2 Bar
             Put_Picture  10 10 Ball                                   
             POP AX                                                    
             Ret                                                       
   Start_Bar_Ball endp                                                 
                                            
 ;#################### For Print High Score 
   Show_High_Score Proc near                
             Printf 4 16 HiScore 66
             Printf 17 16 Name_Hi 13                                    
             Call Print_Hi_Score            
             Ret                            
   Show_High_Score endp         
                                                              
 ;#################### For Pause,Tell Information
   Msg_Before_Play  Proc near                                          
             PUSH AX
             Call Clear_Table
             Call Total_Ball                                           
             Printf 4 8 Hi 99                                          
             Printf 18 8  Msg  95                                      
             Printf 2 10 Tell 89   ;Pause to Ready                     
             Printf 2 12 Escap 39                                       
             Printf 2 14 Space 7
             Call Check_High_Score
             Call Show_High_Score
             Call Table_Msg                                             
     Click:  Call Check_Int_Key    ; check key input                    
             JNZ Press             ; if keypressed check it             
             MOV AX,0005h          ; else                               
             XOR BX,BX             ; check click mouse                  
             INT 33H               ;       any switch                     
             OR  AL,AL             ;       if click => start                 
             JZ  Click                                      
             JMP NoEsc                                      
    Press:   MOV AH,0              ;Read Keyboard Buffer    
             INT 16h                                        
             CMP AH,1              ;If Key = Esc Then Exit  
             JNZ  NoEsc                                     
             JMP  Newgam
     NoEsc:  Call Clear_Table
             POP AX                                   
             Ret                                           
   Msg_Before_Play endp                     
                                            
 ;#################### For Add Score                               
   Add_Score Proc near                                             
               ADD word ptr Userscore,100     ; Score of User
               ADC word ptr Userscore+2,0     ; Add Step / 100
               Ret                                                     
   Add_Score endp
                                                  
 ;#################### Print ToTal Ball                            
   Total_Ball Proc near                          
               PUSH DX                           
               PUSH AX                           
               PUSH SI                                           
               PUSH CX                           
               XOR CX,CX                         
               MOV SI,10                                          
               MOV AX,UserBall           ; Change User Ball To
     YesBall:  MOV DX,0                  ;             Base 10
               DIV SI                             
               PUSH DX                             
               INC CX                         
               OR  AX,AX                                           
               JNE Yesball                    
     BallWri:  POP DX                    ; print it
               ADD DL,'0'                ; convert to character
               MOV Num_score,DL          ; put one char in buffer
               Printf Ballscore 22 Num_score 89    
               INC BallScore             ; next position
               Loop BallWri              ; print by one character
               MOV BallScore,36                    
               POP CX                              
               POP SI                                    
               POP AX                                               
               POP DX                                               
               Ret                                                  
   Total_Ball endp      
                                               
 ;#################### Check High Score                             
   Check_High_Score Proc near                                       
               PUSH AX                                              
               PUSH BX                      
               PUSH ES
               XOR  AX,AX
               XOR  BX,BX
               MOV  AX,word ptr Userscore+2   ;Mov high1 bit => ax  
               MOV  BX,word ptr Scr_Hi+2      ;Mov high2 bit => bx  
               CMP  AX,BX                                           
               JE   Ck_Lbit                   ;if Equal Check low bit
               JL   Not_More                  ;   else return
                       
   Change_Hi:  MOV  Cg_HiSc,1               
               MOV  AX,word ptr Userscore     ;change high score 
               MOV  BX,word ptr Userscore+2                     
               MOV  word ptr Scr_Hi,AX                          
               MOV  word ptr Scr_Hi+2,BX    
               CLD                          
               MOV  AX,DATA                 
               MOV  ES,AX                             
               MOV  CX,10                     ;change name high score
               LEA  SI,Msg          
               LEA  DI,Name_Hi      
               REP  MOVSB           
               JMP  Not_More        
   Ck_Lbit:    MOV AX,word ptr Userscore      ;mov Low1 bit => ax   
               MOV BX,word ptr Scr_Hi         ;mov Low2 bit => bx                   
               CMP AX,BX                                                 
               JG  Change_Hi                  ;if User score  > High score  
   Not_More:   POP ES               
               POP BX                                                  
               POP AX                                                  
               Ret                                                     
   Check_High_Score  endp                                              
                                                                       
 ;#################### For Ball Hit Bar ?       
   Hit Proc near                                                       
               PUSH AX                    ; check in bar ?
               PUSH Xbar                                               
               MOV AX,X                                                
               SUB Xbar,6                                          
               CMP AX,Xbar                                    
               JL No_inbar                                    
               ADD Xbar,36                                    
               CMP AX,Xbar                                    
               JG No_inbar
               SUB Xbar,30
        ;-----------------
               MOV AX,X
               SUB AX,Xbar
               SUB AX,3                  ; In BAr Sure
               CMP AX,0                  ; if inbar 0 - 3
               JG  CMP_HI                ;    _x = _x+ax
               ADD _X,AX
               JMP HitBar
  CMP_HI:      SUB AX,25                 ; if inbar 25 - 32
               CMP AX,0
               JNG HitBar                ;    _x = _x+ax
               ADD _X,AX
        ;------------------
  HitBar:      CMP _X,0-5                ; if _x < -5
               JGE No_5                  ;    do _x = -5
               MOV _X,0-5
  No_5 :       CMP _X,7                  ; if _x > 7
               JLE No7
               MOV _X,7                  ;    do _x = 7
  No7  :       Call Sound                ; if (inbar) then
               Call Add_Score            ;    - sound
               Call Print_Score          ;    - Increate score
               Call Check_High_Score
               MOV Restart,0             ; don't set flag restart
               POP Xbar                                              
               POP AX
               Call Change_Speed_Ball
               Ret                                        
     No_inbar: MOV Restart,1             ; else restart program
               DEC UserBall                                       
               Call ToTal_Ball                     
               POP XBar                                            
               POP AX                              
               RET                              
   HIT endp                                  
                                                                   
 ;####################### For Check Limit Of Ball     
    Check_Limit Proc near                    
                JMP CHK_X           ; if hit wall negative
    CASE_NEGX:  NEG _X              ;    direction of ball
                JMP CHK_Y                                         
    CASE_NEGY:  NEG _Y              ; And it hit bar ?
                Call Hit
                Ret                                           
    CHK_X:      CMP X,XMIN          ; if x <= xmin do neg(x)
                JLE CASE_NEGX                                       
                CMP X,XMAX          ; else if x >= xmax do neg(x)
                JGE CASE_NEGX
    CHK_Y:      CMP Y,YMIN          ; if y <= ymin do neg(y)
                JLE CASE_NEGY                                       
                CMP Y,YMAX          ; else if y >= ymax do neg(y)
                JGE CASE_NEGY                                 
                Ret
   Check_Limit  endp

 ;##################### Change Speed Ball
   Change_Speed_Ball Proc near
                 CMP _X,0           ;if _x < 0 do !change
                 JL  No_Cg
                 CMP _X,5           ;else if _x <> 5 do x=5
                 JNE no5
                 MOV _X,3           ;else _x=3
                 JMP No_Cg
          no5:   MOV _X,5
                 JMP No_Cg
                 Ret
          no3:   MOV _Y,3
       No_Cg:      Ret
   Change_Speed_Ball  endp

 ;##################### Check UFO Hit
   Check_Ufo_hit Proc Near
                 XOR CX,CX              ;if (ufo1 up) do
                 MOV CL,BYTE PTR UFO1
                 CMP X,CX
                 JL  Notin1
                 ADD CX,20
                 CMP X,CX
                 JG  Notin1
                 CMP Y,80
                 JL  Notin1
                 CMP Y,100
                 JG  Notin1
                 Call Print_UFO1      ;if ball pass Do (output)
                 Call Sound
                 MOV Freq,1500
                 Call Sound
                 ADD word ptr Userscore,10000    ; Score of User
                 ADC word ptr Userscore+2,0      ; Add Step / 100
                 ADD UserBall,2
                 CMP UserBall,999
                 JL  No999
                 MOV UserBall,999
      No999:     Printf 34 22 Equal 57      ;Write '='
                 Call Total_Ball
                 Call Print_Score           ;Increate score
                 Call Check_High_Score
                 Ret
     Notin1:     MOV CL,BYTE PTR UFO3       ;if UFO3 (Chinjung Low)
                 CMP X,CX
                 JL  Notin2
                 ADD CX,20
                 CMP X,CX
                 JG  Notin2
                 CMP Y,100
                 JL  Notin2
                 CMP Y,120
                 JG  Notin2
                 Call Print_UFO3           ;if ball Pass Do (Output)
                 Call Sound
                 MOV Freq,1900
                 Call Sound
                 ADD word ptr Userscore,50000   ; Score of User
                 ADC word ptr UserScore+2,0
                 SUB UserBall,2
                 CMP UserBall,0
                 JG HasBall
                 JMP KeyEsc
    HasBall:     Printf 34 22 Equal 57    ;Write '='
                 Call Total_Ball
                 Call Print_Score         ; Increate score
                 Call Check_High_Score
                 Ret
    Notin2:      MOV CL,BYTE PTR UFO2     ;if (ufo2 down)
                 CMP X,CX
                 JL  Notin3
                 ADD CX,20
                 CMP X,CX
                 JG  Notin3
                 CMP Y,30
                 JL  Notin3
                 CMP Y,50
                 JG  Notin3
                 Call Print_UFO2         ;if ball Pass do (output)
                 Call Sound
                 MOV Freq,1200
                 Call Sound
                 CMP UserBall,97
                 JGE NoAD_Ball
                 ADD UserBall,1
                 CMP UserBall,999
                 JL  NoAD_Ball
                 MOV UserBall,999
     NoAD_Ball:  Printf 34 22 Equal 57      ;Write '='
                 Call Total_Ball
                 ADD word ptr Userscore,10000    ; Score of User
                 ADC word ptr Userscore+2,0      ; Add Step / 100
                 Call Print_Score                ; Increate score
                 Call Check_High_Score
                 Ret

     Notin3:     XOR CX,CX
                 MOV CL,BYTE PTR Chin_j    ;if (chinjung up)
                 CMP X,CX
                 JL  NoChin
                 ADD CX,20
                 CMP X,CX
                 JG  NoChin
                 CMP Y,60
                 JL  NoChin
                 CMP Y,80
                 JG  NoChin
                 Call Print_Chinjung            ;if ball Pass do (output)
                 Call Sound
                 MOV Freq,200
                 Call Sound
                 MOV Freq,1500
                 Call Sound
                 ADD word ptr Userscore,50000   ; Score of User
                 ADC word ptr Userscore+2,0     ; Score of User
                 SUB UserBall,2
                 CMP UserBall,0
                 JG HavBall
                 JMP KeyEsc
    HavBall:     Printf 34 22 Equal 57      ;Write '='
                 Call Total_Ball
                 Call Print_Score                ; Increate score
                 Call Check_High_Score
    Nochin:      Ret
   Check_Ufo_hit  endp

 ;##################### For Set Direction Of Ball
   Setxy  Proc near                                   
             PUSH AX             ; Set Direction of Ball
             MOV AX,X               
             ADD AX,_X              
             MOV X,AX                        
             MOV AX,Y                                               
             ADD AX,_Y                                              
             MOV Y,AX                                               
             POP AX                                                    
             Ret                                                    
   Setxy  endp                                         
                                                       
  ;#################### New Game                       
    Prepare_New_Game Proc near                                    
             PUSH AX                                   
             MOV _X,6                                  
             MOV _Y,5                                  
             MOV Ybar,3             ; Del Parallel Bar 
             Put_Bar 37 2 Notbar
             MOV Ybar,167                                          
             Put_Bar 37 2 Notbar
             MOV  XBar,4
             MOV  YBar,3                               
             Call Block                                
             Call Set_Default_Ball                     
             Call Start_Bar_Ball                       
             Call Msg_Before_Play                      
             Call Set_Default_Mouse                    
             MOV Restart,0                                             
             POP AX                                    
             Ret                                            
    Prepare_New_Game endp                                   
                                                            
  ;#################### For Set X Bar Increte                       
   Inc_Xbar  Proc near                                              
              MOV Ybar,167           ; Del Parallel Bar     
              Put_Bar 37 2 Notbar
              MOV Ybar,3                                            
              Put_Bar 37 2 Notbar
              CMP Xbar,Xmax-26
              JGE Noxmax                                            
              ADD Xbar,10                                           
    Noxmax:   MOV Ybar,167           ; Set Parallel Bar Move
              Put_Bar 37 2 Bar
              MOV Ybar,3                                            
              Put_Bar 37 2 Bar
              Call Update_Mouse                             
              Ret                                                   
   Inc_Xbar   endp                                                     
                                                            
  ;#################### For Set X Bar Decrete                       
   Dec_Xbar  Proc near                                              
              MOV Ybar,167           ; Del Parallel Bar     
              Put_Bar 37 2 Notbar
              MOV Ybar,3                                            
              Put_Bar 37 2 Notbar
              CMP Xbar,Xmin+5
              JLE Noxmin                                            
              SUB Xbar,10                                           
     Noxmin:  MOV Ybar,167           ; Set Parallel Bar Move       
              Put_Bar 37 2 Bar
              MOV Ybar,3                                            
              Put_Bar 37 2 Bar
              Call Update_Mouse                            
              Ret                                                   
    Dec_Xbar   endp                           
             
  ;################### For Print Score                
    Print_Score Proc Near             ; convert score to
             PUSH SI                  ;         10 base
             PUSH BP                  ;         and print
             PUSH AX
             PUSH BX
             PUSH CX
             PUSH DX
             XOR AX,AX
             XOR CX,CX                                    
             XOR DX,DX
             MOV BP,word ptr UserScore     ; low bit  => BP        
             MOV BX,word ptr UserScore+2   ; high bit => BX
             MOV SI,10                     
    Nxt_num: MOV DX,0                      
             MOV AX,BX                     ; Do hight Bit                
             DIV SI                        ; div 10       
             MOV BX,AX                     ; hight bit in DX
             MOV AX,BP                     ; low bit in AX
             DIV SI                        ; div 10               
             PUSH DX                       ; get one of number
             MOV BP,AX                     ;       in answer      
             INC CX                        ; add counter                 
             OR BP,BP                      ; has any number             
             JNE Nxt_num                                   
             OR BX,BX                                      
             JNE Nxt_num                   
   Write:    POP DX                        
             ADD DL,'0'                    ; convert to character
             MOV Num_score,DL              ; put one char in buffer                       
             Printf X_score 22 Num_score 2 ; print it !                        
             INC X_Score                   ; next position            
             Loop Write                    ; print by one character
             MOV X_Score,21                ; set default position                          
             POP DX                        ;     of score to next print
             POP CX                          
             POP BX                          
             POP AX                          
             POP BP                          
             POP SI                          
             Ret                             
   Print_Score endp                          
                                             
  ;################### For Print Score       
   Print_Hi_Score Proc Near         ; convert score to
             PUSH SI                ;         10 base
             PUSH BP                ;         and print
             PUSH AX                                          
             PUSH BX                                  
             PUSH CX                               
             PUSH DX                               
             XOR AX,AX                             
             XOR CX,CX                             
             XOR DX,DX
             Call Print_Score
             Call Check_High_Score
             MOV SI,10                             
             MOV BP,word ptr Scr_Hi        ; low bit  => BP
             MOV BX,word ptr Scr_Hi+2      ; high bit => BX
    Nx_num:  MOV DX,0                      ; clear DX
             MOV AX,BX                     ; Do hight Bit                
             DIV SI                        ; div 10 
             MOV BX,AX                     ; hight bit in DX
             MOV AX,BP                     ; low bit in AX
             DIV SI                        ; div 10               
             PUSH DX                       ; I get one of number        
             MOV BP,AX                     ;       in answer
             INC CX                        ; add counter                 
             OR BP,BP                      ; has any number             
             JNE Nx_num                     
             OR BX,BX                                      
             JNE Nx_num                     
     Writ:   POP DX                        
             ADD DL,'0'                    ; convert to character
             MOV Num_score,DL              ; put one char in buffer                       
             Printf H_score 16 Num_score 2 ; print it !
             INC H_Score                   ; next position
             Loop Writ                     ; print by one character
             MOV AL,Def_h_sc                  
             MOV H_Score,AL                ; set default position
             POP DX                        ;     of score to next print
             POP CX                                                    
             POP BX                          
             POP AX                          
             POP BP                          
             POP SI                           
             Ret                             
   Print_Hi_Score endp

 ;################### For Show Picture UFO1 up
   Print_UFO1 Proc near
             PUSH X
             PUSH Y
             PUSH AX
             XOR AX,AX
             MOV AL,BYTE PTR UFO1
             MOV X,AX
             MOV Y,80
             CMP UFO1,140          ;UFO 1
             JE  Y140
             Put_Picture 20 20 Clear
             MOV UFO1,140
             JMP Put1
    Y140:    Put_Picture 20 20 Clear
             MOV UFO1,60
    Put1:    MOV AL,BYTE PTR UFO1
             MOV X,AX
             Put_Picture 20 20 Ufo
             POP AX
             POP Y
             POP X
             Ret
   Print_UFO1 endp

  ;################### For Show Picture UFO2 down
   Print_UFO2 Proc near
             PUSH X
             PUSH Y
             PUSH AX
             XOR AX,AX
             MOV AL,BYTE PTR UFO2
             MOV X,AX
             MOV Y,30                ;Y position
             CMP UFO2,80             ;UFO 2
             JE  Y80
             Put_Picture 20 20 Clear
             MOV UFO2,80
             JMP Put2
    Y80:     Put_Picture 20 20 Clear
             MOV UFO2,180            ;range
    Put2:    MOV AL,BYTE PTR UFO2
             MOV X,AX
             Put_Picture 20 20 UFO
             POP AX
             POP Y
             POP X
             Ret
   Print_UFO2 endp

  ;################### For Show Picture Chinjung down
   Print_UFO3 Proc near
             PUSH X
             PUSH Y
             PUSH AX
             XOR AX,AX
             MOV AL,BYTE PTR UFO3
             MOV X,AX
             MOV Y,100               ;Y position
             CMP UFO3,180            ;UFO 3
             JE  Y180
             Put_Picture 20 20 Clear
             MOV UFO3,180
             JMP Put3
    Y180:    Put_Picture 20 20 Clear
             MOV UFO3,240            ;range
    Put3:    MOV AL,BYTE PTR UFO3
             MOV X,AX
             Put_Picture 20 20 Chinjung
             POP AX
             POP Y
             POP X
             Ret
   Print_UFO3 endp

 ;#####################  For Show Picture Chinjung up
    Print_Chinjung Proc near
             PUSH X
             PUSH Y
             PUSH AX
             XOR AX,AX
             MOV AL,BYTE PTR Chin_j
             MOV X,AX
             MOV Y,60                ;Y position
             CMP Chin_j,40           ;Chinjung
             JE  Y40
             Put_Picture 20 20 Clear
             MOV Chin_j,40
             JMP PutJ
     Y40:    Put_Picture 20 20 Clear
             MOV Chin_j,210          ;range
    PutJ:    MOV AL,BYTE PTR Chin_j
             MOV X,AX
             Put_Picture 20 20 Chinjung
             POP AX
             POP Y
             POP X
             Ret
   Print_Chinjung endp

 ;################### For Refresh Screen When Ball Hit Picture
   Print_Ufo Proc near
             PUSH X
             PUSH Y
             PUSH AX
             XOR AX,AX
             MOV AL,byte ptr UFO1
             MOV X,AX
             MOV Y,80
             Put_Picture 20 20 Ufo       ;Refresh ufo1
             MOV AL,byte ptr UFO2
             MOV X,AX
             MOV Y,30
             Put_Picture 20 20 Ufo       ;Refresh ufo2
             MOV AL,byte ptr UFO3
             MOV X,AX
             MOV Y,100
             Put_Picture 20 20 Chinjung  ;Refresh Chinjung1
             MOV AL,byte ptr Chin_j
             MOV X,AX
             MOV Y,60
             Put_Picture 20 20 Chinjung  ;Refresh Chinjung2
             POP AX
             POP Y
             POP X
             Ret
   Print_Ufo endp

  ;################### For ball-- = 10  Score = Score+1000000
    Sell_Ball Proc near
             PUSH Freq
             MOV Freq,200
             Call Sound
             MOV Freq,700
             Call Sound
             MOV Freq,900
             Call Sound
             SUB Userball,10
             ADD word ptr Userscore,04240h  ; Score of User
             ADC word ptr Userscore+2,0Fh   ; Add Step / 100
             Printf 34 22 Equal 57      ;Write '='
             POP Freq
             Ret
    Sell_Ball endp

  ;################### Show Title And Set Default Of Game
    Game_Title Proc Near
             MOV X,0
             MOV Y,0
             Put_Picture 320 100 Clear
             MOV Y,100
             Put_Picture 320 100 Clear
             MOV X,0
             MOV Y,1
             MOV CX,16
   Putchin:  Put_Picture 20 20 Chinjung
             ADD X,20
             Loop Putchin
             MOV X,0
             MOV Y,180
             MOV CX,16
   Putufo:   Put_Picture 20 20 UFO
             ADD X,20
             Loop Putufo

             MOV CX,5                          ;3
             MOV X,40
             MOV Y,40
   Putbal:   Put_Picture 10 10 Ball
             ADD X,10
             Loop Putbal
             MOV CX,5
             MOV X,40
             MOV Y,100
   Pallbal:  Put_Picture 10 10 Ball
             ADD X,10
             Loop Pallbal
             MOV CX,3
             MOV X,60
             MOV Y,70
   Crsbald:  Put_Picture 10 10 Ball
             ADD X,10
             ADD Y,10
             Loop Crsbald
             MOV CX,3
             MOV X,60
             MOV Y,70
   Crsbalu:  Put_Picture 10 10 Ball
             ADD X,10
             SUB Y,10
             Loop Crsbalu

             MOV CX,5                        ;D
             MOV X,100
             MOV Y,60
   PutDl:    Put_Picture 10 10 Ball
             ADD Y,10
             Loop PutDl
             MOV CX,3
             MOV Y,60
   PutDCr:   Put_Picture 10 10 Ball
             ADD Y,10
             ADD X,10
             Loop PutDCr
             MOV CX,3
             MOV X,100
             MOV Y,100
   PutDCD:   Put_Picture 10 10 Ball
             SUB Y,10
             ADD X,10
             Loop PutDCD

             MOV X,160                   ;B
             MOV Y,90
             Put_Picture 5 17 Stone
             ADD X,7
             Put_Picture 10 10 Ball
             ADD Y,10
             Put_Picture 10 10 Ball

             MOV X,185                   ;A
             MOV Y,100
             MOV Charac,15
             Put_Picture 10 10 Ball
             ADD X,10
             Put_Picture 10 10 Ball
             SUB Y,10
             MOV X,190
             Put_Picture 10 10 Ball
             MOV X,213                   ;L
             MOV Y,80
             Put_Picture 5 27 Line       ;L
             MOV X,223
             Put_Picture 5 27 Line
             Printf 32 21 Vers 0Fh
             Printf 3 17 Tell 11H
             Printf 2 19 Escext 10h
      M_Clk: Call Check_Int_Key    ; check key input
             JNZ InKey             ; if keypressed check it
             MOV AX,0005h          ; else             
             XOR BX,BX             ; check click mouse           
             INT 33H               ;       any switch                     
             OR  AL,AL             ;       if click => start                 
             JZ  M_clk
             JMP NEsc
     InKey:  MOV AH,0              ;Read Keyboard Buffer
             INT 16h                                        
             CMP AH,1              ;If Key = Esc Then Exit  
             JNZ  NEsc
             JMP  End_game
     NEsc:   MOV X,0
             MOV Y,0
             Put_Picture 320 100 Clear
             MOV Y,100
             Put_Picture 320 100 Clear
 ;---------------------------------------------------- Set Default
             MOV _X,5
             MOV _Y,6
             MOV Ybar,3
             MOV Xbar,4
             Ret
   Game_Title endp
  ;################## For Save High Score
    Sav_Hi_Score Proc near
            Call Check_High_Score
            CMP Cg_HiSc,1           ;If User Play More
            JNE Nosav               ;   Than High Score
            Call Change_Hi_Score    ;   do save it!
     Nosav: MOV Cg_Hisc,0
            Ret
   Sav_Hi_Score endp
;------------------------------------------------------------------                      
;                      Start Main Program                                      
;------------------------------------------------------------------                      
    START:                                            
  ;============================================ Initial Zone
             MOV AX,DS              ; set ES to PSP
             MOV ES,AX              ;     for read Parameter                       
             MOV AX,DATA            ; set DS to DATA                        
             MOV DS,AX                                
             MOV AX,0000            ; Check Mouse Installed ?       
             INT 33H                                         
             CMP AX,0FFFFH          ; if not installed AX = 0000                    
             JZ  Begin                                          
             Call Clrscr            ; Tell No mouse Installed 
             MOV  Freq,400                                   
             Call Sound                                      
             MOV  Freq,793                     
             Call Sound                   
             Printf 1 1 No_Mouse 15                               
             JMP End_Game           ; Quit Program
   Begin:    Call Read_Parameter                       
             MOV AX,0013H           ; set mode screen              
             INT 10H                ; 320 x 200 , 256 color
             MOV AX,DATA                  
             MOV ES,AX                    
             MOV DX,offset pal      ; SetPalate For Ball 3D
             MOV CX,0040h           ; 64 Color            
             MOV BX,0                                              
             MOV AX,01012h          ; function set color    
             INT 10h                                    
             MOV AX,0A000H          ; address of video ram           
             MOV ES,AX              ; set extra segment
             Call Init_Mouse
   Newgame:  XOR AX,AX
             MOV AL,byte ptr MaxBall
             MOV UserBall,AX
             MOV word ptr UserScore,0
             MOV word ptr Userscore+2,0
             MOV Cg_Hisc,0

   ;============================================== Hint Game
             CMP MSG[0],'X'         ; Hint If name[1] = 'X'
             JNE NOx                ; do User Ball = 999 Ball
             MOV USERball,999
       NOx:  Call Game_Title
             Call Block             
             Printf 2 22 msg 16     
             Printf 15 22 score 17            
             Call Print_Score                           
             Call Set_Default_Ball                                 
             Call Start_Bar_Ball    
             Call Open_High_Score   
             Call Msg_Before_Play                       
             Call Set_Default_Mouse 

  ;====================================== Loop For play Ball
    Count:   Call Check_High_Score
             Call Print_ufo
             Call Check_Mouse_Mov
             Call TimeDelay                                        
             Put_Picture  10 10 Black                 
             CALL Check_Int_Key    ; If Key Press                  
             JNZ  Key              ; Check For Key Esc             
    Not_In:  Call Check_limit      ; If !(X || Y In Table) => !Direction
             PUSH Freq
             Call Check_Ufo_hit
             POP Freq
             Call Setxy            ; Set Address Of Ball
             CMP Restart,1         ; check for Restart             
             JNE No_rest           ; if Restart = 1 then restart   
             CMP UserBall,0                                        
             JLE KeyEsc                                            
             Call Prepare_New_Game
             Call Check_High_Score
             JMP Count                                             
    No_rest: Put_Picture  10 10 Ball ;if No Restart
             JMP COUNT                                             
                                                                    
  ;====================================== Check What Key Input?
    Key:     MOV AH,0              ;Read keyboard Buffer
             INT 16H                
             CMP AH,1              ;If Key == Esc Then Exit
             JNZ If_RiGt
             JMP Newgam
    If_RiGt: CMP AH,77             ;Else if Key == Right Then X++=10
             JNZ If_Left           ;Else if Key == Left Then X--=10
             Call Inc_Xbar
             JMP Not_In
   If_Left:  CMP AH,75                                                  
             JNZ If_Space                                          
             Call Dec_Xbar
             JMP Not_In
   If_space: CMP AH,57             ;Pause Game
             JNZ If_Enter
             Call Pause_Game
             JMP Not_In
   If_Enter: CMP AH,28
             CMP UserBall,15
             JNG No_sell
             Call Sell_Ball
             Call Total_Ball
             Call Check_High_Score
             Call Print_score
   No_sell:  JMP Not_In

  ;====================================== Return To Dos
   KeyEsc:   Call Clear_Table         ;If game over (ball =0)
             MOV Userball,0
             Call Total_Ball
             Call Table_Msg
             Printf 6 8 Gameover 10H
             Printf 5 10 KPress 89   ;Pause to Ready
             Printf 2 12 Escext 39
             Call Check_High_Score
             Call Show_High_Score
             Call Print_Score
             Call ReadKey
   Newgam:   Call Sav_Hi_Score       ; If Cg_Hisc do Save High Score
             JMP NewGame
   End_game: Call Sav_Hi_Score
             MOV AX,03H              ;Return to Text Mode
             INT 10H
             MOV AX,4C00H            ;Exit
             INT 21H                                                    
Code ends                                                               
     end start
                            
;----------------------------------------
