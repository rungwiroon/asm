;============================================
;Go to define  x,y in screen
;============================================
GOTOXY MACRO X,Y
	PUSH AX
	PUSH BX
	PUSH DX
	
	MOV AH,02H			;FUNCTION CURSOR
	XOR BX,BX
	MOV DH,Y			;DH KEEP POSITION Y
	MOV DL,X			;DL KEEP POSITION X
	INT 10H				;DISPLAY

	POP DX
	POP BX
	POP AX
ENDM

;=========================================
;Write Charecter in teletype Mode
;Input:	AH	= 0EH
;		AL	= Charecter
;		BH	= page
;		BL	= color
;Output:	none
;=========================================
WRITE_CHAR	MACRO CHAR,COLOR
	PUSH	AX
	PUSH	BX
	MOV	AH,0EH
	MOV	AL,CHAR
	XOR	BH,BH		;SELECT PAGE 0
	MOV	BL,COLOR
	INT	10H
	POP	BX
	POP	AX
ENDM


PASTEBMP	MACRO	X,Y,PICNAME
	PUSH	X
	PUSH	Y
	POP		BMP_Y
	POP		BMP_X
	LEA		SI,PICNAME
	MOV		BMP_MODE,0
	CALL	LOADBMP
ENDM

TPASTEBMP	MACRO	X,Y,TRANS,PICNAME
	PUSH	X
	PUSH	Y
	POP		BMP_Y
	POP		BMP_X
	LEA		SI,PICNAME
	MOV		TRANSPARENT,TRANS
	MOV		BMP_MODE,2
	CALL	LOADBMP
ENDM

DELAY MACRO TIME
	LOCAL LOOP_DELAY

	PUSH CX
	
	MOV CX,TIME
	
LOOP_DELAY:	
	CALL	DELAY2
	LOOP	LOOP_DELAY
	
	POP CX
	
ENDM

DELAY_ROAD MACRO TIME
	LOCAL LOOP_DELAY

	PUSH CX
	
	MOV CX,TIME
	
LOOP_DELAY:	
	CALL	DELAY2
	LOOP	LOOP_DELAY
	
	CALL	UPDATE_CAR_POS
	
	POP CX
	
ENDM

CHECK_CRASH	MACRO OBJX1,OBJX2
	MOV	OBJ_X1,OBJX1
	MOV	OBJ_X2,OBJX2
	CALL	CHK_CRASH
ENDM

;=========================================
;Write Charecter in teletype Mode
;Input:	AH	= 0EH
;	AL	= Charecter
;	BH	= page
;	BL	= color
;Output:	none
;=========================================
WRITE_CHAR	MACRO CHAR,COLOR
	PUSH	AX
	PUSH	BX
	
	MOV	AH,0EH
	MOV	AL,CHAR
	XOR	BH,BH		;SELECT PAGE 0
	MOV	BL,COLOR
	INT	10H
	
	POP	BX
	POP	AX
ENDM

