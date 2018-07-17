TITLE GAME :MINESWEEPER
        EXTRN RESETM:NEAR,SHOWM:NEAR,GETM:NEAR
        PUBLIC X_POS,Y_POS,X_TMP,Y_TMP
.MODEL SMALL
OPENGRAPH       MACRO
        PUSH AX

        MOV AX,0013H
        INT 10H

        POP AX
ENDM

CLOSEGRAPH      MACRO
        PUSH AX

        MOV AX,0002H
        INT 10H

        POP AX
ENDM

DOSEXIT         MACRO
        MOV     AH,4CH
        INT     21H
ENDM

OPENFILE        MACRO
        MOV     AH,3DH
        LEA     DX,FILESCORE
        MOV     AL,2
        INT     21H
        MOV     HANDLE,AX
ENDM

CLOSEFILE       MACRO
        MOV     AH,3EH
        MOV     BX,HANDLE
        INT     21H
ENDM

.STACK 100H
.DATA
FILESCORE       DB 'SCORE.DAT',0
HANDLE          DW ?
FILEBUFFER1     DB 200 DUP (0)
FILEBUFFER2     DB 20 DUP (0)
FILETITLE       DB 'TITLE.BMP',0
FILEHISCORE     DB 'HISCORE.BMP',0
FILEWIN         DB 'WIN.BMP',0
BMP_WIDTH	DW ?
BMP_HEIGHT	DW ?
BMP_BUFFER      DB 4 DUP (0)
BMP_COUNT	DW ?
BMP_X		DW ?
BMP_Y		DW ?

START_X         DW 40
START_Y         DW 60
HEIGHT          DB 6
WIDHT           DB 12

DATABLOCK       DB 0,0,0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0,0,0
                DB 0,0,0,0,0,0,0,0,0,0,0,0

DATACLICK DB 0,0,0,0,0,0,0,0,0,0,0,0
          DB 0,0,0,0,0,0,0,0,0,0,0,0
          DB 0,0,0,0,0,0,0,0,0,0,0,0
          DB 0,0,0,0,0,0,0,0,0,0,0,0
          DB 0,0,0,0,0,0,0,0,0,0,0,0
          DB 0,0,0,0,0,0,0,0,0,0,0,0

BOMBPOS DB 0
UPPOS   DW 0
DOWNPOS DW 0
LEFTPOS DW 0
RIGHTPOS DW 0

NUMBOMB DB 5
TMPCOUNT DB 5
NUMBLOCK  DB 72
GAMETIME DW 300
TIMETMP DB ?
SCORE   DW 0
BONUSSCORE DW 0

X_POS   DW ? 
Y_POS   DW ?
COL     DB ?
COLTMP  DB ?
X_TMP   DW ?
Y_TMP   DW ?
POINTER_X        DW ?

EXITGAME DB 0
NAMEPLAY        DB 18 DUP (' ')
NAMEBUFFER      DB 18 DUP (0),'$'
SCOREBUFFER     DW ?
MSGGETNAME      DB 'ENTER NAME : $'
COUNT   DB ?
LINE    DB ?
NUMSAVE DB 0
NUMSHOWSCORE DB ?

.CODE
MAIN    PROC
        MOV AX,@DATA
        MOV DS,AX
        MOV ES,AX

TITLE_:
        MOV     SCORE,0
        OPENGRAPH
        LEA     SI,FILETITLE
        MOV     BMP_X,0
        MOV     BMP_Y,0
        CALL    LOADBMP
        MOV     POINTER_X,29
        MOV     X_POS,29
        MOV     COL,82
        CALL    POINTER

GETKEYLOOP_:
        MOV     AH,0
        INT     16H
        CMP     AH,4BH
        JNE     NOTLEFT_
        MOV     AX,POINTER_X
        MOV     X_POS,AX
        MOV     COL,0
        CALL    POINTER
        CMP     POINTER_X,29
        JNE     SUBPOINTER_
        MOV     POINTER_X,146
        MOV     AX,POINTER_X
        MOV     X_POS,AX
        MOV     COL,82
        CALL    POINTER
        JMP     GETKEYLOOP_
