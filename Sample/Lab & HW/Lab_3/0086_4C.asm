TITLE PGM:
.MODEL SMALL
.CODE
     ORG 100H
START:
     JMP   MAIN
     SCORES  DW  -20876,-5462,  14,7287,   0,   528,   79, 4732,  -55,   19
             DW    3845, 3284,-866,2087,  -9,    25,  325,  141,32767,-2525
             DW     612,  850,  99,  -1,-746,-32768,  999,  456,  789,   20
             DW      65,  543,-175, 206,2498,  -777,-1982,20225,19984,-4325
             DW      66, -323, 104,   5,  11,  2546,-2003,  449,   50, 2129
     NUM     DW  ?           
     N@N     DB    2CH,'$'
     LN      DB   0AH,0DH,'$'
     MSG1    DB   'ALL NUMBER IS',0AH,0DH,'$'
     MSG2    DB   'ODD NUMBER IS',0AH,0DH,'$'
     MSG3    DB   'SOURCE ODD NUMBER',0AH,0DH,'$'

MAIN PROC
        
        LEA  DX,MSG1
        MOV  AH,9H              ;DISPLAY MESSAGE
        INT  21H
        
   DOWORK1:
        MOV  AX,SCORES+[BX]
        CALL OUTDEC
        LEA  DX,N@N
        MOV  AH,9H              ;DISPLAY MESSAGE
        INT  21H

        CMP  BX,62H             ;CHACK NUMBER LAST
        JAE  DOWORK2
        ADD  BX,2               ;NEXT NUMBER
        JMP  DOWORK1

   DOWORK2:
        LEA  DX,LN
        MOV  AH,9H              ;DISPLAY MESSAGE
        INT  21H
        LEA  DX,MSG2
        MOV  AH,9H              ;DISPLAY MESSAGE
        INT  21H

        XOR  BX,BX

   DOWORK2_1:
        MOV  AX,SCORES+[BX]
        MOV  NUM,AX
        SHR  AX,1
        JNC  NUM_IS_EVEN        ;CHECK EVEN NUMBER
        MOV  AX,NUM

   NUM_IS_ODD:
        CALL OUTDEC
        LEA  DX,N@N
        MOV  AH,9H              ;DISPLAY MESSAGE
        INT  21H

   NUM_IS_EVEN:
        CMP  BX,62H             ;CHACK NUMBER LAST
        JAE  DOWORK3
        ADD  BX,2               ;NEXT NUMBER
        JMP  DOWORK2_1
                                
   DOWORK3:
        LEA  DX,LN
        MOV  AH,9H              ;DISPLAY MESSAGE
        INT  21H
        LEA  DX,MSG3
        MOV  AH,9H              ;DISPLAY MESSAGE
        INT  21H

        LEA  SI,SCORES
        MOV  BX,50
        CALL SORT
        
        XOR  BX,BX              ;CLEAR BX
        XOR  SI,SI
        
   DOWORK3_1:
        MOV  AX,SCORES[BX+SI]
        MOV  NUM,AX
        SHR  AX,1
        JNC  @NUM_IS_EVEN        ;CHECK EVEN NUMBER
        MOV  AX,NUM

   @NUM_IS_ODD:
        CALL OUTDEC
        LEA  DX,N@N
        MOV  AH,9H              ;DISPLAY MESSAGE
        INT  21H

   @NUM_IS_EVEN:
        CMP  BX,62H             ;CHACK NUMBER LAST
        JA   EXIT
        ADD  BX,2               ;NEXT NUMBER
        JMP  DOWORK3_1
   EXIT:
        MOV  AH,4CH             ;EXIT DOS
        INT  21H

MAIN  ENDP
INCLUDE A:\OUTDEC.ASM
INCLUDE A:\SORT.ASM
      END  START



