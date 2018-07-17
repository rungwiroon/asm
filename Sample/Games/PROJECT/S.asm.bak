

	EXTRN	SET_VGA_MODEX:FAR	;(ModeType%, MaxXPos%, MaxYpos%, Pages%)
	EXTRN	SET_MODEX:FAR		;(Mode%)
	EXTRN	CLEAR_VGA_SCREEN:FAR	;(ColorNum%)
	EXTRN	SET_POINT:FAR		;(Xpos%, Ypos%, ColorNum%)
	EXTRN	READ_POINT:FAR		;(Xpos%, Ypos%)
	EXTRN	FILL_BLOCK:FAR		;(Xpos1%, Ypos1%, Xpos2%, Ypos2%, ColorNum%)
	EXTRN	DRAW_LINE:FAR		;(Xpos1%, Ypos1%, Xpos2%, Ypos2%, ColorNum%)
	EXTRN	SET_DAC_REGISTER:FAR	;(Register%, Red%, Green%, Blue%)
	EXTRN	GET_DAC_REGISTER:FAR	;(Register%, &Red%, &Green%, &Blue%)
	EXTRN	LOAD_DAC_REGISTERS:FAR	;(SEG PalData, StartReg%, EndReg%, Sync%)
	EXTRN	READ_DAC_REGISTERS:FAR	;(SEG PalData, StartReg%, EndReg%)
	EXTRN	SET_ACTIVE_PAGE:FAR	;(PageNo%)
	EXTRN	GET_ACTIVE_PAGE:FAR	;AX = Current Video Page used for Drawing
	EXTRN	SET_DISPLAY_PAGE:FAR	;(DisplayPage%)
	EXTRN	GET_DISPLAY_PAGE:FAR	;AX = Current Video Page being displayed
	EXTRN	SET_WINDOW:FAR		;(DisplayPage%, Xpos%, Ypos%)
	EXTRN	GET_X_OFFSET:FAR	;AX = Current Horizontal Scroll Offset
	EXTRN	GET_Y_OFFSET:FAR	;AX = Current Vertical Scroll Offset
	EXTRN	SYNC_DISPLAY:FAR
	EXTRN	GPRINTC:FAR		;(CharNum%, Xpos%, Ypos%, ColorF%, ColorB%)
	EXTRN	TGPRINTC:FAR		;(CharNum%, Xpos%, Ypos%, ColorF%)
	EXTRN	PRINT_STR:FAR		;(SEG String, MaxLen%, Xpos%, Ypos%, ColorF%, ColorB%)
	EXTRN	TPRINT_STR:FAR		;(SEG String, MaxLen%, Xpos%, Ypos%, ColorF%, ColorB%)
	EXTRN	SET_DISPLAY_FONT:FAR	;(SEG FontData, FontNumber%)
	EXTRN	DRAW_BITMAP:FAR		;(SEG Image, Xpos%, Ypos%, Width%, Height%)
	EXTRN	TDRAW_BITMAP:FAR	;(SEG Image, Xpos%, Ypos%, Width%, Height%)
	EXTRN	COPY_PAGE:FAR		;(SourcePage%, DestPage%)
	EXTRN	COPY_BITMAP:FAR		;(SourcePage%, X1%, Y1%, X2%, Y2%, DestPage%, DestX1%, DestY1%)
;FROM PICDISP.ASM
	EXTRN	DISPLAY_PIC:FAR		;(SEG File, Xpos1, Ypos1, Width, Height)
	EXTRN	DISPLAY_TPIC:FAR	;(SEG File, Xpos1, Ypos1, Width, Height)
	EXTRN	TITLEGAME:FAR
     .MODEL Medium
    .286

.STACK 100h

.DATA
INCLUDE RGBPAL.ASM
INCLUDE BG.ASM
INCLUDE	PLAYER.ASM
	SCREEN1		DB	'DATA\SCREEN1.PIC',0		;320 * 240
	SCREEN2		DB	'DATA\SCREEN2.PIC',0		;320 * 240
	SCREEN3		DB	'DATA\SCREEN3.PIC',0		;320 * 240
	SCREEN4		DB	'DATA\SCREEN4.PIC',0		;320 * 240
	E1		DB	'DATA\E1.PIC',0			;60 * 60
	E2		DB	'DATA\E2.PIC',0			;60 * 60
	E3		DB	'DATA\E3.PIC',0			;60 * 60
	E4		DB	'DATA\E4.PIC',0			;60 * 60
	E5		DB	'DATA\E5.PIC',0			;60 * 60
	BOSS1		DB	'DATA\BOSS1.PIC',0		;120 * 120
	BOSS2		DB	'DATA\BOSS2.PIC',0		;120 * 120
	BOSS2_		DB	'DATA\BOSS2_.PIC',0		;100 * 100
	BOSS3		DB	'DATA\BOSS3.PIC',0		;120 * 120
	BOSS4		DB	'DATA\BOSS4.PIC',0		;60 * 60
	TEE		DB	'DATA\TEE.PIC',0		;100 * 100
	SELL		DB	'DATA\SELL.PIC',0		;100 * 100

	F1		DB	'DATA\F1.PIC',0			;60 * 60
	F2		DB	'DATA\F2.PIC',0			;60 * 60
	F3		DB	'DATA\F3.PIC',0			;60 * 60	
	BOLT1		DB	'DATA\BOLT1.PIC',0		;60*110
	BOLT2		DB	'DATA\BOLT2.PIC',0		;60*110	
	BOLT3		DB	'DATA\BOLT3.PIC',0		;60*110
	COMET0		DB	'DATA\COMET0.PIC',0		;60 * 60
	COMET1		DB	'DATA\COMET1.PIC',0		;60 * 60
	COMET2		DB	'DATA\COMET2.PIC',0		;60 * 60
	COMET3		DB	'DATA\COMET3.PIC',0		;60 * 60
	COMET4		DB	'DATA\COMET4.PIC',0		;60 * 60
	COMET5		DB	'DATA\COMET5.PIC',0		;60 * 60
	COMET6		DB	'DATA\COMET6.PIC',0		;60 * 60
	COMET7		DB	'DATA\COMET7.PIC',0		;60 * 60
	COMET8		DB	'DATA\COMET8.PIC',0		;60 * 60
	COMET9		DB	'DATA\COMET9.PIC',0		;60 * 60
	COMET10		DB	'DATA\COMET10.PIC',0		;100 * 100
	COMET11		DB	'DATA\COMET11.PIC',0		;100 * 100
	COMET12		DB	'DATA\COMET12.PIC',0		;100 * 100
	COMET13		DB	'DATA\COMET13.PIC',0		;100 * 100
	COMET14		DB	'DATA\COMET14.PIC',0		;100 * 100
	COMET15		DB	'DATA\COMET15.PIC',0		;100 * 100
	COMET16		DB	'DATA\COMET16.PIC',0		;100 * 100
	COMET17		DB	'DATA\COMET17.PIC',0		;100 * 100
	COMET18		DB	'DATA\COMET18.PIC',0		;100 * 100
	HOME		DB	'DATA\HOME.PIC',0		;100 * 100
	BOOM1		DB	'DATA\BOOM1.PIC',0		;60 * 60
	BOOM2		DB	'DATA\BOOM2.PIC',0		;60 * 60
	BOOM3		DB	'DATA\BOOM3.PIC',0		;60 * 60
	STR1		DB	'DATA\STR1.PIC',0		;300 * 30
	STR2		DB	'DATA\STR2.PIC',0		;300 * 30
	STR3		DB	'DATA\STR3.PIC',0		;300 * 30
	MAGIC		DB	'DATA\MAGIC.PIC',0		;200 * 200
	ERROR		DB	'DATA\ERROR.PIC',0		;200 * 200
	HELP		DB	'DATA\HELP.PIC',0		;200 * 200
	OK		DB	'DATA\OK.PIC',0			;200 * 200


FNAME	DB	'C:\DATA.TXT',0
ROW_PAGE	DW	1
COL_PAGE	DW	1
BOSS2_DEAD	DW	0
BOSS1_DEAD	DW	0
BOSS3_DEAD	DW	0
PLAYER_EXP	DW	0
PLAYER_MONEY	DW	10
PLAYER_HP	DW	0
PLAYER_MP	DW	0
PLAYER_X	DW	50
PLAYER_Y	DW	110
PLAYER_LEVEL	DW	2
ITEM1		DW	2
ITEM2		DW	2
ITEM3		DW	2
LOAD_OK		DW	0

PLAYER_ATTACK	DW	9
LASTMOVE	DW	1
TEMPKEY		DB	?
MOVE_R		DW	0
MOVE_L		DW	0
MOVE_U		DW	0
MOVE_D		DW	0
MOVE_PX		DW	0
NUM_RAN		DW	0
BLOCKUP		DW	120
BLOCKDOWN	DW	120
LIMIT_RANDOM	DW	0
FOR_LOOP	DW	0
HEY_LOOP	DW	0
SELECT_MENU	DW	1
SELECT_MENU2	DW	1
ENEMY_WIDTH	DW	?
ENEMY_HEIGHT	DW	?
TIME_ATTACK	DB	0
ENEMY_PY	DW	?
ENEMY_PX	DW	?
MAGIC_PY	DW	?
COMET_PX	DW	?
COMET_PY	DW	?
ENEMY_HP	DW	0
ENEMY_ATTACK	DW	?
FLASH_X1	DW	0
FLASH_Y1	DW	0
FLASH_X2	DW	0
FLASH_Y2	DW	0
FLASH_X3	DW	0
FLASH_Y3	DW	0
STANDARD_HP	DW	40
STANDARD_MP	DW	30
STANDARD_EXP	DW	27
MONEY		DW	0
EXP_VALUE	DW	0
MAX_HP		DW	0
MAX_MP		DW	0
TEMP		DW	0
POWER_ATTACK	DW	0
PARTY_BOSS	DW	0
PLAYER_DEFENCE	DW	4
	PUT_POP		DW	0
	POP_COLOR	DW	0
	POP_X		DW	0
	POP_Y		DW	0
	STR_LEVEL	DB	' LV.    ',0
	STR_ATTACK	DB	'ATTACK',0
	STR_MAGIC	DB	'MAGIC',0
	STR_ITEM	DB	'ITEM',0
	STR_HP		DB	'HP    /',0
	STR_MP		DB	'MP    /',0
	ATTACK_COLOR	DW	255
	MAGIC_COLOR	DW	255
	ITEM_COLOR	DW	255
	ADDLIMIT	DW	0		;FOR INCREASE LIMIT 
	LIMIT_MAX	DW	0
	STR_M1		DB	'FIRE / 2',0
	STR_M2		DB	'BOLT / 3',0
	STR_M3		DB	'COMET/ 5',0
	STR_M4		DB	'CURE / 4',0
	M1_COLOR	DW	255
	M2_COLOR	DW	255
	M3_COLOR	DW	255
	M4_COLOR	DW	255
	S1		DB	'  STATUS',0
	S2		DB	'  MAGIC',0
	S3		DB	'  ITEM',0
	S4		DB	'  SAVE',0
	S5		DB	'  HELP',0
	CURE_COLOR	DW	0
	C1		DW	255
	C2		DW	255
	C3		DW	255
	C4		DW	255
	C5		DW	255
	B1		DW	11
	B2		DW	10
	B3		DW	10
	B4		DW	10
	B5		DW	10
	SELECT_DETAIL	DW	0
	STR_EXP1	DB	'EXPERIENCE NEXT LEVEL',0
	STR_EXP2	DB	'PRESENT EXPERIENCE',0
	STR_MONEY	DB	'TOTAL	MONEY        BATH',0
	STRMONEY	DB	'TOTAL	MONEY',0
	SELL1		DB	'HEALTY MAX    50  BATH',0
	SELL2		DB	'MAGIC MAX     80  BATH',0
	SELL3		DB	'REVIVE       100  BATH',0
	MSG		DB	'YOU HAVE    ITEM',0
	STR_I1		DB	'HEALTY MAX',0
	STR_I2		DB	'MAGIC MAX',0
	STR_I3		DB	'LEVIVE',0


.CODE
MAIN PROC FAR
	MOV	AX,@DATA
	MOV	DS,AX
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
START:	CALL	TITLEGAME
	MOV	MOVE_R,1
	CALL	GET_MAX_HP_MP
	MOV	CX,MAX_HP
	MOV	PLAYER_HP,CX
	MOV	CX,MAX_MP
	MOV	PLAYER_MP,CX
	CALL	SETBGCOLOR
	CALL	SCREEN
	CALL	COPY
	MOV	MOVE_R,1
	CALL	LOAD_PLAYER
ON_RELEASE:
	CALL	KEYPRESSED	
	JZ	ON_RELEASE
	CALL	READKEY
	CALL	CHECK_KEY
	CALL	LOAD_PLAYER
	CALL	CHECK_MEETENEMY
	JMP	ON_RELEASE	

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

MAIN	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
SCREEN	PROC	NEAR
	CMP	ROW_PAGE,1
	JE	@SCREEN1
	JMP	@SCREEN3
@SCREEN1:
	CMP	COL_PAGE,2
	JE	@SCREEN2
	CALL	LOAD_BG1
	RET
@SCREEN2:
	CALL	LOAD_BG2
	RET
@SCREEN3:	
	CMP	COL_PAGE,2
	JE	@SCREEN4
	CALL	LOAD_BG3
	RET
@SCREEN4:	
	CALL	LOAD_BG4
	RET
SCREEN	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
LOAD_BG1	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET SCREEN1	;Picture address
	PUSH	0		;Xpos
	PUSH	0		;Ypos
	PUSH	320		;Pic Width
	PUSH	240		;Pic Height
	CALL	DISPLAY_PIC
	CALL	MERCHANT
	CALL	NOTICE
	RET
