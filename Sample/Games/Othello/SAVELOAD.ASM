

ClearUserName	MACRO
	LOCAL	LoopClearUsername
;Clear user name in INPUT_NAME
	PUSH	AX
	PUSH	CX
	PUSH	SI
	LEA	SI,INPUT_NAME
	MOV	CX,10

LoopClearUsername:
	MOV	AL,' '			;Fill ' ' in every bytes of INPUT_NAME
	MOV	[SI],AL
	ADD	SI,1			;Move to next char
	LOOP	LoopClearUsername
	POP	SI
	POP	CX
	POP	AX
ENDM

;///////////////////////////////////////////////
;///////////////////////////////////////////////
WriteToFile	PROC
;Write name and score to file
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI

	MOV	AH,3CH			;Re-write file fnc.
	LEA	DX,FILENAME		;Try to write to FILENAME
	MOV	CL,0
	INT	21H
	MOV	HANDLE,AX
	JNC	SkipErrWriteToFile
	
	SkipErrWriteToFile:
	LEA	SI,FILEDATA_NAME
	LEA	DI,FILEDATA_SCORE
	MOV	CX,10
	LoopWriteArrayToFile:
	PUSH	CX

	MOV	AH,40H
	MOV	BX,HANDLE
	MOV	CX,10			;Write 10 bytes
	MOV	DX,SI			;Write name at [SI] to file
	INT	21H

	MOV	AH,40H
	MOV	BX,HANDLE
	MOV	CX,2			;Write 2 bytes
	MOV	DX,DI			;Write score at [DI] to file
	INT	21H

	ADD	SI,10			;Move to next name
	ADD	DI,2			;Move to next score
	POP	CX
	LOOP	LoopWriteArrayToFile

	MOV	AH,3EH			;Close file
	MOV	BX,HANDLE
	INT	21H

	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
WriteToFile	ENDP

ReadFromFile	PROC
;Load name and score from file
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI

	MOV	AH,3DH			;Open file fnc.
	LEA	DX,FILENAME		;Try to read FILENAME
	MOV	AL,0
	INT	21H
	MOV	HANDLE,AX
	JC	ExitReadFromFile	;If can read file, then jump to start reading
	
	LEA	SI,FILEDATA_NAME
	LEA	DI,FILEDATA_SCORE
	MOV	CX,10
	LoopReadFileToArray:
	PUSH	CX

	MOV	AH,3FH
	MOV	BX,HANDLE
	MOV	CX,10			;Read 10 bytes
	MOV	DX,SI			;Read name from file into [SI]
	INT	21H

	MOV	AH,3FH
	MOV	BX,HANDLE
	MOV	CX,2			;Read 2 bytes
	MOV	DX,DI			;Read score from file into [DI]
	INT	21H

	ADD	SI,10			;Move to next name
	ADD	DI,2			;Move to next score
	POP	CX
	LOOP	LoopReadFileToArray

	ExitReadFromFile:
	MOV	AH,3EH			;Close file
	MOV	BX,HANDLE
	INT	21H

	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
ReadFromFile	ENDP
;///////////////////////////////////////////////
;///////////////////////////////////////////////
SHOW_FILE	PROC	
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI
;************************************************************

	MOV	AH,3DH				;open file
	LEA	DX,FILENAME			;path name
	MOV	AL,2
	INT	21H
	MOV	HANDLE,AX
	JNC	FIND_RECORD
	
	GOTO_XY	   0,1	
	DISP_STR	'open file ERROR'

FIND_RECORD :

	MOV	AH,42H			;move file read write pointer
	MOV	AL,2
	MOV	BX,HANDLE
	XOR	CX,CX
	XOR	DX,DX
	INT	21H

;	MOV	BL,10+2
;	DIV	BL
;	XOR	AH,AH
;	MOV	FILE_ROUND,AX
MOV	FILE_ROUND,10
	
	LEA	SI,[BUFFER]
	MOV	HANDLE,BX
	MOV	AH,3FH			;read from file
	MOV	CX,(10*10)+(10*2)
	MOV	DX,SI			;READ NAME 10 BYTES AND SCORE 2 BYTES
	INT	21H
	
	MOV	AH,3EH			;CLOSE FILE
	INT	21H

;READ FILE TO ARRAY
	PUSH	FILE_ROUND
	PUSH	DI
	PUSH	SI
	LEA	SI,FILEDATA_NAME
	LEA	DI,FILEDATA_SCORE


	MOV	AH,3DH				;open file
	LEA	DX,FILENAME			;path name
	MOV	AL,2
	INT	21H
	MOV	HANDLE,AX

READ_FILE_TO_ARRAY :

	CMP	FILE_ROUND,0
	JLE	EXIT_READ_FILE_TO_ARRAY

	MOV	HANDLE,BX
	MOV	AH,3FH			;read from file
	MOV	CX,10			;number of byte
	MOV	DX,SI			;READ NAME 10 BYTES
	INT	21H

	MOV	BX,HANDLE
	MOV	AH,3FH			;read from file
	MOV	CX,2			;number of byte
	MOV	DX,DI			;READ SCORE 2 BYTES
	INT	21H

