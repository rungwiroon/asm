TITLE SHOWPIC.asm
;Created by Raywat Tassaneesrivong (Sun) 
;CSs11	ID:47-4055-909-3

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

     .MODEL Medium
    .286

.STACK 100h

.DATA
INCLUDE RGBPAL.ASM

	ASTRO	DB	'ASTRO.PIC',0
	HANDS	DB	'HANDS.PIC',0
	ZEBRA	DB	'ZEBRA.PIC',0

.CODE
MAIN PROC FAR
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
	PUSH	OFFSET ASTRO		;File address
	PUSH	0			;X position
	PUSH	0			;y position
	PUSH	320			;Width
	PUSH	240			;Height
	CALL	DISPLAY_PIC

	PUSH	0
	PUSH	1
	CALL	COPY_PAGE

	PUSH	DS
	PUSH	OFFSET HANDS		;File address
	PUSH	1			;X position
	PUSH	1			;y position
	PUSH	100			;Width
	PUSH	92			;Height
	CALL	DISPLAY_PIC

	PUSH	DS
	PUSH	OFFSET ZEBRA		;File address
	PUSH	143			;X position
	PUSH	0			;y position
	PUSH	177			;Width
	PUSH	240			;Height
	CALL	DISPLAY_TPIC

	MOV	AH,1
	INT	21h			;Get keyboard

	PUSH	1
	PUSH	0
	CALL	COPY_PAGE

	MOV	AH,1
	INT	21h

;reset to text mode
	MOV	AH,0
	MOV	AL,2
	INT	10h

	MOV 	AH,4CH
	INT 	21H

MAIN	ENDP
END MAIN