LOAD_BG1	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
LOAD_BG2	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET SCREEN2	;Picture address
	PUSH	0		;Xpos
	PUSH	0		;Ypos
	PUSH	320		;Pic Width
	PUSH	240		;Pic Height
	CALL	DISPLAY_PIC
	CALL	@BOSS2_
	CMP	BOSS2_DEAD,1
	JE	EXIT_BG2
	CALL	@BOSS2_1
EXIT_BG2: RET
LOAD_BG2	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
LOAD_BG3	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET SCREEN3	;Picture address
	PUSH	0		;Xpos
	PUSH	0		;Ypos
	PUSH	320		;Pic Width
	PUSH	240		;Pic Height
	CALL	DISPLAY_PIC
	CMP	BOSS1_DEAD,1
	JE	EXIT_BG3
	CALL	@BOSS1_1
EXIT_BG3: RET
	RET
LOAD_BG3	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
LOAD_BG4	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET SCREEN4	;Picture address
	PUSH	0		;Xpos
	PUSH	0		;Ypos
	PUSH	320		;Pic Width
	PUSH	240		;Pic Height
	CALL	DISPLAY_PIC
	CALL	@BOSS4_1
	CALL	MY_LOVE
	CMP	BOSS3_DEAD,1
	JE	EXIT_BG4
	CALL	@BOSS3_1
EXIT_BG4:
	RET
LOAD_BG4	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
CHECK_MEET_BOSS	PROC	NEAR	;250 10
	CMP	ROW_PAGE,1
	JNE	CHECK_MEET_BOSS1
	CMP	COL_PAGE,2
	JNE	CHECK_MEET_BOSS1
	CMP	PLAYER_X,230
	JGE	CHECK_PY
	JMP	CHECK_MEET_BOSS1
CHECK_PY:
	CMP	PLAYER_Y,90
	JGE	CHECK_PY2
	JMP	EXIT_CHECK_MEET
CHECK_PY2:
	CMP	PLAYER_Y,110
	JG	EXIT_CHECK_MEET_
	CALL	TALK_BOSS2
	
;******************************   [ POSITION BOSS1  X=40 Y=170 ]
CHECK_MEET_BOSS1:
	CMP	COL_PAGE,1
	JNE	CHECK_MEET_BOSS3
	CMP	ROW_PAGE,2
	JNE	CHECK_MEET_BOSS3
	CMP	PLAYER_X,65
	JL	CHECK_1PY
	JMP	EXIT_CHECK_MEET
CHECK_1PY:
	CMP	PLAYER_Y,145
	JL	EXIT_CHECK_MEET
	CALL	TALK_BOSS1			
			
;******************************   [ POSITION BOSS3  X=230 Y=190 ]
CHECK_MEET_BOSS3:
	CMP	ROW_PAGE,2
	JNE	BRIDGE_BOSS
	CMP	COL_PAGE,2
	JNE	BRIDGE_BOSS
	CMP	PLAYER_X,210
	JL	BRIDGE_BOSS
	CMP	PLAYER_X,250
	JG	BRIDGE_BOSS
	CMP	PLAYER_Y,170
	JL	BRIDGE_BOSS
	CMP	PLAYER_Y,210
	JG	BRIDGE_BOSS

	CALL	TALK_BOSS3
	JMP	BRIDGE_BOSS

EXIT_CHECK_MEET_:
	JMP	EXIT_CHECK_MEET
BRIDGE_BOSS:
;******************************   [ POSITION BOSS3  X=270 Y=190 ]
	CMP	ROW_PAGE,2
	JNE	EXIT_CHECK_MEET
	CMP	COL_PAGE,2
	JNE	EXIT_CHECK_MEET
	CMP	PLAYER_X,250
	JL	EXIT_CHECK_MEET
	CMP	PLAYER_X,270
	JG	EXIT_CHECK_MEET
	CMP	PLAYER_Y,170
	JL	EXIT_CHECK_MEET
	CMP	PLAYER_Y,210
	JG	EXIT_CHECK_MEET
	;CMP	BOSS1_DEAD,1
	;JNE	EXIT_CHECK_MEET
	;CMP	BOSS2_DEAD,1
	;JNE	EXIT_CHECK_MEET
	;CMP	BOSS3_DEAD,1
	;JNE	EXIT_CHECK_MEET
	CALL	TALK_BOSS4
	
EXIT_CHECK_MEET:
	RET
CHECK_MEET_BOSS	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
RESET_STR	PROC	NEAR

	
	PUSH	0	;L
	PUSH	210	;T
	PUSH	320	;W
	PUSH	240	;H
	PUSH	255	;COLOR
	CALL	FILL_BLOCK
	PUSH	2	;L
	PUSH	212	;T
	PUSH	318	;W
	PUSH	238	;H
	PUSH	0
	CALL	FILL_BLOCK
	RET
RESET_STR	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
TALK_BOSS1	PROC	NEAR
	MOV	PARTY_BOSS,1
	CALL	CHANGE_MODE_FIGHTING
	CALL	ACTION	

	RET
TALK_BOSS1	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
TALK_BOSS2	PROC	NEAR
	CALL	LOAD_PLAYER
	CALL	RESET_STR
	PUSH	DS
	PUSH	OFFSET STR1
	PUSH	2			;X position
	PUSH	210		;y position
	PUSH	300		;Width
	PUSH	30		;Height
	CALL	DISPLAY_TPIC
WAIT_PRESS1:
	MOV	AH,01H
	INT	21H
	CMP	AL,0DH
	JNE	WAIT_PRESS1
	CALL	RESET_STR
	
	PUSH	DS
	PUSH	OFFSET STR2
	PUSH	2			;X position
	PUSH	210		;y position
	PUSH	300		;Width
	PUSH	30		;Height
	CALL	DISPLAY_TPIC
WAIT_PRESS2:
	MOV	AH,01H
	INT	21H
	CMP	AL,0DH
	JNE	WAIT_PRESS2
	CALL	RESET_STR
	
	PUSH	DS
	PUSH	OFFSET STR3
	PUSH	2			;X position
	PUSH	210		;y position
	PUSH	300		;Width
	PUSH	30		;Height
	CALL	DISPLAY_TPIC
WAIT_PRESS3:
	MOV	AH,01H
	INT	21H
	CMP	AL,0DH
	JNE	WAIT_PRESS3
	MOV	PARTY_BOSS,2
	CALL	CHANGE_MODE_FIGHTING
	CALL	ACTION	

	RET
TALK_BOSS2	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
TALK_BOSS3	PROC	NEAR
	MOV	PARTY_BOSS,3
	CALL	CHANGE_MODE_FIGHTING
	CALL	ACTION	

	RET
TALK_BOSS3	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
TALK_BOSS4	PROC	NEAR
	MOV	PARTY_BOSS,4
	CALL	CHANGE_MODE_FIGHTING
	CALL	ACTION	

	RET
TALK_BOSS4	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
BG_FIGHTING	PROC	NEAR
	;PUSH	3	;-----------------------
	;PUSH	2				;
	;CALL	COPY_PAGE	;PASTE		;
	PUSH	DS		;Data Segment
	PUSH	OFFSET BG	;Picture address
	PUSH	8		;Xpos
	PUSH	30		;Ypos
	PUSH	300		;Pic Width
	PUSH	141		;Pic Height
	CALL	DRAW_BITMAP
	RET
BG_FIGHTING	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
SETBGCOLOR	PROC	NEAR	
	PUSH	0
	CALL	CLEAR_VGA_SCREEN
	RET
SETBGCOLOR	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
MERCHANT	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET P2	;Picture address
	PUSH	50		;Xpos
	PUSH	30		;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
MERCHANT	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
CHECK_MERCHANT	PROC	NEAR
	CMP	ROW_PAGE,1
	JNE	NONO
	CMP	COL_PAGE,1
	JNE	NONO
	CMP	PLAYER_X,70
	JG	NONO
	CMP	PLAYER_Y,30
	JL	NONO
	CMP	PLAYER_Y,70
	JG	NONO
	CALL	SELL_ITEM
NONO:	RET
CHECK_MERCHANT	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
NOTICE	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET SELL	;Picture address
	PUSH	30		;Xpos
	PUSH	10		;Ypos
	PUSH	40		;Pic Width
	PUSH	40		;Pic Height
	CALL	DISPLAY_TPIC
	RET
NOTICE	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
LOADPLAYERFIGHT	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET PR	;Picture address
	PUSH	50		;Xpos
	PUSH	120		;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	
	CALL	HP_MP
	RET
LOADPLAYERFIGHT	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
PLAYERREADY	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET PF	;Picture address
	PUSH	50		;Xpos
	PUSH	120		;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	CALL	HP_MP
	RET
PLAYERREADY	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
STRIKE	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET RZ	;Picture address
	PUSH	50		;Xpos
	PUSH	120		;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
STRIKE	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
PLAYERHEY	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET POK	;Picture address
	PUSH	MOVE_PX		;Xpos
	PUSH	120		;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
PLAYERHEY	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
PLAYERATTACK	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET PA	;Picture address
	PUSH	MOVE_PX		;Xpos
	PUSH	120		;Ypos
	PUSH	40		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
PLAYERATTACK	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
GET_MAX_HP_MP	PROC	NEAR
	MOV	CX,PLAYER_LEVEL
	MOV	AX,40
	MOV	MAX_HP,AX
	MOV	BX,4
LOOP_HEALTH_POWER:;----------------------[ MAX HP ]
	XOR	DX,DX
	DIV	BX
	ADD	MAX_HP,AX
	MOV	AX,MAX_HP
	LOOP	LOOP_HEALTH_POWER

	MOV	CX,PLAYER_LEVEL
	MOV	AX,28
	MOV	MAX_MP,AX
	MOV	BX,4
LOOP_MAGIC_POWER:;-----------------------[ MAX MP ]
	XOR	DX,DX
	DIV	BX
	ADD	MAX_MP,AX
	MOV	AX,MAX_MP
	LOOP	LOOP_MAGIC_POWER
	RET
GET_MAX_HP_MP	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
ADJUST_LEVEL	PROC	NEAR
	MOV	CX,PLAYER_LEVEL
	MOV	AX,STANDARD_EXP
	MOV	TEMP,AX
LOOP_LEVEL:
	MOV	BX,2
	XOR	DX,DX
	DIV	BX
	ADD	TEMP,AX
	MOV	AX,TEMP
	LOOP	LOOP_LEVEL
	CMP	PLAYER_EXP,AX
	JL	NO_ADJUST
	INC	PLAYER_LEVEL
	SUB	PLAYER_EXP,AX
	
NO_ADJUST: RET
ADJUST_LEVEL	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
FLASHATTACK	PROC	NEAR
;	PUSH	DS		;Data Segment
;	PUSH	OFFSET FLASH	;Picture address
;	PUSH	MOVE_PX		;Xpos
;	PUSH	100		;Ypos
;	PUSH	40		;Pic Width
;	PUSH	40		;Pic Height
;	CALL	TDRAW_BITMAP
;*****************************************************************************************

	MOV	FLASH_X2,234
	MOV	FLASH_Y2,100
	MOV	FLASH_X1,245
	MOV	FLASH_Y1,100
	MOV	FLASH_X3,246
	MOV	FLASH_Y3,100
@FLASH_AGAIN:
	PUSH	FLASH_X1
	PUSH	FLASH_Y1
	PUSH	15
	CALL	SET_POINT

	CALL	DELAY2
	INC	FLASH_X1
	INC	FLASH_X2
	INC	FLASH_X3
	INC	FLASH_Y1
	INC	FLASH_Y2
	INC	FLASH_Y3
	CMP	FLASH_X1,285
	JL	@FLASH_AGAIN
	
	RET
FLASHATTACK	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
PLAYERSTAND	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET PM	;Picture address
	PUSH	50		;Xpos
	PUSH	120		;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
PLAYERSTAND	ENDP

;----------------------------------------------------------------------------------------------------------------------------------
PLAYERDEAD	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET PDEAD	;Picture address
	PUSH	50		;Xpos
	PUSH	120		;Ypos
	PUSH	40		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
PLAYERDEAD	ENDP

;----------------------------------------------------------------------------------------------------------------------------------
PLAYERMAGIC	PROC	NEAR
	CALL	COPY
	PUSH	DS		;Data Segment
	PUSH	OFFSET PM	;Picture address
	PUSH	50		;Xpos
	PUSH	120		;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	
	
	MOV	FOR_LOOP,10
INCANT:
	PUSH	62	;L
	PUSH	128	;T
	PUSH	63	;W
	PUSH	128	;H
	PUSH	0
	CALL	FILL_BLOCK
	CALL	DELAY
	CALL	DELAY

	PUSH	62	;L
	PUSH	128	;T
	PUSH	63	;W
	PUSH	128	;H
	PUSH	165
	CALL	FILL_BLOCK
	CALL	DELAY
	CALL	DELAY
	DEC	FOR_LOOP
	CMP	FOR_LOOP,0
	JNE	INCANT
	CALL	PASTE
	RET
PLAYERMAGIC	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
LOAD_PLAYER	PROC	NEAR	
	CMP	MOVE_R,1
	JE	STEP_RIGHT
	CMP	MOVE_L,1
	JE	STEP_LEFT
	CMP	MOVE_U,1
	JE	STEP_UP	
	CMP	MOVE_D,1
	JE	STEP_DOWN
	;-----------------------------------
STEP_RIGHT:	CALL	@STEP_RIGHT
	JMP	RETURN
	;-----------------------------------
STEP_LEFT:	CALL	@STEP_LEFT
	JMP	RETURN
	;-----------------------------------
STEP_UP:	CALL	@STEP_UP
	JMP	RETURN
	;-----------------------------------
STEP_DOWN:	CALL	@STEP_DOWN
	RETURN:	CALL	DELAY
	;-----------------------------------
	RET
LOAD_PLAYER	ENDP
;----------------------------------------------------------------------------------------------------------------------------------	
LOAD_ENEMY	PROC	NEAR
	CMP	PARTY_BOSS,0
	JE	NO_BOSS
	CMP	PARTY_BOSS,1
	JNE	FIGHT_BOSS2
	CALL	@BOSS1
	JMP	BOSS_OK
