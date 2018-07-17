;COBLOAD.ASM	  07/09/84 - DKeels
;----------------------------------------------------------------------------
;This program provides COBOL programs with access to the program loader (LOAD) 
;by passing parameters via the system parameter area (SYSPARM).
;
;Inputs:
;01  COBLOAD-PARMS
;  05  FILE-SPEC-1    PIC X(80).   Contains complete drive, path and filename.
;  05  PARAMETER-1    PIC X(80).   Contains command line parameters.
;  05  FILE-SPEC-2    PIC X(80).   Same as 1.
;  05  PARAMETER-2    PIC X(80).   Same as 1.
;
;Outputs:
;  None.
;----------------------------------------------------------------------------


CL_CODE_SEG	SEGMENT PUBLIC 'CODE'
		ASSUME	CS:CL_CODE_SEG,DS:CL_CODE_SEG,ES:CL_CODE_SEG

STACK_PARM	STRUC
PUSHED_SI	DW	?
PUSHED_DI	DW	?
PUSHED_DS	DW	?
PUSHED_ES	DW	?
PUSHED_BP	DW	?
RETURN_IP	DW	?
RETURN_CS	DW	?
PARM1_OFFSET	DW	?
PARM1_DS	DW	?
STACK_PARM	ENDS

		PUBLIC	COBLOAD		;make known to COBOL at link time
COBLOAD		PROC	FAR

	;prologue
		PUSH	BP
		PUSH	ES
		PUSH	DS
		PUSH	DI
		PUSH	SI
		MOV	BP,SP		;set base for stack parm structure

	;address caller's parameter block
		MOV	AX,[BP].PARM1_DS
		MOV	DS,AX			;DS -> cobol data seg
		MOV	SI,[BP].PARM1_OFFSET	;SI -> offset to parm block

	;address load's parameter block in sysparm
		MOV	DX,'dk'		;verification switch
		INT	77H		;get seg addr in AX
		MOV	ES,AX		;ES -> sysparm
		MOV	DI,0		;DI -> offset to LOAD parms

	;move cobol's parm block to load's parm block (in sysparm)
		CLD				;set direction for moves

		MOV	CX,80			;length of move
		REP	MOVSB			;move file spec 1
ASCIIZ1:	MOV	BYTE PTR ES:[DI],0	;make asciiz string
		DEC	DI
		MOV	AL,BYTE PTR ES:[DI]
		CMP	AL,' '			;nullify trailing spaces
		JE	ASCIIZ1

		MOV	BX,81			;point to parm length byte
		MOV	BYTE PTR ES:[BX],82	;init length of parm, + 2
		MOV	DI,82			;point to 1st parm position
		MOV	CX,80			;length of move
		REP	MOVSB			;move parm
ADD_CR_1:	MOV	BYTE PTR ES:[DI],13	;add carriage return
		DEC	BYTE PTR ES:[BX]	;sub 1 from length of parm
		DEC	DI
		MOV	AL,BYTE PTR ES:[DI]
		CMP	AL,' '			;put cr in trailing spaces
		JE	ADD_CR_1

		MOV	DI,163
		MOV	CX,80			;length of move
		REP	MOVSB			;move file spec 2
ASCIIZ2:	MOV	BYTE PTR ES:[DI],0	;make asciiz string
		DEC	DI
		MOV	AL,BYTE PTR ES:[DI]
		CMP	AL,' '			;nullify trailing spaces
		JE	ASCIIZ2

		MOV	BX,244			;point to parm length byte
		MOV	BYTE PTR ES:[BX],82	;init length of parm, + 2
		MOV	DI,245			;point to 1st parm position
		MOV	CX,80			;length of move
		REP	MOVSB			;move parm
ADD_CR_2:	MOV	BYTE PTR ES:[DI],13	;add carriage return
		DEC	BYTE PTR ES:[BX]	;sub 1 from length of parm
		DEC	DI
		MOV	AL,BYTE PTR ES:[DI]
		CMP	AL,' '			;put cr in trailing spaces
		JE	ADD_CR_2

	;return to caller
		POP	SI
		POP	DI
		POP	DS
		POP	ES
		POP	BP
		RET	4

COBLOAD		ENDP

CL_CODE_SEG	ENDS
		END
