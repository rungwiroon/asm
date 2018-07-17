;======================================================
;Save screen to vga buffer segment
;use MOVSD for faster ,easier load and store and reduce loop 
;you can chaeng to use 16bit for 286 cpu
;======================================================
SAVESCREEN PROC
	PUSHA
	PUSH	DS
	PUSH	ES	
	
	MOV	AX,0A000H
	MOV	DS,AX
	XOR	SI,SI
	
	MOV	AX,VBUFFERSEG
	MOV ES,AX
	LEA	DI,VBUFFER
	
	MOV	CX,16000
	REP MOVSD	;move data from DS:[SI] to ES:[DI] AND INC SI,DI
		
	POP	ES
	POP	DS
	POPA
	RET
SAVESCREEN ENDP
;============================================
;Restore screen from vga buffer segment
;============================================
RESTORESCREEN	PROC
	PUSHA
	PUSH 	DS
	PUSH	ES
		
	MOV AX,VBUFFERSEG
	MOV	DS,AX
	LEA SI,VBUFFER
	
	MOV	AX,0A000H
	MOV	ES,AX
	XOR DI,DI
	
	MOV	CX,16000
	REP MOVSD	;move data from DS:[SI] to ES:[DI] AND INC SI,DI
	
	POP	ES
	POP	DS
	POPA
	RET
RESTORESCREEN ENDP