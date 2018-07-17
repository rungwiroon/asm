GET_NAME        PROC
	PUSHA
	
GN_PIC:	
	GOTOXY  67,19	;SET START INPUT NAME POSITION
       	
	LEA	DX,NAME1	;SET OFFSET FOR STORE NAME
	MOV	AH,0AH		;GET STRING FROM KEYBOARD
	INT	21H

	CMP	BYTE PTR NAME1[1],0	;CHECK NUMBER OF CHAR
	JE	GN_PIC			;DONT'PASS WITH NO NAME
		
		
	LEA	SI,NAME1	
	ADD	SI,2		;POINT TO CHAR FROM KEYBOARD
	LEA	DI,NAME2
	XOR	CX,CX
	MOV	CL,NAME1[1]	;LOOP NUMBER OF CHAR
	REP	MOVSB		;COPY STIRNG TO NAME2

        POPA
        RET
GET_NAME        ENDP

GET_SCORE	PROC
	PUSHA
	   CALL    READ_DATA       ;READ DATA 10 RECORD FROM FILE

        MOV     AX,SCORE        ;STORE DATA IN RECORD 11
        MOV     SCORE_REC[20],AX
        LEA     SI,NAME2
        LEA     DI,NAME_REC[100]
        MOV     CX,10
        REP     MOVSB
                                        
        CALL    SORT_           ;SORT DATA
        CALL    WRITE_DATA      ;WRITE DATA 10 RECORD TO FILE
	POPA
	RET
GET_SCORE	ENDP

DISP_SCORE      PROC
        PUSHA

		;PASTEBMP	0,0,HI_SCORE
		
        CALL    READ_DATA

        XOR     AX,AX
        XOR     BX,BX
LOOP_SCORE:
        INC     AX
        XOR     CX,CX
        MOV     CL,AL
		
        ADD     CL,9
        GOTOXY 	7,CL
        CALL    OUTDEC

        PUSHA
        GOTOXY 	12,CL

        DEC     AX
        MOV     BX,10
        MUL     BX
        MOV     BX,AX

        LEA     SI,NAME_REC[BX]
        LEA     DI,NAME2
        MOV     CX,10
        REP     MOVSB

        MOV     AH,09
        LEA     DX,NAME2
        INT     21H

        POPA

        PUSHA
        GOTOXY 	30,CL
        MOV     AX,SCORE_REC[BX]
        CALL    OUTDEC

        POPA
        ADD     BX,2		;point to next word score
        CMP     AX,10
        JL      LOOP_SCORE

        POPA
        RET
DISP_SCORE      ENDP

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

SORT_   PROC
        ;PUSHA
        MOV     BX,11
        MOV     NUM,1
SORT_LOOP_I:                    
        MOV     CX,BX        
        LEA     SI,SCORE_REC    ;SET ADDRESS
        MOV     NUM2,0          ;FOR NAME
        SUB     CX,NUM

SORT_LOOP_J:                    
        MOV     AX,[SI+2]       ;READ DATA
        CMP     [SI],AX         ;IF A[J] < A[J+1]
        JGE     NEXT_
        XCHG    [SI],AX		;SWAP SCORE
        MOV     [SI+2],AX

        PUSHA	                ;SWAP NAME
        PUSH    SI
        PUSH    DI

        MOV     BX,NUM2         ;MOV J+1 TO TMP 
        LEA     SI,NAME_REC[BX+10]
        LEA     DI,NAME2
        MOV     CX,10
        REP     MOVSB

        LEA     SI,NAME_REC[BX] ;MOV J TO J+1
        LEA     DI,NAME_REC[BX+10]
        MOV     CX,10
        REP     MOVSB

        LEA     SI,NAME2        ;MOV TMP TO J
        LEA     DI,NAME_REC[BX]
        MOV     CX,10
        REP     MOVSB

        POP     DI
        POP     SI
        POPA
NEXT_:
        ADD     SI,2            ;PLUS ADDRESS
        ADD     NUM2,10
        LOOP    SORT_LOOP_J

        INC     NUM
        CMP     BX,NUM
        JG      SORT_LOOP_I
        ;POPA
        RET
SORT_   ENDP
