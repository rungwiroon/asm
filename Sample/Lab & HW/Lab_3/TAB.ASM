TAB PROC
        PUSH  AX
        PUSH  BX
        PUSH  CX
        PUSH  DX
        PUSH  SI
STAR:
        CMP   AX,0AH
        JB    TAB5
        CMP   AX,64H
        JB    TAB4
        CMP   AX,3E8H
        JB    TAB3
        CMP   AX,2710H
        JB    TAB2
        CMP   AX,8000H
        JB    TAB1
        CMP   AX,0D8EFH
        JB    TAB0
        CMP   AX,0FC17H
        JB    TAB1
        CMP   AX,0FF98H
        JB    TAB2
        CMP   AX,0FFF7H
        JB    TAB3
        JMP   TAB4
TAB5:
        MOV   CX,5
        JMP   DOTAB
TAB4:
        MOV   CX,4
        JMP   DOTAB
TAB3:
        MOV   CX,3
        JMP   DOTAB
TAB2:
        MOV   CX,2
        JMP   DOTAB
TAB1:
        MOV   CX,1
        JMP   DOTAB
TAB0:
        MOV   CX,0
        JMP   EX
DOTAB:
        MOV   AH,2
        MOV   DL,' '
DO:        
        INT   21H
        LOOP  DO
EX:

END_TAB:
        POP   SI
        POP   DX
        POP   CX
        POP   BX
        POP   AX
        RET
TAB  ENDP



