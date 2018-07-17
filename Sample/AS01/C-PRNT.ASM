      PAGE   60,132
;  prnt.ASM   06/25/84 update 10/16/84 sas
;  Subroutine called by a basic program to print a string .
;
; ************** THIS IS THE CBASIC VERSION OF PRNT ******************
;
	TITLE	PRNT
	NAME	PRNT
CGROUP	GROUP	CODESEG
;
CODESEG SEGMENT PARA PUBLIC 'CODE'
	ASSUME	CS:CGROUP,DS:CGROUP
	PUBLIC	PRNT
;
COLOR	EQU	0B800H		;seg address of color adaptor memory
MONO	EQU	0B000H		;seg address of color adaptor memory
CRTCA	EQU	3D4h		;port address of 6845 crt controller addr reg
CRTCD	EQU	3D5h		;port address of 6845 crt controller data reg
CRTSTAT EQU	03DAh		;crt status port address
VSYNC	EQU	08h		;crt vertical retrace status bit map
PORTB	EQU	61h		;I/O Port B
MAG_NUM EQU	10110110b	;special number for port B initialize
TIME_2A EQU	43h		;timer 2
TIME_2B EQU	42h		;timer 2
TONE_CH EQU	1200d		;frequency of tone to use
;
FUNCT	DB	?		;function number
FG_COLR DB	?		;forground color
BG_COLR DB	?		;backround color
T_FORG	DW	?		;forground color of field on entry
T_BACK	DW	?		;backround color of field on entry
ROW	DB	?		;upper left row
COL	DB	?		;upper left column
LENG	DW	?		;length of string
STRG_AD DW	?		;address of string in DS
STRING	DW	256 DUP(00)
ATTRIB	DB	?		;attribute byte to use
REPTC	DW	1		;number of times to repeat each character
REPTWD	DB	1		;number of times to repeat each string
ER_DUR	DW	500d
;
PRNT	PROC	NEAR
	PUSH	BP		;BP unknown (don't care)
	MOV	BP,SP		;set base for parm list
	PUSH	DS		;DS -> basic work area
	PUSH	ES		;ES -> basic work area
;
; get the integer function number,string length,and string address from
; the call. the string address is in the extra segment.
;
	PUSH	BP
	MOV	AL,SS:[BP+4]	;get addr of parameter
	MOV	FUNCT,AL
	MOV	SI,SS:[BP+6]	;get addr of parameter
	MOV	AH,ES:[SI]	;get value of parm
	MOV	AL,ES:[SI+1]	;get value of parm
	MOV	LENG,AX
	ADD	SI,2		;get value of parm
	MOV	STRG_AD,SI
;
;   repeat function
;   check for character & string repitition -1 through -80 & -81 through -160
;
	MOV	REPTC,1 	;set char repeat to 1
	MOV	REPTWD,1	;set string repeat to 1
	CMP	FUNCT,0 	;are you requesting function repeat function
	JGE	TYP3		;if => 0 then check for function 1
	NEG	FUNCT		;convert the negitive function to positive
	CMP	FUNCT,80d	;are you requesting a repeat string function
	JG	WD_REP		;if yes the goto repeat string code
;
	XOR	AX,AX
	MOV	AL,FUNCT	;move the number of repeat character to
	MOV	REPTC,AX	;  the repeat character indicator
	JMP	WD_OUT		;jump out of block
;
WD_REP: SUB	FUNCT,80d	;subtract 80 from value
	MOV	AL,FUNCT	;set number of times to repeat the string
	MOV	REPTWD,AL	;    in repeat string variable
WD_OUT: MOV	FUNCT,3 	;force function to 3
;
;    function 3 send row,col and color/ full data print all prams specified.
;
TYP3:
	CMP	FUNCT,8
	JE	TYP8
R2A:	MOV	AL,SS:[BP+8]   ;get addr of parameter
	CMP	AL,0
	JE	R3
	SUB	AL,1
	MOV	ROW,AL
R3:	MOV	AX,SS:[BP+10]	;get addr of parameter
	CMP	AL,0
	JE	R4
	CMP	FUNCT,6
	JNE	R3A
	MOV	ER_DUR,AX
	JMP	R3B
R3A:	SUB	AL,1
	MOV	COL,AL
R3B:	CMP	FUNCT,7
	JE	TYP7
R4:	MOV	AL,SS:[BP+12]	;get addr of parameter
	MOV	FG_COLR,AL
	MOV	AL,SS:[BP+14]	;get addr of parameter
	MOV	BG_COLR,AL
	CALL	GET_ATB
	JMP	CAL_IT
;
;    for function 7 send address of colors
;
TYP7:	MOV	SI,SS:[BP+12]	;get addr of parameter
	MOV	AX,[SI]
	MOV	FG_COLR,AL
	MOV	SI,SS:[BP+14]	;get addr of parameter
	MOV	AX,[SI]
	MOV	BG_COLR,AL
	CALL	GET_ATB
;
;   set border color through bios call 10 function 11
;
TYP8:	MOV	AL,SS:[BP+14]	;get value of color
	MOV	BL,AL
	MOV	BH,0		;set palette to 0
	MOV	AH,11		;load function number
	INT	10h		;make bios call
	JMP	FINISH
;
;   set up address of string form basica and my data area string
;
CAL_IT:
	MOV	SI,[STRG_AD]	;set address of string in si
	LEA	DI,STRING	;load address of my data area string
	MOV	CX,LENG 	;set loop counter to length of string
	MOV	AH,ATTRIB	;set color attribute
;
;   check for null string
;
	MOV	AL,ES:[SI]	;move character to al
	CMP	AL,00		;is the character a null
	JE	FINISH		;if yes then return
	CMP	CX,0		;is the length 0
	JE	FINISH		;if yes then return
;
;   move string from basic data area to my data area
;
MOV_STR:MOV	AL,ES:[SI]	;move character from basic to al
	MOV	DS:[DI],AX	;move character/attribute to my data area
	INC	SI
	INC	DI
	INC	DI
	LOOP	MOV_STR
;
;
;  determine if color or mono adaptor, and set ES to adaptor's address
	CALL	VIDEO
;
;			  --- calls for function 5 ---
;
	CMP	FUNCT,5
	JNE	F6
	CALL	CENT		;find center of line
	CALL	GET_CR		;find offset into video buffer
	CALL	PT_STG		;print the string
	JMP	FINISH
;
;			  --- calls for function 6 ---
;
F6:	CMP	FUNCT,6
	JNE	FOUT
	CALL	CENT		;find center of line
	CALL	GET_CR		;find offset into video buffer
	CALL	PT_STG		;print the string
	CALL	ERR		;make tone at speaker
	MOV	CX,ER_DUR	;set duration of display
F6A:	PUSH	CX		;loop the print cycle for the number
	CALL	GET_CR		;   of cycles in the duration
	CALL	PT_STG
	POP	CX
	LOOP	F6A
;			blank the string
	LEA	DI,STRING	;get address of the string
	MOV	CX,LENG 	;set length
BLANK:	MOV	AX,DS:[DI]	;mov char/attrib to ax
	MOV	AL,32		;mov blank to cahr part
	MOV	DS:[DI],AX	;store it
	INC	DI
	INC	DI
	LOOP	BLANK
	CALL	GET_CR		;get offset into video buffer
	CALL	PT_STG		;clear the error message
	JMP	FINISH
;
;		---------- calls for all other functions ---------
;
FOUT:	CALL	GET_CR
	CMP	FUNCT,4
	JNE	C1
	CALL	RD_STG
	JMP	FINISH
;
C1:	CMP	FUNCT,7
	JNE	C2
	CALL	GET_CLR
;
C2:	CALL	PT_STG
;
;      get correct return numbers
;
FINISH: POP	BP
	CMP	FUNCT,0
	JE	RET12
;
;
	CMP	FUNCT,1
	JE	RET12
;
	CMP	FUNCT,2
	JE	RET12
;
	CMP	FUNCT,3
	JE	RET12
;
	CMP	FUNCT,4
	JE	RET8A
;
	CMP	FUNCT,5
	JE	RET12
;
	CMP	FUNCT,6
	JE	RET12
;
	CMP	FUNCT,7
	JE	RET12A
;
	CMP	FUNCT,8
	JE	RET12
;
;
;	       function 5 passing the string back to basic.
;
RET8A:	POP	ES		;get back basic es
	MOV	SI,[STRG_AD]	;get address of basic string
	LEA	DI,STRING	;get address of my string
	MOV	CX,LENG 	;get length of string
RESET:	MOV	AX,DS:[DI]	;move char of my string to ax
	MOV	ES:[SI],AX	;move ax to basic string
	INC	SI
	INC	DI
	LOOP	RESET
	POP	DS
	POP	BP
	RET	12		;return to basic
;
;
RET12:	POP	ES
	POP	DS
	POP	BP
	RET	12		;return to basic

RET12A:
	POP	ES
	MOV	AX,T_FORG	;get addr of parameter
	MOV	SI,SS:[BP+12]	;get addr of parameter
	MOV	ES:[SI],AX	;get value of parm
	MOV	AX,T_BACK	;get addr of parameter
	MOV	SI,SS:[BP+14]	;get addr of parameter
	MOV	ES:[SI],AX	;get value of parm
	POP	DS
	POP	BP
	RET	12		;return to basic
PRNT	ENDP
;
;--------------------------------------------------------------------
;    PRINT CHARACTER STRING AT ROW,COL WITH FG,BG COLORS
;
PT_STG	PROC	NEAR
	XOR	CX,CX
	MOV	CL,REPTWD	;set up loop counter for repeat word
NXT_WD: PUSH	CX		;save count
	MOV	CX,LENG 	;set up count for number of characters in string
	LEA	DI,STRING	;load address of my string
;
;    wait until vertical retrace
;
	MOV	DX,CRTSTAT
CRETRC: IN	AL,DX
	TEST	AL,VSYNC
	JZ	CRETRC
;
NXT_CHR:PUSH	CX		;save character count
	MOV	BX,DS:[DI]	;move character from string to bx
	MOV	CX,REPTC	;set up count for repeat character
REP_CHR:MOV	ES:[SI],BX	;move character to video buffer
	INC	SI
	INC	SI
	LOOP	REP_CHR 	;loop to repeat character
	INC	DI
	INC	DI
	POP	CX		;restore character count
	LOOP	NXT_CHR 	;loop for next character
	POP	CX		;restore count for repeat string
	LOOP	NXT_WD		;loop to repeat the string
	RET
PT_STG	ENDP
;---------------------------------------------------------------------
;---------------------------------------------------------------------
;    READ IN CHARACTERS FROM SCREEN
;
RD_STG	PROC	NEAR
	LEA	DI,STRING	;set address of string in si
	MOV	CX,LENG 	;set loop counter to length of string
;
RD_LIN:
	MOV	AX,ES:[SI]	;move character/attribute from video buffer to ax
	MOV	DS:[DI],AL	;move character to my data area
	INC	DI
	INC	SI
	INC	SI
	LOOP	RD_LIN		;loop to next character
	RET
RD_STG	ENDP
;---------------------------------------------------------------------
GET_ATB PROC	NEAR
	MOV	AL,FG_COLR	;move foreground color to bx
	MOV	AH,BG_COLR	;move backround color to bx
	CMP	AL,15		;check for color > 15 ie blinking
	JG	BLNK		;if > 15 then set blink bit
	AND	AL,15		;set normal fg color
	JMP	N_BLNK		;
BLNK:	OR	AL,128		;set blink bit 7
	AND	AL,143		;zero out bit 6,5,4 used for backround
N_BLNK: AND	AH,7		;zero out bit 7,6,5,4,3 used for forground
	MOV	CL,4		;4 bit shift count
	SHL	AH,CL		;shift right 3 bits to pos 6,5,4
	OR	AL,AH		;combine for & back to form attribute byte
	MOV	ATTRIB,AL	;move it to STORAGE
	RET
GET_ATB ENDP
;---------------------------------------------------------------------
;
;  compute starting offset into display buffer
;
GET_CR	PROC	NEAR
	XOR	AX,AX
	MOV	AL,ROW		;move starting row to al
	MOV	BX,160		;move number of character/row to bx
	MUL	BX		;multiply by 160
	XOR	CX,CX
	MOV	CL,COL		;move starting column number to cl
	ADD	AX,CX		;add (scol * 2) to get relative offset
	ADD	AX,CX
	MOV	SI,AX		;SI offsets VIDEO buffers
	RET
GET_CR	ENDP
;---------------------------------------------------------------------
;
;  determine if color or mono adaptor, and set ES to adaptor's address
;
VIDEO	PROC	NEAR
	PUSH	DS		;save DS -> my data
	MOV	AX,0		;set up data seg register ..
	MOV	DS,AX		;..to gain access to DOS info
	MOV	SI,410H 	;offset to color/mono byte
	MOV	AL,[SI] 	;fetch byte
	POP	DS		;restore DS -> my data
	AND	AL,48		;mask
	CMP	AL,48		;48=mono, 32=color
	JZ	SETMNO
	MOV	AX,COLOR	;add seg addr of page 0
	JMP	SETES
SETMNO: MOV	AX,MONO
SETES:	MOV	ES,AX		;now ES -> adaptor memory
	RET
VIDEO	ENDP
;---------------------------------------------------------------------
;   calculate column for centering a stripped string
;
CENT	PROC	NEAR
;
;    find number of leading blanks
;
	XOR	CX,CX		;zero out CX
	LEA	DI,STRING	;load address of string
C_R0:	CMP	CX,LENG 	;are you at end of string
	JE	C_R2		;if yes then out
	MOV	AX,DS:[DI]	;load character to ax
	CMP	AL,20H		;is it a blank
	JNE	C_R2		;if not a blank then out
	INC	CX		;index 1
	INC	DI		;index 2
	INC	DI
	JMP	C_R0		;loop it
;
;    find number of trailing blanks
;
C_R2:	PUSH	CX		;save number of blanks on stack
	LEA	DI,STRING	;load address of string
	ADD	DI,LENG 	;add length to address
	ADD	DI,LENG 	;add length to address
	SUB	DI,2		;index back 2
	XOR	CX,CX		;zero CX
C_R3:	MOV	AX,DS:[DI]	;move character to AX
	CMP	AL,20H		;is it a blank
	JNE	C_R4		;if not then out
	INC	CX		;add 1 ti cx
	DEC	DI		;move back one character
	DEC	DI
	JMP	C_R3		;loop it
;
;    calculate column position for centering
;    column = ((80-(length-trail-lead))/2)-lead
;
C_R4:	MOV	AX,LENG 	;load length
	SUB	AX,CX		;subtract number of trailing blanks
	POP	CX		;get number of leading blanks
	SUB	AX,CX		;subtract number of leading blanks
	MOV	BX,80		;load screen width
	SUB	BX,AX		;subtract out adjusted length
	SAR	BX,1		;divide by 2
	SUB	BX,CX		;subtract number of leading blanks
	MOV	COL,BL		;set column
	RET
CENT	ENDP
;-----------------------------------------------------------------------
;	    error tone for speaker
ERR	PROC	NEAR
;     tone control of speaker
	MOV	AL,MAG_NUM	;put magic number
	OUT	TIME_2A,AL	;	into timer2
;
;     the constant put in ax changes the pitch
;
TONE:	MOV	AX,TONE_CH	;move 1/pitch into ax
	OUT	TIME_2B,AL	;LSB into timer2
	MOV	AL,AH		;MSB to AL then
	OUT	TIME_2B,AL	;  to timer2
;
	IN	AL,PORTB	;read port B into AL
	MOV	AH,AL		;save original in AH
	OR	AL,3		;turn on bits 0 and 1
	OUT	PORTB,AL	;turn on speaker
;
	SUB	CX,CX		;set up loop count
WAIT:	LOOP	WAIT		;delay
;
	MOV	AL,AH
	OUT	PORTB,AL	;turn off speaker
 ;
	RET

ERR	ENDP
;---------------------------------------------------------------------
;---------------------------------------------------------------------
GET_CLR PROC	NEAR
	LEA	DI,STRING
	MOV	AX,ES:[SI]	;get attribute of fist character in field
	XOR	BX,BX		;blank BX registor
	MOV	BL,AH		;move attribute to the BL register
	AND	BL,15		;mask out the backround and blink bit
	CMP	AH,128		;is this a blink character
	JGE	N_BLK		;if no then go to no blink
	ADD	BX,16		;add 16 to forground color
N_BLK:	MOV	T_FORG,BX	;move completed forground color to temp data
	MOV	BL,AH		;move attribute to bl
	AND	BL,112		;mask out forground and blink bit
	MOV	CL,4		;4 bit shift count
	SHR	BL,CL		;shift right 3 bits to pos 2,1,0
	MOV	T_BACK,BX	;move backround to temp data
	RET
GET_CLR ENDP
;---------------------------------------------------------------------
CODESEG ENDS
	END