SUBPOINTER_:
        MOV     POINTER_X,29
        MOV     AX,POINTER_X
        MOV     X_POS,AX
        MOV     COL,82
        CALL    POINTER
        JMP     GETKEYLOOP_
NOTLEFT_:
        CMP     AH,4DH
        JNE     NOTRIGHT_
        MOV     AX,POINTER_X
        MOV     X_POS,AX
        MOV     COL,0
        CALL    POINTER
        CMP     POINTER_X,29
        JNE     SUBPOINTER_
        MOV     POINTER_X,146
        MOV     AX,POINTER_X
        MOV     X_POS,AX
        MOV     COL,82
        CALL    POINTER
        JMP     GETKEYLOOP_
NOTRIGHT_:
        CMP     AH,01H
        JNE     NOTEXITGAME_
        JMP     EXITGAME_
NOTEXITGAME_:
        CMP     AH,1CH
        JE      ENTERGAME_
        JMP     GETKEYLOOP_

ENTERGAME_:
        OPENGRAPH

        CMP     POINTER_X,29
        JE      NEXTGAME_
        CALL    SHOWHISCORE
        JMP     TITLE_

NEXTGAME_:
        CALL    INITBOMB

        CALL    NEWBLOCK
        CALL    HEAD
        CALL    SHOWBOMB
        CALL    SHOWTIME
        CALL    SHOWSCORE

        CALL    RESETM
        CALL    SHOWM
        MOV     AH,2CH
        INT     21H
        MOV     TIMETMP,DH

LOCATE:
        MOV     AX,05H
        INT     33H
        CMP     BX,0
        JNE     THENCLICK_

        MOV     AH,2CH
        INT     21H
        CMP     DH,TIMETMP
        JE      NOTSETTIME
        CALL    SHOWTIME
        MOV     TIMETMP,DH
NOTSETTIME:
        JMP     LOCATE

THENCLICK_:
        MOV X_TMP,CX
        MOV Y_TMP,DX

        SHR CX,1
        MOV X_POS,CX
        MOV Y_POS,DX

        CALL    CHKCLICK

        CALL    SHOWSCORE

        MOV     BL,NUMBOMB
        CMP     NUMBLOCK,BL
        JG      NOTWIN_

WAITCLICK3_:
        MOV     AX,05H
        INT     33H
        CMP     BX,0
        JE      WAITCLICK3_

        CALL    SHOWWIN

WAITCLICK1_:
        MOV     AX,05H
        INT     33H
        CMP     BX,0
        JE      WAITCLICK1_
        JMP     NEXTGAME_
NOTWIN_:
        CMP     EXITGAME,1
        JE      WAITCLICK2_
        JMP     LOCATE

WAITCLICK2_:
        MOV     AX,05H
        INT     33H
        CMP     BX,0
        JE      WAITCLICK2_

        CALL    GETNAME
EXITGAME_:
        CLOSEGRAPH
        DOSEXIT
MAIN    ENDP

NEWBLOCK        PROC

        MOV     X_POS,0
        MOV     Y_POS,0

        MOV  COL,15
        CALL BORDER

        MOV AX,START_X
        MOV BX,START_Y
        MOV CH,WIDHT
        MOV CL,HEIGHT

ROW1:
        MOV X_POS,AX
        MOV Y_POS,BX
        CALL BLOCK
        ADD AX,20
        DEC CH
        JNZ ROW1
        MOV AX,START_X
        ADD BX,20
        MOV CH,WIDHT
        DEC CL
        JNZ ROW1
        RET
NEWBLOCK        ENDP

