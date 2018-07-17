TITLE   PROJECT ASM  4840540175
;WIRACHAI THANANUNTAVASIN


.MODEL  SMALL
INCLUDE	MACRO.ASM
.STACK  100H
.DATA
;FILE
        FILESCORE       DB      'SCORE.BIN',0
        HANDLE          DW      ?

;PICTURE
        TITLE_PIC       DB      'IMG\TITLE.BMP',0
        MENU_PIC        DB      'IMG\MENU1.BMP',0
        LOADING         DB      'IMG\LOADING.BMP',0
        BG_PIC          DB      'IMG\BG.BMP',0
        B               DB      'IMG\BLOCK0.BMP',0
        C               DB      'IMG\CLICK0.BMP',0
        P               DB      'IMG\P00.BMP',0
        T               DB      'IMG\T00.BMP',0
        EMTPY           DB      'IMG\EMTPY.BMP',0
        ENTERNAME       DB      'IMG\EN.BMP',0
        SCORE_PIC       DB      'IMG\SCORE.BMP',0
        HOWTO           DB      'IMG\HOWTO.BMP',0

        LEN_X           DW      28
        LEN_Y           DW      10
        SIZE_BLOCK      DW      18

;LOADBMP
        BMP_WIDTH       DW      ?     
        BMP_HEIGHT      DW      ?     
        BMP_BUFFER      DB      4 DUP(?) 
        BMP_COUNT       DW      ?     
        BMP_X           DW      ?     
        BMP_Y           DW      ?

;VARIABLES
        BLO_DATA        DB      0,0,0,0,0,0,0,0,0,0     ;10X10
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0

        BLO_STR         DB      0,0,0,0,0,0,0,0,0,0     ;10X10
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0
                        DB      0,0,0,0,0,0,0,0,0,0

        NAME_REC        DB      11 DUP(10 DUP(0))
        SCORE_REC       DW      11 DUP(0)               ; 11 RECORD
        NAME_           DB      10 DUP(0),'$'
        SCORE           DW      0

        NUM             DW      0
        NUM2            DW      0

        MENU            DB      1

        POINT           DB      0
        SUM_POINT       DB      0
       
        MOU_CLICK       DW      ?         
        BLOCK_NUM       DW      ?
        COUNT_CLEAR     DW      0
        NCOUNT_CLEAR    DW      0

        CURRENT_TIME    DB      0
        GATE_TIME       DB      0

        BONUS           DW      0       
.CODE

MAIN    PROC
        MOV     AX,@DATA
        MOV     DS,AX
        MOV     ES,AX           ;INITIALIZE DS,ES

;CHANGE DISPLAY MODE TO GRAPHIC
        MOV     AX,0013H
        INT     10H

        MOV     MENU,1
MENU_:
        PASTEBMP 0,0,TITLE_PIC
        
        CLD     
        LEA     DI,MENU_PIC[8]
        MOV     AL,"0"
        CMP     MENU,2
        JE      MENU2_
        CMP     MENU,1
        JE      MENU1_
        INC     AL
MENU2_:
        INC     AL
MENU1_:
        INC     AL
        STOSB
        PASTEBMP 112,110,MENU_PIC

        MOV     AH,0            ;CHECK KEYBOARD
        INT     16H

        CMP     AL,1BH          ;ESC?
        JE      EXIT_GAME1
        CMP     AL,0DH          ;ENTER?
        JE      CHECK_MENU

        CMP     AH,48H          ;ARROW UP KEY AND MENU > 1?
        JNE     NOTUP_
        CMP     MENU,1
        JLE     MENU_
        DEC     MENU
NOTUP_:
        CMP     AH,50H          ;ARROW DOWN KEY AND MENU < 3?
        JNE     MENU_
        CMP     MENU,3
        JGE     MENU_
        INC     MENU
        JMP     MENU_

CHECK_MENU:
        CMP     MENU,2
        JL      GAME_
        JE      SCORE_
        JG      HOW_TO

SCORE_:
        CALL    DISP_SCORE
        CALL    DELAY
        JMP     MENU_
HOW_TO:
        PASTEBMP 0,0,HOWTO
        CALL    DELAY
        MOV     AH,1
        INT     21H
        JMP     MENU_