FIGHT_BOSS2:
	CMP	PARTY_BOSS,2
	JNE	FIGHT_BOSS3
	CALL	@BOSS2
	JMP	BOSS_OK
FIGHT_BOSS3:
	CMP	PARTY_BOSS,3
	JNE	FIGHT_BOSS4
	CALL	@BOSS3
	JMP	BOSS_OK
FIGHT_BOSS4:
	CALL	@BOSS4
BOSS_OK: MOV	PARTY_BOSS,0
	JMP	SET_ENEMY_OK
NO_BOSS:
	MOV	LIMIT_RANDOM,5
	CALL	RANDOM
	INC	NUM_RAN
	CMP	NUM_RAN,1
	JE	MEET_E1
	CMP	NUM_RAN,2
	JE	MEET_E2
	CMP	NUM_RAN,3
	JE	MEET_E3
	CMP	NUM_RAN,4
	JE	MEET_E4
	CMP	NUM_RAN,5
	JE	MEET_E5
MEET_E1: CALL	@E1
	 JMP	SET_ENEMY_OK
MEET_E2: CALL	@E2
	 JMP	SET_ENEMY_OK
MEET_E3: CALL	@E3
	 JMP	SET_ENEMY_OK
MEET_E4: CALL	@E4
	 JMP	SET_ENEMY_OK
MEET_E5: CALL	@E5
SET_ENEMY_OK:			
		RET
LOAD_ENEMY	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@E1	PROC	NEAR
	 MOV	ENEMY_HP,20
	 MOV	MONEY,5
	 MOV	EXP_VALUE,2
	 MOV	ENEMY_ATTACK,20
	PUSH	DS
	PUSH	OFFSET E3
	PUSH	230		;X position
	PUSH	80		;y position
	PUSH	60		;Width
	PUSH	60		;Height
	CALL	DISPLAY_TPIC
	RET
@E1	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@E2	PROC	NEAR
	 MOV	MONEY,7
	 MOV	ENEMY_HP,30
	 MOV	EXP_VALUE,3
	 MOV	ENEMY_ATTACK,22
	PUSH	DS
	PUSH	OFFSET E3
	PUSH	230		;X position
	PUSH	80		;y position
	PUSH	60		;Width
	PUSH	60		;Height
	CALL	DISPLAY_TPIC
	RET
@E2	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@E3	PROC	NEAR
	 MOV	MONEY,13
	 MOV	ENEMY_HP,50
	 MOV	EXP_VALUE,5
	 MOV	ENEMY_ATTACK,24
	PUSH	DS
	PUSH	OFFSET E3
	PUSH	230		;X position
	PUSH	80		;y position
	PUSH	60		;Width
	PUSH	60		;Height
	CALL	DISPLAY_TPIC
	RET
@E3	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@E4	PROC	NEAR
	 MOV	MONEY,16
	MOV	ENEMY_HP,60
	MOV	EXP_VALUE,6
	MOV	ENEMY_ATTACK,26
	PUSH	DS
	PUSH	OFFSET E4
	PUSH	230		;X position
	PUSH	80		;y position
	PUSH	60		;Width
	PUSH	60		;Height
	CALL	DISPLAY_TPIC
	RET
@E4	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@E5	PROC	NEAR
	 MOV	MONEY,21
	MOV	ENEMY_HP,70
	MOV	ENEMY_ATTACK,28
	MOV	EXP_VALUE,7
	PUSH	DS
	PUSH	OFFSET E5
	PUSH	230			;X position
	PUSH	80		;y position
	PUSH	60		;Width
	PUSH	60		;Height
	CALL	DISPLAY_TPIC
	RET
@E5	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@BOSS1	PROC	NEAR
	 MOV	MONEY,100
	MOV	ENEMY_ATTACK,50
	MOV	ENEMY_HP,2;250
	MOV	EXP_VALUE,30
	PUSH	DS		;Data Segment
	PUSH	OFFSET BOSS1	;Picture address
	PUSH	192		;Xpos
	PUSH	35		;Ypos
	PUSH	120		;Pic Width
	PUSH	120		;Pic Height
	CALL	DISPLAY_TPIC
	MOV	BOSS1_DEAD,1
	RET
@BOSS1	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@BOSS2	PROC	NEAR
	 MOV	MONEY,200
	MOV	ENEMY_ATTACK,50
	MOV	ENEMY_HP,2;350
	MOV	EXP_VALUE,40
	PUSH	DS		;Data Segment
	PUSH	OFFSET BOSS2	;Picture address
	PUSH	188		;Xpos
	PUSH	35		;Ypos
	PUSH	120		;Pic Width
	PUSH	120		;Pic Height
	CALL	DISPLAY_TPIC
	MOV	BOSS2_DEAD,1
	RET
@BOSS2	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@BOSS3	PROC	NEAR
	 MOV	MONEY,300
	MOV	ENEMY_ATTACK,70
	MOV	ENEMY_HP,350
	MOV	EXP_VALUE,50
	PUSH	DS		;Data Segment
	PUSH	OFFSET BOSS3	;Picture address
	PUSH	195		;Xpos
	PUSH	35		;Ypos
	PUSH	120		;Pic Width
	PUSH	120		;Pic Height
	CALL	DISPLAY_TPIC
	MOV	BOSS3_DEAD,1
	RET
@BOSS3	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@BOSS4	PROC	NEAR
	 MOV	MONEY,300
	MOV	ENEMY_ATTACK,70
	MOV	ENEMY_HP,3
	MOV	EXP_VALUE,50
	PUSH	DS		;Data Segment
	PUSH	OFFSET BOSS4	;Picture address
	PUSH	240		;Xpos
	PUSH	80		;Ypos
	PUSH	60		;Pic Width
	PUSH	60		;Pic Height
	CALL	DISPLAY_TPIC
	RET
@BOSS4	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@BOSS2_	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET BOSS2_	;Picture address
	PUSH	250		;Xpos
	PUSH	10		;Ypos
	PUSH	100		;Pic Width
	PUSH	100		;Pic Height
	CALL	DISPLAY_TPIC
	RET
@BOSS2_	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@BOSS1_1	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET BOSS1_1	;Picture address
	PUSH	40		;Xpos
	PUSH	170		;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
@BOSS1_1	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@BOSS2_1	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET BOSS2_1	;Picture address
	PUSH	250		;Xpos
	PUSH	100		;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
@BOSS2_1	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@BOSS3_1	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET BOSS4_1	;Picture address
	PUSH	230		;Xpos
	PUSH	190		;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
@BOSS3_1	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@BOSS4_1	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET BOSS3_1	;Picture address
	PUSH	270		;Xpos
	PUSH	190		;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
@BOSS4_1	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
MY_LOVE	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET DALING	;Picture address
	PUSH	290		;Xpos
	PUSH	190		;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
MY_LOVE		ENDP
;----------------------------------------------------------------------------------------------------------------------------------	
@STEP_RIGHT	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET PR2	;Picture address
	PUSH	PLAYER_X	;Xpos
	PUSH	PLAYER_Y	;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	CALL	DELAY
	CALL	PASTE
	CALL	COPY
	ADD	PLAYER_X,1
	PUSH	DS		;Data Segment
	PUSH	OFFSET PR
	PUSH	PLAYER_X	;Xpos
	PUSH	PLAYER_Y	;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
@STEP_RIGHT	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@STEP_LEFT	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET PL2	;Picture address
	PUSH	PLAYER_X	;Xpos
	PUSH	PLAYER_Y	;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	CALL	DELAY
	CALL	PASTE
	CALL	COPY
	SUB	PLAYER_X,1
	PUSH	DS		;Data Segment
	PUSH	OFFSET PL
	PUSH	PLAYER_X	;Xpos
	PUSH	PLAYER_Y	;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
@STEP_LEFT	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@STEP_UP	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET PU2	;Picture address
	PUSH	PLAYER_X	;Xpos
	PUSH	PLAYER_Y	;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	CALL	DELAY
	CALL	PASTE
	CALL	COPY
	SUB	PLAYER_Y,1
	PUSH	DS		;Data Segment
	PUSH	OFFSET PU
	PUSH	PLAYER_X	;Xpos
	PUSH	PLAYER_Y	;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP	
	RET
@STEP_UP	ENDP
;----------------------------------------------------------------------------------------------------------------------------------
@STEP_DOWN	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET PD2	;Picture address
	PUSH	PLAYER_X	;Xpos
	PUSH	PLAYER_Y	;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	CALL	DELAY
	CALL	PASTE
	CALL	COPY
	ADD	PLAYER_Y,1
	PUSH	DS		;Data Segment
	PUSH	OFFSET PD
	PUSH	PLAYER_X	;Xpos
	PUSH	PLAYER_Y	;Ypos
	PUSH	20		;Pic Width
	PUSH	20		;Pic Height
	CALL	TDRAW_BITMAP
	RET
@STEP_DOWN	ENDP
;---------------------------------------------------------------------------------------------------------------------------
EXIT	PROC	NEAR	
	MOV	AH,0
	MOV	AL,2
	INT	10h
	MOV 	AH,4CH
	INT 	21H
	RET
EXIT	ENDP
;---------------------------------------------------------------------------------------------------------------------------
KEYPRESSED	PROC	NEAR
		PUSH	AX	
		MOV	AH,11H
		INT	16H
		POP	AX
		RET
KEYPRESSED	ENDP
;---------------------------------------------------------------------------------------------------------------------------
READKEY		PROC	NEAR
	MOV	AH,10H
	INT	16H
	RET
READKEY		ENDP
;---------------------------------------------------------------------------------------------------------------------------
CHECK_SCREEN	PROC	NEAR
	CMP	PLAYER_X,300
	JGE	NEWIMGR
	CMP	PLAYER_X,10
	JL	NEWIMGL
	CMP	PLAYER_Y,220
	JGE	NEWIMGT
	CMP	PLAYER_Y,10
	JL	NEWIMGB
	JMP	OLDIMG

NEWIMGR: MOV	PLAYER_X,10
	MOV	COL_PAGE,2
	CALL	SCREEN
	JMP	COPY_SCREEN
NEWIMGL: MOV	PLAYER_X,290
	MOV	COL_PAGE,1
	CALL	SCREEN
	JMP	COPY_SCREEN
NEWIMGT: MOV	PLAYER_Y,10
	MOV	ROW_PAGE,2
	CALL	SCREEN
	JMP	COPY_SCREEN
NEWIMGB: MOV	PLAYER_Y,210
	MOV	ROW_PAGE,1
	CALL	SCREEN
COPY_SCREEN:
	PUSH	0
	PUSH	1
	CALL	COPY_PAGE	;COPY
OLDIMG:		RET
CHECK_SCREEN	ENDP
;---------------------------------------------------------------------------------------------------------------------------
CHECK_KEY	PROC	NEAR
	CALL	CHECK_SCREEN
	PUSH	AX
	MOV	TEMPKEY,AH
	;PUSH	1
	;PUSH	0
	;CALL	COPY_PAGE	;PASTE
	;PUSH	0
	;PUSH	1
	;CALL	COPY_PAGE	;COPY
	CALL	PASTE
	CALL	COPY
	CALL	CLEAR_MOVE
	CMP	TEMPKEY,4DH	;KEYRIGHT-------
	JNE	NOTRIGHT			;
	CALL	MOVERIGHT			;
NOTRIGHT:;--------------------------------------
	CMP	TEMPKEY,4BH	;KEYLEFT---------
	JNE	NOTLEFT				;
	CALL	MOVELEFT	
NOTLEFT:;----------------------------------------
	CMP	TEMPKEY,48H	;KEYUP-----------
	JNE	NOTUP				;
	CALL	MOVEUP				;
NOTUP:;------------------------------------------
	CMP	TEMPKEY,50H	;KEYDOWN---------
	JNE	NOTDOWN				;
	CALL	MOVEDOWN			;
NOTDOWN:;----------------------------------------
	CMP	TEMPKEY,01H	;KEYESC----------
	JNE	NOTENTER			;
	CALL	EXIT				;
NOTENTER:;---------------------------------------
	CMP	TEMPKEY,39H	;TAB-------------
	JNE	NOSHIFT				;
	CALL	STATUS				;
NOSHIFT:;---------------------------------------
	CMP	TEMPKEY,1CH	;KEYENTER--------
	JNE	EXITCHECK	;
	CALL	CHECK_MEET_BOSS
	CALL	CHECK_MERCHANT
EXITCHECK:;--------------------------------------
	POP	AX
	RET
CHECK_KEY	ENDP
;---------------------------------------------------------------------------------------------------------------------------
CLEAR_MOVE	PROC	NEAR
	MOV	MOVE_R,0
	MOV	MOVE_L,0
	MOV	MOVE_U,0
	MOV	MOVE_D,0
	RET
CLEAR_MOVE	ENDP
;---------------------------------------------------------------------------------------------------------------------------
MOVERIGHT	PROC	NEAR
	ADD	PLAYER_X,4
	MOV	MOVE_R,1
	RET
MOVERIGHT	ENDP
;---------------------------------------------------------------------------------------------------------------------------
MOVELEFT	PROC	NEAR
	SUB	PLAYER_X,4
	MOV	MOVE_L,1
	RET
MOVELEFT	ENDP
;---------------------------------------------------------------------------------------------------------------------------
MOVEUP		PROC	NEAR
	SUB	PLAYER_Y,4
	MOV	MOVE_U,1
	RET
MOVEUP		ENDP
;---------------------------------------------------------------------------------------------------------------------------
MOVEDOWN	PROC	NEAR
	ADD	PLAYER_Y,4
	MOV	MOVE_D,1
	RET
MOVEDOWN	ENDP
;---------------------------------------------------------------------------------------------------------------------------
DELAY_MAGIC	PROC	NEAR
	PUSH	CX
	PUSH	DX
	MOV	DX,70
