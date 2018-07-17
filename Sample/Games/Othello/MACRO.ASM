;///////////////////////////////////////////////
;///////////////////////////////////////////////
PIC_LOCATE MACRO	X,Y,FILENAME

	LEA	SI,FILENAME
	MOV	CX,X
	MOV	BMP_X,CX
	MOV	DX,Y
	MOV	BMP_Y,DX
	CALL	LOADBMP
	ENDM
;////////////////////////////////////////////////
;////////////////////////////////////////////////
PIC_DELAY MACRO	X,Y,FILENAME

	LEA	SI,FILENAME
	MOV	CX,X
	MOV	BMP_X,CX
	MOV	DX,Y
	MOV	BMP_Y,DX
	CALL	BMP_EDIT
	ENDM
;////////////////////////////////////////////////
;////////////////////////////////////////////////
CHANGE_SET_PLAY	MACRO

	LOCAL	EXIT_CHANGE_SET_PLAY

	INC	SET_PLAY

	CMP	SET_PLAY,2
	JNG	EXIT_CHANGE_SET_PLAY

	MOV	SET_PLAY,1		;become white turn

EXIT_CHANGE_SET_PLAY :
	ENDM
;////////////////////////////////////////////////
;////////////////////////////////////////////////
MOVM	MACRO	ARG1,ARG2

	PUSH	CX

	MOV	CH,ARG2
	MOV	ARG1,CH

	POP	CX

	ENDM
;////////////////////////////////////////////////
;////////////////////////////////////////////////
WAITCLICK MACRO
;;OUTPUT: CX=X,DX=Y

	LOCAL START,X,Y,WAITLOOP,WAITLOOP2
	PUSH AX
	PUSH BX
	JMP START
X	DW	?
Y	DW	?

START:
	
WAITLOOP:
	MOV AX,5H		;read value click mouse
	XOR BX,BX
	INT 33H
	CMP BX,0
	JLE WAITLOOP
	MOV X,CX
	MOV Y,DX
	
WAITLOOP2:
	MOV AX,6H		;read value no click mouse
	XOR BX,BX
	INT 33H
	CMP BX,0
	JLE WAITLOOP2
	CMP CX,X
	JNE WAITLOOP
	CMP DX,Y
	JNE WAITLOOP
	

;	GOTO_XY 0,0		;\
;	MOV	AH,09H		; \
;	LEA	DX,MSG_BLANK	;  \
;	INT	21H		;   \
				;    \
;	GOTO_XY 0,0		;     \
;	MOV AX,X		;      >-> print (x,y) value for click (.micky)
;	CALL OUTDEC		;     / 
;	MOV AH,2		;    /	
;	MOV DL,','		;   /
;	INT 21H			;  /
;	MOV AX,Y		; /
;	CALL OUTDEC		;/

	PUSH	X
	POP	X_MICKY
	PUSH	Y
	POP	Y_MICKY

	POP BX
	POP AX
	ENDM
;////////////////////////////////////////////////
;////////////////////////////////////////////////
GOTO_XY	MACRO	X,Y

	PUSH_R

	MOV	AH,2
	MOV	DL,X		;row = 0-24
	MOV	DH,Y		;col = 0-79
	MOV	BH,0
	INT	10H

	POP_R	

	ENDM
;////////////////////////////////////////////////
;////////////////////////////////////////////////
PUSH_R	MACRO	
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	ENDM

POP_R	MACRO	
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	ENDM
;////////////////////////////////////////////////
;////////////////////////////////////////////////
SHOW_MOUSE	MACRO
	MOV	AX,1		;show mouse
	INT	33H		;call driver mouse
	ENDM

HIDE_MOUSE	MACRO
	MOV	AX,2		;hide mouse
	INT	33H
	ENDM
;////////////////////////////////////////////////
;////////////////////////////////////////////////