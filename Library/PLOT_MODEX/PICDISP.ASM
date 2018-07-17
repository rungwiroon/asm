TITLE PICDISP.ASM
; JINGJAI AND SANDEE LEGEND (RPG Games)
; Programmed by Raywat Tassaneesrivong	 ID 47-4055-909-3   CSs11
; King Mongkut's Institute of Technology North Bangkok
; DATE: 25/2/2548

;FROM MODEX.ASM
EXTRN	SET_POINT:FAR		;(Xpos%, Ypos%, ColorNum%)

.MODEL MEDIUM
    f       EQU FAR PTR 

.DATA
CURRENT_XOFFSET DW  	0       ; Current Display X Offset
CURRENT_YOFFSET DW  	0       ; Current Display Y Offset
 
BUFFER	 DB	512 DUP(0)
HANDLE	 DW	?

.CODE

PUSHx MACRO R1, R2, R3, R4, R5, R6, R7, R8
    IFNB <R1>
        PUSH    R1              ; Save R1
        PUSHx   R2, R3, R4, R5, R6, R7, R8
    ENDIF
ENDM
 
POPx MACRO R1, R2, R3, R4, R5, R6, R7, R8
    IFNB <R1>
        POP     R1              ; Restore R1
        POPx    R2, R3, R4, R5, R6, R7, R8
    ENDIF
ENDM

;=====================================================
;DISPLAY_PIC (FAR Locate, Xpos1, Ypos1, Width, Height)
;=====================================================
;
; ENTRY: Segment  = Data Segment
;	 Locate	  = File Pointer
;	 Xpos1    = X position of first point on line
;        Ypos1    = Y position of first point on line
;	 Width    = Picture width
;        Height   = Picture height
;
; RETURN:  No

DOP_STACK    STRUC
                DW  ?,?,?,?,?,? ; AX, BX, CX, DX, BP, SI
                DD  ?   ; Caller
   DOP_Height   DW  0   ; Height 
   DOP_Width    DW  0   ; Width
   DOP_Ypos1    DW  0   ; Y pos of Upper Left Pixel
   DOP_Xpos1    DW  0   ; X pos of Upper Left Pixel   
   DOP_Locate   DD  ?   ; Filename
DOP_STACK    ENDS

PUBLIC	DISPLAY_PIC
DISPLAY_PIC PROC FAR

    PUSHx   AX, BX, CX, DX, BP, SI ; Preserve Important registers
    MOV     BP, SP              ; Set up Stack Frame
	
	MOV	AX,[BP].DOP_Xpos1
	ADD	[BP].DOP_Width,AX
	MOV	AX,[BP].DOP_Ypos1
	ADD	[BP].DOP_Height,AX
	
    	LDS     SI, [BP].DOP_Locate   ; DS:SI-> Source Image
	MOV	DX,SI
	MOV	AL,0
	CALL	f OPEN_FILE
	MOV	HANDLE,AX
	
	MOV	SI,512		;Size of Buffer
	MOV	AX,[BP].DOP_Xpos1
	MOV	CURRENT_XOFFSET,AX
	MOV	AX,[BP].DOP_Ypos1
	MOV	CURRENT_YOFFSET,AX
@DOP_LOOP:	
	CMP	SI,512
	JL	@DOP_SKIP

;Load pic to buffer	
	LEA	DX,BUFFER
	MOV	BX,HANDLE
	CALL	f READ_FILE
	XOR	SI,SI
@DOP_SKIP:
	XOR	AX,AX
	MOV	AL,BUFFER[SI]
	PUSH	CURRENT_XOFFSET
	PUSH	CURRENT_YOFFSET
	PUSH	AX
	CALL	SET_POINT
	
	INC	SI
	INC	CURRENT_XOFFSET
	MOV	AX,[BP].DOP_Width
	CMP	CURRENT_XOFFSET,AX  ;Compare Xpos > Width?
	JNE	@DOP_LOOP
	MOV	AX,[BP].DOP_Xpos1
	MOV	CURRENT_XOFFSET,AX  ;Set Xpos to start point
	INC	CURRENT_YOFFSET
	MOV	AX,[BP].DOP_Height
	CMP	CURRENT_YOFFSET,AX  ;Compare Ypos > Height?
	JNE	@DOP_LOOP

	MOV	BX,HANDLE
	CALL	f CLOSE_FILE
		
    POPx    SI, BP, DX, CX, BX, AX ; Restore Registers
    RET     12