LOOPM1:	MOV	CX,50000
LOOPM2:	
	LOOP	LOOPM2
	DEC	DX
	CMP	DX,0
	JNE	LOOPM1
	POP	DX
	POP	CX
	RET
DELAY_MAGIC	ENDP
;---------------------------------------------------------------------------------------------------------------------------
DELAY	PROC	NEAR
	PUSH	CX
	PUSH	DX
	MOV	DX,150
LOOP1:	MOV	CX,50000
LOOP2:	
	LOOP	LOOP2
	DEC	DX
	CMP	DX,0
	JNE	LOOP1
	POP	DX
	POP	CX
	RET
DELAY	ENDP
;---------------------------------------------------------------------------------------------------------------------------
DELAY2	PROC	NEAR
	PUSH	CX
	PUSH	DX
	MOV	DX,70
@LOOP1:	MOV	CX,5000
@LOOP2:	LOOP	@LOOP2
	DEC	DX
	CMP	DX,0
	JNE	@LOOP1
	POP	DX
	POP	CX
	RET
DELAY2	ENDP
;---------------------------------------------------------------------------------------------------------------------------
DELAY3	PROC	NEAR
	PUSH	CX
	PUSH	DX
	MOV	DX,200
@_LOOP1:	
	MOV	CX,5000
@_LOOP2:	
	LOOP	@_LOOP2
	DEC	DX
	CMP	DX,0
	JNE	@_LOOP1
	POP	DX
	POP	CX
	RET
DELAY3	ENDP
;---------------------------------------------------------------------------------------------------------------------------
DELAY_ATTACK	PROC	NEAR

	MOV	BH,TIME_ATTACK
BEGIN:	MOV	AH,2CH
	INT	21H
	MOV	BL,DL
	CMP	BL,99
	JNE	NEXT
	MOV	BL,0
NEXT:	INC	BL
	MOV	AH,2CH
	INT	21H
	CMP	DL,BL
	JL	NEXT
	DEC	BH
	CMP	BH,0
	JNE	BEGIN
	CALL	FLASH_ATTACK
	RET
DELAY_ATTACK	ENDP

;---------------------------------------------------------------------------------------------------------------------------

CHECK_MEETENEMY	PROC	NEAR
	MOV	LIMIT_RANDOM,10
	CALL	RANDOM
	CMP	NUM_RAN,0
	JNE	DO_NOT_MEET
	CALL	CHANGE_MODE_FIGHTING
	CALL	ACTION	
DO_NOT_MEET:
	RET
CHECK_MEETENEMY	ENDP
;---------------------------------------------------------------------------------------------------------------------------
ACTION	PROC	NEAR
	CALL	BG_FIGHTING
	CALL	LOAD_ENEMY
	CALL	MENU


	CALL	COPY	
	CALL	LOADPLAYERFIGHT	
FIGHT:

	CALL	OPTION	
	CMP	ENEMY_HP,0		
	JG	NODEAD	
	CMP	ENEMY_HP,0
	JLE	WIN
NODEAD:	CALL	FLASH_ATTACK
	CMP	PLAYER_HP,0
	JLE	LOSS
	JMP	FIGHT
	;-------------------------------
LOSS:	CALL	PLAYER_DEAD
	CALL	EXIT

WIN:	
	CALL	YOU_WIN
	CALL	SETBGCOLOR
	
	CALL	SCREEN
	CALL	COPY
	CALL	LOAD_PLAYER
	RET	
	
	
ACTION	ENDP
;---------------------------------------------------------------------------------------------------------------------------
PLAYER_DEAD	PROC	NEAR
	CALL	PASTE
	MOV	PLAYER_HP,0
	CALL	HP_MP
	CALL	PLAYERDEAD
	MOV	AH,01H
	INT	21H
	RET
PLAYER_DEAD	ENDP
;---------------------------------------------------------------------------------------------------------------------------
ATTACK_PLAYER	PROC	NEAR
	PUSH	AX
	PUSH	BX
;--------DECREASE HP PLAYER----------
	MOV	AX,PLAYER_DEFENCE
	MOV	BX,PLAYER_LEVEL
	MUL	BX			;LEVEL * DEFENCE = AX
	MOV	BX,ENEMY_ATTACK
	SUB	BX,AX			;ENEMY_ATTACK - ( LEVEL * DEFENCE )
	XCHG	BX,AX	
	MOV	POP_X,50
	MOV	POP_Y,130
	MOV	POP_COLOR,1
	MOV	PUT_POP,AX
	CALL	@POP_DIGITS
	SUB	PLAYER_HP,AX
	POP	BX
	POP	AX
	RET
ATTACK_PLAYER	ENDP
;---------------------------------------------------------------------------------------------------------------------------
FLASH_ATTACK	PROC	NEAR	;X = 50 / Y = 120
	CALL	STRIKE
	MOV	FLASH_X2,65
	MOV	FLASH_Y2,120
	MOV	FLASH_X1,70
	MOV	FLASH_Y1,120
	MOV	FLASH_X3,75
	MOV	FLASH_Y3,120
FLASH_AGAIN:
	PUSH	FLASH_X1
	PUSH	FLASH_Y1
	PUSH	1
	CALL	SET_POINT

	PUSH	FLASH_X2
	PUSH	FLASH_Y2
	PUSH	1
	CALL	SET_POINT

	PUSH	FLASH_X3
	PUSH	FLASH_Y3
	PUSH	1
	CALL	SET_POINT

	CALL	DELAY3
	DEC	FLASH_X1
	DEC	FLASH_X2
	DEC	FLASH_X3
	INC	FLASH_Y1
	INC	FLASH_Y2
	INC	FLASH_Y3
	CMP	FLASH_X1,50
	JNL	FLASH_AGAIN
	


	MOV	AX,PLAYER_DEFENCE
	MOV	BX,PLAYER_LEVEL
	MUL	BX			;LEVEL * DEFENCE = AX
	MOV	BX,ENEMY_ATTACK
	CMP	AX,BX
	JG	SUB_OK
	MOV	AX,1
SUB_OK:	SUB	BX,AX			;ENEMY_ATTACK - ( LEVEL * DEFENCE )
	XCHG	BX,AX	
	MOV	POP_X,70
	MOV	POP_Y,130
	MOV	POP_COLOR,1
	MOV	PUT_POP,AX
	CALL	@POP_DIGITS
	SUB	PLAYER_HP,AX
	RET
FLASH_ATTACK	ENDP
;---------------------------------------------------------------------------------------------------------------------------
YOU_WIN		PROC	NEAR
	MOV	CX,EXP_VALUE
	ADD	PLAYER_EXP,CX
	CALL	ADJUST_LEVEL
	MOV	HEY_LOOP,7
	MOV	MOVE_PX,50
	MOV	CX,MONEY
	ADD	PLAYER_MONEY,CX
HEY:
	CALL	BG_FIGHTING
	CALL	LOADPLAYERFIGHT
	CALL	DELAY
	CALL	DELAY
	CALL	DELAY
	CALL	BG_FIGHTING
	CALL	PLAYERHEY
	CALL	DELAY
	CALL	DELAY
	CALL	DELAY
	DEC	HEY_LOOP
	CMP	HEY_LOOP,0
	JNE	HEY
	RET
YOU_WIN		ENDP
;---------------------------------------------------------------------------------------------------------------------------
RANDOM		PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	MOV	AH,2CH
	INT	21H
	XOR	AH,AH
	MOV	AL,DL
	MUL	DH			;( DL * DH ) = ( SEC * 1/100 SEC )
	MOV	BX,LIMIT_RANDOM		;RANDOM MOST THEN  999 IF YOU MOV BX 10 WILL RANDOM 0 - 9
	XOR	DX,DX
	DIV	BX
	MOV	NUM_RAN,DX
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
RANDOM		ENDP
;---------------------------------------------------------------------------------------------------------------------------
CHANGE_MODE_FIGHTING	PROC	NEAR	;320*240

PAINTBLOCK:
	PUSH	0		;L
	PUSH	BLOCKUP		;T
	PUSH	320		;W
	PUSH	BLOCKDOWN	;H
	PUSH	BLOCKDOWN
	CALL	FILL_BLOCK
	CALL	DELAY2
	DEC	BLOCKUP
	INC	BLOCKDOWN
	CMP	BLOCKUP,0
	JNE	PAINTBLOCK
	CALL	SETBGCOLOR
	MOV	BLOCKDOWN,120
	MOV	BLOCKUP,120
	RET
CHANGE_MODE_FIGHTING	ENDP
;---------------------------------------------------------------------------------------------------------------------------
HP_MP	PROC	NEAR
	PUSH	95	;L
	PUSH	205	;T
	PUSH	120	;W
	PUSH	230	;H
	PUSH	7
	CALL	FILL_BLOCK
	;--------------------------HP---------------------------------
	MOV	AX,PLAYER_HP
	MOV	FOR_LOOP,205
	CALL	GET_HP_MP
	;--------------------------MP---------------------------------
	MOV	AX,PLAYER_MP
	MOV	FOR_LOOP,220
	CALL	GET_HP_MP
	;------------------------------------------------------------- 
	RET
HP_MP	ENDP
;---------------------------------------------------------------------------------------------------------------------------
GET_HP_MP	PROC	NEAR

	
	

	CMP	AX,100
	JL	TWODIGIT
	XOR	DX,DX
	MOV	BX,100
	DIV	BX
	MOV	TEMP,DX
	ADD	AX,30H
	PUSH	AX
	PUSH	100		;X POSITION
	PUSH	FOR_LOOP	;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	7
	CALL	GPRINTC

	MOV	AX,TEMP
TWODIGIT:
	CMP	AX,10
	JL	ONEDIGIT
	XOR	DX,DX
	MOV	BX,10
	DIV	BX
	MOV	TEMP,DX
	ADD	AX,30H
	PUSH	AX
	PUSH	108		;X POSITION
	PUSH	FOR_LOOP	;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	7
	CALL	GPRINTC
	JMP	OHON
ONEDIGIT:	
	MOV	TEMP,AX
OHON:
	ADD	TEMP,30H

	PUSH	TEMP
	PUSH	116		;X POSITION
	PUSH	FOR_LOOP	;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	7
	CALL	GPRINTC
	RET
GET_HP_MP	ENDP
;---------------------------------------------------------------------------------------------------------------------------
LIMIT	PROC	NEAR
	PUSH	80	;L
	PUSH	190	;T
	PUSH	150	;W
	PUSH	197	;H
	PUSH	00F0H	;COLOR
	CALL	FILL_BLOCK

	MOV	ADDLIMIT,81
INCREASELIMIT:
	PUSH	81		;L
	PUSH	191		;T
	PUSH	ADDLIMIT	;W
	PUSH	196		;H
	PUSH	100		;COLOR
	CALL	FILL_BLOCK
	CALL	DELAY
	INC	ADDLIMIT
	CMP	ADDLIMIT,150
	JNE	INCREASELIMIT
	MOV	LIMIT_MAX,1
	RET
LIMIT	ENDP
;---------------------------------------------------------------------------------------------------------------------------
MENU	PROC	NEAR
;------------------BLOCK----------------
	PUSH	2	;L
	PUSH	2	;T
	PUSH	316	;W
	PUSH	20	;H
	PUSH	255	;COLOR

	CALL	FILL_BLOCK
	PUSH	4	;L
	PUSH	4	;T
	PUSH	314	;W
	PUSH	18	;H
	PUSH	0H
	CALL	FILL_BLOCK

	
	PUSH	2	;L
	PUSH	171	;T
	PUSH	78	;W
	PUSH	236	;H
	PUSH	255	;COLOR
	CALL	FILL_BLOCK


	PUSH	2	;L
	PUSH	180	;T
	PUSH	316	;W
	PUSH	236	;H
	PUSH	255	;COLOR
	CALL	FILL_BLOCK

	PUSH	4	;L
	PUSH	182	;T
	PUSH	314	;W
	PUSH	234	;H
	PUSH	7
	CALL	FILL_BLOCK

	PUSH	4	;L
	PUSH	173	;T
	PUSH	76	;W
	PUSH	200	;H
	PUSH	7	;COLOR
	CALL	FILL_BLOCK

	
	;------------------STRING----------------
	PUSH	DS
	PUSH	OFFSET STR_LEVEL
	PUSH	255
	PUSH	13		;X POSITION
	PUSH	175		;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	7
	CALL	PRINT_STR
	MOV	CX,PLAYER_LEVEL
	MOV	PUT_POP,CX
	MOV	POP_COLOR,255
	MOV	POP_X,43
	MOV	POP_Y,175
	CALL	MAX_VALUE

	PUSH	DS
	PUSH	OFFSET STR_ATTACK
	PUSH	255
	PUSH	20		;X POSITION
	PUSH	190		;Y POSITION
	PUSH	ATTACK_COLOR		;FONT COLOR		
	PUSH	7
	CALL	PRINT_STR

	PUSH	DS
	PUSH	OFFSET STR_MAGIC
	PUSH	255
	PUSH	20		;X POSITION
	PUSH	205		;Y POSITION
	PUSH	MAGIC_COLOR	;FONT COLOR		
	PUSH	7
	CALL	PRINT_STR

	PUSH	DS
	PUSH	OFFSET STR_ITEM
	PUSH	255
	PUSH	20		;X POSITION
	PUSH	220		;Y POSITION
	PUSH	ITEM_COLOR	;FONT COLOR		
	PUSH	7
	CALL	PRINT_STR
	
	PUSH	DS
	PUSH	OFFSET STR_HP
	PUSH	255
	PUSH	80		;X POSITION
	PUSH	205		;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	7
	CALL	PRINT_STR
	CALL	GET_MAX_HP_MP
	MOV	CX,MAX_HP
	MOV	PUT_POP,CX
	MOV	POP_COLOR,255
	MOV	POP_X,137
	MOV	POP_Y,205
	CALL	MAX_VALUE

	
	
	PUSH	DS
	PUSH	OFFSET STR_MP
	PUSH	255
	PUSH	80		;X POSITION
	PUSH	220		;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	7
	CALL	PRINT_STR
	CALL	GET_MAX_HP_MP
	MOV	CX,MAX_MP
	MOV	PUT_POP,CX
	MOV	POP_COLOR,255
	MOV	POP_X,137
	MOV	POP_Y,220
	CALL	MAX_VALUE
	RET
