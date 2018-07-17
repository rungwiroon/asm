;===================================================
;GET NUMBER FROM ARRAY TO MAP_VAL
;MAP BY DEFINE ROW AND COLUMN
;	AL = ARRAY ROW
;	AH = ARRAY COL
;===================================================
GET_ARRAY	PROC
	PUSH	BX
	
	CALL	CAL_ARRAY	;CALCULATE ARRAY OFFSET
	
	MOV	AL,[SI]		;MOVE DATA FROM POINTER SI
	MOV	ARY_VAL,AL	;SAVE TO ARY_VAL

	POP	BX
	RET
	
GET_ARRAY	ENDP

;===================================================
;SET NUMBER TO ARRAY 
;MAP BY DEFINE ROW AND COLUMN
;	AL = ARRAY ROW
;	AH = ARRAY COL
;	BL = VALUE
;===================================================
SET_ARRAY	PROC
	MOV	ARY_VAL,BL
	
	CALL	CAL_ARRAY	;CALCULATE ARRAY OFFSET
	
	MOV	AL,ARY_VAL
	MOV	[SI],AL
	
	RET
SET_ARRAY	ENDP

;===========================================================
;CALCULATE ARRAY OFFSET
;===========================================================
CAL_ARRAY	PROC
;CALCULATE ARRAY OFFSET
	MOVZX	BX,AH		;SET COLUMN OFFSET				
	
	MOV	AH,COL_SIZE	;SET NUMBER OF COLUMN IN ROW 
	MUL	AH		;MULTIPLY WITH ROW
	ADD	BX,AX		;ADD ROW OFFSET
	ADD	SI,BX		;ADD ARRAY OFFSET TO SI

	RET
CAL_ARRAY	ENDP