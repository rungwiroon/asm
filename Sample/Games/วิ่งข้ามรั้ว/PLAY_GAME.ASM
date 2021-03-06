PLAY_GAME	PROC
	
	PUSHA
	
	
	
	
	PASTEBMP	0,0,READY
	CALL	SCORE_
	TPASTEBMP	240,90,5CH,RUN
	TPASTEBMP		 20,120,05CH,OBJECT
	DELAY	8000
	
	PASTEBMP	0,0,GO
	CALL	SCORE_
	TPASTEBMP	12,75,87H,GUN
	TPASTEBMP	240,90,5CH,RUN
	TPASTEBMP		 20,120,05CH,OBJECT
	DELAY	500
	
	;CALL	CLEAR_KEY_BUFF
	
	MOV	MAN_X,240
	MOV	MAN_Y,90
	MOV	OBJ_X1,20
	MOV	LINE_X,20
	MOV	COUNT,1

	
	
CHECK_KEY:

	CMP	NCRASH,3
	JE	GAME_OVER_NA
	CMP		RETURN,1
	JE		EXIT_MENU_NA
	XOR		AX,AX
	CALL 	TIME_INT
	;CALL	CLEAR_KEY_BUFF
	CALL	WAIT_KEY
	
RUN_KEY:
	CMP	AH,4BH
	JNE	JUMP_KEY
	CALL	SHOW_RUN
	JMP	CHECK_KEY
	
JUMP_KEY:
	CMP	AH,39H
	JNE	EXIT_TO_MENU
	CALL	SHOW_JUMP
	JMP	CHECK_KEY
	
EXIT_TO_MENU:
	CMP	AH,01
	JNE	CHECK_KEY
	
GAME_OVER_NA:
	CALL	GAME_OVER
	MOV	RETURN,1	

EXIT_MENU_NA:	
	
	
	POPA
	RET
	
	
	PLAY_GAME	ENDP
;=================================================================
	TRACK	PROC
	PUSHA
	
	MOV	AL,COUNT
	AND	AL,03H
	OR	AL,30H
	INC	AL


	CMP	COUNT,3
	JG	SHOW_TRACK2
	
SHOW_TRACK1:	
	MOV	FIRST[15],AL
	PASTEBMP	0,0,FIRST
	CALL	SCORE_
	CALL	TIME_INT
	TPASTEBMP		 OBJ_X1,120,05CH,OBJECT
	ADD	OBJ_X1,15
	CMP OBJ_X1,320-40
	JL	END_CHECKC
	
CLEAR_OBJECT:
	MOV	OBJ_X1,20
	ADD	POINT,10
	JMP	END_CHECKC
	
SHOW_TRACK2:


	XOR AL,AL
	MOV	AL,COUNT
	AND	AL,03H
	OR	AL,30H
	INC	AL
	
	CMP COUNT,32
	JG	SHOW_TRACK3
	
	MOV	SECOND[16],AL
	PASTEBMP	0,0,SECOND	
	CALL	SCORE_
	CALL	TIME_INT
	TPASTEBMP		 OBJ_X1,120,05CH,OBJECT
	ADD	OBJ_X1,15
	CMP OBJ_X1,320-40
	JL	END_CHECKC
	
CLEAR_OBJECT2:
	MOV	OBJ_X1,20
	ADD	POINT,10
	JMP	END_CHECKC
	
SHOW_TRACK3:
	
	MOV	OBJ_X1,1
	XOR AL,AL
	MOV	AL,COUNT
	AND	AL,02H
	OR	AL,30H
	INC	AL
	
	MOV	FINISH[16],AL
	PASTEBMP	0,0,FINISH
	CALL	SCORE_
	CALL	TIME_INT
	TPASTEBMP	LINE_X,145,04CH,LINE
	ADD	LINE_X,20
	CMP LINE_X,280
	JNE	END_CHECKC
	CALL GAME_FINISH
END_CHECKC:

	POPA
	RET
	TRACK	ENDP
;=====================================================================
	WAIT_KEY	PROC
	
	PUSH	BX
	PUSH	CX
	
	;CALL	CLEAR_KEY_BUFF
		
