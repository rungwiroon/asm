TITLE   BRK2 -- Break Handling Utilities Module

TRUE            EQU     01H                     ;boolean true
FALSE           EQU     00H                     ;boolean false
BREAKINT        EQU     23H                     ;dos control-break intrpt
GETVECTOR       EQU     35H                     ;dos get vector function
SETVECTOR       EQU     25H                     ;dos set vector function
DOS_FUNCTION    EQU     21H                     ;dos function call

BREAK           SEGMENT PUBLIC  'CODE'
BREAKFLAG       DB      0H                      ;break key hit flag
SAVEBRK         DD      0H                      ;saved break vec. contents
                ASSUME  CS:BREAK
                ASSUME  DS:NOTHING

;CHECK_BREAK    checks if ctrl-break has been pressed.  It returns
;true if ctrl-break has been pressed and false if it hasn't.

                PUBLIC  CHECK_BREAK
CHECK_BREAK     PROC    FAR
                XOR     AX, AX                  ;clear ax
                MOV     AL, BREAKFLAG           ;return value = breakflag
                MOV     BREAKFLAG, FALSE        ;reset breakflag
                RET
CHECK_BREAK     ENDP

;INSTALL_BREAK_HANDLER  sets up a ctrl-break interrupt handler.  It
;also saves the address of the former break handler so that it can
;be restored later.

                PUBLIC  INST_BRK_HANDLR
INST_BRK_HANDLR PROC    FAR
                PUSH    DS
                MOV     AL, BREAKINT            ;AL = break interrupt
                MOV     AH, GETVECTOR           ;AH = dos function code
                INT     DOS_FUNCTION            ;call dos
                MOV     WORD PTR SAVEBRK, BX    ;save offset in int vector
                MOV     WORD PTR SAVEBRK+2, ES  ;save base in int vector
                MOV     AL, BREAKINT            ;AL = break interrupt
                MOV     AH, SETVECTOR           ;AH = dos function code
                MOV     DX, OFFSET BRK_HANDLER  ;DX = offset of brk handler
                MOV     BX, CS                  ;BX = this segment
                MOV     DS, BX                  ;DS = this segment
                INT     DOS_FUNCTION            ;call dos
                POP     DS
                RET
INST_BRK_HANDLR ENDP

;BRK_HANDLER    is invoked by the bios when ctrl_break is pressed

BRK_HANDLER     PROC    FAR
                MOV     BREAKFLAG, TRUE         ;breakflag = yes, break hit
                IRET
BRK_HANDLER     ENDP

;REMOVE_BREAK_HANDLER restores the previous ctrl-break handler

REM_BRK_HANDLR  PROC    FAR
                PUSH    DS
                MOV     AL, BREAKINT            ;AL = break interrupt
                MOV     AH, SETVECTOR           ;AH = dos function code
                MOV     DX, WORD PTR SAVEBRK    ;DX = saved 1st word
                MOV     BX, WORD PTR SAVEBRK+2  ;BX = saved 2nd word
                MOV     DS, BX                  ;DS = saved 2nd word
                INT     DOS_FUNCTION            ;call dos
                POP     DS
                RET
REM_BRK_HANDLR  ENDP
BREAK           ENDS
                END
