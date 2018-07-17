	TITLE	PGM15_3A: SET UP TSR PROGRAM
	EXTRN	MAIN:NEAR,SETUP_INT:NEAR
	EXTRN	NEW_VEC:WORD,OLD_VEC:DWORD
	PUBLIC	INITIALIZE
C_SEG	SEGMENT	PUBLIC
	ASSUME	CS:C_SEG
INITIALIZE	PROC
;setup interrupt vector
	MOV	NEW_VEC,OFFSET MAIN	;store address
	MOV	NEW_VEC+2,CS		;segment 
	LEA	DI,OLD_VEC		;DI points  to vector buffer
	LEA	SI,NEW_VEC		;SI points to new vector
	MOV	AL,09H			;keyboard interrupt
	CALL	SETUP_INT		;set interrupt vector
;exit to DOS
	LEA	DX,INITIALIZE
	INT	27H		;terminate and stay resident
INITIALIZE	ENDP
C_SEG	ENDS
	END
