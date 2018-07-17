	TITLE	PGM15_3B: SAVE SCREEN AND  CURSOR
	EXTRN	SS_BUF:BYTE
	PUBLIC	SAVE_SCREEN,RESTORE_SCREEN,SET_CURSOR
C_SEG	SEGMENT	PUBLIC
	ASSUME	CS:C_SEG
;
SAVE_SCREEN	PROC
;saves 8 characters from upper right hand corner of screen
	LEA	DI,SS_BUF	;screen buffer
	MOV	CX,8		;8 times
	MOV	DL,72		;column  72
	CLD			;clear DF for string operation
SS_LOOP:
	CALL	SET_CURSOR	;setup cursor at row 0, col DL
	MOV	AH,08H		;read char on screen
	INT	10H		;AH = attribute, AL = character
	STOSW			;stores char and attribute
	INC	DL		;next col
	LOOP	SS_LOOP
	RET
SAVE_SCREEN	ENDP
;
RESTORE_SCREEN	PROC
;restores saved screen
	LEA	SI,SS_BUF	;SI points to buffer
	MOV	DI,8		;repeat 8 times
	MOV	DL,72		;column 72
	MOV	CX,1		;1 char at a time
RS_LOOP:
	CALL	SET_CURSOR	;move cursor
	LODSW			;AL = char, AH = attribute
	MOV	BL,AH		;attribute  to BL
	MOV	AH,09H		;function 9, write char and attribute
	MOV	BH,0		;page 0
	INT	10H
	INC	DL		;next char position
	DEC	DI		;more characters?
	JG	RS_LOOP		;yes, repeat
	RET
RESTORE_SCREEN	ENDP
;
SET_CURSOR	PROC
;sets cursor at row 0, column DL
;input DL = column number
	MOV	AH,02		;function 2, set cursor
	MOV	BH,0		;page 0
	MOV	DH,0		;row 0
	INT	10H
	RET
SET_CURSOR	ENDP
;
C_SEG	ENDS
	END
