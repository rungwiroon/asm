	PAGE   60,132
;  CLR.ASM   05/29/84
;  Subroutine called by a basic program to scroll a window.
;
;
DGROUP	GROUP	DATASEG
DATASEG SEGMENT PARA PUBLIC 'DATA'
FUNCT	DW	0		;function 1=6,0=7
FG_COLR DW	0		;forground color
BG_COLR DW	0		;backround color
LINES	DW	0		;number of lines to scroll or 0 for clear
ULROW	DW	0		;upper left row
ULCOL	DW	0		;upper left column
LRROW	DW	0		;lower right row
LRCOL	DW	0		;lower left column
ATTRIB	DB	0		;temp hold for attribute byte
CALNU	DB	0		;temp hold for call function 6 or 7
DATASEG ENDS
;
CSEG	SEGMENT 'CODE'
	ASSUME	CS:CSEG
	PUBLIC CLR
CLR	PROC	FAR
	PUSH	BP		;BP unknown (don't care)
	MOV	BP,SP		;set base for parm list
	PUSH	DS		;DS -> basic work area
	PUSH	ES		;ES -> basic work area
	MOV	AX,DATASEG	;establish data addressability
	MOV	DS,AX		;now DS -> my data
	ASSUME	DS:DATASEG
;
;
	MOV	SI,SS:[BP+6]   ;get addr of parameter
	MOV	AX,ES:[SI]	;get value of parm
	MOV	FUNCT,AX
	MOV	SI,SS:[BP+8]   ;get addr of parameter
	MOV	AX,ES:[SI]	;get value of parm
	MOV	BG_COLR,AX
	MOV	SI,SS:[BP+10]	;get addr of parameter
	MOV	AX,ES:[SI]	;get value of parm
	MOV	FG_COLR,AX
	MOV	SI,SS:[BP+12]	;get addr of parameter
	MOV	AX,ES:[SI]	;get value of parm
	MOV	LINES,AX
	MOV	SI,SS:[BP+14]	;get addr of parameter
	MOV	AX,ES:[SI]	;get value of parm
	MOV	ULROW,AX
	MOV	SI,SS:[BP+16]	;get addr of parameter
	MOV	AX,ES:[SI]	;get value of parm
	MOV	ULCOL,AX
	MOV	SI,SS:[BP+18]	 ;get addr of parameter
	MOV	AX,ES:[SI]	;get value of parm
	MOV	LRROW,AX
	MOV	SI,SS:[BP+20]	 ;get addr of parameter
	MOV	AX,ES:[SI]	;get value of parm
	MOV	LRCOL,AX
;
	MOV	AX,1
	SUB	LRROW,AX	;convert 1-80 cols
	SUB	LRCOL,AX	; and 1-25 rows into
	SUB	ULROW,AX	; 0-79 cols and
	SUB	ULCOL,AX	; 0-24 rows
;
;  change forground & backround colors into single attribute byte
;
	MOV	BX,FG_COLR	;move foreground color to bx
	MOV	AL,BL		;move lower byte to al
	MOV	BX,BG_COLR	;move backround color to bx
	MOV	AH,BL		;move lower byte to ah
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

;
;   convert 1 and 0 to 6 and 7 for routine call
;
	MOV	BX,FUNCT	;move function into bx
	CMP	BL,0		;compare to one
	JG	F6		;if 1 then function is 6
	MOV	AH,7H		;set function 7
	JMP	OUT1		;jump around
F6:	MOV	AH,6H		;set function 6
OUT1:	MOV	CALNU,AH	;move it to storage
;
;
;  set up for bios rom call 10 function 6 (scroll up )
;
	PUSH	BX
	MOV	BX,LINES	;set # of lines to scroll or 0 to clear
	MOV	AL,BL		;put in pass register
	MOV	BX,ULROW	;set upper left row of block 0-24
	MOV	CH,BL		;put in pass register
	MOV	BX,ULCOL	;set upper left column of block 0-79
	MOV	CL,BL		;put in pass register
	MOV	BX,LRROW	;set lower right row of block 0-24
	MOV	DH,BL		;put in pass register
	MOV	BX,LRCOL	;set lower right column of block 0-79
	MOV	DL,BL		;put in pass register
	MOV	BL,CALNU	;set call number 6 to scroll up 7 down
	MOV	AH,BL		;put in pass register
	MOV	BL,ATTRIB	;set color attribute byte
	MOV	BH,BL		;put in pass register
	INT	10H		; make bios call
	POP	BX
;
FINISH: POP	ES
	POP	DS
	POP	BP
	RET	16		;return to basic
CLR	ENDP
CSEG	ENDS
	END