INITBOMB PROC
        MOV     NUMBLOCK,72
        ADD     NUMBOMB,5
        MOV     AL,NUMBOMB
        MOV     TMPCOUNT,AL
        MOV     GAMETIME,300
        MOV     UPPOS,0
        MOV     DOWNPOS,0
        MOV     LEFTPOS,0
        MOV     RIGHTPOS,0

        XOR     BX,BX
CLEARBOMB_:
        MOV     [DATABLOCK+BX],0
        MOV     [DATACLICK+BX],0
        INC     BX
        CMP     BX,71
        JLE     CLEARBOMB_

INITBOMBLP_:
;=====RANDOM BOMB========
        MOV AH,2CH
        INT 21H
        XOR     DL,DH
        CMP DL,71
        JG  INITBOMBLP_
        XOR DH,DH
        MOV BX,DX
        CMP [DATABLOCK+BX],9
        JE  INITBOMBLP_
        MOV [DATABLOCK+BX],9

        CMP BX,11
        JLE INITLP1_
        SUB BX,12
        MOV UPPOS,1
        CMP [DATABLOCK+BX],9
        JE  INITLP1_
        ADD [DATABLOCK+BX],1
INITLP1_:
        MOV BX,DX
        CMP BX,59
        JG  INITLP2_
        ADD BX,12
        MOV DOWNPOS,1
        CMP [DATABLOCK+BX],9
        JE  INITLP2_
        ADD [DATABLOCK+BX],1
INITLP2_:
        MOV BX,DX
        MOV AX,BX
        MOV CL,12
        DIV CL
        CMP AH,0
        JE  INITLP3_
        DEC BX
        MOV LEFTPOS,1
        CMP [DATABLOCK+BX],9
        JE  INITLP3_
        ADD [DATABLOCK+BX],1
INITLP3_:
        MOV BX,DX
        MOV AX,BX
        INC AX
        MOV CL,12
        DIV CL
        CMP AH,0
        JE  INITLP4_
        INC BX
        MOV RIGHTPOS,1
        CMP [DATABLOCK+BX],9
        JE  INITLP4_
        ADD [DATABLOCK+BX],1
INITLP4_:
        MOV BX,DX
        CMP UPPOS,1
        JE  INITLP5_
        JMP INITLP9_
INITLP5_:
        CMP LEFTPOS,1
        JE  INITLP6_
        JMP INITLP12_
INITLP6_:
        CMP [DATABLOCK+BX-13],9
        JE  INITLP12_
        ADD [DATABLOCK+BX-13],1
INITLP12_:
        CMP RIGHTPOS,1
        JE  INITLP7_
        JMP INITLP8_
INITLP7_:
        CMP [DATABLOCK+BX-11],9
        JE  INITLP8_
        ADD [DATABLOCK+BX-11],1
INITLP8_:
        CMP DOWNPOS,1
        JE  INITLP9_
        JMP ENDINIT_
INITLP9_:
        CMP LEFTPOS,1
        JE  INITLP10_
        JMP INITLP13_
INITLP10_:
        CMP [DATABLOCK+BX+11],9
        JE  INITLP13_
        ADD [DATABLOCK+BX+11],1
INITLP13_:
        CMP RIGHTPOS,1
        JE  INITLP11_
        JMP ENDINIT_
INITLP11_:
        CMP [DATABLOCK+BX+13],9
        JE  ENDINIT_
        ADD [DATABLOCK+BX+13],1
ENDINIT_:
        MOV UPPOS,0
        MOV DOWNPOS,0
        MOV LEFTPOS,0
        MOV RIGHTPOS,0
        DEC TMPCOUNT
        JZ  ENDINITBOMB_
        JMP INITBOMBLP_
ENDINITBOMB_:
        RET
INITBOMB ENDP

CHKCLICK PROC
C1X_WHILE:
        CMP X_POS,40
        JGE C1X_NEXT1
        JMP RETURN_
C1X_NEXT1:
        CMP X_POS,60
        JGE C1X_NEXT2
        MOV X_POS,40
        MOV BOMBPOS,0
        JMP C1Y_WHILE
