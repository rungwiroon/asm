TITLE GAME :STANDARD MOUSE
PUBLIC RESETM,SHOWM,GETM
EXTRN X_TMP:WORD,Y_TMP:WORD
.MODEL SMALL
.CODE

RESETM  PROC

        PUSH AX

        MOV AX,00H
        INT 33H

        POP AX
        RET
RESETM  ENDP

SHOWM   PROC

        PUSH AX


        MOV AX,01H
        INT 33H

        POP AX
        RET
SHOWM   ENDP

GETM    PROC

        PUSH AX
     
        MOV AX,04H
        MOV CX,X_TMP
        MOV DX,Y_TMP
        INT 33H

        POP AX
        RET
GETM    ENDP

        END