EXIT_GAME1:
        JMP     EXIT_GAME

; ############### GAME ###############
GAME_:

        PASTEBMP 0,0,LOADING

        CALL    RANDOM
        CALL    RESET_MOUSE 
        CALL    SHOW_MOUSE
        CALL    DRAW
        CALL    RANPOINT                
        MOV     SCORE,0
        MOV     BONUS,100
        MOV     SUM_POINT,0
        CALL    GET_TIME
MAIN_LOOP_:
        MOV     AH,1            ;CHECK KEYBOARD
        INT     16H
        CMP     AL,1BH          ;ESC?
        JE      EXIT_MAIN_LOOP

SCORE_DISPLAY:
        CALL    TIME_RATE

        CALL    CHECK_BONUS

        CMP     BONUS,0
        JLE     EXIT_MAIN_LOOP

        GOTOXY  31,21
        MOV     AX,SCORE
        CALL    OUTDEC

;MOUSE
        CALL    RIGHTCLICK      ;RIGHT CLICK FOR UNDO BLOCK?
        CALL    CHKMOUSE
        CMP     MOU_CLICK,1     ;MOUSE BLICK ON TABLE?
        JL      CANT_CLICK
;MOV     AX,BLOCK_NUM
;CALL    OUTDEC
        MOV     BX,BLOCK_NUM
        CMP     BLO_STR[BX],0   ;STATUS BLOCK[BX] = 0?
        JG      CANT_CLICK

        CALL    CHK_CLICK

        CMP     NCOUNT_CLEAR,99
        JGE     EXIT_MAIN_LOOP

CANT_CLICK:
        JMP     MAIN_LOOP_

EXIT_MAIN_LOOP:

        CALL    GET_NAME
        JMP     MENU_
EXIT_GAME:
        MOV     CH,12
        MOV     CL,19
        MOV     DH,12
        MOV     DL,19

EXIT_LOOP:        
        MOV     AX,0700H
        MOV     BH,0
        INT     10H
        DEC     CH
        DEC     CL
        INC     DH
        INC     DL
        CALL    DELAY
        CALL    DELAY
        CMP     DL,60
        JL      EXIT_LOOP

        GOTOXY  19,10
        DISP_STR 'By'
        GOTOXY  6,12
        DISP_STR 'Mr.Wirachai  Thananuntavasin'
        GOTOXY  7,14
        DISP_STR '4840540175      CSs1RA'
        MOV     AH,1
        INT     21H
;EXIT TO DOS AND CHANGE DISPLAY MODE TO TEXT MODE
        MOV     AH,00H
        MOV     AL,03H
        INT     10H

        MOV     AH,4CH
        INT     21H
MAIN    ENDP

GET_NAME        PROC
        PUSHR

        LEA     DI,T[5]
        MOV     AL,"0"
        STOSB
        STOSB
        PASTEBMP 235,96,T

        CALL    HIDE_MOUSE
        PASTEBMP 37,83,ENTERNAME

        MOV     CX,10           ;CLEAR NAME
        LEA     DI,NAME_
        MOV     AL,0
        REP     STOSB

        GOTOXY  14,12
        XOR     CX,CX
        CLD
        LEA     DI,NAME_
        MOV     AH,1
INPUT_LOOP:
        INT     21H
        CMP     AL,0DH
        JE      EXIT_INPUT
        CMP     AL,8
        JE      BACKSPACE_
        CMP     CX,10
        JGE     NOT_STORE
        STOSB
        INC     CX
NOT_STORE:
        JMP     INPUT_LOOP
BACKSPACE_:
        MOV     CX,10           ;CLEAR NAME
        LEA     DI,NAME_
        MOV     AL,0
        REP     STOSB     

        XOR     CX,CX           ;CLEAR SCREEN
        LEA     DI,NAME_
        GOTOXY  14,12
        DISP_STR '          '
        GOTOXY  14,12
       
        JMP     INPUT_LOOP