DISPLAY_PIC ENDP

;=====================================================
;DISPLAY_TPIC (FAR Locate, Xpos1, Ypos1, Width, Height)
;=====================================================
;0(Black) is a Transparent color
;
; ENTRY: Segment  = Data Segment
;	 Locate	  = File Pointer
;	 Xpos1    = X position of first point on line
;        Ypos1    = Y position of first point on line
;	 Width    = Picture width
;        Height   = Picture height
;
; RETURN:  No

DTP_STACK    STRUC
                DW  ?,?,?,?,?,? ; AX, BX, CX, DX, BP, SI
                DD  ?   ; Caller
   DTP_Height   DW  0   ; Height 
   DTP_Width    DW  0   ; Width
   DTP_Ypos1    DW  0   ; Y pos of Upper Left Pixel
   DTP_Xpos1    DW  0   ; X pos of Upper Left Pixel   
   DTP_Locate   DD  ?   ; Filename
DTP_STACK    ENDS

PUBLIC	DISPLAY_TPIC
DISPLAY_TPIC PROC FAR

    PUSHx   AX, BX, CX, DX, BP, SI ; Preserve Important registers
    MOV     BP, SP              ; Set up Stack Frame
	
	MOV	AX,[BP].DTP_Xpos1
	ADD	[BP].DTP_Width,AX
	MOV	AX,[BP].DTP_Ypos1
	ADD	[BP].DTP_Height,AX
	
    	LDS     SI, [BP].DTP_Locate   ; DS:SI-> Source Image
	MOV	DX,SI
	MOV	AL,0
	CALL	f OPEN_FILE
	MOV	HANDLE,AX
	
	MOV	SI,512		;Size of Buffer
	MOV	AX,[BP].DTP_Xpos1
	MOV	CURRENT_XOFFSET,AX
	MOV	AX,[BP].DTP_Ypos1
	MOV	CURRENT_YOFFSET,AX
@DTP_LOOP:	
	CMP	SI,512
	JL	@DTP_SKIP

;Load pic to buffer	
	LEA	DX,BUFFER
	MOV	BX,HANDLE
	CALL	f READ_FILE
	XOR	SI,SI
@DTP_SKIP:
	CMP	BUFFER[SI],0
	JE	@DTP_NEXT
	XOR	AX,AX
	MOV	AL,BUFFER[SI]
	PUSH	CURRENT_XOFFSET
	PUSH	CURRENT_YOFFSET
	PUSH	AX
	CALL	SET_POINT
@DTP_NEXT:
	INC	SI
	INC	CURRENT_XOFFSET
	MOV	AX,[BP].DTP_Width
	CMP	CURRENT_XOFFSET,AX  ;Compare Xpos > Width?
	JNE	@DTP_LOOP
	MOV	AX,[BP].DTP_Xpos1
	MOV	CURRENT_XOFFSET,AX  ;Set Xpos to start point
	INC	CURRENT_YOFFSET
	MOV	AX,[BP].DTP_Height
	CMP	CURRENT_YOFFSET,AX  ;Compare Ypos > Height?
	JNE	@DTP_LOOP

	MOV	BX,HANDLE
	CALL	f CLOSE_FILE
		
    POPx    SI, BP, DX, CX, BX, AX ; Restore Registers
    RET     12
DISPLAY_TPIC ENDP

;=====================================================
;FILE PROCEDURE
;=====================================================

OPEN_FILE PROC FAR
	MOV	AH,3Dh
	MOV	AL,0
	INT	21h
	RET
OPEN_FILE ENDP

READ_FILE PROC FAR
	MOV	AH,3Fh
	MOV	CX,512
	INT	21h
	RET
READ_FILE ENDP

MOVE_FILE PROC FAR
;Use CX:DX for Move
;Ret DX:AX
	MOV	AH,42h
	MOV	BX,HANDLE
	MOV	AL,0
	INT	21h
	RET
MOVE_FILE ENDP

CLOSE_FILE PROC FAR
	MOV	AH,3Eh
	INT	21h
	RET
CLOSE_FILE ENDP
END