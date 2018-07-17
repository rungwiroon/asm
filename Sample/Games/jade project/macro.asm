PUSHX	MACRO	REGS
	IRP	R,<REGS>
	PUSH	R
	ENDM
ENDM

POPX	MACRO	REGS
	IRP	R,<REGS>
	POP	R
	ENDM
ENDM

drawbmp	macro	x,y,w,h,bitmap
	local	x,y,w,h,bitmap
	pushx	<si,di>
	mov	bmp_x,x
	mov	bmp_y,y
	mov	gpw1,w
	mov	gpw2,h
	;lea	si,bitmap
	mov	si,bitmap
	call	drawobjbuffer;bmp;loadpic
	popx	<di,si>
endm

movebmp	macro	x,y,w,h,offsetbitmap
	local	x,y,w,h,offsetbitmap
	pushx	<si,di>
	mov	bmp_x,x
	mov	bmp_y,y
	mov	gpw1,w
	mov	gpw2,h
	;lea	si,bitmap
	mov	si,offsetbitmap
	call	drawobjbuffer
	;call	clrbmp
	popx	<di,si>
endm

DELAY MACRO TIME
	LOCAL TIME,EATTIME
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

	MOV AX,0
	MOV BX,0
	MOV CX,0

EATTIME :
	INC AX
	CMP AX,1000
	JLE EATTIME
	INC BX
	CMP BX,32766
	JLE EATTIME
	INC CX
	CMP CX,TIME
	JLE EATTIME

	POP DX
	POP CX
	POP BX
	POP AX
ENDM

RANDOM MACRO RANGE
	LOCAL RANGE
	LOCAL SRAND,CLEAR,SET,CALRAN
        MOV AH,2CH      ;USE TO GET TIME FROM COMPUTER
        PUSH CX
        INT 21H
        MOV AL,DL
        POP CX
        XOR AH,AH
SRAND :                 ;AND USE BASIC RANDOM ALGORITHM FROM HOMEWORK
        SHL AX,1        ;THE ALGORITHM IS
        PUSH AX         ;REPLACE BIT 0 BY XOR OF BIT 14 AND 15
        MOV BX,AX       ;CLEAR BIT 15
        SHL AX,1
        XOR AX,BX
        ROL AX,1
        AND AX,1H
        CMP AX,0
        JE CLEAR
        CMP AX,1
        JE SET
CLEAR :
        POP AX
        AND AX,0FFFEH
        AND AX,7FFFH
        JMP CALRAN
SET :
        POP AX
        OR AX,1H
        AND AX,7FFFH
        JMP CALRAN
CALRAN :
        XOR DX,DX
	MOV CX,RANGE
        DIV CX
	INC DX
ENDM

GOTOXY	MACRO	gtX,gtY
	LOCAL	gtX,gtY
	pushx	<AX,DX,BX>
	MOV	AH,2
	MOV	DL,gtX
	MOV	DH,gtY
	MOV	BH,0
	INT	10H
	popx	<BX,DX,AX>
ENDM

PRINTDEC  MACRO	DECIMAL
	LOCAL	DECIMAL
	push	AX
	xor	ax,ax
	MOV	Al,DECIMAL
	CALL	OUTDEC
	pop	AX
ENDM

COUNTDOWN	MACRO	
	LOCAL	@noupdatetime
	pushx	<ax,dx>
	MOV	AH,2CH
	INT	21H

	CMP	DH,DOSTIME
	JZ	@noupdatetime

	MOV	DOSTIME,DH
	DEC	ROUNDTIME
	GOTOXY	19,2
	PRINTDEC ROUNDTIME
@noupdatetime:
	popx	<dx,ax>
ENDM