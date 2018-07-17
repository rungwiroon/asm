TITLE :
	PUBLIC	EXIT_TO_DOS
.MODEL	SMALL
.DATA
.CODE
EXIT_TO_DOS	PROC	NEAR

	MOV     AX,0003H		;exit graphic mode
        INT     10H

        MOV     AH,4CH
        INT     21H

EXIT_TO_DOS	ENDP	

	END