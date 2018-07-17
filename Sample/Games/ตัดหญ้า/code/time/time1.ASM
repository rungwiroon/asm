	TITLE	PGM15_2: DISPLAY_TIME_VER_2
;program that displays the current time
;and updates the time 18.2 times a second
.MODEL	SMALL
.STACK	100H
.DATA
TIME_BUF	DB	'00:00:00$'	;time buffer hr:min:sec
CURSOR_POS	DW	?		;cursor position (row:col)
NEW_VEC		DW	?,?		;new interrupt vector
OLD_VEC		DW	?,?		;old interrupt vector
;
.CODE
MAIN	PROC
	MOV	AX,@DATA
	MOV	DS,AX		;initialize DS
;
;save cursor location
	MOV	AH,3		;function 3, get cursor
	MOV	BH,0		;page 0
	INT	10H		;DH =  row, DL = col
	MOV	CURSOR_POS,DX	;save it
;setup interrupt procedure by
;placing segment:offset of TIME_INT in NEW_VEC
	MOV	NEW_VEC,OFFSET TIME_INT	;offset 
	MOV	NEW_VEC+2,SEG TIME_INT	;segment
	LEA	DI,OLD_VEC	;DI points to vector buffer
	LEA	SI,NEW_VEC	;SI points to new vector
	MOV	AL,1CH		;timer interrupt
	CALL	SETUP_INT	;setup new interrupt vector
;read keyboard
	MOV	AH,0
	INT	16H
;restore old interrupt vector
	LEA	DI,NEW_VEC	;DI points to vector buffer
	LEA	SI,OLD_VEC	;SI points to old vector
	MOV	AL,1CH		;timer interrupt
	CALL	SETUP_INT	;restore old vector
;
	MOV	AH,4CH		;return
	INT	21H		;to DOS
MAIN	ENDP
;
TIME_INT	PROC
;interrupt procedure
;activated by the timer
	PUSH	DS		;save current DS
	MOV	AX,@DATA	;set it to data segment
	MOV	DS,AX
;get new time
	LEA	BX,TIME_BUF	;BX points time buffer
	CALL	GET_TIME	;store time in buffer
;display time
	LEA	DX,TIME_BUF	;DX points to TIME_BUF
	MOV	AH,09H		;display string
	INT	21H
;restore cursor position
	MOV	AH,2		;function 2, move cursor
	MOV	BH,0		;page 0
	MOV	DX,CURSOR_POS	;cursor position,DH=row,DL=col
	INT	10H		;
	POP	DS		;restore DS
	IRET
TIME_INT	ENDP		;end of interrupt procedure

SETUP_INT	PROC
;saves old vector and sets up new vector
;inputº  AÌ = interrupô type
;	DI = address of buffer for old vector
;	SI = address of buffer containing new vector
;savå old interrupô vector
 	MOV	AH,35H		;function 35h, get vector
	INT	21H		;ES:BX = vector
	MOV	[DI],BX		;save offset
	MOV	[DI+2],ES	;save segment
;setup new vector
	MOV	DX,[SI]		;DX has offset
	PUSH	DS		;save it
	MOV	DS,[SI+2]	;DS has segment number
	MOV	AH,25H		;function 25h, set vector
	INT	21H		;
	POP	DS		;restore DS
      RET
SETUP_INT	ENDP

GET_TIME        PROC
;get time of day and store ASCII digits in time buffer
;input:  BX = address of time buffer
        MOV     AH,2CH          ;gettime
        INT     21H             ;CH = hr, CL =  min, DH = sec
;convert hours into ASCII and store
        MOV     AL,CH           ;hour
        CALL    CONVERT         ;convert to ASCII
        MOV     [BX],AX         ;store
;convert minutes into ASCII and store
        MOV     AL,CL           ;minute
        CALL    CONVERT         ;convert to ASCII
        MOV     [BX+3],AX       ;store
;convert seconds into ASCII and store
        MOV     AL,DH           ;second
        CALL    CONVERT         ;convert to ASCII
        MOV     [BX+6],AX       ;store
        RET
GET_TIME        ENDP
;
CONVERT PROC
;converts byte number (0-59) into ASCII digits
;input: AL = number
;output: AX = ASCII digits, AL = high digit, AH = low digit
        MOV     AH,0            ;clear AH
        MOV     DL,10           ;divide AX by 10
        DIV     DL              ;AH has remainder, AL has quotient
        OR      AX,3030H        ;convert to ASCII, AH has low digit
        RET                     ;AL has high digit
CONVERT ENDP
;
	END	MAIN
