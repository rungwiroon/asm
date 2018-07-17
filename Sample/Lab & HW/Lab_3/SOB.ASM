TITLE PGM: THANWA MAITRI
.MODEL SMALL
.CODE
        ORG 100H
START:
        JMP MAIN
        LN     DB   0AH,0DH,'$'
        MSG1   DB   'PUT NUMBER ISBN :','$'
        MSG2   DB   '-'
        NUM1   DB   ?
        NUM2   DB   ?
        NUM3   DB   ?
        NUM4   DB   ?
        NUM5   DB   ?
        NUM6   DB   ?
        NUM7   DB   ?
        NUM8   DB   ?
        NUM9   DB   ?
        NUM10  DB   ?
        WEIGHT1  DB   ?
        WEIGHT2  DB   ?
        WEIGHT3  DB   ?
        WEIGHT4  DB   ?
        WEIGHT5  DB   ?
        WEIGHT6  DB   ?
        WEIGHT7  DB   ?
        WEIGHT8  DB   ?
        WEIGHT9  DB   ?
        WEIGHT10 DB   ?


MAIN PROC
       LEA   DX,LN
       MOV   AH,9               ;NEW LINE
       INT   21H

       LEA   DX,MSG1
       MOV   AH,9               ;DISPLAY MESSAGE
       INT   21H
SCAN1:
       MOV   AH,1
       INT   21H                ;INPUT NUM1

       CMP   AL,30H
       JB    CLER1
       CMP   AL,39H             ;CHECK NUM (0-9)
       JA    CLER1

       SUB   AL,30H
       MOV   NUM1,AL            ;SAVE NUM1
       ;MOV   BL,10H
       ;MUL   BL                 ;MUL WEIGHT
       ;MOV   WEIGHT1,AL         ;SAVE WEIGHT

       LEA   DX,MSG2
       MOV   AH,9               ;DISPLAY MESSAGE
       INT   21H
       JMP   CON1

CLER1:
        MOV  DL,8H
        MOV  AH,2
        INT  21H
        JMP  SCAN1

CON1:
        MOV   AL,NUM1
        ADD   AL,30H
        MOV   DL,AL
        MOV   AH,2
        INT   21H
        ;CALL  OUTDEC
        LEA   DX,MSG2
        MOV   AH,9               ;DISPLAY MESSAGE
        INT   21H
        ;XOR   AX,AX
        ;MOV   AL,WEIGHT1
        ;CALL  OUTDEC

EXIT:
       MOV   AH,4CH
       INT   21H

MAIN ENDP
INCLUDE  A:OUTDEC.ASM
       END START
