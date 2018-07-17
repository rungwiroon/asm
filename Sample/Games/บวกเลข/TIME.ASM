
TIME_RATE       PROC
;FOR CHECK GATE TIME
        PUSHR

        XOR     DX,DX           ;DIV BY 13 FOR SHOW GATE TIME
        MOV     AX,BONUS
        MOV     BX,8
        DIV     BX

        CMP     AL,GATE_TIME
        JE      EXIT_TIME_RATE

        CLD
        LEA     DI,T[5]

        CMP     AL,0
        JLE     RATE_0

        XOR     DX,DX
        MOV     BX,10
        DIV     BX

        ADD     AL,"0"
        STOSB
        MOV     AL,DL
        ADD     AL,"0"
        STOSB
        JMP     SHOW_GATE
RATE_0:
        MOV     AL,"0"
        STOSB
        STOSB
SHOW_GATE:
	PASTEBMP 235,96,T
EXIT_TIME_RATE:
        POPR
        RET

TIME_RATE       ENDP

GET_TIME        PROC
;GET BEGIN OF TIME
        PUSHR

        MOV     AH,2CH
        INT     21H

        XOR     AX,AX           ;DIV BY 10
        MOV     AL,DL
        MOV     DL,10
        DIV     DL

        MOV     CURRENT_TIME,AL

        POPR
        RET
GET_TIME        ENDP


;******************************************************************
;			RANDOM FUNCTION
;******************************************************************
RANDOM	PROC
	PUSH	AX
        PUSH    BX
	PUSH	CX
	PUSH	DX

;RANDOM NUMBER
	XOR	AX,AX
	XOR	BX,BX
        MOV     CX,100
FOR_R:
;ACCESS IN ARRAY
        PUSH    CX
        MOV     AH,2CH          ;RANDOM
	INT	21H
        XOR     AX,AX           ;MOD 9 + 1
	MOV	AL,DL
	MOV	DL,9
	DIV	DL
	INC	AH

	MOV	BLO_DATA[BX],AH
	MOV	BLO_STR[BX],0
	INC	BX

        ;MOV     DL,AH           ;SHOW NUMBER
        ;ADD     DL,48
        ;MOV     AH,2
        ;INT     21H

	CALL	DELAY
        POP     CX
	LOOP	FOR_R

	POP	DX
	POP	CX
        POP     BX
	POP	AX
	RET
RANDOM	ENDP

;******************************************************************
;			DELAY FUNCTION
;******************************************************************
DELAY 	PROC
	PUSH	AX
	PUSH	DX
        MOV     DX,10000
FOR_D:
        MOV     AX,10000
	FOR_N:
		DEC	AX
		CMP	AX,0
		JNE	FOR_N
	DEC	DX
	JNE	FOR_D
	
	POP	DX
	POP	AX
	RET
DELAY ENDP
;**********************END OF DELAY********************************
