START_GAME	PROC

DO_BLANK_TABLE :

	MOV	[TABLE+BX],0		;show table
	INC	BX
	CMP	BX,64
	JLE	DO_BLANK_TABLE
	PIC_LOCATE 0,0,PIC_BG		;in file MACRO.ASM  (set value picture start game)
	SHOW_MOUSE			;in file MACRO.ASM		

FIRST :
	SHOW_MOUSE			
	WAITCLICK			;in file MACRO.ASM		
	CALL	CHECK_FIRST_PAGE	;in chkmouse.asm
	CMP	CHECK_CLICK,0
	JE	FIRST

	HIDE_MOUSE
	PIC_LOCATE 0,0,PIC_BG_SELECT	;Page of player
;--------------------------------------------------
FOR_PL1_SELECT :
	MOV	TEMP,1			;check select pic for PL1
	SHOW_MOUSE
	WAITCLICK
	CALL	CHECK_SELECT_PAGE	;in chkmouse.asm
	CMP	PL1_SELECT,0		;check mouse click bg
	JE	FOR_PL1_SELECT

	CMP	PL1_SELECT,1		;check mouse click NOBITA
	JE	SELECT_NOB1

	CMP	PL1_SELECT,2		;check mouse click DORAEMON
	JE	SELECT_DOR1

	CMP	PL1_SELECT,3		;check mouse click SHIZUKA
	JE	SELECT_SHI1

SELECT_NOB1 :
	PIC_LOCATE	10,12,PIC_NOB	;if select NOBITA show pic NOBITA
	JMP	FOR_PL2_SELECT
SELECT_DOR1 :
	PIC_LOCATE	10,12,PIC_DOR	;if select DORAEMON show pic DORAEMON
	JMP	FOR_PL2_SELECT
SELECT_SHI1 :
	PIC_LOCATE	10,12,PIC_SHI	;if select SHIZUKA show pic SHIZUKA

;--------------------------------------------------
FOR_PL2_SELECT :
	MOV	TEMP,2			;check select pic for PL1
	SHOW_MOUSE
	WAITCLICK
	CALL	CHECK_SELECT_PAGE
	CMP	PL2_SELECT,0		;check mouse click bg
	JE	FOR_PL2_SELECT

	CMP	PL2_SELECT,1		;check mouse click NOBITA
	JE	SELECT_NOB2

	CMP	PL2_SELECT,2		;check mouse click DORAEMON
	JE	SELECT_DOR2

	CMP	PL2_SELECT,3		;check mouse click SHIZUKA
	JE	SELECT_SHI2

SELECT_NOB2 :
	PIC_LOCATE	266,12,PIC_NOB	;if select NOBITA show pic NOBITA
	JMP	CALL_START_PLAY
SELECT_DOR2 :
	PIC_LOCATE	266,12,PIC_DOR	;if select DORAEMON show pic DORAEMON
	JMP	CALL_START_PLAY

SELECT_SHI2 :
	PIC_LOCATE	266,12,PIC_SHI	;if select SHIZUKA show pic SHIZUKA

CALL_START_PLAY :
	WAITCLICK
	CALL	START_PLAY		;call fnc start play			
START_GAME	ENDP
;///////////////////////////////////////////////////////
;///////////////////////////////////////////////////////
START_PLAY	PROC

	XOR	BX,BX
	HIDE_MOUSE
DONE_BLANK_TABLE :

	MOV	[TABLE+BX],0		;show table
	INC	BX
	CMP	BX,64
	JLE	DONE_BLANK_TABLE
	
	PIC_LOCATE     0,0,PIC_BG_TABLE  ;blank table for start game
	MOV     [TABLE+27],1		;white
	MOV     [TABLE+28],2		;black
	MOV     [TABLE+35],2		;black
	MOV     [TABLE+36],1		;white

	MOV	POSITION,27
	CALL	PUT_PIC_SHELL		;in put_mak.asm

	MOV	POSITION,28
	CALL	PUT_PIC_SHELL		;in put_mak.asm

	MOV	POSITION,35
	CALL	PUT_PIC_SHELL		;in put_mak.asm

	MOV	POSITION,36
	CALL	PUT_PIC_SHELL		;in put_mak.asm

;--------------------------------------------------------
CHECK_SELECT1 :

	CMP	PL1_SELECT,1		;check mouse click NOBITA
	JE	NOB_PL1

	CMP	PL1_SELECT,2		;check mouse click DORAEMON
	JE	DOR_PL1

	CMP	PL1_SELECT,3		;check mouse click SHIZUKA
	JE	SHI_PL1

NOB_PL1 :
	PIC_LOCATE	15,29,PIC_NOB	;show picture NOBITA
	JMP	CHECK_SELECT2
DOR_PL1 :
	PIC_LOCATE	15,29,PIC_DOR	;show picture DORAEMON
	JMP	CHECK_SELECT2
SHI_PL1 :
	PIC_LOCATE	15,29,PIC_SHI	;show picture SHIZUKA
	JMP	CHECK_SELECT2
;---------------------------------------------------------
CHECK_SELECT2 :

	CMP	PL2_SELECT,1		;check mouse click NOBITA
	JE	NOB_PL2

	CMP	PL2_SELECT,2		;check mouse click DORAEMON
	JE	DOR_PL2

	CMP	PL2_SELECT,3		;check mouse click SHIZUKA
	JE	SHI_PL2

NOB_PL2 :
	PIC_LOCATE	265,29,PIC_NOB	;show picture NOBITA
	JMP	RANDOM_SETPLAY
DOR_PL2 :
	PIC_LOCATE	265,29,PIC_DOR	;show picture DORAEMON
	JMP	RANDOM_SETPLAY
SHI_PL2 :
	PIC_LOCATE	265,29,PIC_SHI	;show picture SHIZUKA
	JMP	RANDOM_SETPLAY
;---------------------------------------------------------
RANDOM_SETPLAY :
	CALL	_SCORE			;in file SCORE.ASM

	MOV	AH,2CH			;get time fnc
	INT	21H			;output to dl

	MOV	AL,DL
	AND	AL,01H			;0 to 1
	INC	AL			;1 to 2
	MOV	SET_PLAY,AL

        MOV	AX,01H		;show mouse (not new create)
	INT	33H		
	CALL	PUT_MAK
	RET
	
START_PLAY	ENDP
;///////////////////////////////////////////////////////
;///////////////////////////////////////////////////////