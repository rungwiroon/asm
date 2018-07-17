;/////////////////////////////////////////////////////////////////
;/////////////////////////////////////////////////////////////////
TO_ROW	PROC

	PUSH_R			;PUSH AX,BX,CX,DX

	MOV	ROW,1
	MOV	COL,1

SEEK_COL :
	
	MOV	BL,ROW
	MOV	BH,COL

	SUB	BH,1		

	SUB	BL,1		
	MOV	AL,8		
	MUL	BL		
	
	XOR	AH,AH
	ADD	AL,BH		;TEMP = 8(ROW-1)+(COL-1) ,AL is TEMP
	
	CMP	POSITION,AL
	JE	SUCCESS
	INC	COL

	CMP	COL,8
	JLE	SEEK_COL
	INC	ROW
	MOV	COL,1
	JMP	SEEK_COL

SUCCESS :

	POP_R			;POP	DX,CX,BX,AX

	RET	;return row,col
TO_ROW	ENDP
;/////////////////////////////////////////////////////////////////
;/////////////////////////////////////////////////////////////////
TO_POS	PROC

	PUSH_R			;PUSH AX,BX,CX,DX
	MOV	CL,TEMP_ROW
	MOV	CH,TEMP_COL

	SUB	TEMP_COL,1

	SUB	TEMP_ROW,1
	MOV	AL,8
	MUL	TEMP_ROW	;8(ROW-1)
	
	ADD	AL,TEMP_COL	;POSITION = 8(ROW-1)+(COL-1) AL is POSITION
	MOV	POSITION,AL

	MOV	TEMP_ROW,CL
	MOV	TEMP_COL,CH

	POP_R			;POP	DX,CX,BX,AX

	RET	;return position
TO_POS	ENDP
;/////////////////////////////////////////////////////////////////
;/////////////////////////////////////////////////////////////////
TO_PIXEL	PROC	;require position

	PUSH_R			;PUSH AX,BX,CX,DX

	CALL	TO_ROW		;return row,col
	MOV	DH,ROW
	MOV	DL,COL

;col to x_pixel
	DEC	DL
	MOV	AL,22
	MUL	DL
	
	XOR	AH,AH
	ADD	AL,73

	MOV	X_PIXEL,AX
	

;row to y_pixel

	DEC	DH
	MOV	AL,18
	MUL	DH
	
	XOR	AH,AH
	ADD	AL,29

	MOV	Y_PIXEL,AX

	POP_R			;POP DX,CX,BX,AX

	RET
TO_PIXEL	ENDP
;/////////////////////////////////////////////////////////////////
;/////////////////////////////////////////////////////////////////