KEY_LOOP:	
	CALL	TIME_INT
	MOV	AH,01			;WAITING FOR KEY
	INT	16H

	JZ	KEY_LOOP
	
	MOV	AH,0
	INT	16H
	
	POP	CX
	POP	BX
	
	RET
	
	WAIT_KEY	ENDP
	
	
;=====================================================================

	CLEAR_KEY_BUFF	PROC

	MOV	AH,0CH
	MOV	AL,0
	INT	21H
	RET
	CLEAR_KEY_BUFF ENDP

;======================================================================	
	SHOW_RUN	PROC
	
	PUSHA
	
	INC COUNT
	MOV	BL,'2'
	MOV	CX,6

RUN_EMOTION:
	CALL	TRACK
	CMP	RETURN,1
	JE	RE_RUN
	
	MOV	RUN[13],BL
	TPASTEBMP MAN_X,MAN_Y,5CH,RUN
	
	CALL	WAIT_KEY
	
	CMP	AH,39H
	JE	JUMPING
	;CALL	CLEAR_KEY_BUFF
	CMP OBJ_X1,210
	JG	CHECK_CRASH1
	DELAY	250
	INC	BL

	LOOP	RUN_EMOTION 

    CMP OBJ_X1,210
	JG	CHECK_CRASH1

NO_CRASH:
	JMP RE_RUN

CHECK_CRASH1:	
	PUSH CX
	XOR CX,CX
	MOV	CX,MAN_Y
	ADD	CX,74
	MOV	MAN_YY,CX
	CMP	MAN_YY,130
	POP CX
	JG	CLASH_YO
	JMP	RE_RUN
	
CLASH_YO:
	CALL	CLASH
	JMP		RE_RUN
JUMPING:
	CALL	SHOW_JUMP
	;CALL	CLEAR_KEY_BUFF
RE_RUN:

	POPA
	RET
	
	SHOW_RUN	ENDP
;===========================================================================
	SHOW_JUMP	PROC
	
	PUSHA
	
	INC COUNT
	MOV		BL,'1'
	MOV		CX,3
	
JUMP1_EMOTION:

	CALL	TRACK
	CMP	RETURN,1
	JE	RE_JUMP3
	MOV	JUMP_UP[14],BL
	TPASTEBMP MAN_X,MAN_Y,05CH,JUMP_UP
	INC	BL

	SUB	MAN_Y,20
	ADD OBJ_X1,10
	DELAY	500
	
	LOOP	JUMP1_EMOTION
	
	CMP OBJ_X1,200
	JG	CHECK_CRASH2

NO_CRASH2:
	JMP RE_JUMP

CHECK_CRASH2:	
	PUSH CX
	MOV	CX,MAN_Y
	ADD	CX,74
	MOV	MAN_YY,CX
	CMP	MAN_YY,130
	POP CX
	JL	RE_JUMP
	
CLASH_YO2:
	CALL	CLASH
	
RE_JUMP:
	
	
	MOV		BL,'3'
	MOV		CX,3
	
	
JUMP2_EMOTION:

	CALL	TRACK
	MOV	JUMP_DOWN[14],BL
	TPASTEBMP MAN_X,MAN_Y,05CH,JUMP_DOWN
	DEC	BL
	ADD	MAN_Y,20
	DELAY	500
	
	LOOP	JUMP2_EMOTION
	
	CMP OBJ_X1,230
	JG	CHECK_CRASH3

NO_CRASH3:
	JMP RE_JUMP2

CHECK_CRASH3:	
	PUSH CX
	MOV	CX,MAN_Y
	ADD	CX,74
	MOV	MAN_YY,CX
	CMP	MAN_YY,130
	POP CX
	JL	RE_JUMP2
	
CLASH_YO3:
	CALL	CLASH
	CMP	OBJ_X1,240
	JG	CLASH_AGIAN
	
RE_JUMP2:
	
	CALL		TRACK
	TPASTEBMP MAN_X,MAN_Y,05CH,RUN
	JMP	RE_JUMP3
CLASH_AGIAN:
	CALL	CLASH
	JMP	RE_JUMP2
RE_JUMP3:

	POPA
	RET
	
	SHOW_JUMP	ENDP