EXIT_INPUT:
        CMP     CX,0
        JE      INPUT_LOOP

        CALL    READ_DATA               ;READ DATA 10 RECORD FROM FILE

        MOV     AX,SCORE                ;STORE DATA IN RECORD 11
        MOV     SCORE_REC[20],AX
        LEA     SI,NAME_
        LEA     DI,NAME_REC[100]
        MOV     CX,10
        REP     MOVSB
                                        
        CALL    SORT_                   ;SORT DATA

        CALL    WRITE_DATA              ;WRITE DATA 10 RECORD TO FILE

        CALL    DISP_SCORE

        POPR
        RET
GET_NAME        ENDP

DISP_SCORE      PROC
        PUSHR

        CALL    READ_DATA

        PASTEBMP 0,0,SCORE_PIC

        XOR     AX,AX
        XOR     BX,BX
LOOP_SCORE:
        INC     AX
        XOR     CX,CX
        MOV     CL,AL
        ADD     CL,9
        RGOTOXY 7,CL
        CALL    OUTDEC

        PUSHR
        RGOTOXY 12,CL

        DEC     AX
        MOV     BX,10
        MUL     BX
        MOV     BX,AX

        LEA     SI,NAME_REC[BX]
        LEA     DI,NAME_
        MOV     CX,10
        REP     MOVSB

        MOV     AH,09
        LEA     DX,NAME_
        INT     21H

        POPR

        PUSHR
        RGOTOXY 28,CL
        MOV     AX,SCORE_REC[BX]
        CALL    OUTDEC

        POPR
        ADD     BX,2
        CMP     AX,10
        JL      LOOP_SCORE

        MOV     AH,1
        INT     21H

        POPR
        RET
DISP_SCORE      ENDP

READ_DATA       PROC
        PUSHR
        OPENFILE
        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,100
        LEA     DX,NAME_REC
        INT     21H

        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,20
        LEA     DX,SCORE_REC
        INT     21H

        CLOSEFILE
        POPR
        RET
READ_DATA       ENDP

WRITE_DATA      PROC
        PUSHR
        OPENFILE
        MOV     AH,40H
        MOV     BX,HANDLE
        MOV     CX,100
        LEA     DX,NAME_REC
        INT     21H

        MOV     AH,40H
        MOV     BX,HANDLE
        MOV     CX,20
        LEA     DX,SCORE_REC
        INT     21H

        CLOSEFILE
        POPR
        RET
WRITE_DATA      ENDP

SORT_   PROC    NEAR
        PUSHR
        MOV     BX,11
        MOV     NUM,1
I_:                             ;LOOP I
        MOV     CX,BX        
        LEA     SI,SCORE_REC    ;SET ADDRESS
        MOV     NUM2,0          ;FOR NAME
        SUB     CX,NUM
J_:                             ;LOOP J
        MOV     AX,[SI+2]       ;READ DATA
        CMP     [SI],AX         ;IF A[J] < A[J+1]
        JGE     NEXT_
        XCHG    [SI],AX         ;SWAP SCORE
        MOV     [SI+2],AX

        PUSHR                   ;SWAP NAME
        PUSH    SI
        PUSH    DI

        MOV     BX,NUM2         ;MOV J+1 TO TMP 
        LEA     SI,NAME_REC[BX+10]
        LEA     DI,NAME_
        MOV     CX,10
        REP     MOVSB

        LEA     SI,NAME_REC[BX] ;MOV J TO J+1
        LEA     DI,NAME_REC[BX+10]
        MOV     CX,10
        REP     MOVSB

        LEA     SI,NAME_        ;MOV TMP TO J
        LEA     DI,NAME_REC[BX]
        MOV     CX,10
        REP     MOVSB

        POP     DI
        POP     SI
        POPR
NEXT_:
        ADD     SI,2            ;PLUS ADDRESS
        ADD     NUM2,10
        LOOP    J_

        INC     NUM
        CMP     BX,NUM
        JG      I_
        POPR
        RET
SORT_   ENDP

CHECK_BONUS     PROC
        PUSHR

        MOV     AH,2CH
        INT     21H

        XOR     AX,AX           ;DIV BY 10
        MOV     AL,DL
        MOV     DL,10
        DIV     DL

        CMP     CURRENT_TIME,AL
        JE      NOT_SET_TIME

        MOV     CURRENT_TIME,AL
        SUB     BONUS,1

        MOV     AX,BONUS
        GOTOXY  35,14
        DISP_STR        '   '
        GOTOXY  35,14
        CALL    OUTDEC

