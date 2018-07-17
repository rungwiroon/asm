TITLE PGM :THANWA 0086
.MODEL SMALL
.CODE
        ORG 100H
START:
        JMP  MAIN
        MSG1 DB 0AH,0DH,'ENTER THREE INITIALS : $'
        CHA1 DB ?
        CHA2 DB ?
        CHA3 DB ?

MAIN PROC

;OUTPUT MESSAGE
        LEA DX,MSG1     ;GET MESSAGE
        MOV AH,9        ;DISPLAY STRING FUNCTION
        INT 21H         ;DISPLAY MESSAGE

;GET INITIALS
    SCANCHA1:
        MOV AH,1
        INT 21H
        CMP AL,41H      ;CHECK INITIALS
        JB  CLER1
        CMP AL,7AH      ;CHECK INITIALS
        JA  CLER1
        MOV CHA1,AL

    SCANCHA2:
        MOV AH,1
        INT 21H
        CMP AL,41H      ;CHECK INITIALS
        JB  CLER2
        CMP AL,7AH      ;CHECK INITIALS
        JA  CLER2
        MOV CHA2,AL

    SCANCHA3:
        MOV AH,1
        INT 21H
        CMP AL,41H      ;CHECK INITIALS
        JB  CLER3
        CMP AL,7AH      ;CHECK INITIALS
        JA  CLER3
        MOV CHA3,AL

;DISPLAY
        MOV AH,2
        MOV DL,0AH
        INT 21H
        MOV DL,0DH
        INT 21H
        MOV DL,CHA1
        INT 21H
        MOV DL,0AH
        INT 21H
        MOV DL,0DH
        INT 21H
        MOV DL,CHA2
        INT 21H
        MOV DL,0AH
        INT 21H
        MOV DL,0DH
        INT 21H
        MOV DL,CHA3
        INT 21H

        JMP EXIT        ;DOS EXIT

   CLER1:
        MOV DL,8H
        MOV AH,2
        INT 21H
        JMP SCANCHA1
   CLER2:
        MOV DL,8H
        MOV AH,2
        INT 21H
        JMP SCANCHA2
   CLER3:
        MOV DL,8H
        MOV AH,2
        INT 21H
        JMP SCANCHA3

   EXIT:
        MOV AH,4CH
        INT 21H          ;DOS EXIT

MAIN  ENDP
      END START
