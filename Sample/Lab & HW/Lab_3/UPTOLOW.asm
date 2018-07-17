 TITLE PGM4_3: CASE CONVERSION PROGRAM
 .MODEL   SMALL
 .STACK   100H
 .DATA
     CR   EQU  0DH
     LF   EQU  0AH
 MSG1   DB      'ENTER A UPPER CASE LETTER: $'
 MSG2   DB      0DH,0AH,'IN LOWER CASE IT IS: '
 CHAR   DB      ?,'$'
 .CODE  
 MAIN    PROC
 ;initialize DS
     MOV  AX,@DATA     ;get data segment 
     MOV  DS,AX        ;initialize DS
 ;print user prompt
     LEA  DX,MSG1      ;get first message               
     MOV  AH,9         ;display string function
     INT  21H          ;display first message
 ;input a character and convert to upper case
SCAN:
     MOV  AH,1         ;read character function
     INT  21H          ;read a small letter into AL
     CMP  AL,'A'
     JB   CLER
     CMP  AL,5AH
     JA   CLER
     OR   AL,20H
   
     MOV  CHAR,AL      ;and store it
 ;display on the next line
     LEA  DX, MSG2     ;get second message
     MOV  AH,9         ;display string function
     INT  21H          ;display message and upper case letter
     JMP  EXIT
CLER:
     MOV  DL,8H
     MOV  AH,2
     INT  21H
     JMP  SCAN

EXIT:
     MOV  AH,4CH
     INT  21H          ;DOS exit
 MAIN    ENDP
     END     MAIN