NOT_SET_TIME:

        POPR
        RET
CHECK_BONUS     ENDP

CHK_CLICK       PROC
;INPUT BX = NUMBER OF BLOCK
;CHECK BLOCK MOUSE CLICK
        PUSHR

        XOR     AX,AX
        MOV     AL,BLO_DATA[BX]
        ADD     SUM_POINT,AL
        MOV     AL,POINT
        CMP     SUM_POINT,AL
        JLE     OK_
        JG      NOTOK_
OK_:
        MOV     BLO_STR[BX],1

        XOR     DX,DX
        MOV     AX,BX           ;DIVIDE BY 10
        MOV     CX,10
        DIV     CX

        MOV     CL,18           ;POSITION Y = (AX * 18) + LEN_Y
        MUL     CL
        ADD     AX,LEN_Y
        MOV     BMP_Y,AX

        MOV     AX,DX           ;POSITION X = (DX * 18) + LEN_X
        MUL     CL
        ADD     AX,LEN_X
        MOV     BMP_X,AX

        MOV     DI,BX
        CALL    CHK_BLOCK_DRAW
        CALL    HIDE_MOUSE
        CALL    LOADBMP
        CALL    SHOW_MOUSE

        MOV     AL,POINT
        CMP     SUM_POINT,AL
        JE      CLEAR_

        JMP     EXIT_CHK_CLICK
CLEAR_:
        CALL    CLEAR
        JMP     EXIT_CHK_CLICK
NOTOK_:
        MOV     AL,BLO_DATA[BX]
        SUB     SUM_POINT,AL
        
EXIT_CHK_CLICK:

        POPR
        RET
CHK_CLICK       ENDP


CLEAR   PROC
        PUSHR

        MOV     BX,0
        MOV     COUNT_CLEAR,0
        MOV     NCOUNT_CLEAR,0
CLEAR_LOOP:
        CMP     BLO_STR[BX],1
        JNE     NOTCLEAR_

        MOV     BLO_STR[BX],2   ;CLEAR BLOCK
        INC     COUNT_CLEAR

        XOR     DX,DX
        MOV     AX,BX           ;DIVIDE BY 10
        MOV     CX,10
        DIV     CX

        MOV     CL,18           ;POSITION Y = (AX * 18) + LEN_Y
        MUL     CL
        ADD     AX,LEN_Y
        MOV     BMP_Y,AX

        MOV     AX,DX           ;POSITION X = (DX * 18) + LEN_X
        MUL     CL
        ADD     AX,LEN_X
        MOV     BMP_X,AX

        LEA     SI,EMTPY
        CALL    HIDE_MOUSE
        CALL    LOADBMP
        CALL    SHOW_MOUSE
        ;DEC     NCOUNT_CLEAR    ;##
NOTCLEAR_:
        INC     BX
        ;INC     NCOUNT_CLEAR
        CMP     BX,100
        JL      CLEAR_LOOP      ;GO LOOP

;CALCULATE SCORE
        MOV     AX,COUNT_CLEAR  ;SCORE = (NUNBLOCK * 50) * NUMBLOCK 
        MOV     BX,50
        MUL     BX

        MOV     CX,COUNT_CLEAR
        SUB     CX,1
        MOV     DX,AX
CAL_SCORE:
        ADD     DX,AX
        LOOP    CAL_SCORE

        ADD     SCORE,DX
        MOV     AX,BONUS
        ADD     SCORE,AX

        MOV     BONUS,100
        CALL    GET_TIME

        CALL    RANPOINT
        MOV     SUM_POINT,0
        JMP     EXIT_CLEAR

EXIT_CLEAR:
        POPR
        RET
CLEAR   ENDP


RANPOINT        PROC
        PUSHR

        MOV     AH,2CH
        INT     21H

        XOR     AX,AX           ;POINT = 1 - 20
        MOV     AL,DL           ;MOD 20 + 1
        MOV     BL,20
        DIV     BL
        INC     AH

        MOV     POINT,AH

        CLD                     ;STO STRING
        LEA     DI,P[5]
        CMP     AH,20
        JL      POINT19

        MOV     AL,"2"          ;POINT = 20
        STOSB
        MOV     AL,"0"
        STOSB
        JMP     EXIT_RANPOINT
