TIMER	PROC
	MOV AH,2
	MOV DH,0
	MOV DL,0
	MOV BH,0
	INT 10H
	
	LEA	BX,TIME_BUF	;BX points to TIME_BUF
	CALL	GET_TIME	;put current time in TIME_BUF
	MOV	AH,09H		;display time	
	LEA	DX,MSG	;DX points  to TIME_BUF
  	INT	21H
	;LEA	DX,TIME_BUF	;DX points  to TIME_BUF
  	;INT	21H

	RET
TIMER	ENDP


GET_TIME	PROC
				;get time of day and store ASCII digits in time buffer
				;input:  BX = address of time buffer
	MOV	AH,2CH		;gettime
	INT	21H		;CH = hr, CL =  min, DH = sec
				;convert hours into ASCII and store
	MOV	AL,CH		;hour
	CALL	CONVERT		;convert to ASCII
	MOV	[BX],AX		;store
				;convert minutes into ASCII and store
	MOV	AL,CL		;minute
	CALL	CONVERT		;convert to ASCII
	MOV	[BX+3],AX	;store
				;convert seconds into ASCII and store
	MOV	AL,DH		;second
	CALL	CONVERT		;convert to ASCII
	MOV	[BX+6],AX	;store
	RET
GET_TIME	ENDP

CONVERT	PROC
				;converts byte number (0-59) into ASCII digits
				;input: AL = number
				;output: AX = ASCII digits, AL = high digit, AH = low digit
	MOV	AH,0		;clear AH
	MOV	DL,10		;divide AX by 10
	DIV	DL		;AH has remainder, AL has quotient
	OR	AX,3030H	;convert to ASCII, AH has low digit
	RET			;AL has high digit
CONVERT	ENDP
