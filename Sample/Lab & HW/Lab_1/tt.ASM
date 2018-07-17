LAB3    SEGMENT
        ASSUME  CS:LAB3,DS:LAB3
        ORG     100H
MAIN1   PROC    NEAR
;========================================================
        JMP     START
MSG1    DB      '[..........Hello! Lab3 (555)........] $'
MSG2    DB      '[.........EXIT PROGRAM ........] $'
START:
        MOV     AH,09H
        LEA     DX,MSG1
        INT     21H
        CALL    DISPLAY1
       
        MOV     AH,09H
        LEA     DX,MSG2
        INT     21H
;..............................................................................................
        INT     20H
;==========================================================
MAIN1   ENDP
;............................................................................................
;=====================
;SUB ROUTINE "DISPLAY"
;=====================
DISPLAY1 PROC NEAR

CHAR    DB      'A'
        PUSH    AX
        PUSH    CX
        PUSH    DX
        MOV     CL,0
DISP1:
        MOV     AH,02H
        MOV     DL,CHAR
        ADD     DL,CL
        INT     21H
        INC     CL
        CMP     CL,26
        JNZ     DISP1
		CALL    sound
        POP     DX
        POP     CX
        POP     AX
        RET
DISPLAY1 ENDP

;.................................................................................................

sound	PROC  NEAR
        MOV     CX,03H
ss:   	MOV     AH,02H
		MOV     DL,07h     
		LOOP   ss	
		INT     21H
		RET
sound	endp
;............................................................................................

LAB3    ENDS
END     MAIN1
;............................................................................................