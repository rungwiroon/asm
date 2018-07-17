lab3    segment
        assume  cs:lab3,ds:lab3
        org     100h
main1    proc    near
;========================================================
        JMP     START
MSG1    DB      '[..........Hello! Lab3 (555)........] $'

START:
        MOV     AH,09H
        LEA     DX,MSG1        
        INT     21H
	CALL    DISPLAY1
        ;...................
        INT     20H
;==========================================================
MAIN1   ENDP
;/////////////////////////
;===========
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

        POP     DX
        POP     CX
        POP     AX

        RET

DISPLAY1 ENDP

;////////////////////////

LAB3    ENDS
END     MAIN1
