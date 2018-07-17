LAB3    SEGMENT
        ASSUME  CS:LAB3,DS:LAB3
        	ORG     	100H
MAIN1   	PROC    	NEAR
;====================================================================
        	JMP     	START
FREE1   	DB        ' '
MSG1    	DB      	'[..........Hello!     Lab3 (555)........] $'
MSG2    	DB      	'[.........EXIT     PROGRAM ........] $'
START:
        	MOV     	AH,09H
        	LEA     	DX,MSG1
        	INT     	21H
        	CALL    	DISPLAY1
        	mov     	cx,05h
exit:
        	MOV     	AH,09H
        	LEA     	DX,MSG2
        	INT     	21H
        	call    	sound
        	loop    	exit
;............................................................................................................................................................
        	INT     	20H
;=====================================================================
MAIN1   	ENDP

;=====================================================================
;SUB ROUTINE "DISPLAY"
;=====================================================================
DISPLAY1 	PROC 	NEAR
CHAR    	DB      	'A'
        	PUSH    	AX
        	PUSH    	CX
        	PUSH    	DX
        	MOV     	CL,0
DISP1:
        	MOV     	AH,02H
        	MOV     	DL,CHAR;	ABCDEFGHI.......
        	ADD     	DL,CL
        	INT     	21H
       	CALL    	FREE
        	INC     	CL
        	CMP     	CL,26
        	JNZ     	DISP1
        	POP     	DX
        	POP     	CX
        	POP     	AX
        	RET
DISPLAY1  	ENDP
			
;.....................................................................................

sound   	PROC  	NEAR
        	push    	ax
        	push    	cx
        	push    	dx
        	MOV     	cx,03H
sa:
        	MOV     	AH,02H
        	MOV     	DL,07h;		sound
        	INT     	21H
        	loop    	sa	
        	pop     	dx
        	pop     	cx
        	pop     	ax
        	RET
sound  endp

;....................................................................................

FREE 	PROC 	NEAR
        	PUSH    	AX
        	PUSH    	DX
        	MOV     	AH,02H
        	MOV     	DL,FREE1;   	A_B_C_D_G_F_G_.....................
        	INT     	21H
        	POP     	DX
        	POP     	AX
        	RET
FREE 	ENDP

;......................................................................................................................................................
LAB3    	ENDS
END     	MAIN1
;===================================================================