C1X_NEXT2:
        CMP X_POS,80
        JGE C1X_NEXT3
        MOV X_POS,60
        MOV BOMBPOS,1
        JMP C1Y_WHILE
C1X_NEXT3:
        CMP X_POS,100
        JGE C1X_NEXT4
        MOV X_POS,80
        MOV BOMBPOS,2
        JMP C1Y_WHILE
C1X_NEXT4:
        CMP X_POS,120
        JGE C1X_NEXT5
        MOV X_POS,100
        MOV BOMBPOS,3
        JMP C1Y_WHILE
C1X_NEXT5:
        CMP X_POS,140
        JGE C1X_NEXT6
        MOV X_POS,120
        MOV BOMBPOS,4
        JMP C1Y_WHILE
C1X_NEXT6:
        CMP X_POS,160
        JGE C1X_NEXT7
        MOV X_POS,140
        MOV BOMBPOS,5
        JMP C1Y_WHILE
C1X_NEXT7:
        CMP X_POS,180
        JGE C1X_NEXT8
        MOV X_POS,160
        MOV BOMBPOS,6
        JMP C1Y_WHILE
C1X_NEXT8:
        CMP X_POS,200
        JGE C1X_NEXT9
        MOV X_POS,180
        MOV BOMBPOS,7
        JMP C1Y_WHILE
C1X_NEXT9:
        CMP X_POS,220
        JGE C1X_NEXT10
        MOV X_POS,200
        MOV BOMBPOS,8
        JMP C1Y_WHILE
C1X_NEXT10:
        CMP X_POS,240
        JGE C1X_NEXT11
        MOV X_POS,220
        MOV BOMBPOS,9
        JMP C1Y_WHILE
C1X_NEXT11:
        CMP X_POS,260
        JGE C1X_NEXT12
        MOV X_POS,240
        MOV BOMBPOS,10
        JMP C1Y_WHILE
C1X_NEXT12:
        CMP X_POS,280
        JLE C1X_NEXT13
        JMP RETURN_
C1X_NEXT13:
        MOV X_POS,260
        MOV BOMBPOS,11
C1Y_WHILE:
        CMP Y_POS,60
        JGE C1Y_NEXT1
        JMP RETURN_
C1Y_NEXT1:
        CMP Y_POS,80
        JGE C1Y_NEXT2
        MOV Y_POS,60
        ADD BOMBPOS,0
        JMP BLOCKING_
C1Y_NEXT2:
        CMP Y_POS,100
        JGE C1Y_NEXT3
        MOV Y_POS,80
        ADD BOMBPOS,12
        JMP BLOCKING_
C1Y_NEXT3:
        CMP Y_POS,120
        JGE C1Y_NEXT4
        MOV Y_POS,100
        ADD BOMBPOS,24
        JMP BLOCKING_
C1Y_NEXT4:
        CMP Y_POS,140
        JGE C1Y_NEXT5
        MOV Y_POS,120
        ADD BOMBPOS,36
        JMP BLOCKING_
C1Y_NEXT5:
        CMP Y_POS,160
        JGE C1Y_NEXT6
        MOV Y_POS,140
        ADD BOMBPOS,48
        JMP BLOCKING_
C1Y_NEXT6:
        CMP Y_POS,180
        JLE C1Y_NEXT7
        JMP RETURN_
C1Y_NEXT7:
        MOV Y_POS,160
        ADD BOMBPOS,60
BLOCKING_:
        XOR     BX,BX
        MOV     BL,BOMBPOS
        CMP     [DATACLICK+BX],1
        JE      RETURN_

        PUSH X_TMP
        PUSH Y_TMP
        MOV AX,X_POS
        SHL AX,1
        MOV X_TMP,AX
        MOV AX,Y_POS
        MOV Y_TMP,AX
        CALL GETM

        CMP [DATABLOCK+BX],9
        JE  ISBOMB_
        JMP NOTBOMB_
