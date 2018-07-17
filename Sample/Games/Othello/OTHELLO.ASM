TITLE OTHELLO :
.MODEL  SMALL
.386
	
	EXTRN	EXIT_TO_DOS:NEAR
	INCLUDE MACROS.ASM 
	INCLUDE MACRO.ASM 

.STACK  100H
.DATA

; ============ PICTURE FOR OTHELLO ==============

        PIC_TABLE       DB  'TABLE.BMP',0
	PIC_BG		DB  'BG_START.BMP',0	
	PIC_HOWTO	DB  'HOWTO.BMP',0
	PIC_BG_SELECT	DB  'BGSELECT.BMP',0
	PIC_BG_TABLE	DB  'BG_PLAY.BMP',0
	PIC_TOPSCORE	DB  'TOPSCORE.BMP',0
	PIC_WHITE_TURN1	DB  'W_TURN_1.BMP',0
	PIC_WHITE_TURN0	DB  'W_TURN_0.BMP',0
	PIC_BLACK_TURN1	DB  'B_TURN_1.BMP',0
	PIC_BLACK_TURN0	DB  'B_TURN_0.BMP',0
	PIC_NEW		DB  'NEW.BMP',0 	
	PIC_EXIT	DB  'EXIT.BMP',0 	

	PIC_NOB		DB  'PIC_NOB.BMP',0 
	PIC_DOR		DB  'PIC_DOR.BMP',0
	PIC_SHI		DB  'PIC_SHI.BMP',0

        WHITE           DB  'WHITE.BMP',0
        BLACK           DB  'BLACK.BMP',0
	BLANK		DB  'BLANK.BMP',0

;=========== FOR LOADBMP.ASM ================
        BMP_WIDTH       DW  ?
        BMP_HEIGHT      DW  ?
        BMP_BUFFER      DB  4 DUP(0)
        BMP_COUNT       DW  ?
        BMP_X           DW  ?
        BMP_Y           DW  ?
		COUNTCOLOR		DB	?

;=========== FOR SAVESCORE.ASM ===============

	FILENAME	DB	'RANK.TXT',0
	INPUT_NAME	DB	10 DUP (' '),0
	INPUT_SCORE	DW	0
	FILEDATA_NAME	DB	11 DUP(10 DUP(' ')),0
	FILEDATA_SCORE	DW	11 DUP(0),0
	FILE_SIZE	DW	0
	FILE_ROUND	DW	0
	FILE_WALL	DW	0
	FILE_MOVE	DW	0

;============================================

        TABLE           DB  65 DUP(0)
        ROW             DB  0
        COL             DB  0
	TEMP_ROW	DB  0
	TEMP_COL	DB  0 	
	TEMP_ROW2	DB  0
	TEMP_COL2	DB  0 	
        POSITION        DB  0
	COUNT		DB  0
	SET_PLAY	DB  0
	WHITE_POINT	DB  ?
	BLACK_POINT     DB  ?
	WIN_POINT       DB  ?
	X_PIXEL		DW  ?
	Y_PIXEL		DW  ?
	X_MICKY		DW  ?
	Y_MICKY		DW  ?
	X_POS		DB  ?
	Y_POS		DB  ?
	TEMP		DW  ?
	TEMP_BX		DW  0	
	PL1_ABLE	DB  0	
	PL2_ABLE	DB  0
	PL1_SELECT	DB  0
	PL2_SELECT	DB  0	
	HANDLE		DW  ?
	BUFFER		DB  11 DUP (12 DUP (?)),0
	BUFFER_WORD	DW  ?
	CHECK_POINT	DB  0
	CHECK_POINT2	DB  0
	CHECK_CLICK	DB  0
	MSG_BLANK	DB  '        $'	
	MSG_PT		DB  ' pt$'	
	MSG_WHITE_PASS	DB  'WHITE PASS$'
	MSG_BLACK_PASS	DB  'BLACK PASS$'
	InsertPos	DW	0

.CODE
MAIN    PROC

        MOV     AX,@DATA
        MOV     DS,AX

;=================================================
;save display mode
        MOV     AH,0FH
        INT     10H
        PUSH    AX
;set mode 320*200 256 color
        MOV     AH,00H
        MOV     AL,13H
        INT     10H
;=================================================

;start game

	CALL	START_GAME

;=================================================


;load display mode
        POP     AX
        MOV     AH,00H
        INT     10H
;dos exit
        MOV     AX,0003H
        INT     10H

        MOV     AH,4CH
        INT     21H

MAIN    ENDP

INCLUDE LOADBMP.ASM
INCLUDE OUTDEC.ASM
INCLUDE	CONVERT.ASM
INCLUDE	PUT_PIC.ASM
INCLUDE	PUT_MAK.ASM
INCLUDE	CHK_PASS.ASM
INCLUDE	BMP_EDIT.ASM
INCLUDE	START.ASM
INCLUDE	END_GAME.ASM
INCLUDE	SCORE.ASM
INCLUDE	CHKMOUSE.ASM
INCLUDE SAVELOAD.ASM


END     MAIN