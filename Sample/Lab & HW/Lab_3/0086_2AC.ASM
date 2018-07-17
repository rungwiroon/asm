TITLE PGM  :THANWA 0086
.MODEL SMALL
.CODE
        ORG 100H
START:
        JMP  MAIN
        MSG1 DB 0AH,0DH,'?  $'
        MSG2 DB 0AH,0DH,'THE SUM OF  $'
        MSG3 DB '  AND  $'
        MSG4 DB '  IS  $'
        NUM1 DB ?
        NUM2 DB ?
        SUM  DB ?


MAIN PROC

;PRINT MESSAGE
        LEA DX,MSG1     ;GET MESSAGE
        MOV AH,9        ;DISPLAY STRING FUNCTION
        INT 21H         ;DISPLAY MESSAGE

    SCANNUM1:
        MOV AH,1        ;READ DIGIT NUMBER
        INT 21H         
        CMP AL,30H      ;CHECK NUM < 0
        JB CLER1
        CMP AL,39H      ;CHECK NUM ) 9
        JA CLER1
        MOV NUM1,AL

;PRINT MESSAGE
        

    SCANNUM2:
        MOV AH,1        ;READ DIGIT NUMBER
        INT 21H         
        MOV NUM2,AL
        ADD AL,NUM1
        CMP AL,60H      ;CHECK NUM1+NUM2 < 0
        JB CLER2
        CMP AL,69H      ;CHECK NUM1+NUM2 ) 9
        JA CLER2
        MOV SUM,AL
                
        SUB SUM,30H

;PRINT MESSAGE
        LEA DX,MSG2     ;GET MESSAGE
        MOV AH,9        ;DISPLAY STRING FUNCTION
        INT 21H         ;DISPLAY MESSAGE
        MOV DL,NUM1
        MOV AH,2
        INT 21H
        LEA DX,MSG3     ;GET MESSAGE
        MOV AH,9        ;DISPLAY STRING FUNCTION
        INT 21H         ;DISPLAY MESSAGE
        MOV DL,NUM2
        MOV AH,2
        INT 21H
        LEA DX,MSG4     ;GET MESSAGE
        MOV AH,9        ;DISPLAY STRING FUNCTION
        INT 21H         ;DISPLAY MESSAGE
        MOV DL,SUM
        MOV AH,2
        INT 21H
        JMP EXIT
CLER1:
        MOV DL,8H
        MOV AH,2
        INT 21H
        JMP SCANNUM1

CLER2:
        MOV DL,8H
        MOV AH,2
        INT 21H
        JMP SCANNUM2

 EXIT:
        MOV AH,4CH
        INT 21H         ; DOS EXIT

MAIN    ENDP
        END START