;=============================================================

	CLASH	PROC
	
	INC	NCRASH
	SUB	POINT,10
	PASTEBMP	0,0,SECOND
	CALL	SCORE_
	CALL	TIME_INT
	TPASTEBMP	180,140,05CH,OBJECT2
	TPASTEBMP	MAN_X,90,05CH,JUMP_DOWN
	DELAY 500
	PASTEBMP	0,0,SECOND
	CALL	SCORE_
	CALL	TIME_INT
	TPASTEBMP	180,140,05CH,OBJECT2
	TPASTEBMP	MAN_X,115,05CH,CRASH
	DELAY 2000
	MOV	OBJ_X1,20
	XOR	AX,AX
	;CALL	CLEAR_KEY_BUFF
	RET
	CLASH ENDP
;=======================================================

	GAME_FINISH	PROC
	
	PUSHA
	
	
	
	PASTEBMP	0,0,YEAH
	DELAY	8000
	
	MOV	AH,08
	INT	21H
	
	XOR	BX,BX
	XOR	CX,CX
	XOR	AX,AX
	
	
	CALL	BONUS
	CALL	GET_NAME
	CALL	RESULT_
	CALL	HIGH_SCORE
	MOV	RETURN,1
	POPA
	RET
	
	GAME_FINISH	ENDP
	
;==========================================================

	GAME_OVER	PROC
	
	XOR	BX,BX
	XOR	CX,CX
	XOR	AX,AX
	PASTEBMP	0,0,OVER
	DELAY	2000
	
	MOV	AH,08
	INT	21H
	RET
	
	GAME_OVER	ENDP
;=======================================================
OUTDEC PROC
;prints AX as a unsigned decimal integer
;input: AX
;output : none
	
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

	OR   AX,AX
	JGE  @END_IF1

	PUSH AX
	MOV  DL,'-'
	WRITE_CHAR	DL,232
	POP  AX
	NEG  AX

	@END_IF1:
	XOR  CX,CX
	MOV  BX,10D

	@REPEAT1:
	XOR  DX,DX
	DIV  BX
	PUSH DX
	INC  CX
	OR	AX,AX
	JNE  @REPEAT1

	;MOV  AH,2

	@PRINT_LOOP:
	POP  DX
	OR   DL,30H
	;INT  21H
	WRITE_CHAR	DL,232
	LOOP @PRINT_LOOP

	POP  DX
	POP  CX
	POP  BX
	POP  AX
	
	RET
OUTDEC ENDP
;===============================================================
	SCORE_	PROC
	
	GOTOXY	66,1
	WRITE_CHAR	'S',232
	WRITE_CHAR	'C',232
	WRITE_CHAR	'O',232
	WRITE_CHAR	'R',232
	WRITE_CHAR	'E',232
	WRITE_CHAR	':',232
	MOV	AX,POINT
	CALL	OUTDEC
		
	RET
	
	SCORE_	ENDP
;===================================================================	

	BONUS	PROC
	
	XOR	AX,AX
	XOR	BX,BX
	XOR	DX,DX
	
	MOVZX	AX,SEC
	MOV	BX,100
	MUL	BX
	
	MOVZX	BX,M_SEC
	
	ADD	AX,BX
	MOV	TEMP,AX
	
	XOR	DX,DX
	MOV	AX,10000
	MOV	BX,TEMP
	DIV	BX
	
	MOV	TEMP,AX
	MOV	AX,POINT
	MOV	BX,TEMP
	MUL	BX
	
	MOV	SCORE,AX
	
	RET
	
	BONUS	ENDP
	
;==========================================================================	
	
	RESULT_	PROC
	
	PUSHA
	
	PASTEBMP	0,0,RESULT
	
	GOTOXY	22,9
	MOV		AX,POINT
	CALL	OUTDEC
	
	GOTOXY	22,13
	MOVZX		AX,SEC
	CALL	OUTDEC
	
	GOTOXY	25,13
	MOVZX		AX,M_SEC
	CALL	OUTDEC
	
	GOTOXY	23,16
	MOV	AX,SCORE
	CALL	OUTDEC
	
	MOV	AH,08
	INT	21H
	XOR	AX,AX
	POPA
	RET
	RESULT_	ENDP