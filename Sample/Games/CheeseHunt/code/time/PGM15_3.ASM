	TITLE	PGM15_3: TIME_DISPLAY_VER_3
;memory resident program that shows current time of day
;called by Ctrl-rt shift key combination
;
	EXTRN	INITIALIZE:NEAR,SAVE_SCREEN:NEAR
	EXTRN	RESTORE_SCREEN:NEAR,SET_CURSOR:NEAR
	EXTRN	GET_TIME:NEAR
	PUBLIC	MAIN
	PUBLIC	NEW_VEC,OLD_VEC,SS_BUF
C_SEG	SEGMENT	PUBLIC
	ASSUME	CS:C_SEG, DS:C_SEG, SS:C_SEG
	ORG	100H
START:	JMP	INITIALIZE
;
SS_BUF		DB	16 DUP(?)	;save screen buffer 
TIME_BUF	DB	'00:00:00$'	;time buffer hr:min:sec
CURSOR_POS	DW	?	;cursor position
ON_FLAG		DB	0	;1 = interrupt procedure running
NEW_VEC		DW	?,?	;contains new vector
OLD_VEC		DD	?	;contains old vector
;
MAIN	PROC
;interrupt procedur
;save registers
	PUSH	DS
	PUSH	ES
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI
;
	MOV	AX,CS		;set DS
	MOV	DS,AX
	MOV	ES,AX		;and ES to current segment
;call old keyboard interrupt procedure
	PUSHF			;save FLAGS
	CALL	OLD_VEC
;get keyboard flags
	MOV	AX,CS		;reset DS
	MOV	DS,AX
	MOV	ES,AX		;and ES to current segment
	MOV	AH,02		;function 2, keyboard flags
	INT	16H		;AL has flag bits
	TEST	AL,1		;rt shift?
	JE	I_DONE		;no, exit
	TEST	AL,100B		;Ctrl?
	JE	I_DONE		;no, exit
;process 
	CMP	ON_FLAG,1	;procedure active?
	JE	RESTORE		;yes, deactivate
	MOV	ON_FLAG,1	;no, activate
;--save cursor position and screen info
	MOV	AH,03		;get cursor position
	MOV	BH,0		;page 0
	INT	10H		;DH = row, DL = col
	MOV	CURSOR_POS,DX	;save it
	CALL	SAVE_SCREEN	;save time display screen
;--position cursor to upper right corner
	MOV	DL,72		;column 72
	CALL	SET_CURSOR	;position cursor in row 0, col 72
	LEA	BX,TIME_BUF
	CALL	GET_TIME	;get current time
;--display time
	LEA	SI,TIME_BUF
	MOV	CX,8		;8 chars
	MOV	BH,0		;page 0
M1:	MOV	AH,0EH		;write char
	LODSB			;char in AL
	INT	10H		;cursor is moved to next col
	LOOP	M1		;loop back if more chars
	JMP	RES_CURSOR	;
RESTORE:
;restore screen
	MOV	ON_FLAG,0	;clears flag
	CALL	RESTORE_SCREEN
;restore saved cursor position
RES_CURSOR:
	MOV	AH,02		;set cursor
	MOV	BH,0
	MOV	DX,CURSOR_POS
	INT	10H
;restore registers
I_DONE:
	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	POP	ES
	POP	DS
	IRET			;interrupt return
MAIN	ENDP	
;
C_SEG	ENDS
	END	START		;starting instruction
