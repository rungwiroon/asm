LOADPLOT	PROC
	MOV		AX,@DATA
	MOV		DS,AX
	MOV     DX,POSIT_Y		;Y
    MOV     CX,POSIT_X		;X
    CALL    DISPLAY_PIC             

	RET
	LOADPLOT	ENDP	


DISPLAY_PIC	PROC
	MOV     AH,0CH			;call function 0CH for paint spot
    MOV     BH,0			;choose page (this page 0)
    PUSH    DX
    PUSH    CX
PIC_NEXT:
    CMP     BYTE PTR[SI],'0'
    JE      PIC_C0
    CMP     BYTE PTR[SI],'1'
    JE      PIC_C1
    CMP     BYTE PTR[SI],'2'
    JE      PIC_C2
	CMP		BYTE PTR[SI],'3'
	JE		PIC_C3
    CMP     BYTE PTR[SI],'4'
    JE      PIC_C4
	CMP		BYTE PTR[SI],'5'
	JE		PIC_C5
    CMP     BYTE PTR[SI],'6'
    JE      PIC_C6
    CMP     BYTE PTR[SI],'7'
    JE      PIC_C7
	CMP     BYTE PTR[SI],'8'
    JE      PIC_C8
	CMP     BYTE PTR[SI],'9'
    JE      PIC_C9
	CMP     BYTE PTR[SI],'A'
    JE      PIC_CA
	CMP     BYTE PTR[SI],'B'
    JE      PIC_CB
    CMP     BYTE PTR[SI],'C'
    JE      PIC_CC
    CMP     BYTE PTR[SI],'D'
    JE      PIC_CD
    CMP     BYTE PTR[SI],'E'
    JE      PIC_CE
    CMP     BYTE PTR[SI],'F'
    JE      PIC_CF
    CMP     BYTE PTR[SI],' '
    JE      PIC_BLANK
    CMP     BYTE PTR[SI],13
    JE      PIC_LINE
	CMP     BYTE PTR[SI],'$'
    JE      EXIT_PIC
    MOV     AL,0
PRINT_PIC:
		INT     10H			;paint spot
		INC     CX
		INC     SI
		JMP     PIC_NEXT
PIC_C0:
		MOV     AL,0		;black
		JMP     PRINT_PIC
PIC_C1:
        MOV     AL,219		;dark gray
        JMP     PRINT_PIC
PIC_C2:
        MOV     AL,128		;dark red
        JMP     PRINT_PIC
PIC_C3:
		MOV		AL,144		;dark yellow
		JMP		PRINT_PIC
PIC_C4:
		MOV     AL,16		;dark green
        JMP     PRINT_PIC
PIC_C5:
		MOV     AL,18		;cyan
        JMP     PRINT_PIC
PIC_C6:
        MOV     AL,2		;dark blue
        JMP     PRINT_PIC
PIC_C7:
		MOV     AL,130		;dark magetta
        JMP     PRINT_PIC
PIC_C8:
		MOV     AL,219		;gray
        JMP     PRINT_PIC
PIC_C9:
		MOV     AL,224		;red
        JMP     PRINT_PIC
PIC_CA:
		MOV     AL,252		;yellow
        JMP     PRINT_PIC
PIC_CB:
		MOV     AL,28		;green
        JMP     PRINT_PIC
PIC_CC:
        MOV     AL,31		;light cyan
        JMP     PRINT_PIC
PIC_CD:
        MOV     AL,3		;blue
        JMP     PRINT_PIC
PIC_CE:
        MOV     AL,227		;magetta
        JMP     PRINT_PIC
PIC_CF:
        MOV     AL,255		;white
        JMP     PRINT_PIC
PIC_BLANK:
        INC     CX
        INC     SI
        JMP     PIC_NEXT
PIC_LINE:
        POP     CX
        POP     DX
        INC     DX
        PUSH    DX
        PUSH    CX
        INC     SI
        JMP     PIC_NEXT
EXIT_PIC:
        POP     CX
        POP     DX
        RET                
	DISPLAY_PIC     ENDP
 