ISBOMB_:
        CALL    BLOCKBOMB
        MOV     EXITGAME,1
        JMP     ENDCHKCLICK_
NOTBOMB_:
        MOV     BONUSSCORE,0
        CALL    OPENBLOCK
ENDCHKCLICK_:
        CALL RESETM
        CALL SHOWM
        POP Y_TMP
        POP X_TMP
        CALL GETM

RETURN_:
        RET
CHKCLICK ENDP

OPENBLOCK PROC
        PUSH    X_POS
        PUSH    Y_POS

        CMP     [DATACLICK+BX],1
        JNE     UNCLICK_
        JMP     ENDOPEN_

UNCLICK_:
        INC     BONUSSCORE
        MOV     AX,BONUSSCORE
        MOV     CL,10
        MUL     CL
        ADD     SCORE,AX
        DEC     NUMBLOCK

        MOV     [DATACLICK+BX],1
        CMP     [DATABLOCK+BX],1
        JNE     BOMBNX1_
        CALL    BLOCK1
        JMP     ENDOPEN_
BOMBNX1_:
        CMP     [DATABLOCK+BX],2
        JNE     BOMBNX2_
        CALL    BLOCK2
        JMP     ENDOPEN_
BOMBNX2_:        
        CMP [DATABLOCK+BX],3
        JNE BOMBNX3_
        CALL BLOCK3
        JMP ENDOPEN_
BOMBNX3_:
        CMP [DATABLOCK+BX],4
        JNE BOMBNX4_
        CALL BLOCK4
        JMP ENDOPEN_
BOMBNX4_:
        CMP [DATABLOCK+BX],5
        JNE BOMBNX5_
        CALL BLOCK5
        JMP ENDOPEN_
BOMBNX5_:
        CMP [DATABLOCK+BX],6
        JNE BOMBNX6_
        CALL BLOCK6
        JMP ENDOPEN_
BOMBNX6_:
        CMP [DATABLOCK+BX],7
        JNE BOMBNX7_
        CALL BLOCK7
        JMP ENDOPEN_
BOMBNX7_:
        CMP [DATABLOCK+BX],8
        JNE BOMBNX8_
        CALL BLOCK8
        JMP ENDOPEN_
BOMBNX8_:
        CALL    BLOCKING
;CHECK BLOCK BY RECURSIVE
        CMP     BX,11
        JLE     OPENLP1_
        SUB     BX,12
        SUB     Y_POS,20
        CALL    OPENBLOCK
        ADD     BX,12
        ADD     Y_POS,20
OPENLP1_:
        CMP     BX,60
        JGE     OPENLP2_
        ADD     BX,12
        ADD     Y_POS,20
        CALL    OPENBLOCK
        SUB     BX,12
        SUB     Y_POS,20
OPENLP2_:
        MOV     AX,BX
        MOV     CL,12
        DIV     CL
        CMP     AH,0
        JE      OPENLP3_
        DEC     BX
        SUB     X_POS,20
        CALL    OPENBLOCK
        INC     BX
        ADD     X_POS,20
OPENLP3_:
        MOV     AX,BX
        ADD     AX,1
        MOV     CL,12
        DIV     CL
        CMP     AH,0
        JE      OPENLP4_
        INC     BX
        ADD     X_POS,20
        CALL    OPENBLOCK
        DEC     BX
        SUB     X_POS,20
OPENLP4_:
        CMP     BX,11
        JG      OPENLP5_
        JMP     OPENLP9_
OPENLP5_:
        MOV     AX,BX
        MOV     CL,12
        DIV     CL
        CMP     AH,0
        JNE     OPENLP6_
        JMP     OPENLP12_
OPENLP6_:
        SUB     BX,13
        SUB     X_POS,20
        SUB     Y_POS,20
        CALL    OPENBLOCK
        ADD     BX,13
        ADD     X_POS,20
        ADD     Y_POS,20