MENU	ENDP
;---------------------------------------------------------------------------------------------------------------------------
MAX_VALUE	PROC	NEAR
	MOV	AX,PUT_POP
	CMP	AX,100
	JL	TWO_DIGITS
	XOR	DX,DX
	MOV	BX,100
	DIV	BX
	MOV	TEMP,DX
	ADD	AX,30H
	PUSH	AX
	PUSH	POP_X		;X POSITION
	PUSH	POP_Y		;Y POSITION
	PUSH	POP_COLOR	;FONT COLOR		
	PUSH	7
	CALL	GPRINTC
	MOV	AX,TEMP
	JMP	@NEXT
TWO_DIGITS:
	CMP	AX,10
	JL	ONE_DIGIT
@NEXT:	
	XOR	DX,DX
	MOV	BX,10
	DIV	BX
	MOV	TEMP,DX
	ADD	AX,30H
	ADD	POP_X,8
	PUSH	AX
	PUSH	POP_X		;X POSITION
	PUSH	POP_Y		;Y POSITION
	PUSH	POP_COLOR	;FONT COLOR		
	PUSH	7
	CALL	GPRINTC
	JMP	OH_ON
ONE_DIGIT:	
	MOV	TEMP,AX
OH_ON:
	ADD	POP_X,8
	ADD	TEMP,30H
	PUSH	TEMP
	PUSH	POP_X		;X POSITION
	PUSH	POP_Y		;Y POSITION
	PUSH	POP_COLOR	;FONT COLOR		
	PUSH	7
	CALL	GPRINTC
	RET
MAX_VALUE	ENDP
;---------------------------------------------------------------------------------------------------------------------------
OPTION	PROC	NEAR
	CALL	HP_MP
	CALL	LIMIT
	CALL	CHECK_KEY_FIGHTING
	CALL	PASTE
	RET
OPTION	ENDP
;---------------------------------------------------------------------------------------------------------------------------
PRINT_LIMIT	PROC	NEAR
	PUSH	80	;L
	PUSH	190	;T
	PUSH	150	;W
	PUSH	197	;H
	PUSH	00F0H	;COLOR
	CALL	FILL_BLOCK
	PUSH	81		;L
	PUSH	191		;T
	PUSH	149		;W
	PUSH	196		;H
	PUSH	100		;COLOR
	CALL	FILL_BLOCK
	CALL	HP_MP
	RET
PRINT_LIMIT	ENDP
;---------------------------------------------------------------------------------------------------------------------------
CHECK_KEY_FIGHTING	PROC	NEAR
	PUSH	AX
	MOV	SELECT_MENU,1
BEGIN_CHECK:
	CMP	SELECT_MENU,1
	JNE	CHOICE2
	MOV	ATTACK_COLOR,1
	MOV	MAGIC_COLOR,255
	MOV	ITEM_COLOR,255
	JMP	PRESSED
CHOICE2: CMP	SELECT_MENU,2
	JNE	CHOICE3
	MOV	ATTACK_COLOR,255
	MOV	MAGIC_COLOR,1
	MOV	ITEM_COLOR,255
	JMP	PRESSED
CHOICE3:
	MOV	ATTACK_COLOR,255
	MOV	MAGIC_COLOR,255
	MOV	ITEM_COLOR,1	
	JMP	PRESSED
BRIDGE:	CALL	LOADPLAYERFIGHT
	JMP	BEGIN_CHECK
PRESSED:
	CALL	MENU 
	CALL	PRINT_LIMIT
	CALL	KEYPRESSED
	CALL	READKEY
	MOV	TEMPKEY,AH

	CMP	TEMPKEY,48H	;KEYUP-----------
	JNE	@NOTUP				;
	DEC	SELECT_MENU
	CMP	SELECT_MENU,0
	JNE	BEGIN_CHECK
	MOV	SELECT_MENU,3
	JMP	BEGIN_CHECK
@NOTUP:;------------------------------------------
	CMP	TEMPKEY,50H	;KEYDOWN---------
	JNE	@NOTDOWN			;
	INC	SELECT_MENU
	CMP	SELECT_MENU,4
	JNE	BRIDGE
	MOV	SELECT_MENU,1
	JMP	BEGIN_CHECK
@NOTDOWN:;------------------------------------------
	CMP	TEMPKEY,1CH	;KEYENTER---------
	JNE	BRIDGE	


	JMP	@ENTER
@ENTER:;--------------------------------------
	
	CALL	PASTE
	CALL	PRINT_LIMIT

	CMP	SELECT_MENU,1
	JNE	MENU2
	CALL	OPTION_ATTACK
	JMP	XX
MENU2:	
	CMP	SELECT_MENU,2
	JNE	MENU3
	CMP	PLAYER_MP,2
	JL	BRIDGE
	CALL	ACTION2
	JMP	XX
MENU3:	

	CALL	OPTION_ITEM
SELECT_OK:
	MOV	ATTACK_COLOR,255
	MOV	MAGIC_COLOR,255
	MOV	ITEM_COLOR,255
	
XX:	CALL	MENU
	POP	AX
	RET
CHECK_KEY_FIGHTING	ENDP
;---------------------------------------------------------------------------------------------------------------------------
OPTION_ATTACK	PROC	NEAR
	
	CALL	COPY
	CALL	PLAYERREADY
	MOV	FOR_LOOP,7
READY:	CALL	DELAY
	DEC	FOR_LOOP
	CMP	FOR_LOOP,0
	JNE	READY
	CALL	PASTE
	CALL	COPY
	MOV	MOVE_PX,30
JUMP:				;ENEMY X = 230
	ADD	MOVE_PX,25
	CALL	DELAY_MAGIC
	CALL	PLAYERHEY
	CALL	PASTE
	CALL	COPY
	CMP	MOVE_PX,210
	JL	JUMP
	ADD	MOVE_PX,5
	CALL	PLAYERATTACK
	ADD	MOVE_PX,10
	CALL	FLASHATTACK
	CALL	DELAY
	CALL	DELAY
	CALL	PASTE
	CALL	LOADPLAYERFIGHT
;--------DECREASE HP ENEMY----------
	MOV	AX,PLAYER_ATTACK
	MOV	BX,PLAYER_LEVEL
	MUL	BX
	MOV	POP_X,240
	MOV	POP_Y,130
	MOV	POP_COLOR,1
	MOV	PUT_POP,AX
	CALL	@POP_DIGITS
	SUB	ENEMY_HP,AX
	RET
OPTION_ATTACK	ENDP
;---------------------------------------------------------------------------------------------------------------------------
ACTION2	PROC	NEAR
	CALL	COPY
		
	CALL	MENU_MAGIC
	CALL	OPTION2
	CALL	PASTE
	CALL	LOADPLAYERFIGHT
	RET
ACTION2	ENDP
;---------------------------------------------------------------------------------------------------------------------------

ITEM_DETAIL	PROC	NEAR

	PUSH	165	;L
	PUSH	182	;T
	PUSH	314	;W
	PUSH	234	;H
	PUSH	0 	;COLOR
	CALL	FILL_BLOCK

	PUSH	166	;L
	PUSH	183	;T
	PUSH	313	;W
	PUSH	233	;H
	PUSH	255 	;COLOR
	CALL	FILL_BLOCK

	PUSH	168	;L
	PUSH	185	;T
	PUSH	311	;W
	PUSH	231	;H
	PUSH	0
	CALL	FILL_BLOCK

	;------------------STRING----------------
	PUSH	DS
	PUSH	OFFSET STR_I1
	PUSH	255
	PUSH	174		;X POSITION
	PUSH	190		;Y POSITION
	PUSH	M1_COLOR	;FONT COLOR		
	PUSH	0
	CALL	PRINT_STR

	PUSH	DS
	PUSH	OFFSET STR_I2
	PUSH	255
	PUSH	174		;X POSITION
	PUSH	205		;Y POSITION
	PUSH	M2_COLOR	;FONT COLOR		
	PUSH	0
	CALL	PRINT_STR

	PUSH	DS
	PUSH	OFFSET STR_I3
	PUSH	255
	PUSH	174		;X POSITION
	PUSH	220		;Y POSITION
	PUSH	M3_COLOR	;FONT COLOR		
	PUSH	0
	CALL	PRINT_STR
	
	RET
ITEM_DETAIL	ENDP
;---------------------------------------------------------------------------------------------------------------------------
OPTION_ITEM	PROC	NEAR


	CALL	COPY
	CALL	MENU
	CALL	MENU_ITEMS
	;CALL	OPTION2

	CALL	CHECK_KEY_ITEM
	;CALL	PASTE
	;CALL	LOADPLAYERFIGHT

	RET
OPTION_ITEM	ENDP
;---------------------------------------------------------------------------------------------------------------------------
OPTION2	PROC	NEAR
	CALL	LOADPLAYERFIGHT
	CALL	CHECK_KEY_MAGIC
	RET
OPTION2	ENDP
;---------------------------------------------------------------------------------------------------------------------------
CHECK_KEY_MAGIC	PROC	NEAR
	PUSH	AX
	MOV	SELECT_MENU2,1
BEGIN_CHECK2:
	CMP	SELECT_MENU2,1
	JNE	MAGIC2
	MOV	M1_COLOR,1
	MOV	M2_COLOR,255
	MOV	M3_COLOR,255
	MOV	M4_COLOR,255
	JMP	MAGIC_PRESSED
MAGIC2: CMP	SELECT_MENU2,2
	JNE	MAGIC3
	MOV	M1_COLOR,255
	MOV	M2_COLOR,1
	MOV	M3_COLOR,255
	MOV	M4_COLOR,255
	JMP	MAGIC_PRESSED
MAGIC3: CMP	SELECT_MENU2,3
	JNE	MAGIC4
	MOV	M1_COLOR,255
	MOV	M2_COLOR,255
	MOV	M3_COLOR,1
	MOV	M4_COLOR,255	
	JMP	MAGIC_PRESSED
MAGIC4:
	MOV	M1_COLOR,255
	MOV	M2_COLOR,255
	MOV	M3_COLOR,255
	MOV	M4_COLOR,1	
	JMP	MAGIC_PRESSED
BRIDGE2:	
	JMP	BEGIN_CHECK2
MAGIC_PRESSED:
	CALL	MENU_MAGIC
	CALL	KEYPRESSED
	CALL	READKEY
	MOV	TEMPKEY,AH

	CMP	TEMPKEY,48H	;KEYUP-----------
	JNE	@NOTUP2				;
	DEC	SELECT_MENU2
	CMP	SELECT_MENU2,0
	JNE	BRIDGE2
	MOV	SELECT_MENU2,4
	JMP	BEGIN_CHECK2
@NOTUP2:;------------------------------------------
	CMP	TEMPKEY,50H	;KEYDOWN---------
	JNE	@NOTDOWN2			;
	INC	SELECT_MENU2
	CMP	SELECT_MENU2,5
	JNE	BRIDGE2
	MOV	SELECT_MENU2,1
;BRIDGE3: CALL	LOADPLAYERFIGHT
	JMP	BRIDGE2
@NOTDOWN2:;------------------------------------------
	CMP	TEMPKEY,1CH	;KEYENTER---------
	JNE	BRIDGE2	


	JMP	@ENTER2
@ENTER2:;--------------------------------------
	
	CALL	PASTE
	CALL	PLAYERMAGIC
	CALL	PRINT_LIMIT

	CMP	SELECT_MENU2,1
	JNE	SELECT_BOLT
	CALL	MAGIC_FIRE
	JMP	SELECT_0K2
SELECT_BOLT:
	CMP	SELECT_MENU2,2
	JNE	SELECT_COMET
	CMP	PLAYER_MP,3
	JL	NO_USE
	CALL	MAGIC_BOLT
	JMP	SELECT_0K2
SELECT_COMET:
	CMP	SELECT_MENU2,3
	JNE	SELECT_CURE
	CMP	PLAYER_MP,5
	JL	NO_USE
	CALL	MAGIC_COMET
	JMP	SELECT_0K2
SELECT_CURE:
	CMP	PLAYER_MP,4
	JL	NO_USE
	CALL	MAGIC_CURE
SELECT_0K2:
	MOV	M1_COLOR,255
	MOV	M2_COLOR,255
	MOV	M3_COLOR,255
	MOV	M4_COLOR,255
NO_USE:	POP	AX
	RET
CHECK_KEY_MAGIC	ENDP
;---------------------------------------------------------------------------------------------------------------------------
CHECK_KEY_ITEM	PROC	NEAR
	MOV	SELECT_MENU2,1
	CALL	LOADPLAYERFIGHT
BEGIN_CHECK3:
	;CALL	MENU_ITEMS
	;CALL	ITEM_DETAIL
	CMP	SELECT_MENU2,1
	JNE	@ITEM2
	MOV	M1_COLOR,1
	MOV	M2_COLOR,255
	MOV	M3_COLOR,255
	JMP	ITEM_PRESSED
@ITEM2: CMP	SELECT_MENU2,2
	JNE	@ITEM3
	MOV	M1_COLOR,255
	MOV	M2_COLOR,1
	MOV	M3_COLOR,255
	JMP	ITEM_PRESSED
@ITEM3:
	MOV	M1_COLOR,255
	MOV	M2_COLOR,255
	MOV	M3_COLOR,1
	JMP	ITEM_PRESSED
BRIDGE_2:	
	JMP	BEGIN_CHECK3
