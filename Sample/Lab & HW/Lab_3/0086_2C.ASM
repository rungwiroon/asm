TITLE PGM:THANWA 0086
.MODEL SMALL
.STACK 100H
.DATA
        MSG1 DB 0AH,0DH,'  ENTER A HEX DIGIT: $'
        MSG2 DB 0AH,0DH,'  IN DECIMAL IT IS 1$'
        NUM  DB ?
.CODE
        MAIN PROC

;INITIALIZE DS

        MOV AX,@DATA
        MOV DS,AX       ;INTIAILIZE DS

;DISPLAY MESSAGE
        LEA DX,MSG1     ;GET MESSAGE
        MOV AH,9        ;DISPLAY STRING FUNCTION
        INT 21H         ;DISPLAY MESSAGE

;GET HEX(A-F)
    SCANHEX:
        MOV AH,1
        INT 21H
        CMP AL,61H      ;CHECK HEX <A
        JB  CLER       
        CMP AL,66H      ;CHECK HEX >F
        JA  CLER
        MOV NUM,AL
        SUB NUM,31H

;DISPLAY MESSAGE
        LEA DX,MSG2     ;GET MESSAGE
        MOV AH,9        ;DISPLAY STRING FUNCTION
        INT 21H         ;DISPLAY MESSAGE
        MOV AH,2
        MOV DL,NUM      ;DISPLAY HEX
        INT 21H

        JMP EXIT

   CLER:
        MOV DL,8H
        MOV AH,2
        INT 21H
        JMP SCANHEX

     EXIT:
        MOV AH,4CH
        INT 21H
MAIN ENDP
        END MAIN
