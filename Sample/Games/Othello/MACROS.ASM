DOS_RTN MACRO
	MOV AH,4CH
	INT 21H
	ENDM
SAVE_REG MACRO REGS
	IRP D,<REGS>
	PUSH D
	ENDM
	ENDM
LOAD_REG MACRO REGS
	IRP D,<REGS>
	POP D
	ENDM
	ENDM
NEW_LINE MACRO
	PUSH AX
	PUSH DX

	MOV AH,2
	MOV DL,0DH
	INT 21H
	MOV DL,0AH
	INT 21H

	POP DX
	POP AX
	ENDM
DISP_STR MACRO STRING
	LOCAL START,MSG

	PUSH AX
	PUSH DX
	PUSH DS
	JMP START
MSG DB STRING,'$'
START:
	MOV AX,CS
	MOV DS,AX
	MOV AH,9
	LEA DX,MSG
	INT 21H

	POP DS
	POP DX
	POP AX
	ENDM

GOTOXY MACRO X,Y
	PUSH AX
	PUSH BX
	PUSH DX
	
	MOV AH,02H
	XOR BX,BX
	MOV DH,Y
	MOV DL,X
	INT 10H

	POP DX
	POP BX
	POP AX
	ENDM

WM MACRO
;;OUTPUT: CX=X,DX=Y

	LOCAL START,X,Y,WAITLOOP,WAITLOOP2
	PUSH AX
	PUSH BX
	JMP START
X	DW	?
Y	DW	?

START:
	
WAITLOOP:
	MOV AX,5H
	XOR BX,BX
	INT 33H
	CMP BX,0
	JLE WAITLOOP
	MOV X,CX
	MOV Y,DX
WAITLOOP2:
	MOV AX,6H
	XOR BX,BX
	INT 33H
	CMP BX,0
	JLE WAITLOOP2
	CMP CX,X
	JNE WAITLOOP
	CMP DX,Y
	JNE WAITLOOP
	

	POP BX
	POP AX
	ENDM