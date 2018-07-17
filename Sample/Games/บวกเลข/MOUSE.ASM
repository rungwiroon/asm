;CHECK MOUSE CLICK
;OUTPUT   BLOCK_NUM = POSITION OF ARRAY,BLOCK
;         MOUSE_CLICK >= 1 -> CLICK ON TABLE
;                      = 0 -> NOT CLICK OR NOT ON TABLE
CHKMOUSE        PROC
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX

        MOV     AX,5            
        MOV     BX,0
        INT     33H

        MOV     MOU_CLICK,BX
        CMP     BX,1            ;MOUSE CLICK
        JL      MNCLI_

        SUB     CX,56
        SUB     DX,LEN_Y
        CMP     CX,360          ;X < 360  -> ON TABLE
        JGE     MNCLI_
        CMP     CX,0
        JL      MNCLI_
        CMP     DX,180          ;Y < 180  -> ON TABLE
        JGE     MNCLI_
        CMP     DX,0
        JL      MNCLI_

        PUSH    DX
        MOV     AX,CX           ;DIV BY 36
        XOR     DX,DX
        MOV     BX,36           ;CX = POSITION X
        DIV     BX
        MOV     CX,AX

        POP     DX
        MOV     AX,DX           ;DIV BY 18
        XOR     DX,DX
        MOV     BX,18
        DIV     BX              ;DX = POSITION Y
        MOV     DX,AX

        MOV     BLOCK_NUM,0     ;BLOCK_NUM = X+(Y*10)
        ADD     BLOCK_NUM,CX    ;BLOCK_NUM += X
        MOV     AL,DL           ;AX = Y * 10
        MOV     BL,10
        MUL     BL
        ADD     BLOCK_NUM,AX    ;BLOCK_NUM = X+(Y*10)

        JMP     MCLI_
MNCLI_:
        MOV     MOU_CLICK,0
MCLI_:
        
        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
CHKMOUSE        ENDP


RIGHTCLICK	PROC
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
	
        MOV     AX,5            
        MOV     BX,1
        INT     33H

        CMP     BX,1            ;RIGHT CLICK?
        JL       RNCLI_

        XOR     BX,BX

UNDO_LOOP:
        CMP     BLO_STR[BX],1
        JNE     NOTUNDO_

        MOV     BLO_STR[BX],0   ;UNDO BLOCK

        XOR     DX,DX
        MOV     AX,BX           ;DIVIDE BY 10
        MOV     CX,10
        DIV     CX

        MOV     CL,18           ;POSITION Y = (AX * 18) + LEN_Y
        MUL     CL
        ADD     AX,LEN_Y
        MOV     BMP_Y,AX

        MOV     AX,DX           ;POSITION X = (DX * 18) + LEN_X
        MUL     CL
        ADD     AX,LEN_X
        MOV     BMP_X,AX

        MOV     DI,BX 
        CALL    CHK_BLOCK_DRAW
        CALL    HIDE_MOUSE
        CALL    LOADBMP
        CALL    SHOW_MOUSE

NOTUNDO_:
        INC     BX
        CMP     BX,100
        JL      UNDO_LOOP      ;GO LOOP

        MOV     SUM_POINT,0

RNCLI_:
        POP     DX
        POP     CX
        POP     BX
        POP     AX
	RET
RIGHTCLICK	ENDP

RESET_MOUSE	PROC
	PUSH	AX
	XOR	AX,AX	;RESET_MOUSE
	INT	33H
	POP	AX
	RET
RESET_MOUSE	ENDP

SHOW_MOUSE	PROC
	PUSH	AX
	MOV     	AX,1            ;SHOW MOUSE
	INT     	33H
	POP	AX
	RET
SHOW_MOUSE	ENDP

HIDE_MOUSE	PROC
	PUSH	AX
	MOV    	AX,2H           ;HIDE MOUSE
	INT     	33H
	POP	AX
	RET
HIDE_MOUSE	ENDP