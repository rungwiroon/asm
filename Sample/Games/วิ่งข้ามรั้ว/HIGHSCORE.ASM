	HIGH_SCORE	PROC
	
	PUSHA

	PASTEBMP	0,0,POINT_BG
	CALL			DISP_SCORE 
	MOV	AH,08
	INT	21H
	MOV	CHOICE,1
	
	POPA
	RET
	
	HIGH_SCORE ENDP
	
;=====================================================
GET_NAME        PROC
	PUSHA

GN_PIC:	
	PASTEBMP 80,57,ENTER_NAME
	GOTOXY  15,12	;SET START INPUT NAME POSITION
       	
	LEA	DX,NAME1	;SET OFFSET FOR STORE NAME
	MOV	AH,0AH		;GET STRING FROM KEYBOARD
	INT	21H

	CMP	BYTE PTR NAME1[1],0	;CHECK NUMBER OF CHAR
	JE	GN_PIC			;DONT'PASS WITH NO NAME
	
	LEA	DI,NAME2
	MOV	AL,0
	MOV	CX,10
	REP	STOSB		;CLEAR ARRAY NAME2
	
	LEA	SI,NAME1	
	ADD	SI,2		;POINT TO CHAR FROM KEYBOARD
	LEA	DI,NAME2
	MOVZX	CX,NAME1[1]	;LOOP NUMBER OF CHAR
	REP	MOVSB		;COPY STIRNG TO NAME2

        CALL    READ_DATA       ;READ DATA 10 RECORD FROM FILE

        MOV     AX,SCORE        ;STORE DATA IN RECORD 11
        MOV     SCORE_REC[20],AX
        LEA     SI,NAME2
        LEA     DI,NAME_REC[100]
	MOVSD			;COPY DS:[SI] TO ES:[DI] 4 BYTE
	MOVSD			;COPY DS:[SI] TO ES:[DI] 4 BYTE
	MOVSW			;COPY DS:[SI] TO ES:[DI] 2 BYTE 
				;TOTAL COPY 10 BYTE
                                        
        CALL    SORT_           ;SORT DATA
        CALL    WRITE_DATA      ;WRITE DATA 10 RECORD TO FILE
	
        POPA
        RET
GET_NAME        ENDP

;=====================================================================
DISP_SCORE      PROC
        PUSHA

	    CALL    READ_DATA

	XOR	AX,AX		;FOR COUNT NUMBER
	XOR	BX,BX		;FOR POINT SCORE ARRAY
	MOV	CL,9		;DEFINE Y START POISITION
	LEA     SI,NAME_REC
LOOP_SCORE:
	;SHOW NUMBER
	INC	AX
       	INC	CL
        GOTOXY 	7,CL
        CALL    OUTDEC
	PUSH	AX
		
	;SHOW NAME
        GOTOXY 	12,CL
        LEA     DI,NAME2
        MOVSD			;COPY DS:[SI] TO ES:[DI] 4 BYTE
	MOVSD			;COPY DS:[SI] TO ES:[DI] 4 BYTE
	MOVSW			;COPY DS:[SI] TO ES:[DI] 2 BYTE 
				;TOTAL COPY 10 BYTE
        MOV     AH,09
        LEA     DX,NAME2
        INT     21H
		
	;SHOW SCORE
        GOTOXY 	30,CL
        MOV     AX,SCORE_REC[BX]
        CALL    OUTDEC

	;NEXT RECORD
        POP	AX
	ADD     BX,2		;point to next word score
        CMP     AX,10
        JL      LOOP_SCORE

        POPA
        RET
DISP_SCORE      ENDP
;========================================================================
READ_DATA       PROC
        ;PUSHA

	MOV     AH,3DH
        LEA     DX,FILESCORE
        MOV     AL,2
        INT     21H
        MOV     BX,AX
        
	MOV     AH,3FH
        ;MOV     BX,HANDLE
        MOV     CX,100
        LEA     DX,NAME_REC
        INT     21H

        MOV     AH,3FH
        ;MOV     BX,HANDLE
        MOV     CX,20
        LEA     DX,SCORE_REC
        INT     21H

	;CLOSE FILE
        MOV     AH,3EH
        ;MOV     BX,HANDLE
        INT     21H
		
        ;POPA
        RET
READ_DATA       ENDP

;==========================================================================

WRITE_DATA      PROC
        ;PUSHA
        
	MOV     AH,3DH
        LEA     DX,FILESCORE
        MOV     AL,2
        INT     21H
        MOV     BX,AX
		
        MOV     AH,40H
        ;MOV     BX,HANDLE
        MOV     CX,100
        LEA     DX,NAME_REC
        INT     21H

        MOV     AH,40H
        ;MOV     BX,HANDLE
        MOV     CX,20
        LEA     DX,SCORE_REC
        INT     21H

        MOV     AH,3EH
        ;MOV     BX,HANDLE
        INT     21H
		
        ;POPA
        RET
WRITE_DATA      ENDP
;========================================================
SORT_   PROC
        PUSHA
		
        MOV     BX,11		;NUMBER OF RECORD
		MOV     NUM,1		
SORT_LOOP_I:                    
        MOV     CX,BX        
        LEA     SI,SCORE_REC    ;SET ADDRESS
        MOV     NUM2,0          ;FOR NAME
        SUB     CX,NUM
	PUSH	BX		;SAVE ARRAY SIZE

SORT_LOOP_J:                    
        MOV     AX,[SI+2]       ;READ DATA
        CMP     [SI],AX         ;IF A[J] < A[J+1]
        JGE     NEXT_
        XCHG    [SI],AX		;SWAP SCORE
        MOV     [SI+2],AX
	
	PUSH	SI		;PUSH SCORE POINTER
				;SWAP NAME
        MOV     BX,NUM2         ;MOV J+1 TO TMP 
        LEA     SI,NAME_REC[BX+10]
        LEA     DI,NAME2
        MOVSD			;COPY DS:[SI] TO ES:[DI] 4 BYTE
	MOVSD			;COPY DS:[SI] TO ES:[DI] 4 BYTE
	MOVSW			;COPY DS:[SI] TO ES:[DI] 2 BYTE 
				;TOTAL COPY 10 BYTE

        LEA     SI,NAME_REC[BX] ;MOV J TO J+1
        LEA     DI,NAME_REC[BX+10]
        MOVSD			;COPY DS:[SI] TO ES:[DI] 4 BYTE
	MOVSD			;COPY DS:[SI] TO ES:[DI] 4 BYTE
	MOVSW			;COPY DS:[SI] TO ES:[DI] 2 BYTE 
				;TOTAL COPY 10 BYTE

        LEA     SI,NAME2        ;MOV TMP TO J
        LEA     DI,NAME_REC[BX]
        MOVSD			;COPY DS:[SI] TO ES:[DI] 4 BYTE
	MOVSD			;COPY DS:[SI] TO ES:[DI] 4 BYTE
	MOVSW			;COPY DS:[SI] TO ES:[DI] 2 BYTE 
				;TOTAL COPY 10 BYTE

        POP	SI		;POP SCORE POINTER
	
NEXT_:
        ADD     SI,2            ;PLUS ADDRESS
        ADD     NUM2,10
        LOOP    SORT_LOOP_J

	POP	BX		;POP ARRAY	SIZE
        INC     NUM
        CMP     BX,NUM
        JG      SORT_LOOP_I
        
		POPA
        RET
SORT_   ENDP