ITEM_PRESSED:
	CALL	MENU_ITEMS
	CALL	KEYPRESSED
	CALL	READKEY
	MOV	TEMPKEY,AH

	CMP	TEMPKEY,48H	;KEYUP-----------
	JNE	@NOTUP_2				;
	DEC	SELECT_MENU2
	CMP	SELECT_MENU2,0
	JNE	BRIDGE_2
	MOV	SELECT_MENU2,3
	JMP	BEGIN_CHECK3
@NOTUP_2:;------------------------------------------
	CMP	TEMPKEY,50H	;KEYDOWN---------
	JNE	@NOTDOWN_2			;
	INC	SELECT_MENU2
	CMP	SELECT_MENU2,4
	JNE	BRIDGE_2
	MOV	SELECT_MENU2,1
	JMP	BRIDGE_2
@NOTDOWN_2:;------------------------------------------
	CMP	TEMPKEY,1CH	;KEYENTER---------
	JNE	BRIDGE_2	

	CALL	PASTE
	CALL	LOADPLAYERFIGHT
	CALL	PRINT_LIMIT

	CMP	SELECT_MENU2,1
	JNE	SELECT_MPMAX
	CMP	ITEM1,0
	JE	@NO_USE
	CALL	ITEM_HP_MAX
	DEC	ITEM1
	JMP	SELECT_0K3
SELECT_MPMAX:
	CMP	SELECT_MENU2,2
	JNE	SELECT_REVIVE
	CMP	ITEM2,0
	JE	@NO_USE
	CALL	ITEM_MP_MAX
	JMP	SELECT_0K3
SELECT_REVIVE:
	CMP	ITEM3,0
	JE	@NO_USE
	CALL	ITEM_HP_MP_MAX
SELECT_0K3:
@NO_USE:	
	MOV	M1_COLOR,255
	MOV	M2_COLOR,255
	MOV	M3_COLOR,255
	
	RET
CHECK_KEY_ITEM	ENDP
;---------------------------------------------------------------------------------------------------------------------------
ITEM_HP_MAX	PROC	NEAR
	DEC	ITEM1
	CALL	GET_MAX_HP_MP
	MOV	CX,MAX_HP
	MOV	PLAYER_HP,CX
	RET
ITEM_HP_MAX	ENDP
;---------------------------------------------------------------------------------------------------------------------------
ITEM_MP_MAX	PROC	NEAR
	DEC	ITEM2
	CALL	GET_MAX_HP_MP
	MOV	CX,MAX_MP
	MOV	PLAYER_MP,CX
	RET
ITEM_MP_MAX	ENDP
;---------------------------------------------------------------------------------------------------------------------------
ITEM_HP_MP_MAX	PROC	NEAR
	DEC	ITEM3
	CALL	GET_MAX_HP_MP
	MOV	CX,MAX_MP
	MOV	PLAYER_MP,CX
	MOV	CX,MAX_HP
	MOV	PLAYER_HP,CX
	RET
ITEM_HP_MP_MAX	ENDP
;---------------------------------------------------------------------------------------------------------------------------
MENU_MAGIC	PROC	NEAR

	PUSH	165	;L
	PUSH	182	;T
	PUSH	314	;W
	PUSH	234	;H
	PUSH	0 	;COLOR
	CALL	FILL_BLOCK

	PUSH	166	;L
	PUSH	183	;T
	PUSH	313	;W
	PUSH	233	;H
	PUSH	255 	;COLOR
	CALL	FILL_BLOCK

	PUSH	168	;L
	PUSH	185	;T
	PUSH	311	;W
	PUSH	231	;H
	PUSH	0
	CALL	FILL_BLOCK

	;------------------STRING----------------
	PUSH	DS
	PUSH	OFFSET STR_M1
	PUSH	255
	PUSH	174		;X POSITION
	PUSH	190		;Y POSITION
	PUSH	M1_COLOR		;FONT COLOR		
	PUSH	0
	CALL	PRINT_STR

	PUSH	DS
	PUSH	OFFSET STR_M2
	PUSH	255
	PUSH	174		;X POSITION
	PUSH	205		;Y POSITION
	PUSH	M2_COLOR	;FONT COLOR		
	PUSH	0
	CALL	PRINT_STR

	PUSH	DS
	PUSH	OFFSET STR_M3
	PUSH	255
	PUSH	174		;X POSITION
	PUSH	220		;Y POSITION
	PUSH	M3_COLOR	;FONT COLOR		
	PUSH	0
	CALL	PRINT_STR
	
	PUSH	DS
	PUSH	OFFSET STR_M4
	PUSH	255
	PUSH	245		;X POSITION
	PUSH	190		;Y POSITION
	PUSH	M4_COLOR	;FONT COLOR		
	PUSH	0
	CALL	PRINT_STR
	RET
MENU_MAGIC	ENDP
;---------------------------------------------------------------------------------------------------------------------------
MENU_ITEMS	PROC	NEAR

	PUSH	165	;L
	PUSH	182	;T
	PUSH	314	;W
	PUSH	234	;H
	PUSH	0 	;COLOR
	CALL	FILL_BLOCK

	PUSH	166	;L
	PUSH	183	;T
	PUSH	313	;W
	PUSH	233	;H
	PUSH	255 	;COLOR
	CALL	FILL_BLOCK

	PUSH	168	;L
	PUSH	185	;T
	PUSH	311	;W
	PUSH	231	;H
	PUSH	0
	CALL	FILL_BLOCK

	;------------------STRING----------------
	PUSH	DS
	PUSH	OFFSET STR_I1
	PUSH	255
	PUSH	174		;X POSITION
	PUSH	190		;Y POSITION
	PUSH	M1_COLOR		;FONT COLOR		
	PUSH	0
	CALL	PRINT_STR

	PUSH	DS
	PUSH	OFFSET STR_I2
	PUSH	255
	PUSH	174		;X POSITION
	PUSH	205		;Y POSITION
	PUSH	M2_COLOR	;FONT COLOR		
	PUSH	0
	CALL	PRINT_STR

	PUSH	DS
	PUSH	OFFSET STR_I3
	PUSH	255
	PUSH	174		;X POSITION
	PUSH	220		;Y POSITION
	PUSH	M3_COLOR	;FONT COLOR		
	PUSH	0
	CALL	PRINT_STR
	
	RET
MENU_ITEMS	ENDP
;---------------------------------------------------------------------------------------------------------------------------
GETTIME	PROC	NEAR
	PUSH	AX
	MOV	AH,2CH
	INT	21H
	POP	AX
	RET
GETTIME	ENDP
;---------------------------------------------------------------------------------------------------------------------------
MAGIC_FIRE	PROC	NEAR
	MOV	FOR_LOOP,20
	MOV	LIMIT_RANDOM,40
LOOP_FIRE:
	CALL	RANDOM
	ADD	NUM_RAN,220
	
	CALL	COPY
	CALL	PLAYERSTAND
	PUSH	DS
	PUSH	OFFSET F3		;File address
	PUSH	NUM_RAN			;X position
	PUSH	80			;y position
	PUSH	60			;Width
	PUSH	60			;Height
	CALL	DISPLAY_TPIC
	CALL	DELAY

	PUSH	DS
	PUSH	OFFSET F2		;File address
	PUSH	NUM_RAN			;X position
	PUSH	80			;y position
	PUSH	60			;Width
	PUSH	60			;Height
	CALL	DISPLAY_TPIC
	CALL	DELAY_MAGIC

	PUSH	DS
	PUSH	OFFSET F1		;File address
	PUSH	NUM_RAN			;X position
	PUSH	80			;y position
	PUSH	60			;Width
	PUSH	60			;Height
	CALL	DISPLAY_TPIC
	CALL	DELAY2
	CALL	PASTE
	DEC	FOR_LOOP
	CMP	FOR_LOOP,0
	JNE	LOOP_FIRE
;--------DECREASE HP ENEMY----------
	MOV	AX,10
	MOV	BX,PLAYER_LEVEL
	MUL	BX
	MOV	POP_X,240
	MOV	POP_Y,130
	MOV	POP_COLOR,1
	MOV	PUT_POP,AX
	CALL	@POP_DIGITS
	SUB	ENEMY_HP,AX
	SUB	PLAYER_MP,2
	RET
MAGIC_FIRE	ENDP
;---------------------------------------------------------------------------------------------------------------------------
MAGIC_BOLT	PROC	NEAR
	
	MOV	FOR_LOOP,20
	MOV	LIMIT_RANDOM,40
LOOP_BOLT:
	CALL	RANDOM
	ADD	NUM_RAN,220
	CALL	COPY
	CALL	PLAYERSTAND
	PUSH	DS
	PUSH	OFFSET BOLT3		;File address
	PUSH	NUM_RAN			;X position
	PUSH	30			;y position
	PUSH	60			;Width
	PUSH	110			;Height
	CALL	DISPLAY_TPIC
	CALL	DELAY_MAGIC
	PUSH	DS
	PUSH	OFFSET BOLT2		;File address
	PUSH	NUM_RAN			;X position
	PUSH	30			;y position
	PUSH	60			;Width
	PUSH	110			;Height
	CALL	DISPLAY_TPIC
	CALL	DELAY_MAGIC
	PUSH	DS
	PUSH	OFFSET BOLT1		;File address
	PUSH	NUM_RAN			;X position
	PUSH	30			;y position
	PUSH	60			;Width
	PUSH	110			;Height
	CALL	DISPLAY_TPIC
	CALL	DELAY_MAGIC
	CALL	PASTE
	DEC	FOR_LOOP
	CMP	FOR_LOOP,0
	JNE	LOOP_BOLT
;--------DECREASE HP ENEMY----------
	MOV	AX,15
	MOV	BX,PLAYER_LEVEL
	MUL	BX
	MOV	POP_X,240
	MOV	POP_Y,130
	MOV	POP_COLOR,1
	MOV	PUT_POP,AX
	CALL	@POP_DIGITS
	SUB	ENEMY_HP,AX
	SUB	PLAYER_MP,3
	RET
MAGIC_BOLT	ENDP
;---------------------------------------------------------------------------------------------------------------------------
MAGIC_COMET	PROC	NEAR
	MOV	COMET_PX,0
	MOV	COMET_PY,0
LOOP_COMET:	
	CALL	COPY
	CALL	PLAYERSTAND
	ADD	COMET_PY,5
	ADD	COMET_PX,13
	PUSH	DS
	PUSH	OFFSET COMET0		;File address
	PUSH	COMET_PX		;X position
	PUSH	COMET_PY		;y position
	PUSH	60			;Width
	PUSH	60			;Height
	CALL	DISPLAY_TPIC
	CALL	DELAY2
	CALL	PASTE
	CMP	COMET_PY,90
	JL	LOOP_COMET

	MOV	FOR_LOOP,30
	MOV	LIMIT_RANDOM,40
LOOP_COMET2:
	CALL	RANDOM
	ADD	NUM_RAN,220
	
	CALL	COPY
	CALL	PLAYERSTAND
	PUSH	DS
	PUSH	OFFSET BOOM1		;File address
	PUSH	NUM_RAN			;X position
	PUSH	90			;y position
	PUSH	60			;Width
	PUSH	60			;Height
	CALL	DISPLAY_TPIC
	CALL	DELAY_MAGIC

	PUSH	DS
	PUSH	OFFSET BOOM2		;File address
	PUSH	NUM_RAN			;X position
	PUSH	90		;y position
	PUSH	60			;Width
	PUSH	60			;Height
	CALL	DISPLAY_TPIC
	CALL	DELAY_MAGIC

	PUSH	DS
	PUSH	OFFSET BOOM3		;File address
	PUSH	NUM_RAN			;X position
	PUSH	90		;y position
	PUSH	60			;Width
	PUSH	60			;Height
	CALL	DISPLAY_TPIC
	CALL	DELAY_MAGIC
	CALL	PASTE
	DEC	FOR_LOOP
	CMP	FOR_LOOP,0
	JNE	LOOP_COMET2
;--------DECREASE HP ENEMY----------
	MOV	AX,20
	MOV	BX,PLAYER_LEVEL
	MUL	BX
	MOV	POP_X,240
	MOV	POP_Y,130
	MOV	POP_COLOR,1
	MOV	PUT_POP,AX
	CALL	@POP_DIGITS
	SUB	ENEMY_HP,AX
	SUB	PLAYER_MP,5
	RET
MAGIC_COMET	ENDP
;---------------------------------------------------------------------------------------------------------------------------
MAGIC_CURE	PROC	NEAR
	
	MOV	FOR_LOOP,15
	MOV	LIMIT_RANDOM,18
LOOP_CURE:
	CALL	RANDOM
	ADD	NUM_RAN,50
	MOV	TEMP,140
	CALL	COPY
	CALL	PLAYERSTAND

	MOV	TEMP,140
LOOP_CURE2:
	CALL	GETTIME
	PUSH	NUM_RAN
	PUSH	TEMP
	PUSH	DX
	CALL	SET_POINT
	CALL	DELAY2
	DEC	TEMP
	CMP	TEMP,125
	JG	LOOP_CURE2
	
	CALL	RANDOM
	ADD	NUM_RAN,50
	MOV	TEMP,140
LOOP_CURE3:
	CALL	GETTIME
	PUSH	NUM_RAN
	PUSH	TEMP
	PUSH	DX
	CALL	SET_POINT
	CALL	DELAY2
	DEC	TEMP
	CMP	TEMP,115
	JG	LOOP_CURE3
	JMP	NEXT_CURE
BRIDGE_CURE:
	JMP	LOOP_CURE
NEXT_CURE:	
	CALL	RANDOM
	ADD	NUM_RAN,50
	MOV	TEMP,140
LOOP_CURE4:
	CALL	GETTIME
	PUSH	NUM_RAN
	PUSH	TEMP
	PUSH	DX
	CALL	SET_POINT
	CALL	DELAY2
	DEC	TEMP
	CMP	TEMP,120
	JG	LOOP_CURE4

	CALL	PASTE
	DEC	FOR_LOOP
	CMP	FOR_LOOP,0
	JNE	BRIDGE_CURE