POINT19:                        ;POINT < 20
        CMP     AH,10
        JL      POINT9
        MOV     AL,"1"
        STOSB
        MOV     AL,AH
        ADD     AL,38
        STOSB
        JMP     EXIT_RANPOINT
POINT9:                         ;POINT < 10
        MOV     AL,"0"
        STOSB
        MOV     AL,AH
        ADD     AL,48
        STOSB

EXIT_RANPOINT:
        PASTEBMP 242,54,P
        
        POPR
        RET
RANPOINT        ENDP

DRAW    PROC
;DRAW BACKGROUND AND BLOCK

        PUSHR

        CALL    HIDE_MOUSE      ;HIDE MOUSE

        PASTEBMP 0,0,BG_PIC     ;DRAW BACKGROUND

        MOV     CX,10           ;DRAW BLOCK
        XOR     DI,DI           ;DI = NUMBER OF BLOCK
        MOV     AX,LEN_X
        MOV     BX,LEN_Y
DRAW1_:
        PUSH    CX
        MOV     CX,10
        MOV     AX,LEN_X

DRAW2_:
        CALL    CHK_BLOCK_DRAW
        INC     DI
        MOV     BMP_X,AX
        MOV     BMP_Y,BX
        CALL    LOADBMP

        ADD     AX,SIZE_BLOCK
        LOOP    DRAW2_
        POP     CX
        ADD     BX,SIZE_BLOCK
        LOOP    DRAW1_

        CALL    SHOW_MOUSE	

        POPR
        RET
DRAW    ENDP

CHK_BLOCK_DRAW  PROC
;INPUT DI -> DATA
;OUTPUT SI -> PIC
        PUSH    DI
        PUSH    AX
        CMP     BLO_STR[DI],0
        JG      STR1_

        CLD
        MOV     AL,BLO_DATA[DI]
        ADD     AL,48
        LEA     DI,B[9]
        STOSB
        LEA     SI,B
        JMP     EXIT_CHK_BLOCK
STR1_:
        MOV     AL,BLO_DATA[DI]
        ADD     AL,48
        LEA     DI,C[9]
        STOSB
        LEA     SI,C

EXIT_CHK_BLOCK:
        POP     AX
        POP     DI
        RET
CHK_BLOCK_DRAW  ENDP

;PROC FOR SHOW PICTURE(.BMP)
;ÔÔÔTHIS PROC IS FOR 320 * 200(MODE 13H) IN 256 COLORS ONLYÔÔÔ
;INPUT:	BMP_FILENAME(LEA SI,FILENAME)	
;	BMP_WIDTH	DW ?		DON'T CARE
;	BMP_HEIGHT	DW ?		DON'T CARE
;	BMP_BUFFER	DB 4 DUP(?)	DON'T CARE
;	BMP_COUNT	DW ?		DON'T CARE
;	BMP_X		DW ?		X POSITION OF BMP 
;	BMP_Y		DW ?		Y POSITION OF BMP
;OUTPUT:NONE
LOADBMP PROC
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX

	MOV	BMP_COUNT,0

;OPEN BMP FILE
	MOV	DX,SI
	MOV	AX,3D00H
	INT	21H
	JC	ERROR_BMP_1
	MOV	BX,AX
;SEEK TO COLOR
	MOV	AX,4200H
	XOR	CX,CX
	MOV	DX,54D
	INT	21H
;SET COLOR
COLOR_BMP_LOOP:
;READ 4 BYTES FROM BMP FILE TO BUFFER
	MOV	AH,3FH
	MOV	CX,4
	LEA	DX,BMP_BUFFER
	INT	21H

	PUSH	BX
	MOV	BX,COUNT_COLOR
	MOV	[BMP_BUFFER + 3],4
	XOR	AX,AX
	MOV	AL,[BMP_BUFFER + 1]	;GREEN	
	DIV	[BMP_BUFFER + 3]
	MOV	CH,AL
	MOV	AL,[BMP_BUFFER + 0]	;BLUE
	DIV	[BMP_BUFFER + 3]
	MOV	CL,AL
	MOV	AL,[BMP_BUFFER + 2]	;RED
	DIV	[BMP_BUFFER + 3]
	MOV	DH,AL
	MOV	AX,1010H
	INT	10H
	INC	BMP_COUNT
	POP	BX
	CMP	BMP_COUNT,256D
	JGE	EXIT_COLOR_LOOP
	JMP	COLOR_BMP_LOOP