OPENLP12_:
        MOV     AX,BX
        ADD     AX,1
        MOV     CL,12
        DIV     CL
        CMP     AH,0
        JNE     OPENLP7_
        JMP     OPENLP8_
OPENLP7_:
        SUB     BX,11
        ADD     X_POS,20
        SUB     Y_POS,20
        CALL    OPENBLOCK
        ADD     BX,11
        SUB     X_POS,20
        ADD     Y_POS,20
OPENLP8_:
        CMP     BX,60
        JL      OPENLP9_
        JMP     ENDOPEN_
OPENLP9_:
        MOV     AX,BX
        MOV     CL,12
        DIV     CL
        CMP     AH,0
        JNE     OPENLP10_
        JMP     OPENLP13_
OPENLP10_:
        ADD     BX,11
        SUB     X_POS,20
        ADD     Y_POS,20
        CALL    OPENBLOCK
        SUB     BX,11
        ADD     X_POS,20
        SUB     Y_POS,20
OPENLP13_:
        MOV     AX,BX
        ADD     AX,1
        MOV     CL,12
        DIV     CL
        CMP     AH,0
        JNE     OPENLP11_
        JMP     ENDOPEN_
OPENLP11_:
        ADD     BX,13
        ADD     X_POS,20
        ADD     Y_POS,20
        CALL    OPENBLOCK
        SUB     BX,13
        SUB     X_POS,20
        SUB     Y_POS,20
ENDOPEN_:
        POP     Y_POS
        POP     X_POS
        RET
OPENBLOCK       ENDP

SHOWBOMB        PROC
        PUSH    X_POS
        PUSH    Y_POS

        MOV     X_POS,75
        MOV     Y_POS,33
        CALL    CLRNUM
        MOV     X_POS,87
        MOV     Y_POS,33
        CALL    CLRNUM

        MOV     X_POS,75
        MOV     Y_POS,33
        MOV     COL,0
        XOR     AX,AX
        MOV     AL,NUMBOMB
        CALL    OUTNUM

        POP     Y_POS
        POP     X_POS
        RET
SHOWBOMB        ENDP

SHOWTIME        PROC
        PUSH    X_POS
        PUSH    Y_POS

        MOV     X_POS,126
        MOV     Y_POS,33
        CALL    CLRNUM
        MOV     X_POS,138
        MOV     Y_POS,33
        CALL    CLRNUM
        MOV     X_POS,150
        MOV     Y_POS,33
        CALL    CLRNUM

        MOV     AX,GAMETIME
        MOV     X_POS,126
        MOV     Y_POS,33
        MOV     COL,4
        CALL    OUTNUM
        DEC     GAMETIME

        POP     Y_POS
        POP     X_POS
        RET
SHOWTIME        ENDP

SHOWSCORE       PROC
        PUSH    X_POS
        PUSH    Y_POS

        MOV     X_POS,215
        MOV     Y_POS,20
        CALL    CLRNUM
        MOV     X_POS,227
        MOV     Y_POS,20
        CALL    CLRNUM
        MOV     X_POS,239
        MOV     Y_POS,20
        CALL    CLRNUM
        MOV     X_POS,251
        MOV     Y_POS,20
        CALL    CLRNUM
        MOV     X_POS,263
        MOV     Y_POS,20
        CALL    CLRNUM

        MOV     X_POS,215
        MOV     Y_POS,20
        MOV     COL,1
        MOV     AX,SCORE
        CALL    OUTNUM

        POP     Y_POS
        POP     X_POS
        RET
SHOWSCORE       ENDP

OUTNUM          PROC
        PUSH    BX
        PUSH    CX
        PUSH    DX              

        MOV     CL,COL
        MOV     COLTMP,CL
;get decimal digits
        XOR     CX,CX           ;CX counts digits                 
        MOV     BX,10D          ;BX has divisor
