	TITLE	PGM15_2A: SET INTERRUPT VECTOR
	PUBLIC	SETUP_INT
.MODEL SMALL
.CODE
SETUP_INT	PROC
;saves old vector and sets up new vector
;inputº  AÌ = interrupô type
;	DI = address of buffer for old vector
;	SI = address of buffer containing new vector
;savå old interrupô vector
 	MOV	AH,35H		;function 35h, get vector
	INT	21H		;ES:BX = vector
	MOV	[DI],BX		;save offset
	MOV	[DI+2],ES	;save segment
;setup new vector
	MOV	DX,[SI]		;DX has offset
	PUSH	DS		;save it
	MOV	DS,[SI+2]	;DS has segment number
	MOV	AH,25H		;function 25h, set vector
	INT	21H		;
	POP	DS		;restore DS
        RET
SETUP_INT	ENDP
	END
