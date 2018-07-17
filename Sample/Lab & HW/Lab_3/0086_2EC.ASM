TITLE PGM :THANWA 0086
.MODEL SMALL
.CODE
        ORG 100H
START:
        JMP  MAIN
        MSG1 DB 0AH,0DH,'***********$'
        MSG2 DB 0AH,0DH,'*         *$'
        MSG3 DB 0AH,0DH,'*   $'
        MSG4 DB '   *$'
        MSG5 DB '?$'
        CHA1 DB ?
        CHA2 DB ?
        CHA3 DB ?

MAIN PROC

;DISPLAYMESSAGE
        LEA DX,MSG5     ;GET MESSAGE
        MOV AH,9        ;DISPLAY STRING FUNCTION
        INT 21H         ;DISPLAY MESSAGE

  SCAN1:
        MOV AH,1
        INT 21H
        MOV CHA1,AL

  SCAN2:
        MOV AH,1
        INT 21H
        MOV CHA2,AL

  SCAN3:
        MOV AH,1
        INT 21H
        MOV CHA3,AL

;DISPLAYMESSAGE
        LEA DX,MSG1     ;GET MESSAGE
        MOV AH,9        ;DISPLAY STRING FUNCTION
        INT 21H         ;DISPLAY MESSAGE
        LEA DX,MSG2     ;GET MESSAGE
        INT 21H         ;DISPLAY MESSAGE
        INT 21H         ;DISPLAY MESSAGE
        INT 21H         ;DISPLAY MESSAGE
        INT 21H         ;DISPLAY MESSAGE
        LEA DX,MSG3     ;GET MESSAGE
        INT 21H         ;DISPLAY MESSAGE
        
        MOV DL,CHA1
        MOV AH,2
        INT 21H

        MOV DL,CHA2
        INT 21H

        MOV DL,CHA3
        INT 21H

        LEA DX,MSG4     ;GET MESSAGE
        MOV AH,9        ;DISPLAY STRING FUNCTION
        INT 21H         ;DISPLAY MESSAGE
        LEA DX,MSG2     ;GET MESSAGE
        INT 21H         ;DISPLAY MESSAGE
        INT 21H         ;DISPLAY MESSAGE
        INT 21H         ;DISPLAY MESSAGE
        INT 21H         ;DISPLAY MESSAGE
        LEA DX,MSG1     ;GET MESSAGE
        INT 21H         ;DISPLAY MESSAGE
EXIT:                
	MOV AH,4CH      ;DOS EXIT
        INT 21H
MAIN ENDP
        END START