;UPDATE SI,DI,FILE_ROUND
	ADD	SI,10
	ADD	DI,2
	DEC	FILE_ROUND
	JMP	READ_FILE_TO_ARRAY

EXIT_READ_FILE_TO_ARRAY :

	POP	SI
	POP	DI
	POP	FILE_ROUND

	MOV	AH,3EH			;CLOSE FILE
	INT	21H

;************************************************************
	GOTO_XY	14,8
	DISP_STR 'NAME'

	GOTO_XY	26,8
	DISP_STR 'SCORE'

	MOV	CX,1
	LEA	SI,FILEDATA_NAME
	LEA	DI,FILEDATA_SCORE

	MOV	BL,10		;Y POSITION
	MOV	BH,11
ACCESS_FILEDATA:
	CMP	CX,FILE_ROUND
	JG	EXIT_ACCESS_FILEDATA
	MOV	AX,CX

	CMP	CX,11
	JE	EXIT_ACCESS_FILEDATA

	CMP	CX,10
	JNE	PRINT_RANK

	MOV	BH,10

PRINT_RANK :

	GOTO_XY	BH,BL		;BH = 11 (FOR RANK 1-9) BH = 10 (FOR RANK 10)
	CALL	OUTDEC
	DISP_STR '. '

	MOV	AH,2
	MOV	DL,[SI]
	INT	21H
	INC	SI

	MOV	DL,[SI]
	INT	21H
	INC	SI

	MOV	DL,[SI]
	INT	21H
	INC	SI

	MOV	DL,[SI]
	INT	21H
	INC	SI

	MOV	DL,[SI]
	INT	21H
	INC	SI

	MOV	DL,[SI]
	INT	21H
	INC	SI

	MOV	DL,[SI]
	INT	21H
	INC	SI

	MOV	DL,[SI]
	INT	21H
	INC	SI

	MOV	DL,[SI]
	INT	21H
	INC	SI

	MOV	DL,[SI]
	INT	21H
	INC	SI

	GOTO_XY 26,BL

	MOV	AX,[DI]
	CALL	OUTDEC
	ADD	DI,2
	INC	BL
	INC	CX
	JMP	ACCESS_FILEDATA
EXIT_ACCESS_FILEDATA:
	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
SHOW_FILE	ENDP
;///////////////////////////////////////////////
;///////////////////////////////////////////////
CopyData	MACRO	RepeatTime
	LOCAL	LoopCopyData
;Copy data from SI to DI
	PUSH	AX
	PUSH	CX
	PUSH	SI
	PUSH	DI

	MOV	CX,RepeatTime		;CX is the counter
	LoopCopyData:
	MOV	AL,[SI]			;Copy [SI]->[DI]
	MOV	[DI],AL
	ADD	SI,1			;Move SI to next data
	ADD	DI,1			;Move SI to next data
	LOOP	LoopCopyData

	POP	DI
	POP	SI
	POP	CX
	POP	AX
ENDM

InsertData	PROC
;Shift to make empty room for adding new data at InsertPos
;Input:	InsertPos = position to insert
;	INPUT_NAME
;	INPUT_SCORE
;Output: FILEDATA_NAME
;	 FILEDATA_SCORE
	LEA	SI,FILEDATA_NAME	;SI points to #10 of name
	ADD	SI,9*10
	LEA	DI,FILEDATA_SCORE	;DI points to #10 of score
	ADD	DI,9*2
	MOV	CX,10			;Repeat 10 times
	LoopMoveData:
	CMP	CX,InsertPos		;If this is the insert position
	JLE	StartReplaceData	;Then jump to replace data in this position
	SUB	SI,10			;Skip back to prior name
	SUB	DI,2			;Skip back to prior score
	PUSH	DI
	MOV	DI,SI			;Shift data to next name
	ADD	DI,10
	CopyData	10
	POP	DI
	MOV	AX,[DI]			;Shift data to next score
	MOV	[DI+2],AX
	LOOP	LoopMoveData

	StartReplaceData:
	PUSH	SI
	PUSH	DI
	MOV	DI,SI			;Replace name at SI
	LEA	SI,INPUT_NAME
	CopyData	10
	POP	DI
	POP	SI
	MOV	AX,INPUT_SCORE		;Replace score at DI
	MOV	[DI],AX

	RET
InsertData	ENDP

SortData	PROC
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	SI
	PUSH	DI

	LEA	DI,FILEDATA_SCORE
	ADD	DI,9*2			;DI points to #10 of score
	MOV	CX,10			;Repeat 10 times
	LoopFindInsertPos:		;Find the insert position
	MOV	AX,[DI]
	CMP	INPUT_SCORE,AX		;If INPUT_SCORE<=[DI] score
	JLE	DoInsertData		;Then insert data to this position
	SUB	DI,2			;Move to prior score
	LOOP	LoopFindInsertPos

	DoInsertData:
	ADD	CX,1			;Adjust CX from LOOP
	MOV	InsertPos,CX		;Save CX into InsertPos
	CALL	InsertData		;Insert data at InsertPos

	ExitSortData:
	POP	DI
	POP	SI
	POP	DX
	POP	CX
	POP	BX
	POP	AX
	RET
SortData	ENDP