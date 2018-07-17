;============================================
;LOAD BMP FILE TO BUFFER
;============================================
LBTB	MACRO	X,Y,PICNAME,@SEGMENT
	PUSHA
	
	PUSH	@SEGMENT
	POP	ES
	
	PUSH	X
	POP	BMP_X
	PUSH	Y
	POP	BMP_Y
	
	LEA	SI,PICNAME
	CALL	BTB
	
	POPA
ENDM


;============================================
;LOAD BMP FILE TO BMP ARRAY
;============================================
LBFTBA	MACRO	PICNAME,ARRAY
	PUSHA
	
	LEA	SI,PICNAME
	LEA	DI,ARRAY
	CALL	BTA
	
	POPA
ENDM

;============================================
;SET OBJECT POINTER TO BITMAP ARRAY
;============================================
SOPTBA	MACRO	OBJECT,ARRAY
	PUSH	BX
	
	LEA	BX,ARRAY
	MOV	OBJECT[PTR_OFFSET],BX
	
	POP	BX
ENDM

;============================================
;LOAD OBJECT TO BUFFER
;============================================
LOTB	MACRO	OBJECT,@SEGMENT
	PUSHA
	
	PUSH	@SEGMENT
	POP	ES
	LEA	SI,OBJECT
	CALL	ATB
	
	POPA
ENDM

LOTBXY	MACRO	X,Y,OBJECT,@SEGMENT
	PUSHA
	
	PUSH	@SEGMENT
	POP	ES
	LEA	SI,OBJECT
	PUSH	X
	POP	WORD PTR[SI+X_OFFSET]
	PUSH	Y
	POP	WORD PTR[SI+Y_OFFSET ]
	CALL	ATB
	
	POPA
ENDM

	
;============================================
;LOAD COLOR TABLE
;============================================
LCT	MACRO	PICNAME
	PUSHA
	LEA	SI,PICNAME
	CALL	CBMP
	POPA
ENDM

;============================================
;LOAD BUFFER TO SCREEN
;============================================
LBTS	MACRO	@SEGMENT

	PUSH	DS
	
	PUSH	@SEGMENT
	POP	DS
	CALL	BUFFER_TO_SCREEN
	
	POP	DS

ENDM



;============================================
;COPY BUFFER TO BUFFER
;============================================
CBUF	MACRO	SEGMENT1,SEGMENT2
	PUSH	DS
	
	PUSH	SEGMENT1
	POP	DS
	PUSH	SEGMENT2
	POP	ES
	CALL	COPY_BUFFER
	
	POP	DS
ENDM

;============================================
;CLEAR BUFFER
;============================================
CLRB	MACRO	SEGEMENT1
	
	PUSH	SEGMENT1
	POP	ES
	CALL	CLEAR_BUFFER
	
ENDM

;========================================
;TEST MOVE OBJECT
;=======================================
TMO	MACRO	OBJECT
	LEA	SI,OBJECT
	CALL	TEST_MOVE_OBJECT
ENDM

;========================================
;TEST OBJECT ON PLANE
;========================================
TOOP	MACRO	OBJECT,PLANE
	LEA	SI,OBJECT
	LEA	DI,PLANE
	CALL	TEST_OBJECT_ON_PLANES
ENDM

;===========================================================================

;==========================================
;MOD RESGISTER OR MEM BY IMMEDIATE
;INPUT:
;	DEST	: UNSIGNED DIVIDEND
;	IMM?	: DIVISOR 
;OUTPUT:
;	DEST	:
;	AH	:
;	AX	:
;	EAX	:	
;==========================================
MODB	MACRO	DEST,IMM8
	MOV	AL,DEST
	MOV	BL,IMM8
	CBW
	DIV	BL
	MOV	DEST,AH
ENDM

MODW	MACRO	DEST,IMM16
	MOV	AX,DEST
	MOV	BX,IMM16
	CWD
	DIV	BX
	MOV	DEST,AX
ENDM

; GCDB	MACRO	DEST,IMM8
	; MOV	AL,DEST
	; AND	AL,IMM8
	; XOR	AL,IMM8
; ENDM

GCDB	MACRO	DEST,IMM8
	MOV	AL,DEST
	MOV	BL,IMM8
	MOV	AH,0
	;CBW
	DIV	BL
	OR	AH,00H
ENDM

CBIB	MACRO	DEST,IMM8
	MOV	AL,DEST
	MOV	BL,AL
	DEC	BL
	AND	AL,IMM8
	AND	BL,IMM8
	XOR	AL,BL	
ENDM

;======================================================
;SET OBJECT BITMAP BY DEFINE ARRAY INDEX
;INPUT:
;	OBJECT	: OBJECT NAME
;	BITMAP	: BITMAP NAME
;	@SIZE	: ARRAY ELEMENT SIZE
;	INDEX	: ARRAY INDEX
;OUTPUT:
;	OBJECT	: BITMAP ADDRESS IN PTR_OFFSET
;======================================================	
SOBI	MACRO	OBJECT,BITMAP,@SIZE,INDEX
	MOV	AX,@SIZE
	XOR	BX,BX
	MOV	BL,INDEX
	MUL	BX
	
	LEA	DI,BITMAP
	ADD	DI,AX
	MOV	OBJECT[PTR_OFFSET],DI
ENDM
;========================================================


;======================
;SET GRAPHIC MODE
;=====================
SET_GRAPH	MACRO	MODE
	MOV	AX,MODE
	INT	10H		;SET DISPLAY MODE 13H
ENDM

;======================
;BEEP
;======================
BEEP	MACRO
	PUSHA
	MOV	DL,07
	MOV	AH,02
	INT	21H
	POPA
ENDM

;====================
;DELAY
;===================	
V_SYNC	MACRO	COUNT
	LOCAL	V_LOOP

	PUSHA
	MOV	CX,COUNT
V_LOOP:
	CALL	WAIT_RETRACE
	LOOP	V_LOOP	
	POPA
ENDM

;============================================
;Go to define  x,y in screen
;============================================
GOTOXY	MACRO	X,Y
	PUSH	AX
	PUSH	BX
	PUSH	DX
	
	MOV	AH,02H
	XOR	BX,BX
	MOV	DH,Y
	MOV	DL,X
	INT	10H

	POP	DX
	POP	BX
	POP	AX
ENDM

;============================================
;PUT CHAR
;============================================
PUT_CHR	MACRO CHAR,FCOLOR
	PUSH	AX
	PUSH	BX
	
	MOV	AH,0EH
	MOV	AL,CHAR
	MOV	BL,FCOLOR
	MOV	BH,0	;SELECT PAGE 0
	INT	10H
	
	POP	BX
	POP	AX
ENDM

SET_VECTOR	MACRO	OLD_VEC, NEW_VEC, PROC_NAME
;SET UP KEYBOARD INTERRUPT VECTOR
	MOV	NEW_VEC,OFFSET PROC_NAME ;OFFSET
	MOV	NEW_VEC+2,CS		;SEGMENT
	MOV	AL,9H			;INTERRUPT NUM
	LEA	DI,OLD_VEC	;FOR SAVE OLD VECTOR
	LEA	SI,NEW_VEC	;SEND NEW VECTOR
	CALL	SETUP_INT
ENDM

RESET_VECTOR	MACRO	OLD_VEC, NEW_VEC
;-RESET KEYBOARD INTERRUPT VECTROR
	LEA	DI,NEW_VEC	;NEW VECTOR ADDR
	LEA	SI,OLD_VEC	;OLD VECTOR ADDR
	MOV	AL,9H		;INTERRUPT NUMBER
	CALL	SETUP_INT
ENDM