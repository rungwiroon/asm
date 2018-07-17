.MODEL	SMALL	
.STACK 100H
INCLUDE MACRO.ASM
.DATA
	bmp_x		dw 100
	bmp_y		dw 1
	byte_buffer	db	?	;temp buffer
	GPW1		DW	?	;temp bmp width
	GPW2		DW	?	;temp bmp hight
        FILEHANDLE      DW      ?



        PUNCH DB 'L_P.PIC',0
.CODE
MAIN PROC
	MOV	AX,@DATA
	MOV	DS,AX

	MOV	AH,0
	MOV	AL,13H
	INT	10H

        LEA     SI,PUNCH
        MOV     BMP_X,10
        MOV     BMP_Y,10
        MOV     GPW1,26
        MOV     GPW2,34
        CALL    LOADPIC

        MOV     AH,1
        INT     21H

	MOV	AH,0
	MOV	AL,3H
	INT	10H

	MOV	AH,4CH
	INT	21H
MAIN ENDP
INCLUDE GRAPHIC.ASM
END