;--------INCREASE HP ENEMY----------
	CALL	PLAYERSTAND
	SUB	PLAYER_MP,4
	CALL	GET_MAX_HP_MP
	ADD	PLAYER_HP,50
	MOV	BX,PLAYER_HP
	CMP	BX,MAX_HP
	JNG	CURE_OK
	MOV	BX,MAX_HP
	MOV	PLAYER_HP,BX
CURE_OK: MOV	POP_X,70
	MOV	POP_Y,130
	MOV	POP_COLOR,100 
	MOV	PUT_POP,50
	CALL	@POP_DIGITS
	
 RET
MAGIC_CURE	ENDP
;---------------------------------------------------------------------------------------------------------------------------
@POP_DIGITS	PROC	NEAR
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX

	MOV	AX,PUT_POP
	CMP	AX,100
	JL	@TWODIGITS
	XOR	DX,DX
	MOV	BX,100
	DIV	BX
	MOV	TEMP,DX
	ADD	AX,30H
	PUSH	AX
	PUSH	POP_X		;X POSITION
	PUSH	POP_Y		;Y POSITION
	PUSH	POP_COLOR	;FONT COLOR		
	PUSH	7
	CALL	GPRINTC
	MOV	AX,TEMP
	JMP	@POP_NEXT
@TWODIGITS:
	CMP	AX,10
	JL	@ONEDIGIT
@POP_NEXT:
	XOR	DX,DX
	MOV	BX,10
	DIV	BX
	MOV	TEMP,DX
	ADD	POP_X,8
	ADD	AX,30H
	PUSH	AX
	PUSH	POP_X		;X POSITION
	PUSH	POP_Y		;Y POSITION
	PUSH	POP_COLOR	;FONT COLOR		
	PUSH	7
	CALL	GPRINTC
	JMP	@OHON
@ONEDIGIT:	
	MOV	TEMP,AX
@OHON:
	ADD	TEMP,30H
	ADD	POP_X,8

	PUSH	TEMP
	PUSH	POP_X		;X POSITION
	PUSH	POP_Y		;Y POSITION
	PUSH	POP_COLOR	;FONT COLOR		
	PUSH	7
	CALL	GPRINTC
	MOV	FOR_LOOP,7
LOOPX:	CALL	DELAY
	DEC	FOR_LOOP
	CMP	FOR_LOOP,0
	JNE	LOOPX
	CALL	PASTE
	CALL	LOADPLAYERFIGHT
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
@POP_DIGITS	ENDP
;---------------------------------------------------------------------------------------------------------------------------

PASTE	PROC	NEAR
	PUSH	1					
	PUSH	0					
	CALL	COPY_PAGE	
	RET
PASTE	ENDP
;---------------------------------------------------------------------------------------------------------------------------
COPY	PROC	NEAR
	PUSH	0				
	PUSH	1					
	CALL	COPY_PAGE	
	RET
COPY	ENDP
;---------------------------------------------------------------------------------------------------------------------------
STATUS	PROC	NEAR
	MOV	BLOCKUP,130
	MOV	BLOCKDOWN,110

BLOCK:
	MOV	DX,BLOCKUP
	ADD	DX,2
	PUSH	0		;L
	PUSH	BLOCKUP		;T
	PUSH	320		;W
	PUSH	DX		;H
	PUSH	255
	CALL	FILL_BLOCK
	MOV	CX,BLOCKUP
	MOV	BX,BLOCKDOWN
	ADD	CX,2
	SUB	BX,2
	PUSH	2		;L
	PUSH	CX		;T
	PUSH	318		;W
	PUSH	BX		;H
	PUSH	7
	CALL	FILL_BLOCK
	MOV	DX,BLOCKDOWN
	SUB	DX,2
	PUSH	0		;L
	PUSH	DX	;T
	PUSH	320		;W
	PUSH	BLOCKDOWN		;H
	PUSH	255
	CALL	FILL_BLOCK

	CALL	DELAY2
	DEC	BLOCKUP
	INC	BLOCKDOWN
	CMP	BLOCKUP,0
	JNL	BLOCK
	MOV	BLOCKDOWN,120
	MOV	BLOCKUP,120
	CALL	DETAIL
	RET
STATUS	ENDP
;---------------------------------------------------------------------------------------------------------------------------
DETAIL	PROC	NEAR
	MOV	C1,255
	MOV	B1,10
	MOV	C2,255
	MOV	B2,10
	MOV	C3,255
	MOV	B3,10
	MOV	C4,255
	MOV	B4,10
	MOV	C5,255
	MOV	B5,10
	MOV	SELECT_DETAIL,1
	PUSH	DS
	PUSH	OFFSET TEE		;File address
	PUSH	10			;X position
	PUSH	10			;y position
	PUSH	100			;Width
	PUSH	100			;Height
	CALL	DISPLAY_PIC
	CALL	PRINT_DETAIL
	CALL	@MENU_STATUS
BEGIN_DETAIL:
	CALL	KEYPRESSED	
	JZ	BEGIN_DETAIL
	CALL	CHECK_KEY_DETAIL
	RET
DETAIL	ENDP
;---------------------------------------------------------------------------------------------------------------------------
CHECK_KEY_DETAIL	PROC	NEAR
	PUSH	AX
	MOV	SELECT_DETAIL,1
START_DETAIL:
	CALL	PRINT_DETAIL
	CALL	READKEY
	MOV	TEMPKEY,AH
	CMP	TEMPKEY,48H	;KEYUP-----------
	JNE	DETAIL_NOTUP				
	DEC	SELECT_DETAIL
	CMP	SELECT_DETAIL,0
	JNE	START_DETAIL
	MOV	SELECT_DETAIL,5
	JMP	START_DETAIL
DETAIL_NOTUP:;------------------------------------------
	CMP	TEMPKEY,50H	;KEYDOWN---------
	JNE	DETAIL_NOTDOWN				
	INC	SELECT_DETAIL
	CMP	SELECT_DETAIL,6
	JNE	START_DETAIL
	MOV	SELECT_DETAIL,1
	JMP	START_DETAIL
	
DETAIL_NOTDOWN:;----------------------------------------
	CMP	TEMPKEY,39H	;TAB----------
	JNE	DETAIL_NOTTAB				
	JMP	DETAIL_EXITCHECK				
DETAIL_NOTTAB:;---------------------------------------
	CMP	TEMPKEY,1CH	;KEYENTER--------
	JNE	START_DETAIL

	CMP	SELECT_DETAIL,1
	JNE	SELECT_MAGIC
	CALL	@MENU_STATUS
	JMP	START_DETAIL	
SELECT_MAGIC:
	CMP	SELECT_DETAIL,2
	JNE	SELECT_ITEM
	CALL	@MENU_MAGIC
	JMP	START_DETAIL
SELECT_ITEM:
	CMP	SELECT_DETAIL,3
	JNE	SELECT_SAVE
	;CALL
	JMP	START_DETAIL

SELECT_SAVE:
	CMP	SELECT_DETAIL,4
	JNE	SELECT_HELP
	CALL	@MENU_SAVE
	JMP	START_DETAIL

SELECT_HELP:
	CALL	@MENU_HELP
	JMP	START_DETAIL
DETAIL_EXITCHECK:;--------------------------------------
	POP	AX
	RET
CHECK_KEY_DETAIL	ENDP
;---------------------------------------------------------------------------------------------------------------------------
LAYER	PROC	NEAR

	PUSH	120		;L
	PUSH	10		;T
	PUSH	310		;W
	PUSH	220		;H
	PUSH	6
	CALL	FILL_BLOCK
	RET
LAYER	ENDP
;---------------------------------------------------------------------------------------------------------------------------
PRINT_DETAIL	PROC	NEAR
@D1:	CMP	SELECT_DETAIL,1
	JNE	@D2
	MOV	C1,0
	MOV	B1,11
	MOV	C2,255
	MOV	B2,10
	MOV	C5,255
	MOV	B5,10
	JMP	@D_OK
@D2:	CMP	SELECT_DETAIL,2
	JNE	@D3
	MOV	C2,0
	MOV	B2,11
	MOV	C1,255
	MOV	B1,10
	MOV	C3,255
	MOV	B3,10
	JMP	@D_OK
@D3:	CMP	SELECT_DETAIL,3
	JNE	@D4
	MOV	C3,0
	MOV	B3,11
	MOV	C2,255
	MOV	B2,10
	MOV	C4,255
	MOV	B4,10
	JMP	@D_OK
@D4:	CMP	SELECT_DETAIL,4
	JNE	@D5
	MOV	C4,0
	MOV	B4,11
	MOV	C3,255
	MOV	B3,10
	MOV	C5,255
	MOV	B5,10
	JMP	@D_OK
@D5:	CMP	SELECT_DETAIL,5
	JNE	@D_OK
	MOV	C1,255
	MOV	C5,0
	MOV	B5,11
	MOV	C1,255
	MOV	B1,10
	MOV	C4,255
	MOV	B4,10
@D_OK:
	PUSH	10		;L
	PUSH	125		;T
	PUSH	110		;W
	PUSH	140		;H
	PUSH	B1
	CALL	FILL_BLOCK
	PUSH	DS
	PUSH	OFFSET S1
	PUSH	255
	PUSH	20		;X POSITION
	PUSH	130		;Y POSITION
	PUSH	C1	;FONT COLOR		
	PUSH	B1
	CALL	PRINT_STR

	PUSH	10		;L
	PUSH	145		;T
	PUSH	110		;W
	PUSH	160		;H
	PUSH	B2
	CALL	FILL_BLOCK
	PUSH	DS
	PUSH	OFFSET S2
	PUSH	255
	PUSH	20		;X POSITION
	PUSH	150		;Y POSITION
	PUSH	C2	;FONT COLOR		
	PUSH	B2
	CALL	PRINT_STR
	
	PUSH	10		;L
	PUSH	165		;T
	PUSH	110		;W
	PUSH	180		;H
	PUSH	B3
	CALL	FILL_BLOCK
	PUSH	DS
	PUSH	OFFSET S3
	PUSH	255
	PUSH	20		;X POSITION
	PUSH	170		;Y POSITION
	PUSH	C3	;FONT COLOR		
	PUSH	B3
	CALL	PRINT_STR


	PUSH	10		;L
	PUSH	185		;T
	PUSH	110		;W
	PUSH	200		;H
	PUSH	B4
	CALL	FILL_BLOCK
	PUSH	DS
	PUSH	OFFSET S4
	PUSH	255
	PUSH	20		;X POSITION
	PUSH	190		;Y POSITION
	PUSH	C4	;FONT COLOR		
	PUSH	B4
	CALL	PRINT_STR

	
	PUSH	10		;L
	PUSH	205		;T
	PUSH	110		;W
	PUSH	220		;H
	PUSH	B5
	CALL	FILL_BLOCK
	PUSH	DS
	PUSH	OFFSET S5
	PUSH	225
	PUSH	20		;X POSITION
	PUSH	210		;Y POSITION
	PUSH	C5	;FONT COLOR		
	PUSH	B5
	CALL	PRINT_STR
	

	RET
PRINT_DETAIL	ENDP
;---------------------------------------------------------------------------------------------------------------------------
@MENU_STATUS	PROC	NEAR	;80 205

	CALL	LAYER
	PUSH	DS
	PUSH	OFFSET STR_LEVEL
	PUSH	255
	PUSH	122		;X POSITION
	PUSH	40		;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	6
	CALL	PRINT_STR
	MOV	CX,PLAYER_LEVEL
	MOV	PUT_POP,CX
	MOV	POP_COLOR,255
	MOV	POP_X,150
	MOV	POP_Y,40
	CALL	MAX_VALUE

	PUSH	DS
	PUSH	OFFSET STR_HP
	PUSH	255
	PUSH	130		;X POSITION
	PUSH	60		;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	6
	CALL	PRINT_STR
	MOV	CX,PLAYER_HP
	MOV	PUT_POP,CX
	MOV	POP_COLOR,255
	MOV	POP_X,150
	MOV	POP_Y,60
	CALL	MAX_VALUE
	CALL	GET_MAX_HP_MP
	MOV	CX,MAX_HP
	MOV	PUT_POP,CX
	MOV	POP_COLOR,255
	MOV	POP_X,187
	MOV	POP_Y,60
	CALL	MAX_VALUE

	
	
	PUSH	DS
	PUSH	OFFSET STR_MP
	PUSH	255
	PUSH	130		;X POSITION
	PUSH	80		;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	6
	CALL	PRINT_STR
	CALL	GET_MAX_HP_MP
	MOV	CX,PLAYER_MP
	MOV	PUT_POP,CX
	MOV	POP_COLOR,255
	MOV	POP_X,150
	MOV	POP_Y,80
	CALL	MAX_VALUE
	MOV	CX,MAX_MP
	MOV	PUT_POP,CX
	MOV	POP_COLOR,255
	MOV	POP_X,187
	MOV	POP_Y,80
	CALL	MAX_VALUE

	
	
	PUSH	DS
	PUSH	OFFSET STR_EXP1
	PUSH	255
	PUSH	130		;X POSITION
	PUSH	100		;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	6
	CALL	PRINT_STR
	CALL	ADJUST_LEVEL
	MOV	CX,TEMP
	MOV	PUT_POP,CX
	MOV	POP_COLOR,255
	MOV	POP_X,270
	MOV	POP_Y,120
	CALL	MAX_VALUE

	PUSH	DS
	PUSH	OFFSET STR_EXP2
	PUSH	255
	PUSH	130		;X POSITION
	PUSH	140		;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	6
	CALL	PRINT_STR
	CALL	ADJUST_LEVEL
	MOV	CX,PLAYER_EXP
	MOV	PUT_POP,CX
	MOV	POP_COLOR,255
	MOV	POP_X,270
	MOV	POP_Y,160
	CALL	MAX_VALUE

	PUSH	DS
	PUSH	OFFSET STRMONEY
	PUSH	255
	PUSH	130		;X POSITION
	PUSH	180		;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	6
	CALL	PRINT_STR
	CALL	ADJUST_LEVEL
	MOV	CX,PLAYER_MONEY
	MOV	PUT_POP,CX
	MOV	POP_COLOR,255
	MOV	POP_X,270
	MOV	POP_Y,200
	CALL	MAX_VALUE

	RET
