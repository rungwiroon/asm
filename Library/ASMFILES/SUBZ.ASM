TITLE SCREEN HANDLING
COMMENT *
                TERMINATE       *
SUBTTL DEFINITIONS OF MACROS
UP            MACRO
              MOV     AH,6H           ;AH=6 Requests scroll UP
              BIOSCALL                ;Invoke BIOS to scroll the window
              ENDM
;
DOWN          MACRO
              MOV     AH,7H           ;AH=7 Requests scroll DOWN
              BIOSCALL                ;Invoke BIOS to scroll the window
              ENDM
;
READ_CURSOR   MACRO
              MOV     BH,AL
              MOV     AH,3            ;Functoin Selected Read Cursor Position
              BIOSCALL                ;Invoke BIOS to scroll the window
              ENDM
;
SET_CURSOR    MACRO
              MOV     AH,2            ;Function selected = locate
              BIOSCALL                ;Invoke BIOS to move cursor
              ENDM
;
BIOSCALL      MACRO
              INT     10H             ;Request BIOS service, id in AH
              ENDM
SUBTTL DESCRIPTION OF THE STACK SEGMENT
;
STACK         SEGMENT PARA STACK 'STACK'
;
              DB      64 DUP('STACK   ')
STACK         ENDS
;
;***************************************************************
;
SUBTTL DESCRIPTION OF DOS INTERFACES
;
CSEG          SEGMENT PARA PUBLIC 'CODE'
              PUBLIC LDELETE,LINSERT,PFILL
;
LDELETE       PROC    FAR
        ASSUME CS:CSEG,SS:STACK,ES:NOTHING
;
SUBTTL ESTABLISH ENTRY FROM BASIC
;
              PUSH    BP              ;save calling program BP
              MOV     BP,SP           ;establish new BP
;
SUBTTL SET THE ACTIVE PAGE
;
              MOV     SI,[BP]+6
              MOV     AX,[SI]
;
SUBTTL SCROLL THE WINDOW FROM CURSOR POSITION
;
              READ_CURSOR             ;read cursor position
              MOV     CH,DH           ;row position
              MOV     CL,DL           ;column postion
              MOV     AL,1            ;number of lines to insert
              CALL    SCROLL_UP       ;Call the scroll up routine
;
SUBTTL RESTORE THE ENTRY CONDITIONS, RETURN TO BASIC
;
              POP     BP              ;Restore BP register
              RET     2               ;Far return to BASIC
;
LDELETE      ENDP
;
;
;
LINSERT      PROC    FAR
;
SUBTTL  ESTABLISH ENTRY BASIC
;
              PUSH    BP              ;save calling program BP
              MOV     BP,SP           ;establish new BP
;
SUBTTL SET THE ACTIVE PAGE
;
              MOV     SI,[BP]+6
              MOV     AX,[SI]
;
SUBTTL SCROLL THE WINDOW FROM CURSOR POSITION
;
              READ_CURSOR             ;read cursor position
              MOV     CH,DH           ;row position
              MOV     CL,DL           ;column postion
              MOV     AL,1            ;number of lines to insert
              CALL    SCROLL_DOWN     ;Call scroll down routine
;
SUBTTL RESTORE THE ENTRY CONDITIONS, RETURN TO BASIC
;
              POP     BP              ;Restore BP register
              RET     2               ;Far return to BASIC
;
LINSERT       ENDP
;
;---------------------------------------------------------------
;
PFILL         PROC    FAR
;
SUBTTL ESTABLISH ENTRY FROM BASIC
;
              PUSH    BP              ;save calling program BP
              MOV     BP,SP           ;establish new BP
;
SUBTTL GET ADDRESSES FOR VARIABLES PASSED FROM BASIC
;
              MOV     SI,[BP]+6
              MOV     AX,[SI]         ;CHARACTER [AL]
              MOV     SI,[BP]+8
              MOV     BX,[SI]         ;PAGE [BH]/ATTRIBUTE [BL]
              MOV     SI,[BP]+10
              MOV     CX,[SI]         ;COUNT [CX]
;
SUBTTL FILL FROM CURSOR TO BOTTOM OF SCREEN
;
              MOV     AH,9
              BIOSCALL
;
SUBTTL RESTORE THE ENTRY CONDITIONS, RETURN TO BASIC
;
              POP     BP              ;Restore BP register
              RET     6               ;Far return to BASIC
;
PFILL        ENDP
SUBTTL ************* COMMON CODE LOCAL SUBROUTINES ****************
;
SCROLL_UP     PROC    NEAR
              MOV     DX,174FH
              MOV     BH,7            ;Normal attribute for Insert
              UP                      ;Scroll up, insert at bottom
              RET                     ;Return to caller
SCROLL_UP     ENDP
;
SCROLL_DOWN   PROC    NEAR
              MOV     DX,174FH
              MOV     BH,7            ;Normal attribute for Insert
              DOWN                    ;Scroll down, insert at top
              RET                     ;Return to caller
SCROLL_DOWN   ENDP
CSEG          ENDS
              END     LDELETE
                                                                                                     