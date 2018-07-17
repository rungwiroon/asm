	PAGE   60,132
;  WINDO.ASM   03/05/84
;  Subroutine called by a C-basic program to paint a window.
;
	TITLE	WINDO
	NAME	WINDO
CGROUP	GROUP	CODESEG
;
CODESEG SEGMENT PARA PUBLIC 'CODE'
	ASSUME	CS:CGROUP,DS:CGROUP
	PUBLIC	WINDO
;
COLOR	EQU	0B800H		;seg address of color adaptor memory
MONO	EQU	0B000H		;seg address of color adaptor memory
CRTCA	EQU	3D4H		;port address of 6845 crt controller addr reg
CRTCD	EQU	3D5H		;port address of 6845 crt controller data reg
CRTSTAT EQU	03DAH		;crt status port address
VSYNC	EQU	08H		;crt vertical retrace status bit map
;
HBUF1	DW	1000H DUP(00H)	;hold area for display buffer
SCOL	DW	0		;starting column position
SROW	DW	0		;starting row position
COLS	DW	0		;number of columns
ROWS	DW	0		;number of rows
FOREGR	DW	0		;foreground attribute
BACKGR	DW	0		;background attribute
FUNCTN	DW	0		;function 0=open,1=close
PGNUM	DW	0		;page number to display
CCTR	DW	0		;column counter
RCTR	DW	0		;row counter
;
; **************************** WINDOW ROUTINE ************************
;
WINDO	PROC	NEAR
	PUSH	BP		;BP unknown (don't care)
	MOV	BP,SP		;set base for parm list
	PUSH	DS		;DS -> basic work area
	PUSH	ES		;ES -> basic work area
;
	MOV	AX,SS:[BP+18]	;get addr of parameter
;	MOV	AX,ES:[SI]	;get value of parm
	MOV	FUNCTN,AX
	MOV	AX,SS:[BP+16]	;get addr of parameter
;	MOV	AX,ES:[SI]	;get value of parm
	MOV	SCOL,AX
	MOV	AX,SS:[BP+14]	;get addr of parameter
;	MOV	AX,ES:[SI]	;get value of parm
	MOV	SROW,AX
	MOV	AX,SS:[BP+12]	;get addr of parameter
;	MOV	AX,ES:[SI]	;get value of parm
	MOV	COLS,AX
	MOV	AX,SS:[BP+10]	;get addr of parameter
;	MOV	AX,ES:[SI]	;get value of parm
	MOV	ROWS,AX
	MOV	AX,SS:[BP+8]	;get addr of parameter
;	MOV	AX,ES:[SI]	;get value of parm
	MOV	FOREGR,AX
	MOV	AX,SS:[BP+6]	;get addr of parameter
;	MOV	AX,ES:[SI]	;get value of parm
	MOV	BACKGR,AX
	MOV	AX,SS:[BP+4]	;get addr of parameter
;	MOV	AX,ES:[SI]	;get value of parm
	MOV	PGNUM,AX
;
;  determine if color or mono adaptor, and set ES to adaptor's address
	PUSH	DS		;save DS -> my data
	MOV	AX,0		;set up data seg register ..
	MOV	DS,AX		;..to gain access to DOS info
	MOV	SI,410H 	;offset to color/mono byte
	MOV	AL,[SI] 	;fetch byte
	POP	DS		;restore DS -> my data
	AND	AL,48		;mask
	CMP	AL,48		;48=mono, 32=color
	JZ	SETMNO
	MOV	AX,100H 	;move display page offset (divided by 10h)
	MUL	PGNUM		;compute total offset (num pages x offset)
	ADD	AX,COLOR	;add seg addr of page 0
	JMP	SETES
SETMNO: MOV	AX,MONO
SETES:	MOV	ES,AX		;now ES -> adaptor memory
;
;  initialize counters
	MOV	CX,COLS
	MOV	CCTR,CX 	;initialize column counter
	MOV	CX,ROWS
	MOV	RCTR,CX 	;initialize row counter
;
;  compute starting offset into display buffer
	MOV	AX,SROW
	DEC	AX		;set row 1 to row 0
	MOV	BX,160
	MUL	BX		;multiply by 160
	ADD	AX,SCOL 	;add (scol * 2) to get relative offset
	ADD	AX,SCOL
	SUB	AX,2		;point to attribute byte (adjust col 1 to 0)
	MOV	DI,AX		;AX has starting offset into buffer
	MOV	SI,AX		;SI and DI have same offsets to both buffers
;
;  determine function
	CMP	FUNCTN,1
	JZ	OPN
	CALL	CLOSW
	JMP	FINISH
OPN:	CALL	OPENW
FINISH: POP	ES
	POP	DS
	POP	BP
	RET	16		;return to basic
WINDO	ENDP
;
;
;  open window - save original data and attributes
;
OPENW	PROC	NEAR
;
;  convert attribute parameters (2 words) to attribute byte, store in BL
	CMP	FOREGR,10H	;check for blinking attr in foreground
	JL	NOBLNK		;skip conversion if no blink specified
	SUB	FOREGR,10H	;move the blink bit from foreground ...
	ADD	BACKGR,10H	;...to background
NOBLNK: MOV	CL,4		;count for SHL instruction
	MOV	BX,BACKGR	;background attr in low-nibble
	SHL	BX,CL		;background attr shifted left one nibble
	ADD	BX,FOREGR	;foreground attr in low-nibble
	MOV	CL,8		;count for SHL instruction
	SHL	BX,CL		;shift attr byte to high-byte
	MOV	BL,' '          ;move space char to low-byte
;
	MOV	DX,CRTSTAT
ORETRC: IN	AL,DX
	TEST	AL,VSYNC
	JZ	ORETRC
;
	MOV	AX,ES:[SI]
	MOV	DS:[DI+OFFSET HBUF1],AX
	MOV	ES:[DI],BX	;move space + attribute byte to buffer
	DEC	CCTR		;count off number of columns
	JZ	OCONT
	ADD	DI,2		;move destination of block one position
	ADD	SI,2
	JMP	ORETRC
;
OCONT:	DEC	RCTR		;count off number of rows
	JZ	FINOPN
;
	MOV	CX,COLS
	MOV	CCTR,CX 	;reset column counter
	MOV	AX,162
	SUB	AX,COLS 	;move to next row in buffer
	SUB	AX,COLS
	ADD	DI,AX
	ADD	SI,AX
	JMP	ORETRC
FINOPN: RET
OPENW	ENDP
;
;
;  close window - restore original data and attributes
;
CLOSW	PROC	NEAR
;
	MOV	DX,CRTSTAT
CRETRC: IN	AL,DX
	TEST	AL,VSYNC
	JZ	CRETRC
;
	MOV	AX,DS:[SI+OFFSET HBUF1]
	MOV	ES:[DI],AX
	DEC	CCTR		;count off number of columns
	JZ	CCONT
	ADD	DI,2		;move destination of block one position
	ADD	SI,2
	JMP	CRETRC
;
CCONT:	DEC	RCTR		;count off number of rows
	JZ	FINCLS
;
	MOV	CX,COLS
	MOV	CCTR,CX 	;reset column counter
	MOV	AX,162
	SUB	AX,COLS 	;move to next row in buffer
	SUB	AX,COLS
	ADD	DI,AX
	ADD	SI,AX
	JMP	CRETRC
FINCLS: RET
CLOSW	ENDP
;--------------------------------------------------------------------
CODESEG ENDS
	END
