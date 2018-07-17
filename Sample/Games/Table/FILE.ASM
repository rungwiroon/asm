.DATA
	FILESCORE       DB 'SCORE.DAT',0
	HANDLE          DW ?
	FILEBUFFER1     DB 70 DUP (0)
	FILEBUFFER2     DB 7 DUP (0)
	NAMEPLAY        DB 5 DUP (' ')
	NAMEBUFFER      DB 5 DUP (0),'$'
	SCOREBUFFER     DW ?
	MSGGETNAME      DB 'ENTER NAME:$'
	TITLESCORE	DB 'NAME   HITS$'
	LINE    DB ?
	NUMSAVE DB 0
	NUMSHOWSCORE DB ?
	score	dw ?

.CODE
OPENFILE        MACRO
        MOV     AH,3DH
        LEA     DX,FILESCORE
        MOV     AL,2
        INT     21H
        MOV     HANDLE,AX
ENDM

CLOSEFILE       MACRO
        MOV     AH,3EH
        MOV     BX,HANDLE
        INT     21H
ENDM

GETNAME PROC

	MOV	CX,5
	XOR	BX,BX
CLRNAME:
	MOV	[NAMEPLAY+BX],0
	INC	BX
	LOOP	CLRNAME

	MOV     AH,2H
        MOV     BH,0
        MOV     DH,12
        MOV     DL,15
        INT     10H
        MOV     AH,9
        LEA     DX,MSGGETNAME
        INT     21H

        MOV     AH,2H
        MOV     BH,0
        MOV     DH,12
        MOV     DL,26
        INT     10H

        XOR     BX,BX

        MOV     AH,1
GETNAMELP_:
        INT     21H
	CMP     AL,0DH
        JE      ENDGETNAME_
        MOV     [NAMEPLAY+BX],AL
        INC     BX
	CMP	BX,5
	JE	ENDGETNAME_
        JMP     GETNAMELP_
ENDGETNAME_:
	MOV	AX,HITS
	MOV	SCORE,AX
        OPENFILE
        CLD
        LEA     DI,FILEBUFFER1
        MOV     NUMSAVE,0
NEXTSAVE3_:
        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,5
        LEA     DX,NAMEBUFFER
        INT     21H

        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,2
        LEA     DX,SCOREBUFFER
        INT     21H

        MOV     AX,SCOREBUFFER
        CMP     SCORE,AX
        JLE     NEXTSAVE1_

        INC     NUMSAVE
        LEA     SI,NAMEBUFFER
        MOV     CX,5
        REP     MOVSB
        MOV     AX,SCOREBUFFER
        STOSW
        CMP     NUMSAVE,10
        JNE     NEXTSAVE3_
        JMP     ENDSAVE_
NEXTSAVE1_:
        INC     NUMSAVE
        LEA     SI,NAMEPLAY
        MOV     CX,5
        REP     MOVSB
        MOV     AX,SCORE
        STOSW

        CMP     NUMSAVE,10
        JNE     NEXTSAVE2_
        JMP     ENDSAVE_
NEXTSAVE2_:
        INC     NUMSAVE
        LEA     SI,NAMEBUFFER
        MOV     CX,5
        REP     MOVSB
        MOV     AX,SCOREBUFFER
        STOSW

        CMP     NUMSAVE,10
        JE      ENDSAVE_

NEXTSAVE4_:
        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,5
        LEA     DX,NAMEBUFFER
        INT     21H

        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,2
        LEA     DX,SCOREBUFFER
        INT     21H

        INC     NUMSAVE
        LEA     SI,NAMEBUFFER
        MOV     CX,5
        REP     MOVSB
        MOV     AX,SCOREBUFFER
        STOSW

        CMP     NUMSAVE,10
        JE      ENDSAVE_
        JMP     NEXTSAVE4_

ENDSAVE_:
        MOV     AH,42H
        MOV     AL,0
        MOV     BX,HANDLE
        XOR     CX,CX
        XOR     DX,DX
        INT     21H

        MOV     AH,40H
        MOV     BX,HANDLE
        MOV     CX,70
        LEA     DX,FILEBUFFER1
        INT     21H
        CLOSEFILE
        RET
GETNAME ENDP

SHOWHISCORE     PROC

        OPENFILE

        MOV     NUMSHOWSCORE,30H
        MOV     COUNT,10
        MOV     LINE,10

	MOV     AH,2H
        MOV     BH,0
        MOV     DH,8
	MOV     DL,17
        INT     10H

        MOV     AH,9
        LEA     DX,TITLESCORE
        INT     21H


HISCORELOOP_:
        INC     NUMSHOWSCORE
        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,5
        LEA     DX,NAMEBUFFER
        INT     21H

        MOV     AH,2H
        MOV     BH,0
        MOV     DH,LINE
        MOV     DL,17
        INT     10H

        MOV     AH,9
        LEA     DX,NAMEBUFFER
        INT     21H

        MOV     AH,3FH
        MOV     BX,HANDLE
        MOV     CX,2
        LEA     DX,SCORE
        INT     21H

        MOV     AH,2H
        MOV     BH,0
        MOV     DH,LINE
        MOV     DL,25
        INT     10H

        MOV     AX,SCORE
        CALL    OUTDEC

        INC     LINE

        DEC     COUNT
        JZ      ENDHISCORE_
        JMP     HISCORELOOP_
ENDHISCORE_:
        MOV     AH,1
        INT     21H
        CLOSEFILE
        
        RET
SHOWHISCORE     ENDP