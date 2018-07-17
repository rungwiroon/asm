;FROM MODEX.ASM
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
	EXTRN	@LOAD_FILE:FAR

.MODEL Medium
.286
.STACK 100h
.DATA
INCLUDE RGBPAL.ASM
	BGTITLE		DB	'DATA\BGTITLE.PIC',0
	STR_NEW		DB	'  LOAD GAME  ',0
	STR_LOAD	DB	'  NEW GAME  ',0
	SELECT1		DW	100
	SELECT2		DW	0
	SELECT		DW	0
.CODE
PUBLIC	TITLEGAME
TITLEGAME PROC FAR
	MOV	AX,@DATA
	MOV	DS,AX
;##### Example Set Mode X #####
	PUSH	4		; Mode 320x240
	CALL	SET_MODEX
;##### Example Set Palette #####
	LEA	AX,Palette	
	PUSH	DS
	PUSH	AX
	PUSH	0
	PUSH	255
	PUSH	1
	CALL	LOAD_DAC_REGISTERS
;##### Example Clear Screen #####
	PUSH	0			;Color Black
	CALL	CLEAR_VGA_SCREEN
;##### Example Show Bitmap #####
	PUSH	DS
	PUSH	OFFSET BGTITLE		;File address
	PUSH	0			;X position
	PUSH	0			;y position
	PUSH	320			;Width
	PUSH	240			;Height
	CALL	DISPLAY_PIC

	
BEGIN:	
	CALL	DRAWBLOCK
	CALL	PRINTTITLE
PRESS:
	MOV	AH,10H
	INT	16H
	CMP	AH,48H
	JNE	NEXT1
	CALL	KEYUP
	JMP	BEGIN
NEXT1:	CMP	AH,50H
	JNE	NEXT2
	CALL	KEYDOWN
	JMP	BEGIN
NEXT2:	CMP	AH,01H
	JNE	NEXT3
	CALL	EXIT
NEXT3:	CMP	AH,1CH
	JNE	BEGIN
	CMP	SELECT,1
	JE	TITLE_OK
	CALL	@LOAD_FILE
	RET
TITLE_OK: 
	
	RET
TITLEGAME	ENDP
;---------------------------------------------------------------------------------------------------------------------------
PRINTTITLE	PROC	NEAR
	PUSH	DS
	PUSH	OFFSET STR_NEW
	PUSH	255	;
	PUSH	110	;X
	PUSH	105	;Y
	PUSH	255	;F COLOR
	PUSH	SELECT1	;BG COLOR
	CALL	PRINT_STR

	PUSH	DS
	PUSH	OFFSET STR_LOAD
	PUSH	255
	PUSH	110
	PUSH	120
	PUSH	255
	PUSH	SELECT2
	CALL	PRINT_STR
	RET
PRINTTITLE	ENDP
;--------------------------------------------------------------------------------------------------------------------------
DRAWBLOCK	PROC	NEAR

	PUSH	105	;L
	PUSH	100	;T
	PUSH	220	;R
	PUSH	130	;D
	PUSH	0
	CALL	FILL_BLOCK
	RET
DRAWBLOCK	ENDP
;---------------------------------------------------------------------------------------------------------------------------
KEYUP	PROC	NEAR
	MOV	SELECT1,100
	MOV	SELECT2,0
	MOV	SELECT,0
	RET
KEYUP	ENDP
;---------------------------------------------------------------------------------------------------------------------------
KEYDOWN	PROC	NEAR
	MOV	SELECT1,0
	MOV	SELECT2,100
	MOV	SELECT,1
	RET
KEYDOWN	ENDP
;---------------------------------------------------------------------------------------------------------------------------
EXIT	PROC	NEAR
	MOV	AH,01H
	INT	21H
	MOV	AH,0
	MOV	AL,2
	INT	10h
	MOV	AH,4CH
	INT	21H
	RET
EXIT	ENDP
END