REPEAT1:
        XOR     DX,DX           ;prepare high part of dividend  
        DIV     BX              ;AX = quotient, DX = remainder
        PUSH    DX              ;save remainder on stack
        INC     CX              ;count = count + 1
;until
        OR      AX,AX           ;quotient = 0?
        JNE     REPEAT1        ;no, keep going
;convert digits to picture and print
        MOV     BX,X_POS
;for count times do
        MOV     BX,Y_POS
PRINT_LOOP:
        MOV     Y_POS,BX
        MOV     AL,COLTMP
        MOV     COL,AL
        POP     DX              ;digit in DL
        CMP     DX,1
        JNE     NOTNUM1_
        CALL    NUM1
        JMP     NEXTNUM_
NOTNUM1_:
        CMP     DX,2
        JNE     NOTNUM2_
        CALL    NUM2
        JMP     NEXTNUM_
NOTNUM2_:
        CMP     DX,3
        JNE     NOTNUM3_
        CALL    NUM3
        JMP     NEXTNUM_
NOTNUM3_:
        CMP     DX,4
        JNE     NOTNUM4_
        CALL    NUM4
        JMP     NEXTNUM_
NOTNUM4_:
        CMP     DX,5
        JNE     NOTNUM5_
        CALL    NUM5
        JMP     NEXTNUM_
NOTNUM5_:
        CMP     DX,6
        JNE     NOTNUM6_
        CALL    NUM6
        JMP     NEXTNUM_
NOTNUM6_:
        CMP     DX,7
        JNE     NOTNUM7_
        CALL    NUM7
        JMP     NEXTNUM_
NOTNUM7_:
        CMP     DX,8
        JNE     NOTNUM8_
        CALL    NUM8
        JMP     NEXTNUM_
NOTNUM8_:
        CMP     DX,9
        JNE     NOTNUM9_
        CALL    NUM9
        JMP     NEXTNUM_
NOTNUM9_:
        CALL    NUM0
NEXTNUM_:
        DEC     CX
        JZ      ENDOUTNUM_
        JMP     PRINT_LOOP     ;loop until done
ENDOUTNUM_:
;end_for
        POP     DX              ;restore registers
        POP     CX
        POP     BX
        RET
OUTNUM  ENDP

GETNAME PROC
        CALL    INAME
        MOV     AH,2H
        MOV     BH,0
        MOV     DH,12
        MOV     DL,7
        INT     10H
        MOV     AH,9
        LEA     DX,MSGGETNAME
        INT     21H

        MOV     AH,2H
        MOV     BH,0
        MOV     DH,12
        MOV     DL,20
        INT     10H

        XOR     BX,BX

        MOV     AH,1
GETNAMELP_:
        INT     21H
        CMP     AL,0DH
        JE      ENDGETNAME_
        MOV     [NAMEPLAY+BX],AL
        INC     BX
        JMP     GETNAMELP_
ENDGETNAME_:
        OPENFILE
        CLD
        LEA     DI,FILEBUFFER1
        MOV     NUMSAVE,0
NEXTSAVE3_:
        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,18
        LEA     DX,NAMEBUFFER
        INT     21H

        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,2
        LEA     DX,SCOREBUFFER
        INT     21H

        MOV     AX,SCOREBUFFER
        CMP     SCORE,AX
        JGE     NEXTSAVE1_

        INC     NUMSAVE
        LEA     SI,NAMEBUFFER
        MOV     CX,18
        REP     MOVSB
        MOV     AX,SCOREBUFFER
        STOSW
        CMP     NUMSAVE,10
        JNE     NEXTSAVE3_
        JMP     ENDSAVE_
NEXTSAVE1_:
        INC     NUMSAVE
        LEA     SI,NAMEPLAY
        MOV     CX,18
        REP     MOVSB
        MOV     AX,SCORE
        STOSW

        CMP     NUMSAVE,10
        JNE     NEXTSAVE2_
        JMP     ENDSAVE_
