	       PAGE    ,132
	       TITLE   CALC
CGROUP	       GROUP   CODESEG
CODESEG        SEGMENT PARA PUBLIC 'CODE'
	       ASSUME  CS:CGROUP,DS:CGROUP,ES:CGROUP
	       PUBLIC  CALC

	       ORG     100H

CALC	       PROC    FAR
	       JMP     START

;---------------------------------------------------------------------;
;								      ;
;			     DATA AREA				      ;
;								      ;
;---------------------------------------------------------------------;

	       DB      'INTERRUPT NUMBER ='
INT_NUMBER     DB      61h

SCREEN_HANDLE  DW      0001h

MESSAGE        DB      'PEMATH is not resident',13,10
MESSAGE_LEN    EQU     $-MESSAGE

TAG	       DB      'PEMATH'
TAG_LEN        EQU     $-TAG

;---------------------------------------------------------------------;
;								      ;
;			     CODE AREA				      ;
;								      ;
;---------------------------------------------------------------------;

START:
;---------------------------------------------------------------------;
;    TEST FOR PRESENCE OF CALCULATOR				      ;
;---------------------------------------------------------------------;
	       SUB     AX,AX
	       MOV     ES,AX
	       SUB     BH,BH
	       MOV     BL,INT_NUMBER
	       SHL     BX,1
	       SHL     BX,1
	       MOV     DI,ES:[BX]
	       MOV     ES,ES:[BX+2]
	       ADD     DI,4
	       LEA     SI,TAG
	       MOV     CX,TAG_LEN
	 REPE  CMPSB
	       JE      CALL_CALC
	       MOV     BX,SCREEN_HANDLE
	       MOV     CX,MESSAGE_LEN
	       LEA     DX,MESSAGE
	       MOV     AH,40h
	       INT     21h
	       JMP     SHORT CALC_EXIT
;---------------------------------------------------------------------;
;    CALL CALCULATOR						      ;
;---------------------------------------------------------------------;
CALL_CALC:
	       MOV     AL,INT_NUMBER
	       MOV     BYTE PTR INT_CODE,AL
	       DB      0CDh	  ; INT
INT_CODE:
	       DB      00h
	       NOP
	       NOP

CALC_EXIT:
	       INT     20h

CALC	       ENDP

CODESEG        ENDS
	       END     CALC