@MENU_STATUS	ENDP
;---------------------------------------------------------------------------------------------------------------------------
@MENU_MAGIC	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET MAGIC	;Picture address
	PUSH	120		;Xpos
	PUSH	10		;Ypos
	PUSH	200		;Pic Width
	PUSH	200		;Pic Height
	CALL	DISPLAY_PIC
	CALL	LAYER_BLOCK
	RET
@MENU_MAGIC	ENDP
;---------------------------------------------------------------------------------------------------------------------------
@MENU_HELP	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET HELP	;Picture address
	PUSH	120		;Xpos
	PUSH	10		;Ypos
	PUSH	200		;Pic Width
	PUSH	200		;Pic Height
	CALL	DISPLAY_PIC
	CALL	LAYER_BLOCK
	RET
@MENU_HELP	ENDP
;---------------------------------------------------------------------------------------------------------------------------
@MSG_OK	PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET OK	;Picture address
	PUSH	120		;Xpos
	PUSH	10		;Ypos
	PUSH	200		;Pic Width
	PUSH	200		;Pic Height
	CALL	DISPLAY_PIC
	CALL	LAYER_BLOCK
	RET
@MSG_OK	ENDP
;---------------------------------------------------------------------------------------------------------------------------
@MSG_ERR PROC	NEAR
	PUSH	DS		;Data Segment
	PUSH	OFFSET ERROR	;Picture address
	PUSH	120		;Xpos
	PUSH	10		;Ypos
	PUSH	200		;Pic Width
	PUSH	200		;Pic Height
	CALL	DISPLAY_PIC
	CALL	LAYER_BLOCK
	RET
@MSG_ERR ENDP
;---------------------------------------------------------------------------------------------------------------------------
@MENU_SAVE	PROC	NEAR
	
CREATE:
	LEA	DX,FNAME
	MOV	CX,0
	MOV	AH,3CH
	INT	21H
	JC	FILE_ERROR
WRITE:	
	MOV	BX,AX
;---------------------------[ HP ]
	MOV	AL,0
	LEA	DX,PLAYER_HP
	MOV	CX,2
	MOV	AH,40H
	INT	21H
;---------------------------[ MP ]
	MOV	AL,0
	LEA	DX,PLAYER_MP
	MOV	CX,2
	MOV	AH,40H
	INT	21H
;---------------------------[ LV ]
	MOV	AL,0
	LEA	DX,PLAYER_LEVEL
	MOV	CX,2
	MOV	AH,40H
	INT	21H
;---------------------------[ EXP ]
	MOV	AL,0
	LEA	DX,PLAYER_EXP
	MOV	CX,2
	MOV	AH,40H
	INT	21H
;---------------------------[ MONEY ]
	MOV	AL,0
	LEA	DX,PLAYER_MONEY
	MOV	CX,2
	MOV	AH,40H
	INT	21H
	JMP	NEXT_SAVE
FILE_ERROR:	
	CALL	@MSG_ERR
	JMP	CLOSE
NEXT_SAVE:
;---------------------------[ ROW ]
	MOV	AL,0
	LEA	DX,ROW_PAGE
	MOV	CX,2
	MOV	AH,40H
	INT	21H
;---------------------------[ COL]
	MOV	AL,0
	LEA	DX,COL_PAGE
	MOV	CX,2
	MOV	AH,40H
	INT	21H
;---------------------------[ X ]
	MOV	AL,0
	LEA	DX,PLAYER_X
	MOV	CX,2
	MOV	AH,40H
	INT	21H
;---------------------------[ Y ]
	MOV	AL,0
	LEA	DX,PLAYER_Y
	MOV	CX,2
	MOV	AH,40H
	INT	21H
;---------------------------[ BOSS1_DEAD ]
	MOV	AL,0
	LEA	DX,BOSS1_DEAD
	MOV	CX,2
	MOV	AH,40H
	INT	21H
;---------------------------[ BOSS2_DEAD ]
	MOV	AL,0
	LEA	DX,BOSS2_DEAD
	MOV	CX,2
	MOV	AH,40H
	INT	21H
;---------------------------[ BOSS3_DEAD ]
	MOV	AL,0
	LEA	DX,BOSS3_DEAD
	MOV	CX,2
	MOV	AH,40H
	INT	21H
	CALL	@MSG_OK
CLOSE:
	MOV	AH,3EH
	INT	21H
	RET
@MENU_SAVE	ENDP
;---------------------------------------------------------------------------------------------------------------------------
PUBLIC	@LOAD_FILE
@LOAD_FILE	PROC	FAR

	LEA	DX,FNAME
	MOV	AL,0
	MOV	AH,3DH
	INT	21H
	JC	CLOSE_FILE
	MOV	BX,AX
;---------------------------[ LOAD_HP ]
	LEA	DX,PLAYER_HP
	MOV	CX,2
	MOV	AH,3FH
	INT	21H
;---------------------------[ LOAD_MP ]
	LEA	DX,PLAYER_MP
	MOV	CX,2
	MOV	AH,3FH
	INT	21H
;---------------------------[ LOAD_LEVEL ]
	LEA	DX,PLAYER_LEVEL
	MOV	CX,2
	MOV	AH,3FH
	INT	21H
;---------------------------[ LOAD_EXP ]
	LEA	DX,PLAYER_EXP
	MOV	CX,2
	MOV	AH,3FH
	INT	21H
;---------------------------[ LOAD_MONEY ]
	LEA	DX,PLAYER_MONEY
	MOV	CX,2
	MOV	AH,3FH
	INT	21H
	JMP	NEXT_LOAD
CLOSE_FILE:
	JMP	CLOSE_
;---------------------------[ LOAD_ROW ]
NEXT_LOAD:
	LEA	DX,ROW_PAGE
	MOV	CX,2
	MOV	AH,3FH
	INT	21H
;---------------------------[ LOAD_COL ]
	LEA	DX,COL_PAGE
	MOV	CX,2
	MOV	AH,3FH
	INT	21H
;---------------------------[ LOAD_X ]
	LEA	DX,PLAYER_X
	MOV	CX,2
	MOV	AH,3FH
	INT	21H
;---------------------------[ LOAD_Y ]
	LEA	DX,PLAYER_Y
	MOV	CX,2
	MOV	AH,3FH
	INT	21H
;---------------------------[ BOSS1_DEAD ]
	LEA	DX,BOSS1_DEAD
	MOV	CX,2
	MOV	AH,3FH
;---------------------------[ BOSS2_DEAD ]
	LEA	DX,BOSS2_DEAD
	MOV	CX,2
	MOV	AH,3FH
;---------------------------[ BOSS3_DEAD ]
	LEA	DX,BOSS3_DEAD
	MOV	CX,2
	MOV	AH,3FH
	INT	21H
;---------------------------[ CLOSE FILE ]
CLOSE_:	MOV	AH,3EH
	INT	21H
	MOV	LOAD_OK,1
	RET
@LOAD_FILE	ENDP
;---------------------------------------------------------------------------------------------------------------------------
LAYER_BLOCK	PROC	NEAR
	PUSH	310		;L
	PUSH	10		;T
	PUSH	318		;W
	PUSH	230		;H
	PUSH	7
	CALL	FILL_BLOCK
	PUSH	319		;L
	PUSH	10		;T
	PUSH	320		;W
	PUSH	230		;H
	PUSH	255
	CALL	FILL_BLOCK
	PUSH	120		;L
	PUSH	210		;T
	PUSH	309		;W
	PUSH	220		;H
	PUSH	0
	CALL	FILL_BLOCK
	RET
LAYER_BLOCK	ENDP
;---------------------------------------------------------------------------------------------------------------------------
SELL_ITEM PROC	NEAR
	MOV	BLOCKUP,130
	MOV	BLOCKDOWN,110

BLOCKX:
	MOV	DX,BLOCKUP
	ADD	DX,2
	PUSH	100		;L
	PUSH	BLOCKUP		;T
	PUSH	300		;W
	PUSH	DX		;H
	PUSH	255
	CALL	FILL_BLOCK
	MOV	CX,BLOCKUP
	MOV	BX,BLOCKDOWN
	ADD	CX,2
	SUB	BX,2
	PUSH	102		;L
	PUSH	CX		;T
	PUSH	298		;W
	PUSH	BX		;H
	PUSH	7
	CALL	FILL_BLOCK
	MOV	DX,BLOCKDOWN
	SUB	DX,2
	PUSH	100		;L
	PUSH	DX	;T
	PUSH	300		;W
	PUSH	BLOCKDOWN		;H
	PUSH	255
	CALL	FILL_BLOCK

	CALL	DELAY2
	DEC	BLOCKUP
	INC	BLOCKDOWN
	CMP	BLOCKUP,20
	JNL	BLOCKX
	CALL	MOVE_SELL
	RET
SELL_ITEM	ENDP
;---------------------------------------------------------------------------------------------------------------------------
SHOW_ITEM	PROC	NEAR	
	CMP	SELECT_DETAIL,1
	JNE	I2
	MOV	C1,15
	MOV	C2,255
	MOV	C3,255
	MOV	CX,ITEM1
	MOV	TEMP,CX
	JMP	I_OK
I2:	CMP	SELECT_DETAIL,2
	JNE	I3
	MOV	C1,255
	MOV	C2,15
	MOV	C3,255
	MOV	CX,ITEM2
	MOV	TEMP,CX
	JMP	I_OK
I3:
	MOV	C1,255
	MOV	C2,255
	MOV	C3,15
	MOV	CX,ITEM3
	MOV	TEMP,CX
I_OK:
	PUSH	DS
	PUSH	OFFSET SELL1
	PUSH	255
	PUSH	110		;X POSITION
	PUSH	50		;Y POSITION
	PUSH	C1		;FONT COLOR		
	PUSH	7
	CALL	PRINT_STR
	PUSH	DS
	PUSH	OFFSET SELL2
	PUSH	255
	PUSH	110		;X POSITION
	PUSH	70		;Y POSITION
	PUSH	C2		;FONT COLOR		
	PUSH	7
	CALL	PRINT_STR

	PUSH	DS
	PUSH	OFFSET SELL3
	PUSH	255
	PUSH	110		;X POSITION
	PUSH	90		;Y POSITION
	PUSH	C3		;FONT COLOR		
	PUSH	7
	CALL	PRINT_STR

	PUSH	DS
	PUSH	OFFSET MSG
	PUSH	255
	PUSH	133		;X POSITION
	PUSH	150		;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	7
	CALL	PRINT_STR

	
	MOV	CX,TEMP
	MOV	PUT_POP,CX
	MOV	POP_COLOR,255
	MOV	POP_X,205
	MOV	POP_Y,150
	CALL	MAX_VALUE


	PUSH	130		;L
	PUSH	200		;T
	PUSH	298		;W
	PUSH	215		;H
	PUSH	7
	CALL	FILL_BLOCK

	PUSH	DS
	PUSH	OFFSET STR_MONEY
	PUSH	255
	PUSH	110		;X POSITION
	PUSH	200		;Y POSITION
	PUSH	255		;FONT COLOR		
	PUSH	7
	CALL	PRINT_STR
	MOV	CX,PLAYER_MONEY
	MOV	PUT_POP,CX
	MOV	POP_COLOR,255
	MOV	POP_X,230
	MOV	POP_Y,200
	CALL	MAX_VALUE
	RET
SHOW_ITEM	ENDP

;---------------------------------------------------------------------------------------------------------------------------
MOVE_SELL	PROC	NEAR
	MOV	SELECT_DETAIL,1
START_ITEM:
	CALL	SHOW_ITEM
	CALL	READKEY
	MOV	TEMPKEY,AH
	CMP	TEMPKEY,48H	;KEYUP-----------
	JNE	ITEM_NOTUP				
	DEC	SELECT_DETAIL
	CMP	SELECT_DETAIL,0
	JNE	START_ITEM
	MOV	SELECT_DETAIL,3
	JMP	START_ITEM
ITEM_NOTUP:;------------------------------------------
	CMP	TEMPKEY,50H	;KEYDOWN---------
	JNE	ITEM_NOTDOWN				
	INC	SELECT_DETAIL
	CMP	SELECT_DETAIL,4
	JNE	START_ITEM
	MOV	SELECT_DETAIL,1
	JMP	START_ITEM
	
ITEM_NOTDOWN:;----------------------------------------
	CMP	TEMPKEY,39H	;TAB----------
	JNE	ITEM_NOTTAB				
	JMP	ITEM_EXITCHECK				
ITEM_NOTTAB:;---------------------------------------
	CMP	TEMPKEY,1CH	;KEYENTER--------
	JNE	START_ITEM
	JMP	NEXT_ITEM
BRIDGE_ITEM:
	JMP	START_ITEM
NEXT_ITEM:
	CMP	SELECT_DETAIL,1
	JNE	SELECT_MP_MAX
	CMP	PLAYER_MONEY,50
	JL	START_ITEM
	INC	ITEM1
	SUB	PLAYER_MONEY,50
	JMP	BRIDGE_ITEM	
SELECT_MP_MAX:
	CMP	SELECT_DETAIL,2
	JNE	SELECT_LEVIVE
	CMP	PLAYER_MONEY,80
	JL	START_ITEM
	INC	ITEM2
	SUB	PLAYER_MONEY,80
	JMP	BRIDGE_ITEM
SELECT_LEVIVE:
	CMP	PLAYER_MONEY,100
	JL	BRIDGE_ITEM
	INC	ITEM3
	SUB	PLAYER_MONEY,100
	JMP	START_ITEM

ITEM_EXITCHECK:;--------------------------------------
	RET
MOVE_SELL	ENDP
;---------------------------------------------------------------------------------------------------------------------------
	END	MAIN