NEXTSAVE2_:
        INC     NUMSAVE
        LEA     SI,NAMEBUFFER
        MOV     CX,18
        REP     MOVSB
        MOV     AX,SCOREBUFFER
        STOSW

        CMP     NUMSAVE,10
        JE      ENDSAVE_

NEXTSAVE4_:
        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,18
        LEA     DX,NAMEBUFFER
        INT     21H

        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,2
        LEA     DX,SCOREBUFFER
        INT     21H

        INC     NUMSAVE
        LEA     SI,NAMEBUFFER
        MOV     CX,18
        REP     MOVSB
        MOV     AX,SCOREBUFFER
        STOSW

        CMP     NUMSAVE,10
        JE      ENDSAVE_
        JMP     NEXTSAVE4_

ENDSAVE_:
        MOV     AH,42H
        MOV     AL,0
        MOV     BX,HANDLE
        XOR     CX,CX
        XOR     DX,DX
        INT     21H

        MOV     AH,40H
        MOV     BX,HANDLE
        MOV     CX,200
        LEA     DX,FILEBUFFER1
        INT     21H
        CLOSEFILE
        RET
GETNAME ENDP

SHOWHISCORE     PROC

        LEA     SI,FILEHISCORE
        MOV     BMP_X,0
        MOV     BMP_Y,0
        CALL    LOADBMP

        OPENFILE

        MOV     NUMSHOWSCORE,30H
        MOV     COUNT,10
        MOV     LINE,9
HISCORELOOP_:
        INC     NUMSHOWSCORE
        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,18
        LEA     DX,NAMEBUFFER
        INT     21H

        MOV     AH,2H
        MOV     BH,0
        MOV     DH,LINE
        MOV     DL,6
        INT     10H

        CMP     NUMSHOWSCORE,3AH
        JNE     IS1_9
        MOV     AH,2H
        MOV     BH,0
        MOV     DH,LINE
        MOV     DL,5
        INT     10H
        MOV     AH,2
        MOV     DL,'1'
        INT     21H
        MOV     DL,'0'
        INT     21H
        MOV     DL,'.'
        INT     21H
        MOV     DL,' '
        INT     21H
        JMP     SHOWNAME_
IS1_9:
        MOV     AH,2
        MOV     DL,NUMSHOWSCORE
        INT     21H
        MOV     DL,'.'
        INT     21H
        MOV     DL,' '
        INT     21H

SHOWNAME_:
        MOV     AH,2H
        MOV     BH,0
        MOV     DH,LINE
        MOV     DL,9
        INT     10H

        MOV     AH,9
        LEA     DX,NAMEBUFFER
        INT     21H

        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,2
        LEA     DX,SCORE
        INT     21H

        MOV     AH,2H
        MOV     BH,0
        MOV     DH,LINE
        MOV     DL,27
        INT     10H

        MOV     AX,SCORE
        CALL    OUTDEC

        INC     LINE

        DEC     COUNT
        JZ      ENDHISCORE_
        JMP     HISCORELOOP_
ENDHISCORE_:
        MOV     AH,1
        INT     21H
        CLOSEFILE
        
        RET
SHOWHISCORE     ENDP

SHOWWIN         PROC
        CALL    WINBG

        MOV     X_POS,200
        MOV     Y_POS,96
        MOV     COL,1
        MOV     AX,SCORE
        CALL    OUTNUM

        MOV     X_POS,200
        MOV     Y_POS,115
        MOV     COL,4
        MOV     AX,GAMETIME
        CALL    OUTNUM

        MOV     X_POS,200
        MOV     Y_POS,135
        MOV     COL,15
        MOV     AX,GAMETIME
        INC     AX
        ADD     SCORE,AX
        MOV     AX,SCORE
        CALL    OUTNUM

        RET
SHOWWIN         ENDP

INCLUDE OUTDEC.ASM
INCLUDE GRAPH.ASM
END