ERROR_BMP_1:
	CALL	OUTDEC
	MOV	DL,'E'
	MOV	AH,2
	INT	21H	
	JMP	ERROR_BMP_2
EXIT_COLOR_LOOP:

;SEEK TO HEIGHT
	MOV	AX,4200H
	XOR	CX,CX
	MOV	DX,22D
	INT	21H
;READ HEIGHT TO BUFFER AND SAVE TO BMP_HEIGHT
	MOV	AH,3FH
	MOV	CX,2
	LEA	DX,BMP_BUFFER
	INT	21H
	MOV	AX,WORD PTR BMP_BUFFER
	MOV	BMP_HEIGHT,AX
;SEEK TO WIDTH
	MOV	AX,4200H
	XOR	CX,CX
	MOV	DX,18D
	INT	21H
;READ WIDTH TO BUFFER AND SAVE TO BMP_WIDTH
	MOV	AH,3FH
	MOV	CX,2
	LEA	DX,BMP_BUFFER
	INT	21H
	MOV	AX,WORD PTR BMP_BUFFER
	MOV	BMP_WIDTH,AX
;SEEK TO BIT IMAGE
	MOV	AX,4200H
	XOR	CX,CX
	MOV	DX,1078D
	INT	21H

	MOV	AX,BMP_X		;AX = BMP_X
	PUSH	BX			
	MOV	BX,BMP_Y
	ADD	BX,BMP_HEIGHT
	MOV	CX,320
ADD_BMP_COUNT:
	ADD	AX,BX		;AX += (BMY_Y+BMP_H)*320
	LOOP	ADD_BMP_COUNT
	POP	BX

	MOV	BMP_COUNT,AX	;USE FOR POINT TO VGA MEMORY
	MOV	CX,BMP_WIDTH	;USE IN READ FILE FUNCTION(READ EACH BMP_WIDTH BYTES)
;COMPUTE BLANK PIXEL
SUB_BMP_WIDTH:
	SUB	BMP_WIDTH,4
	CMP	BMP_WIDTH,4
	JLE	EXIT_SUB_BMP_WIDTH
	JMP	SUB_BMP_WIDTH
EXIT_SUB_BMP_WIDTH:
	MOV	AX,4
	SUB	AX,BMP_WIDTH
	MOV	BMP_WIDTH,AX
SHOW_BMP_LOOP:
	MOV	DX,BMP_COUNT
;READ BMP TO VGA MEMORY	
	PUSH	DS			;SAVE DS(FROM MAIN)	
	MOV	AX,0A000H		;VGA MEMORY
	MOV	DS,AX			;POINT TO VGA MEMORY
	XOR	AX,AX			;CLEAR AX
	MOV	AH,3FH			;READ FILE FUNCTION
	INT	21H			;TO BUFFER DS:DX
	POP	DS

;POINT PASS THE BLANK BMP PIXEL
	PUSH	AX
	PUSH	CX
	PUSH	DX
	MOV	AX,4201H
	XOR	CX,CX
	MOV	DX,BMP_WIDTH
	INT	21H
	POP	DX
	POP	CX
	POP	AX
;UPDATE BMP_COUNT
	SUB	BMP_COUNT,320	;SUB BY WIDTH

;CHECK FOR END OF FILE AND EXIT LOOP
	CMP	AX,CX		;CHECK EOF?
	JL	EXIT_BMP
	JMP	SHOW_BMP_LOOP

EXIT_BMP:
;CLOSE BMP FILE
	MOV	AH,3EH
	INT	21H
ERROR_BMP_2:

	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
LOADBMP ENDP

INCLUDE MOUSE.ASM
INCLUDE TIME.ASM
INCLUDE OUTDEC.ASM
END
