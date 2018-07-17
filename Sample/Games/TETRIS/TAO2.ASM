; AUTHOR         : DUSIT NIYATO
; CONSTRUCT DATE : 25/03/97
; CONSTRUCT TIME : 11.30
TITLE           PROGRAM TAO TETRIS
        .MODEL SMALL
        .STACK  1000H
;-------------------------------------------------------------------
        .DATA
ARRAY   DB      0,0,0,0,0,0,0,0,0,0     ; 0
        DB      0,0,0,0,0,0,0,0,0,0     ; 1
        DB      0,0,0,0,0,0,0,0,0,0     ; 2
        DB      0,0,0,0,0,0,0,0,0,0     ; 3
        DB      0,0,0,0,0,0,0,0,0,0     ; 4
        DB      0,0,0,0,0,0,0,0,0,0     ; 5
        DB      0,0,0,0,0,0,0,0,0,0     ; 6
        DB      0,0,0,0,0,0,0,0,0,0     ; 7
        DB      0,0,0,0,0,0,0,0,0,0     ; 8
        DB      0,0,0,0,0,0,0,0,0,0     ; 9
        DB      0,0,0,0,0,0,0,0,0,0     ; 10
        DB      0,0,0,0,0,0,0,0,0,0     ; 11
        DB      0,0,0,0,0,0,0,0,0,0     ; 12
        DB      0,0,0,0,0,0,0,0,0,0     ; 13
        DB      0,0,0,0,0,0,0,0,0,0     ; 14
        DB      0,0,0,0,0,0,0,0,0,0     ; 15
        DB      0,0,0,0,0,0,0,0,0,0     ; 16
        DB      0,0,0,0,0,0,0,0,0,0     ; 17
        DB      0,0,0,0,0,0,0,0,0,0     ; 18
        DB      0,0,0,0,0,0,0,0,0,0     ; 19
        DB      0,0,0,0,0,0,0,0,0,0     ; 20

ARRAY1  DB      0,0,0,0,0,0,0,0,0,0     ; 0
        DB      0,0,0,0,0,0,0,0,0,0     ; 1
        DB      0,0,0,0,0,0,0,0,0,0     ; 2
        DB      0,0,0,0,0,0,0,0,0,0     ; 3
        DB      0,0,0,0,0,0,0,0,0,0     ; 4
        DB      0,0,0,0,0,0,0,0,0,0     ; 5
        DB      0,0,0,0,0,0,0,0,0,0     ; 6
        DB      0,0,0,0,0,0,0,0,0,0     ; 7
        DB      0,0,0,0,0,0,0,0,0,0     ; 8
        DB      0,0,0,0,0,0,0,0,0,0     ; 9
        DB      0,0,0,0,0,0,0,0,0,0     ; 10
        DB      0,0,0,0,0,0,0,0,0,0     ; 11
        DB      0,0,0,0,0,0,0,0,0,0     ; 12
        DB      0,0,0,0,0,0,0,0,0,0     ; 13
        DB      0,0,0,0,0,0,0,0,0,0     ; 14
        DB      0,0,0,0,0,0,0,0,0,0     ; 15
        DB      0,0,0,0,0,0,0,0,0,0     ; 16
        DB      0,0,0,0,0,0,0,0,0,0     ; 17
        DB      0,0,0,0,0,0,0,0,0,0     ; 18
        DB      0,0,0,0,0,0,0,0,0,0     ; 19
        DB      0,0,0,0,0,0,0,0,0,0     ; 20

        ; 0 = No element, 1 = Moving element, 2 = Store element

INT1CSEG   DW      00H
INT1COFF   DW      00H
INT09SEG   DW      00H
INT09OFF   DW      00H

HELPBAR    DB   '≥ ESC=Exit ≥ Alt=Help ≥'
BLOCKCOLOR DB      0H           ; 0 = black, 1 = green, 2 = gray
SAVESCREEN DW   2000D   DUP(0)

TYPEELE         DB      0       ; indicate for element in array
FORM    DB      0               ; indicate for form of element in array


TYPEELE1        DB      0       ; indicate for element in array
FORM1   DB      0               ; indicate for form of element in array

POSX    DB      5               ; position in x
POSY    DB      2               ; position in y
POSX1   DB      5               ; position in x
POSY1   DB      0               ; position in y


TIME    DB      1                       ; setting time

SCORE   DB      3D      DUP(0)
score1  db      03d     dup(0)

                ; for change font
BOX1    DB      0ffH, 080H, 0d5H, 080H, 0d5H, 080H, 0d5H, 080H
        db      0d5H, 080H, 0d5H, 080H, 0d5H, 080H, 0d5H, 0ffH
box2    db      0ffH, 01H, 0abH, 01H, 0abH, 01H, 0abH, 001H
        db      0abH, 01H, 0abH, 001H, 0abH, 01H, 0abH, 0ffH

                ; for fade
TIMEPORT        DW      0422h                    ; wait time for wait61
COLOR   DB      768D    DUP(0)                  ; table of color pallate
colorbase       db      768d    dup(0)  ; table of original color pallate

speed   db      'Speed : '

PLAYER  DB      0       ; player, 1 = block0, 2 = block1, 3 = block 1 and 2

help     db     '‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹'
         db     '€                                             €'
         db     '€              Game Control                 €'
         db     '€      F1        = New game with 1 player     €'
         db     '€      F2        = New game with 2 players    €'
         db     '€      Pause     = Pause                      €'
         db     '€      Page UP   = Speed up                   €'
         db     '€      Page Down = Speed Down                 €'
         db     '€                                             €'
         db     '€                Player 1                   €'
         db     '€      W         = Rotate                     €'
         db     '€      A         = Move left                  €'
         db     '€      S         = Move right                 €'
         db     '€      Z         = Move down                  €'
         db     '€                                             €'
         db     '€                Player 2                   €'
         db     '€               = Rotate                     €'
         db     '€               = Move left                  €'
         db     '€               = Move right                 €'
         db     '€               = Move down                  €'
         db     '€             High Score     Line             €'
         db     '€          Press ESC to return game           €'
         db     '€‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹€'

RESTORE_FE      DW      0

highs    db     03d     dup(00h)
highfile db     'high.tao',0h   ; ***IMPORTANT file name may be terminate with
                                ;  value 0h
filehandle      dw      0

title1  db      'A s s e m b l y  T e t r i s'
        db      'By'
        db      'D u s i t  N i y a t o (Tao)'
        db      'To'
        db      'Arjarn Thana Hongsuwan'
        db      'Computer Engineering, King Mongkut Institute of Technology Ladkrabang'

name1   db      'Player 1 :'
        db      'Player 2 :'

last_message    db      "Assembly Tetris version final beta.",0ah, 0dh
                db      "Please send comment to s8014162@diamond.ce.kmitl.ac.th.",0ah,0dh
                db      "Thank P'Jock very much for his pascal program and consultance.",0ah,0dh,"$"
;-------------------------------------------------------------------
        .CODE
MAIN    PROC    FAR
        MOV     AX, @DATA           ; prepare date segment and es
        MOV     DS, AX
        MOV     ES, AX
;*************************** Prepare anything ******************
        call    getpallate
        call    fade_in
        CALL    VIDEO
        CALL    SAVESCR
        CALL    HIDECURSOR
        call    read_score
        call    clear_screen
        CALL    GET1C
        CALL    SET1C
        CALL    GET09
        CALL    SET09
        call    show_title              ; call after hook int 1ch !!!
        CALL    BORDER
        CALL    PRINTBAR
        CALL    CHGFON
        call    fade_outof
;***************************************************************

        MOV     TIME, 08D
        CALL    SET_NEW
        call    show_speed

        mov     ax, 0040h                       ; clear my key board buffer
        mov     es, ax
        mov     di, 00feh
        mov     byte ptr es:[di], 00h

        ;<<<<<<<<<<<<<<<<<<<<<<< main loop >>>>>>>>>>>>>>>>>>>>>>>>

MAIN_LOOP:
        MOV     AX, 0040H               ; clear counter
        MOV     ES, AX
        MOV     DI, 00FFH
        MOV     BYTE PTR ES:[DI], 00H

WAITTIME:
        mov     ax, 0040h               ; check key board buffer
        mov     es, ax
        mov     di, 0feh

        mov     al, byte ptr es:[di]        ; get key from my keyboard buffer


testplayer_one:                             ; test player before precess
        cmp     byte ptr player, 01d
        jne     testplayer_one_3
        jmp     test_next_rotate
testplayer_one_3:
        cmp     byte ptr player, 03d
        jne     testplayer_two
        ;........................... for player 1 .........................

test_next_rotate:
        cmp     al, 048h                    ; for  (rotate) 0
        jne     test_next_left
        call    rotate
        jmp     processed

test_next_left:
        cmp     al, 04bh                    ; for  0
        jne     test_next_right
        call    left
        jmp     processed

test_next_right:
        cmp     al, 04dh                    ; for  0
        jne     test_next_down
        call    right
        jmp     processed

test_next_down:
        cmp     al, 050h                    ; for  0
        jne     testplayer_two
        call    down
        jmp     processed


testplayer_two:
        cmp     byte ptr player, 02d
        jne     testplayer_two_3
        jmp     test_next_rotate1
testplayer_two_3:
        cmp     byte ptr player, 03d
        jne     test_next_new1play
        ;........................... for player 2 .........................
test_next_rotate1:
        cmp     al, 011h                    ; for w (rotate) 1
        jne     test_next_left1
        call    rotate_1
        jmp     processed

test_next_left1:
        cmp     al, 01eh                    ; for a (left) 1
        jne     test_next_right1
        call    left_1
        jmp     processed

test_next_right1:
        cmp     al, 01fh                    ; for s (right) 1
        jne     test_next_down1
        call    right_1
        jmp     processed

test_next_down1:
        cmp     al, 02ch                    ; for z (down) 1
        jne     test_next_new1play
        call    down_1
        jmp     processed


        ;....................... game control .......................

test_next_new1play:
        cmp     al, 03bh                        ; for new game(F1)
        jne     test_next_new2play
        call    check_high
        mov     byte ptr player, 01d            ; for 1 player (1)
        call    set_new
        jmp     processed

test_next_new2play:
        cmp     al, 03ch                        ; for new game(F2)
        jne     test_next_pause
        call    check_high
        mov     byte ptr player, 03d            ; for 2 player (2)
        call    set_new
        jmp     processed

test_next_pause:
        cmp     al, 0c5h                        ; for pause
        jne     test_next_Alt
        call    pause_press
        jmp     process_with_no_refresh

test_next_Alt:
        cmp     al, 038h                        ; for Alt(help)
        jne     test_next_pageup
        call    show_help
        jmp     process_with_no_refresh

test_next_pageup:
        cmp     al, 049h                        ; for speed up(PageUP)
        jne     test_next_pagedown              ; by dec time
        cmp     byte ptr time, 01d
        jbe     nospeedup
        dec     byte ptr time
        call    show_speed
        jmp     process_with_no_refresh
nospeedup:

test_next_pagedown:
        cmp     al, 051h                        ; for speed down(PageDown)
        jne     test_next_ESC                   ; by inc time
        cmp     byte ptr time, 09d
        jae     nospeeddown
        inc     byte ptr time
        call    show_speed
        jmp     process_with_no_refresh
nospeeddown:

test_next_ESC:
        cmp  al, 01h                    ; for ESC
        je   ESCpressed

        jmp     check_time              ; if key no match then check time

processed:
        call    element
        call    refresh
        call    element1
        call    refresh1
process_with_no_refresh:
        mov     ax, 0040h               ; clear keyboard my buffer after process
        mov     es, ax
        mov     di, 00feh
        mov     byte ptr es:[di], 00h
        

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~ check time ~~~~~~~~~~~~~~~~~~~~~~~~~~
check_time:
        MOV     AX, 0040H               ; check time < counter
        MOV     ES, AX
        MOV     DI, 00FFH
        MOV     AL, BYTE PTR ES:[DI]
        CMP     AL, TIME
        Ja      skip_wait_time
        jmp     waittime
;------------------------- end loop wait time ----------------------

skip_wait_time:
                                        ; test player before moving down
        cmp     byte ptr player, 01d
        jne     test_player_one_down3
        jmp     player1down
test_player_one_down3:
        cmp     byte ptr player, 03d
        jne     testplayer_two_down

player1down:
        call    down
        CALL    ELEMENT
        CALL    REFRESH

testplayer_two_down:
        cmp     byte ptr player, 02d
        jne     test_player_two_down3
        jmp     player2down
test_player_two_down3:
        cmp     byte ptr player, 03d
        jne     noplayer_two_down

player2down:
        CALL    DOWN_1
        call    element1
        call    refresh1
noplayer_two_down:
        JMP     MAIN_LOOP

ESCpressed:
        call    check_high

;*************************** Restore anything ******************
        call    fade_out
        CALL    RET09
        CALL    RET1C
        CALL    RESTORESCR
        call    fade_into
;***************************************************************

        MOV     AH, 02H         ; set position of cursor at r24, c81
        MOV     BH, 00H         ; do this technic for hide cursor
        MOV     DH, 24D
        MOV     DL, 00D
        INT     10H

        lea     dx, last_message    ; print last message in the true
        mov     ah, 09h             ; version I will remove it !!!
        int     21h

        MOV     AX, 4C00H           ; End program
        INT     21H

MAIN    ENDP
;-------------------------------------------------------------------
                ; Check video mode and change if not mode 3
VIDEO   PROC NEAR

        PUSH AX
        PUSH BX
        ;+++++++++++++++++++++++++++

        MOV  AH, 0FH
        INT  10H
        CMP  AL, 03H            ; is mode 3 ?
        JE   CHECKPAGE          ; if [yes] continue to check page
        MOV  AX, 0003H          ; function 00, mode 3 (set video mode)
        INT  10H
        JMP  ENDCHANGE

CHECKPAGE:
        CMP  BH, 00H            ; is page 0 ?
        JE   ENDCHANGE
        MOV  AX, 0500H          ; function 5, page 0 (set active page)
        INT  10H

ENDCHANGE:
        ;+++++++++++++++++++++++++++
        POP BX
        POP  AX
        RET

VIDEO   ENDP
;-------------------------------------------------------------------
                        ; save screen
SAVESCR PROC    NEAR
        PUSH    AX
        PUSH    DS
        PUSH    ES
        PUSH    DI
        PUSH    SI
        ;+++++++++++++++++++++++++++

        MOV     AX, DS          ; prepare ES
        MOV     ES, AX
        LEA     DI, SAVESCREEN  ; prepare DI
        MOV     AX, 0B800H      ; prepare DS
        MOV     DS, AX
        MOV     SI, 00H         ; prepare SI

        MOV     CX, 2000D       ; repeat 4000 time
LOOP_SAVESCR:
        MOVSW
        LOOP    LOOP_SAVESCR     ;

        ;+++++++++++++++++++++++++++
        POP     SI
        POP     DI
        POP     ES
        POP     DS
        POP     AX
        RET
SAVESCR ENDP
;-------------------------------------------------------------------
                        ; restore screen
RESTORESCR      PROC    NEAR
        PUSH    AX
        PUSH    DS
        PUSH    ES
        PUSH    DI
        PUSH    SI
        ;+++++++++++++++++++++++++++

        MOV     AX, 0B800H      ; prepare ES
        MOV     ES, AX
        MOV     DI, 00H         ; prepare DI
        LEA     SI, SAVESCREEN  ; prepare SI

        MOV     CX, 2000D       ; repeat 4000 time
LOOP_RESTORESCR:
        MOVSW
        LOOP    LOOP_RESTORESCR     ;

        ;+++++++++++++++++++++++++++
        POP     SI
        POP     DI
        POP     ES
        POP     DS
        POP     AX
        RET
RESTORESCR      ENDP
;-------------------------------------------------------------------
                ; Hide cursor
HIDECURSOR      PROC    NEAR
        PUSH    AX
        PUSH    CX
        ;+++++++++++++++++++++++++++

        MOV     AH, 02H         ; set position of cursor at r24, c81
        MOV     BH, 00H         ; do this technic for hide cursor
        MOV     DH, 24D
        MOV     DL, 81D
        INT     10H

        ;+++++++++++++++++++++++++++
        POP     CX
        POP     AX
        RET
HIDECURSOR     ENDP
;-------------------------------------------------------------------
                ; Get interrupt vector numver 1C for time trick
GET1C   PROC NEAR
        PUSH DI
        PUSH AX
        PUSH ES
        PUSH BX
        ;+++++++++++++++++++++++++++

        MOV  AX, 0351CH        ; function 35h interrupt 1ch
        INT  21H
        MOV  INT1CSEG, ES
        MOV  INT1COFF, BX

        ;+++++++++++++++++++++++++++
        POP  BX
        POP  ES
        POP  AX
        POP  DI
        RET

GET1C   ENDP
;-------------------------------------------------------------------
                ; Set interrupt vector number 1C for time trick
SET1C   PROC NEAR
        PUSH    ES
        PUSH    DI
        PUSH    DX
        PUSH    AX
        PUSH    DS
        ;+++++++++++++++++++++++++++

        MOV   AX, CS
        MOV   DS, AX
        LEA   DX, INT1CSERVICE

        ; TESTINT        ; ?????? is address at my interrupt service routine
        MOV   AX, 0251CH        ; function 25h for set interrupt 1ch routine
        INT   21H

        ;.......... store value of counter and my key board buffer ..........
        POP     DS
        MOV     AX, 0040H
        MOV     ES, AX
        MOV     DI, 0FEH
        MOV     AX, WORD PTR ES:[DI]
        MOV     RESTORE_FE, AX
        ;....................................................................
        
        ;+++++++++++++++++++++++++++
        POP     AX                      ; already pop ds
        POP     DX
        POP     DI
        POP     ES
        RET

SET1C   ENDP
;-------------------------------------------------------------------
                ; Return interrupt vector number 1C
RET1C   PROC NEAR
        PUSH    ES
        PUSH    DI
        PUSH    DX
        PUSH    AX
        PUSH    DS
        ;+++++++++++++++++++++++++++

        MOV   DX, INT1COFF
        MOV   AX, INT1CSEG
        MOV   DS, AX
        MOV   AX, 0251CH        ; function 25h for set interrupt 1ch routine
        INT   21H

        ;........ restore value of counter and my key board buffer ..........
        POP     DS
        MOV     AX, 0040H
        MOV     ES, AX
        MOV     DI, 0FEH
        MOV     AX, RESTORE_FE
        MOV     WORD PTR ES:[DI], AX
        ;....................................................................

        ;+++++++++++++++++++++++++++
        POP     AX                      ; already pop ds
        POP     DX
        POP     DI
        POP     ES
        RET

RET1C   ENDP
;-------------------------------------------------------------------
INT1CSERVICE    PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        PUSH    CX
        PUSH    DX
        ;+++++++++++++++++++++++++++

        MOV     AX, 0B800H
        MOV     ES, AX
        MOV     DI, 3982D

        MOV     AL, 00H                 ; read second from CMOS
        OUT     70H, AL
        IN      AL, 71H
        MOV     DH, AL

        MOV     AL, 02H                 ; read minute from CMOS
        OUT     70H, AL
        IN      AL, 71H
        MOV     CL, AL

        MOV     AL, 04H
        OUT     70H, AL
        IN      AL, 71H
        MOV     CH, AL

;        MOV     AH, 02H                ; no use because it late
;        INT     1AH
;        JC      CANTREAD                ; skip if cf=1

        MOV     AX, 00D                 ; process hour
        MOV     AL, CH
        SHL     AX, 04D

        MOV     AL, CH
        AND     AL, 0FH
        AND     AH, 0FH
        XCHG    AL, AH

        ADD     AL, 30H
        STOSB
        INC     DI
        XCHG    AL, AH
        ADD     AL, 30H
        STOSB
        ADD     DI, 03D
        MOV     AX, 00D                 ; process minute
        MOV     AL, CL
        SHL     AX, 04D
        MOV     AL, CL
        AND     AL, 0FH
        AND     AH, 0FH
        XCHG    AL, AH
        ADD     AL, 30H
        STOSB
        INC     DI
        XCHG    AL, AH
        ADD     AL, 30H
        STOSB
        ADD     DI, 03D
        MOV     AX, 00D                 ; process second
        MOV     AL, DH
        SHL     AX, 04D
        MOV     AL, DH
        AND     AL, 0FH
        AND     AH, 0FH
        XCHG    AL, AH

        ADD     AL, 30H
        STOSB
        INC     DI
        XCHG    AL, AH
        ADD     AL, 30H
        STOSB

        ;================= counter ====================
        MOV     AX, 0040H
        MOV     ES, AX
        MOV     DI, 0FFH
        INC     BYTE PTR ES:[DI]
        ;==============================================

CANTREAD:
        ;+++++++++++++++++++++++++++
        POP     DX
        POP     CX
        POP     DI
        POP     ES
        POP     AX
        IRET                    ; please check before running *****

INT1CSERVICE    ENDP
;-------------------------------------------------------------------
                ; Get interrupt vector numver 09 for keyboard
GET09   PROC NEAR

        PUSH AX
        PUSH ES
        PUSH BX
        ;+++++++++++++++++++++++++++

        MOV  AX, 03509H        ; function 35h interrupt 09h
        INT  21H
        MOV  INT09SEG, ES
        MOV  INT09OFF, BX

        ;+++++++++++++++++++++++++++
        POP  BX
        POP  ES
        POP  AX
        RET

GET09   ENDP
;-------------------------------------------------------------------
                ; Set interrupt vector number 09 for keyboard
SET09   PROC NEAR
        PUSH    DX
        PUSH    AX
        PUSH    DS
        ;+++++++++++++++++++++++++++

        MOV   AX, CS
        MOV   DS, AX
        LEA   DX, INT09SERVICE

        ; int09service is address at my interrupt service routine
        MOV   AX, 02509H        ; function 25h for set interrupt 09h routine
        INT   21H

        ;+++++++++++++++++++++++++++
        POP     DS
        POP     AX
        POP     DX
        RET

SET09   ENDP
;-------------------------------------------------------------------
                ; Return interrupt vector number 09
RET09   PROC NEAR
        PUSH    DX
        PUSH    AX
        PUSH    DS
        ;+++++++++++++++++++++++++++

        MOV   DX, INT09OFF
        MOV   AX, INT09SEG
        MOV   DS, AX
        MOV   AX, 02509H        ; function 25h for set interrupt 09h routine
        INT   21H

        ;+++++++++++++++++++++++++++
        POP     DS
        POP     AX
        POP     DX
        RET

RET09   ENDP
;-------------------------------------------------------------------
INT09SERVICE    PROC  NEAR
        cli
        push es
        push di
        push ax
        push bx

;        mov  ax, 0f00h                  ; text attribute
        in   al, 60h

;        mov  bx, 0b800h                 ; implement by TAO
;        mov  es, bx                     ; write to display
;        mov  di, 00d
;        mov  word ptr es:[di], ax

        mov  bx, 0040h
        mov  es, bx
        mov  di, 0feh                   ; use 0040:00fe to keyboard buffer

        mov  byte ptr es:[di], al       ; store buffer

        ;******************* REQUIRE FOR INT 09H ********************
        mov  al, 20h                    ; for nospecific EOI
        out  20h, al
        ;************************************************************

        pop  bx
        pop  ax
        pop  di
        pop  es
        sti
        IRET

INT09SERVICE    ENDP
;-------------------------------------------------------------------
                ; Draw Border
BORDER  PROC    NEAR
        PUSH    AX
        PUSH    CX
        PUSH    ES
        PUSH    DI
        ;+++++++++++++++++++++++++++

        MOV     DI, 167D               ; set starting address block 1
        mov     CX, 02D
loop_border0:
        PUSH    CX
        MOV     AX, 0B800H             ; set segment of video buffer
        MOV     ES, AX

        
        MOV     AL, 055H               ; set border color  ****

        MOV     CX, 21D                ; write 21 line

LOOP_BORDER1:                          ; write two arm
        STOSB
        INC     DI
        STOSB

        ADD     DI, 41D                ; write next column
        STOSB
        INC     DI
        STOSB
        ADD     DI, 113D               ; write next line
        LOOP    LOOP_BORDER1

        MOV     CX, 24D
LOOP_BORDER2:                           ; write buttom
        STOSB
        INC     DI
        LOOP    LOOP_BORDER2
        pop     cx
        mov     di, 269d
        loop    loop_border0

        mov     di, 3696d               ; write "Player 1 : "
        lea     SI, NAME1
        MOV     CX,  10D
LOOP_BORDER3:
        LODSB
        MOV     AH, 0FH                 ; text attribute
        STOSW
        LOOP    LOOP_BORDER3

        mov     di, 3798d               ; write "Player 2 : "
        MOV     CX, 10D
LOOP_BORDER4:
        LODSB
        MOV     AH, 0BH                 ; text attribute
        STOSW
        LOOP    LOOP_BORDER4

        ;+++++++++++++++++++++++++++
        POP     DI
        POP     ES
        POP     CX
        POP     AX
        RET
BORDER  ENDP
;-------------------------------------------------------------------
                        ; Print Help bar at bottom of screen
PRINTBAR        PROC    NEAR
        PUSH    AX
        PUSH    CX
        PUSH    ES
        PUSH    DI
        PUSH    SI
        ;+++++++++++++++++++++++++++
                      
        MOV     AX, 0B800H
        MOV     ES, AX

        MOV     DI, 3840D
        LEA     SI, HELPBAR
        MOV     CX, 23D         ; write 23 character

LOOP_PRINTBAR1:                 ; write character
        MOVSB
        INC     DI
        LOOP    LOOP_PRINTBAR1


        MOV     CX, 70D
        MOV     AL, 01EH         ; attribute

        MOV     DI, 3841D
LOOP_PRINTBAR2:                 ; set character attribute
        STOSB
        INC     DI
        LOOP    LOOP_PRINTBAR2


; ------------------ prepare anything for clock -----------------
        MOV     CX, 60D
        MOV     AL, 01FH        ; attribute for clock

        MOV     DI, 3981D
LOOP_PRINTBAR21:
        STOSB
        INC     DI
        LOOP    LOOP_PRINTBAR21

        MOV     DI, 3986D       ; write :(3A) with attribute 17h
        MOV     AX, 173AH
        STOSW

        ADD     DI, 04D         ; write :(3A) with attribute 17h
        MOV     AX, 173AH
        STOSW

        MOV     DI, 3845D       ; set color to special character
        MOV     AL, 1CH
        MOV     CX, 03D
LOOP_PRINTBAR3:
        STOSB
        INC     DI
        LOOP    LOOP_PRINTBAR3

        ADD     DI, 16D
        mov     cx, 03d
loop_printbar4:        
        STOSB
        inc     di
        LOOP    LOOP_PRINTBAR4

        ;+++++++++++++++++++++++++++
        POP     SI
        POP     DI
        POP     ES
        POP     CX
        POP     AX
        RET
PRINTBAR        ENDP
;-------------------------------------------------------------------
                        ; Put block (€€) of tetris
PUTBLOCK        PROC    NEAR
        PUSH    AX
        PUSH    CX
        ;+++++++++++++++++++++++++++

        CMP     BLOCKCOLOR, 01H         ; test blockcolor is 1
        JNE     TEST2
        MOV     AH, 0aH                 ; if yes put green color
        JMP     PUTCHAR
TEST2:
        CMP     BLOCKCOLOR, 02H         ; test blockcolor is 2
        JNE     TEST0
        MOV     AH, 77H                 ; if yes put gray color
        JMP     PUTCHAR
TEST0:
        MOV     AH, 00H                 ; if anothor then put black color

PUTCHAR:
        ;*********************  put my character 2 time
        MOV     AL, 0b1H                ; ascii number 0b1h
        STOSW
        MOV     AL, 0b2H                ; ascii number 0b2h
        STOSW

        ;+++++++++++++++++++++++++++
        POP     CX
        POP     AX
        RET
PUTBLOCK        ENDP
;-------------------------------------------------------------------
                        ; refresh array of table
REFRESH PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        PUSH    SI
        PUSH    CX
        PUSH    BX
        ;+++++++++++++++++++++++++++

        MOV     AX, 0B800H
        MOV     ES, AX
        MOV     BX, 00H         ; use bh to indicate jump next line
        MOV     DI, 272D        ; starting of block
        MOV     CX, 210D        ; repeat 210 time(equal element in array)
        LEA     SI, ARRAY       ; set address of array to indicate

LOOP_REFRESH:
        MOV     BL, BYTE PTR [SI]
        MOV     BLOCKCOLOR, BL
        CALL    PUTBLOCK
        INC     SI
        INC     BH
        CMP     BH, 10D         ; if bh = 10 then jump to next line
        JNE     REFRESH_CON
        ADD     DI, 120D
        MOV     BH, 00H
REFRESH_CON:
        LOOP    LOOP_REFRESH

        ;+++++++++++++++++++++++++++
        POP     BX
        POP     CX
        POP     SI
        POP     DI
        POP     ES
        POP     AX
        RET
REFRESH ENDP
;-------------------------------------------------------------------
                        ; Put block (€€) of tetris
PUTBLOCK1       PROC    NEAR
        PUSH    AX
        PUSH    CX
        ;+++++++++++++++++++++++++++

        CMP     BLOCKCOLOR, 01H         ; test blockcolor is 1
        JNE     TEST1_2
        MOV     AH, 0cH                 ; if yes put green color
        JMP     PUTCHAR
TEST1_2:
        CMP     BLOCKCOLOR, 02H         ; test blockcolor is 2
        JNE     TEST1_0
        MOV     AH, 77H                 ; if yes put gray color
        JMP     PUTCHAR_1
TEST1_0:
        MOV     AH, 00H                 ; if anothor then put black color

PUTCHAR_1:
        ;*********************  put my character 2 time
        MOV     AL, 0b1H                ; ascii number 0b1h
        STOSW
        MOV     AL, 0b2H                ; ascii number 0b2h
        STOSW

        ;+++++++++++++++++++++++++++
        POP     CX
        POP     AX
        RET
PUTBLOCK1       ENDP
;-------------------------------------------------------------------

                        ; refresh array 1 of table
REFRESH1        PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        PUSH    SI
        PUSH    CX
        PUSH    BX
        ;+++++++++++++++++++++++++++

        MOV     AX, 0B800H
        MOV     ES, AX
        MOV     BX, 00H         ; use bh to indicate jump next line
        MOV     DI, 170D        ; starting of block
        MOV     CX, 210D        ; repeat 210 time(equal element in array)
        LEA     SI, ARRAY1      ; set address of array to indicate

LOOP_REFRESH1:
        MOV     BL, BYTE PTR [SI]
        MOV     BLOCKCOLOR, BL
        CALL    PUTBLOCK1
        INC     SI
        INC     BH
        CMP     BH, 10D         ; if bh = 10 then jump to next line
        JNE     REFRESH1_CON
        ADD     DI, 120D
        MOV     BH, 00H
REFRESH1_CON:
        LOOP    LOOP_REFRESH1

        ;+++++++++++++++++++++++++++
        POP     BX
        POP     CX
        POP     SI
        POP     DI
        POP     ES
        POP     AX
        RET
REFRESH1        ENDP
;-------------------------------------------------------------------
                        ; clear moving block
CLEARMOVING     PROC    NEAR
        PUSH    DI
        PUSH    CX
        ;+++++++++++++++++++++++++++

        LEA     DI, ARRAY
        MOV     CX, 210D                ; repeat 210 element

CLEARMOVING_1:
        CMP     BYTE PTR DS:[DI], 01D
        JNE     NEXT
        MOV     BYTE PTR DS:[DI], 00D

NEXT:
        INC     DI
        LOOP    CLEARMOVING_1

        ;+++++++++++++++++++++++++++
        POP     CX
        POP     DI
        RET
CLEARMOVING     ENDP
;-------------------------------------------------------------------
                        ; clear moving block1
CLEARMOVING1    PROC    NEAR
        PUSH    DI
        PUSH    CX
        ;+++++++++++++++++++++++++++

        LEA     DI, ARRAY1
        MOV     CX, 210D                ; repeat 210 element

CLEARMOVING1_1:
        CMP     BYTE PTR DS:[DI], 01D
        JNE     NEXT_1
        MOV     BYTE PTR DS:[DI], 00D

NEXT_1:
        INC     DI
        LOOP    CLEARMOVING1_1

        ;+++++++++++++++++++++++++++
        POP     CX
        POP     DI
        RET
CLEARMOVING1    ENDP
;-------------------------------------------------------------------
                       ; procedure for refresh element to array
ELEMENT PROC    NEAR

;               calculate di = center of element

        MOV     AX, DS
        MOV     ES, AX

        MOV     AL, 10D                ; store posy for multiply
        LEA     DI, ARRAY              ; clear si for put position

        MUL     POSY                   ; calculate for put element
        ADD     DI, AX
        MOV     AX, 00H
        MOV     AL, POSX
        ADD     DI, AX
        MOV     AL, 01D                 ; for 1 = moving element

;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 1                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
        CMP     TYPEELE, 01D            ; test type of element = 1
        JNE     NEXTTYPE2

        MOV     CX, 04                  ; put 4 block

        CMP     FORM, 01D               ; if form = 1 then do
        JNE     TEST1_FORM2              ; else form = 2 or other

        DEC     DI
LOOP_TYPE1_FORM1:
        STOSB
        LOOP    LOOP_TYPE1_FORM1

        JMP     NO2

TEST1_FORM2:
        CMP     FORM, 02D               ; if form <> 2 then no match
        JNE     NO2

        SUB     DI, 10D

LOOP_TYPE1_FORM2:
        STOSB
        ADD     DI, 10D
        DEC     DI
        LOOP    LOOP_TYPE1_FORM2
        JMP     NO2

NO2:    JMP     NO3
;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 2                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
NEXTTYPE2:
        CMP     TYPEELE, 02D             ; test type of element = 2
        JNE     NEXTTYPE3
        CMP     FORM, 01D               ; if form = 1 then do
        JNE     TEST2_FORM2             ; else form = 2 or other

        DEC     DI
        STOSB
        STOSB
        ADD     DI, 09D
        STOSB
        STOSB
        JMP     NO3                     ; quit subroutine

TEST2_FORM2:
        CMP     FORM, 02D               ; if form <> 2 then no match
        JNE     NO3

        STOSB
        STOSB
        SUB     DI, 11D
        STOSB
        ADD     DI, 18D
        STOSB
        JMP     NO3

NO3:    JMP     NO4
;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 3                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
NEXTTYPE3:
        CMP     TYPEELE, 03D            ; test type of element = 3
        JNE     NEXTTYPE4
        CMP     FORM, 01D               ; if form = 1 then do
        JNE     NO4                     ; else form = 2 or other

        STOSB
        STOSB
        ADD     DI, 08D
        STOSB
        STOSB
        JMP     NO4

NO4:    JMP     NO5
;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 4                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
NEXTTYPE4:
        CMP     TYPEELE, 04D             ; test type of element = 4
        JNE     NEXTTYPE5
        CMP     FORM, 01D               ; if form = 1 then do
        JNE     TEST4_FORM2             ; else form = 2 or other

        STOSB
        STOSB
        ADD     DI, 07D
        STOSB
        STOSB
        


TEST4_FORM2:
        CMP     FORM, 02D
        JNE     NO5

        STOSB
        STOSB
        SUB     DI, 12D
        STOSB
        ADD     DI, 20D
        STOSB
        JMP     NO5

NO5:    JMP     NO6
;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 5                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
NEXTTYPE5:
        CMP     TYPEELE, 05D            ; test type of element = 5
        JNE     NEXTTYPE6
        CMP     FORM, 01D               ; if form = 1 then do
        JNE     TEST5_FORM2             ; else form = 2 or other

        DEC     DI
        STOSB
        STOSB
        STOSB
        ADD     DI, 09D
        STOSB
        JMP     NO6                     ; quit subroutine


TEST5_FORM2:
        CMP     FORM, 02D               ; if form = 2 then do
        JNE     TEST5_FORM3             ; else form = 3 or other

        STOSB
        SUB     DI, 11D
        STOSB
        STOSB
        ADD     DI, 18D
        STOSB
        JMP     NO6                     ; quit subroutine

TEST5_FORM3:
        CMP     FORM, 03D               ; if form = 3 then do
        JNE     TEST5_FORM4             ; else form = 4 or other

        DEC     DI
        STOSB
        STOSB
        STOSB
        SUB     DI, 13D
        STOSB
        JMP     NO6                     ; quit subroutine

TEST5_FORM4:
        CMP     FORM, 04D               ; if form = 4 then do
        JNE     NO6                     ; else form = no match

        STOSB
        SUB     DI, 11D
        STOSB
        ADD     DI, 18D
        STOSB
        STOSB

NO6:    JMP     NO7
;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 6                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
NEXTTYPE6:
        CMP     TYPEELE, 06D             ; test type of element = 6
        JNE     NEXTTYPE7
        CMP     FORM, 01D               ; if form = 1 then do
        JNE     TEST6_FORM2             ; else form = 2 or other

        DEC     DI
        STOSB
        STOSB
        STOSB
        ADD     DI, 07D
        STOSB
        JMP     NO7                     ; quit subroutine

TEST6_FORM2:
        CMP     FORM, 02D               ; if form = 2 then do
        JNE     TEST6_FORM3             ; else form = 3 or other

        STOSB
        SUB     DI, 11D
        STOSB
        ADD     DI, 19D
        STOSB
        STOSB
        JMP     NO7                     ; quit subroutine

TEST6_FORM3:
        CMP     FORM, 03D               ; if form = 3 then do
        JNE     TEST6_FORM4             ; else form = 4 or other

        DEC     DI
        STOSB
        STOSB
        STOSB
        SUB     DI, 11D
        STOSB
        JMP     NO7                     ; quit subroutine

TEST6_FORM4:
        CMP     FORM, 04D               ; if form = 4 then do
        JNE     NO7                     ; else form = no match

        STOSB
        SUB     DI, 12D
        STOSB
        STOSB
        ADD     DI, 19D
        STOSB

NO7:    JMP     NO
;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 7                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
NEXTTYPE7:
        CMP     TYPEELE, 07D            ; test type of element = 7
        JNE     NO
        CMP     FORM, 01D               ; if form = 1 then do
        JNE     TEST7_FORM2             ; else form = 2 or other

        DEC     DI
        STOSB
        STOSB
        STOSB
        ADD     DI, 08D
        STOSB
        JMP     NO                      ; quit subroutine

TEST7_FORM2:
        CMP     FORM, 02D               ; if form = 2 then do
        JNE     TEST7_FORM3             ; else form = 3 or other

        STOSB
        STOSB
        SUB     DI, 12D
        STOSB
        ADD     DI, 19D
        STOSB
        JMP     NO                      ; quit subroutine

TEST7_FORM3:
        CMP     FORM, 03D               ; if form = 3 then do
        JNE     TEST7_FORM4             ; else form = 4 or other

        DEC     DI
        STOSB
        STOSB
        STOSB
        SUB     DI, 12D
        STOSB
        JMP     NO                      ; quit subroutine

TEST7_FORM4:
        CMP     FORM, 04D               ; if form = 4 then do
        JNE     NO                      ; else form = no match

        DEC     DI
        STOSB
        STOSB
        SUB     DI, 11D
        STOSB
        ADD     DI, 19D
        STOSB

NO:
        RET

ELEMENT ENDP
;-------------------------------------------------------------------
                       ; procedure for refresh element to array1
ELEMENT1        PROC    NEAR

;               calculate di = center of element

        MOV     AX, DS
        MOV     ES, AX

        MOV     AL, 10D                ; store posy for multiply
        LEA     DI, ARRAY1             ; clear si for put position

        MUL     POSY1                  ; calculate for put element
        ADD     DI, AX
        MOV     AX, 00H
        MOV     AL, POSX1
        ADD     DI, AX
        MOV     AL, 01D                 ; for 1 = moving element

;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 1                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
        CMP     TYPEELE1, 01D            ; test type of element = 1
        JNE     NEXTTYPE1_2

        MOV     CX, 04                  ; put 4 block

        CMP     FORM1, 01D               ; if form = 1 then do
        JNE     TEST1_1_FORM2              ; else form = 2 or other

        DEC     DI
        rep     STOSB

        JMP     NO1_2

TEST1_1_FORM2:
        CMP     FORM1, 02D               ; if form <> 2 then no match
        JNE     NO1_2

        SUB     DI, 10D

LOOP_TYPE1_FORM2_1:
        STOSB
        ADD     DI, 10D
        DEC     DI
        LOOP    LOOP_TYPE1_FORM2_1
        JMP     NO1_2

NO1_2:    JMP     NO1_3
;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 2                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
NEXTTYPE1_2:
        CMP     TYPEELE1, 02D             ; test type of element = 2
        JNE     NEXTTYPE1_3
        CMP     FORM1, 01D               ; if form = 1 then do
        JNE     TEST1_2_FORM2             ; else form = 2 or other

        DEC     DI
        STOSB
        STOSB
        ADD     DI, 09D
        STOSB
        STOSB
        JMP     NO1_3                     ; quit subroutine

TEST1_2_FORM2:
        CMP     FORM1, 02D               ; if form <> 2 then no match
        JNE     NO1_3

        STOSB
        STOSB
        SUB     DI, 11D
        STOSB
        ADD     DI, 18D
        STOSB
        JMP     NO1_3

NO1_3:    JMP     NO1_4
;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 3                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
NEXTTYPE1_3:
        CMP     TYPEELE1, 03D            ; test type of element = 3
        JNE     NEXTTYPE1_4
        CMP     FORM1, 01D               ; if form = 1 then do
        JNE     NO1_4                     ; else form = 2 or other

        STOSB
        STOSB
        ADD     DI, 08D
        STOSB
        STOSB
        JMP     NO1_4

NO1_4:    JMP     NO1_5
;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 4                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
NEXTTYPE1_4:
        CMP     TYPEELE1, 04D             ; test type of element = 4
        JNE     NEXTTYPE1_5
        CMP     FORM1, 01D               ; if form = 1 then do
        JNE     TEST1_4_FORM2             ; else form = 2 or other

        STOSB
        STOSB
        ADD     DI, 07D
        STOSB
        STOSB

TEST1_4_FORM2:
        CMP     FORM1, 02D
        JNE     NO1_5

        STOSB
        STOSB
        SUB     DI, 12D
        STOSB
        ADD     DI, 20D
        STOSB

NO1_5:    JMP     NO1_6
;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 5                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
NEXTTYPE1_5:
        CMP     TYPEELE1, 05D            ; test type of element = 5
        JNE     NEXTTYPE1_6
        CMP     FORM1, 01D               ; if form = 1 then do
        JNE     TEST1_5_FORM2             ; else form = 2 or other

        DEC     DI
        STOSB
        STOSB
        STOSB
        ADD     DI, 09D
        STOSB
        JMP     NO1_6                     ; quit subroutine


TEST1_5_FORM2:
        CMP     FORM1, 02D               ; if form = 2 then do
        JNE     TEST1_5_FORM3             ; else form = 3 or other

        STOSB
        SUB     DI, 11D
        STOSB
        STOSB
        ADD     DI, 18D
        STOSB
        JMP     NO1_6                     ; quit subroutine

TEST1_5_FORM3:
        CMP     FORM1, 03D               ; if form = 3 then do
        JNE     TEST1_5_FORM4             ; else form = 4 or other

        DEC     DI
        STOSB
        STOSB
        STOSB
        SUB     DI, 13D
        STOSB
        JMP     NO1_6                     ; quit subroutine

TEST1_5_FORM4:
        CMP     FORM1, 04D               ; if form = 4 then do
        JNE     NO1_6                     ; else form = no match

        STOSB
        SUB     DI, 11D
        STOSB
        ADD     DI, 18D
        STOSB
        STOSB

NO1_6:    JMP     NO1_7
;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 6                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
NEXTTYPE1_6:
        CMP     TYPEELE1, 06D             ; test type of element = 6
        JNE     NEXTTYPE1_7
        CMP     FORM1, 01D               ; if form = 1 then do
        JNE     TEST1_6_FORM2             ; else form = 2 or other

        DEC     DI
        STOSB
        STOSB
        STOSB
        ADD     DI, 07D
        STOSB
        JMP     NO1_7                     ; quit subroutine

TEST1_6_FORM2:
        CMP     FORM1, 02D               ; if form = 2 then do
        JNE     TEST1_6_FORM3             ; else form = 3 or other

        STOSB
        SUB     DI, 11D
        STOSB
        ADD     DI, 19D
        STOSB
        STOSB
        JMP     NO1_7                     ; quit subroutine

TEST1_6_FORM3:
        CMP     FORM1, 03D               ; if form = 3 then do
        JNE     TEST1_6_FORM4             ; else form = 4 or other

        DEC     DI
        STOSB
        STOSB
        STOSB
        SUB     DI, 11D
        STOSB
        JMP     NO1_7                     ; quit subroutine

TEST1_6_FORM4:
        CMP     FORM1, 04D               ; if form = 4 then do
        JNE     NO1_7                     ; else form = no match

        STOSB
        SUB     DI, 12D
        STOSB
        STOSB
        ADD     DI, 19D
        STOSB

NO1_7:    JMP     NO_1
;⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
;≥                            TYPE 7                                 ≥
;¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
NEXTTYPE1_7:
        CMP     TYPEELE1, 07D            ; test type of element = 7
        JNE     NO_1
        CMP     FORM1, 01D               ; if form = 1 then do
        JNE     TEST1_7_FORM2             ; else form = 2 or other

        DEC     DI
        STOSB
        STOSB
        STOSB
        ADD     DI, 08D
        STOSB
        JMP     NO_1                      ; quit subroutine

TEST1_7_FORM2:
        CMP     FORM1, 02D               ; if form = 2 then do
        JNE     TEST1_7_FORM3             ; else form = 3 or other

        STOSB
        STOSB
        SUB     DI, 12D
        STOSB
        ADD     DI, 19D
        STOSB
        JMP     NO_1                      ; quit subroutine

TEST1_7_FORM3:
        CMP     FORM1, 03D               ; if form = 3 then do
        JNE     TEST1_7_FORM4             ; else form = 4 or other

        DEC     DI
        STOSB
        STOSB
        STOSB
        SUB     DI, 12D
        STOSB
        JMP     NO_1                      ; quit subroutine

TEST1_7_FORM4:
        CMP     FORM1, 04D               ; if form = 4 then do
        JNE     NO_1                      ; else form = no match

        DEC     DI
        STOSB
        STOSB
        SUB     DI, 11D
        STOSB
        ADD     DI, 19D
        STOSB

NO_1:
        RET

ELEMENT1        ENDP
;-------------------------------------------------------------------

DELAY   PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        ;+++++++++++++++++++++++++++

        MOV     AX, 0040H               ; prepare segment at 0040h
        MOV     ES, AX
        MOV     DI, 0FFH                ; and offset at 00ffh
        MOV     BYTE PTR ES:[DI], 00H   ; clear it before use

WAITDELAY:
        MOV     AL, ES:[DI]
        CMP     AL, TIME                ; compare
        JB      WAITDELAY

        ;+++++++++++++++++++++++++++
        POP     DI
        POP     ES
        POP     AX
        RET
DELAY   ENDP
;-------------------------------------------------------------------
                        ; procedure for moving down element
DOWN    PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        ;++++++++++++++++++++++++++++++++++++

        MOV     AX, DS
        MOV     ES, AX

        MOV     AL, 10D                 ; store posy for multiply
        LEA     DI, ARRAY               ; clear si for put position

        MUL     POSY                    ; calculate for put element
        ADD     DI, AX
        MOV     AX, 00H
        MOV     AL, POSX
        ADD     DI, AX                  ; di = center position of element
        
        CMP     TYPEELE, 01D            ; check type1
        JNE     TESTNEXTTYPED2
        CALL    DOWN1
        JMP     ENDDOWN
TESTNEXTTYPED2:
        CMP     TYPEELE, 02D            ; check type2
        JNE     TESTNEXTTYPED3
        CALL    DOWN2
        JMP     ENDDOWN

TESTNEXTTYPED3:
        CMP     TYPEELE, 03D            ; check type3
        JNE     TESTNEXTTYPED4
        CALL    DOWN3
        JMP     ENDDOWN

TESTNEXTTYPED4:
        CMP     TYPEELE, 04D            ; check type4
        JNE     TESTNEXTTYPED5
        CALL    DOWN4
        JMP     ENDDOWN

TESTNEXTTYPED5:
        CMP     TYPEELE, 05D            ; check type5
        JNE     TESTNEXTTYPED6
        CALL    DOWN5
        JMP     ENDDOWN

TESTNEXTTYPED6:
        CMP     TYPEELE, 06D            ; check type6
        JNE     TESTNEXTTYPED7
        CALL    DOWN6
        JMP     ENDDOWN

TESTNEXTTYPED7:
        CMP     TYPEELE, 07D            ; check type7
        JNE     ENDDOWN
        CALL    DOWN7

ENDDOWN:
        ;++++++++++++++++++++++++++++++++++++
        POP     DI
        POP     ES
        POP     AX

        RET

DOWN    ENDP
;-------------------------------------------------------------------
                        ; moving type 1 down
DOWN1   PROC    NEAR

        CMP     FORM, 01D
        JNE     DOWN1NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 09D

        CMP     POSY, 20D               ; if element stay at buttom of block
        JAE     ENDDOWN1
        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1
        ADD     DI, 02D
        CMP     WORD PTR DS:[DI], 00D
        JNE     ENDDOWN1

        JMP     DOWN1CALL

DOWN1NEXTFORM2:
        CMP     FORM, 02D
        JNE     ENDDOWN1                ; if not form 2 jmp no match type

        ADD     DI, 30D

        CMP     POSY, 18D               ; if element stay at buttom of block
        JAE     ENDDOWN1
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1

DOWN1CALL:
        INC     BYTE PTR POSY
        CALL    CLEARMOVING
        CALL    ELEMENT
        JMP     RETDOWN1
        
ENDDOWN1:
        CALL    NODOWN
RETDOWN1:
        RET
DOWN1   ENDP
;-------------------------------------------------------------------
                        ; moving type 2 down
DOWN2   PROC    NEAR

        CMP     FORM, 01D
        JNE     DOWN2NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 09D

        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN2
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN2
        ADD     DI, 11D
        CMP     WORD PTR DS:[DI], 00D
        JNE     ENDDOWN2

        JMP     DOWN2CALL

DOWN2NEXTFORM2:
        CMP     FORM, 02D
        JNE     ENDDOWN2                ; if not form 2 jmp no match type

        ADD     DI, 11D

        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN2

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN2
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN2

DOWN2CALL:
        INC     BYTE PTR POSY
        CALL    CLEARMOVING
        CALL    ELEMENT
        JMP     RETDOWN2
                    
ENDDOWN2:
        CALL    NODOWN
RETDOWN2:
        RET
DOWN2   ENDP
;-------------------------------------------------------------------
                        ; moving type 3 down
DOWN3   PROC    NEAR

        CMP     FORM, 01D
        JNE     ENDDOWN3                ; if not form 1 jmp no match type

        ADD     DI, 20D

        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN3

        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN3

        INC     BYTE PTR POSY

        CALL    CLEARMOVING
        CALL    ELEMENT
        JMP     RETDOWN3
                    
ENDDOWN3:
        CALL    NODOWN
RETDOWN3:
        RET
DOWN3   ENDP
;-------------------------------------------------------------------
                        ; moving type 4 down
DOWN4   PROC    NEAR

        CMP     FORM, 01D
        JNE     DOWN4NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 11D

        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN4
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN4
        ADD     DI, 08D
        CMP     WORD PTR DS:[DI], 00D
        JNE     ENDDOWN4

        JMP     DOWN4CALL

DOWN4NEXTFORM2:
        CMP     FORM, 02D
        JNE     ENDDOWN4                ; if not form 2 jmp no match type

        ADD     DI, 10D

        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN4

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN4
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN4

DOWN4CALL:
        INC     BYTE PTR POSY
        CALL    CLEARMOVING
        CALL    ELEMENT
        JMP     RETDOWN4
                    
ENDDOWN4:
        CALL    NODOWN
RETDOWN4:
        RET
DOWN4   ENDP
;-------------------------------------------------------------------
                        ; moving type 5 down
DOWN5   PROC    NEAR

        CMP     FORM, 01D
        JNE     DOWN5NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 09D

        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN5
        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN5
        ADD     DI, 12D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN5

        JMP     DOWN5CALL

DOWN5NEXTFORM2:
        CMP     FORM, 02D
        JNE     DOWN5NEXTFORM3          ; if not form 2 jmp to test next type

        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN5

        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN5
        ADD     DI, 19D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN5

        JMP     DOWN5CALL

DOWN5NEXTFORM3:
        CMP     FORM, 03D
        JNE     DOWN5NEXTFORM4          ; if not form 3 jmp to test next type

        ADD     DI, 09D

        CMP     POSY, 20D               ; if element stay at buttom of block
        JAE     ENDDOWN5

        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN5
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN5

        JMP     DOWN5CALL

DOWN5NEXTFORM4:
        CMP     FORM, 04D
        JNE     ENDDOWN5                ; if not form 4 jmp no match type

        ADD     DI, 19D
        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN5

        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN5

DOWN5CALL:
        INC     BYTE PTR POSY
        CALL    CLEARMOVING
        CALL    ELEMENT
        JMP     RETDOWN5
                    
ENDDOWN5:
        CALL    NODOWN
RETDOWN5:
        RET
DOWN5   ENDP
;-------------------------------------------------------------------
                        ; moving type 6 down
DOWN6   PROC    NEAR

        CMP     FORM, 01D
        JNE     DOWN6NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 10D

        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN6
        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN6
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN6

        JMP     DOWN6CALL

DOWN6NEXTFORM2:
        CMP     FORM, 02D
        JNE     DOWN6NEXTFORM3          ; if not form 2 jmp to test next type

        ADD     DI, 20D

        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN6

        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN6

        JMP     DOWN6CALL

DOWN6NEXTFORM3:
        CMP     FORM, 03D
        JNE     DOWN6NEXTFORM4          ; if not form 3 jmp to test next type

        ADD     DI, 09D

        CMP     POSY, 20D               ; if element stay at buttom of block
        JAE     ENDDOWN6

        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN6
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN6
        JMP     DOWN6CALL

DOWN6NEXTFORM4:
        CMP     FORM, 04D
        JNE     ENDDOWN6                ; if not form 4 jmp no match type

        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN6

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN6
        ADD     DI, 21D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN6

DOWN6CALL:
        INC     BYTE PTR POSY
        CALL    CLEARMOVING
        CALL    ELEMENT
        JMP     RETDOWN6
                    
ENDDOWN6:
        CALL    NODOWN
RETDOWN6:
        RET
DOWN6   ENDP
;-------------------------------------------------------------------
                        ; moving type 7 down
DOWN7   PROC    NEAR

        CMP     FORM, 01D
        JNE     DOWN7NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 09D

        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN7
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN7
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN7
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN7

        JMP     DOWN7CALL

DOWN7NEXTFORM2:
        CMP     FORM, 02D
        JNE     DOWN7NEXTFORM3          ; if not form 2 jmp to test next type

        ADD     DI, 11D

        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN7
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN7

        JMP     DOWN7CALL

DOWN7NEXTFORM3:
        CMP     FORM, 03D
        JNE     DOWN7NEXTFORM4          ; if not form 3 jmp to test next type

        ADD     DI, 09D

        CMP     POSY, 20D               ; if element stay at buttom of block
        JAE     ENDDOWN7

        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN7
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN7

DOWN7CALL:
        INC     BYTE PTR POSY
        CALL    CLEARMOVING
        CALL    ELEMENT
        JMP     RETDOWN7

ENDDOWN7:
        CALL    NODOWN
RETDOWN7:
        RET
        
DOWN7NEXTFORM4:
        CMP     FORM, 04D
        JNE     ENDDOWN7                ; if not form 4 jmp no match type

        ADD     DI, 09D
        CMP     POSY, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN7
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN7

        JMP     DOWN7CALL

DOWN7   ENDP
;-------------------------------------------------------------------
                        ; procedure for moving down element 1
DOWN_1   PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        ;++++++++++++++++++++++++++++++++++++

        MOV     AX, DS
        MOV     ES, AX

        MOV     AL, 10D                 ; store posy for multiply
        LEA     DI, ARRAY1              ; clear si for put position

        MUL     POSY1                   ; calculate for put element
        ADD     DI, AX
        MOV     AX, 00H
        MOV     AL, POSX1
        ADD     DI, AX                  ; di = center position of element

        CMP     TYPEELE1, 01D           ; check type1
        JNE     TESTNEXTTYPED2DOWN1
        CALL    DOWN1_1
        JMP     ENDDOWN_1
TESTNEXTTYPED2DOWN1:
        CMP     TYPEELE1, 02D           ; check type2
        JNE     TESTNEXTTYPED3DOWN1
        CALL    DOWN1_2
        JMP     ENDDOWN_1

TESTNEXTTYPED3DOWN1:
        CMP     TYPEELE1, 03D            ; check type3
        JNE     TESTNEXTTYPED4DOWN1
        CALL    DOWN1_3
        JMP     ENDDOWN_1

TESTNEXTTYPED4DOWN1:
        CMP     TYPEELE1, 04D            ; check type4
        JNE     TESTNEXTTYPED5DOWN1
        CALL    DOWN1_4
        JMP     ENDDOWN_1

TESTNEXTTYPED5DOWN1:
        CMP     TYPEELE1, 05D            ; check type5
        JNE     TESTNEXTTYPED6DOWN1
        CALL    DOWN1_5
        JMP     ENDDOWN_1

TESTNEXTTYPED6DOWN1:
        CMP     TYPEELE1, 06D            ; check type6
        JNE     TESTNEXTTYPED7DOWN1
        CALL    DOWN1_6
        JMP     ENDDOWN_1

TESTNEXTTYPED7DOWN1:
        CMP     TYPEELE1, 07D            ; check type7
        JNE     ENDDOWN_1
        CALL    DOWN1_7

ENDDOWN_1:
        ;++++++++++++++++++++++++++++++++++++
        POP     DI
        POP     ES
        POP     AX

        RET

DOWN_1   ENDP
;-------------------------------------------------------------------

                        ; moving type 1 down_1
DOWN1_1 PROC    NEAR

        CMP     FORM1, 01D
        JNE     DOWN1_1NEXTFORM2        ; if not form 1 jmp to test next type

        ADD     DI, 09D

        CMP     POSY1, 20D              ; if element stay at buttom of block
        JAE     ENDDOWN1_1
        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_1
        ADD     DI, 02D
        CMP     WORD PTR DS:[DI], 00D
        JNE     ENDDOWN1_1

        JMP     DOWN1_1CALL

DOWN1_1NEXTFORM2:
        CMP     FORM1, 02D
        JNE     ENDDOWN1_1              ; if not form 2 jmp no match type

        ADD     DI, 30D

        CMP     POSY1, 18D              ; if element stay at buttom of block
        JAE     ENDDOWN1_1
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_1

DOWN1_1CALL:
        INC     BYTE PTR POSY1
        CALL    CLEARMOVING1
        CALL    ELEMENT1
        JMP     RETDOWN1_1

ENDDOWN1_1:
        CALL    NODOWN1
RETDOWN1_1:
        RET
DOWN1_1   ENDP
;-------------------------------------------------------------------
                        ; moving type 2 down_1
DOWN1_2 PROC    NEAR

        CMP     FORM1, 01D
        JNE     DOWN1_2NEXTFORM2        ; if not form 1 jmp to test next type

        ADD     DI, 09D

        CMP     POSY1, 19D              ; if element stay at buttom of block
        JAE     ENDDOWN1_2
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_2
        ADD     DI, 11D
        CMP     WORD PTR DS:[DI], 00D
        JNE     ENDDOWN1_2

        JMP     DOWN1_2CALL

DOWN1_2NEXTFORM2:
        CMP     FORM1, 02D
        JNE     ENDDOWN1_2              ; if not form 2 jmp no match type

        ADD     DI, 11D

        CMP     POSY1, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN1_2

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_2
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN1_2

DOWN1_2CALL:
        INC     BYTE PTR POSY1
        CALL    CLEARMOVING1
        CALL    ELEMENT1
        JMP     RETDOWN1_2

ENDDOWN1_2:
        CALL    NODOWN1
RETDOWN1_2:
        RET
DOWN1_2 ENDP
;-------------------------------------------------------------------
                        ; moving type 3 down
DOWN1_3 PROC    NEAR

        CMP     FORM1, 01D
        JNE     ENDDOWN1_3                ; if not form 1 jmp no match type

        ADD     DI, 20D

        CMP     POSY1, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN1_3

        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_3

        INC     BYTE PTR POSY1

        CALL    CLEARMOVING1
        CALL    ELEMENT1
        JMP     RETDOWN1_3

ENDDOWN1_3:
        CALL    NODOWN1
RETDOWN1_3:
        RET
DOWN1_3 ENDP
;-------------------------------------------------------------------
                        ; moving type 4 down
DOWN1_4   PROC    NEAR

        CMP     FORM1, 01D
        JNE     DOWN1_4NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 11D

        CMP     POSY1, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN1_4
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_4
        ADD     DI, 08D
        CMP     WORD PTR DS:[DI], 00D
        JNE     ENDDOWN1_4

        JMP     DOWN1_4CALL

DOWN1_4NEXTFORM2:
        CMP     FORM1, 02D
        JNE     ENDDOWN1_4                ; if not form 2 jmp no match type

        ADD     DI, 10D

        CMP     POSY1, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN1_4

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_4
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN1_4

DOWN1_4CALL:
        INC     BYTE PTR POSY1
        CALL    CLEARMOVING1
        CALL    ELEMENT1
        JMP     RETDOWN1_4

ENDDOWN1_4:
        CALL    NODOWN1
RETDOWN1_4:
        RET
DOWN1_4 ENDP
;-------------------------------------------------------------------
                        ; moving type 5 down
DOWN1_5 PROC    NEAR

        CMP     FORM1, 01D
        JNE     DOWN1_5NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 09D

        CMP     POSY1, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN1_5
        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_5
        ADD     DI, 12D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN1_5

        JMP     DOWN1_5CALL

DOWN1_5NEXTFORM2:
        CMP     FORM1, 02D
        JNE     DOWN1_5NEXTFORM3          ; if not form 2 jmp to test next type

        CMP     POSY1, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN1_5

        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_5
        ADD     DI, 19D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_5

        JMP     DOWN1_5CALL

DOWN1_5NEXTFORM3:
        CMP     FORM1, 03D
        JNE     DOWN1_5NEXTFORM4          ; if not form 3 jmp to test next type

        ADD     DI, 09D

        CMP     POSY1, 20D               ; if element stay at buttom of block
        JAE     ENDDOWN1_5

        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_5
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN1_5

        JMP     DOWN1_5CALL

DOWN1_5NEXTFORM4:
        CMP     FORM1, 04D
        JNE     ENDDOWN1_5              ; if not form 4 jmp no match type

        ADD     DI, 19D
        CMP     POSY1, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN1_5

        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_5

DOWN1_5CALL:
        INC     BYTE PTR POSY1
        CALL    CLEARMOVING1
        CALL    ELEMENT1
        JMP     RETDOWN1_5

ENDDOWN1_5:
        CALL    NODOWN1
RETDOWN1_5:
        RET
DOWN1_5 ENDP
;-------------------------------------------------------------------
                        ; moving type 6 down
DOWN1_6   PROC    NEAR

        CMP     FORM1, 01D
        JNE     DOWN1_6NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 10D

        CMP     POSY1, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN1_6
        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_6
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN1_6

        JMP     DOWN1_6CALL

DOWN1_6NEXTFORM2:
        CMP     FORM1, 02D
        JNE     DOWN1_6NEXTFORM3          ; if not form 2 jmp to test next type

        ADD     DI, 20D

        CMP     POSY1, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN1_6

        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_6

        JMP     DOWN1_6CALL

DOWN1_6NEXTFORM3:
        CMP     FORM1, 03D
        JNE     DOWN1_6NEXTFORM4          ; if not form 3 jmp to test next type

        ADD     DI, 09D

        CMP     POSY1, 20D               ; if element stay at buttom of block
        JAE     ENDDOWN1_6

        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_6
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN1_6
        JMP     DOWN1_6CALL

DOWN1_6NEXTFORM4:
        CMP     FORM1, 04D
        JNE     ENDDOWN1_6                ; if not form 4 jmp no match type

        CMP     POSY1, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN1_6

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_6
        ADD     DI, 21D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN1_6

DOWN1_6CALL:
        INC     BYTE PTR POSY1
        CALL    CLEARMOVING1
        CALL    ELEMENT1
        JMP     RETDOWN1_6

ENDDOWN1_6:
        CALL    NODOWN1
RETDOWN1_6:
        RET
DOWN1_6 ENDP
;-------------------------------------------------------------------
                        ; moving type 7 down
DOWN1_7 PROC    NEAR

        CMP     FORM1, 01D
        JNE     DOWN1_7NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 09D

        CMP     POSY1, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN1_7
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_7
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN1_7
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN1_7

        JMP     DOWN1_7CALL

DOWN1_7NEXTFORM2:
        CMP     FORM1, 02D
        JNE     DOWN1_7NEXTFORM3          ; if not form 2 jmp to test next type

        ADD     DI, 11D

        CMP     POSY1, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN1_7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_7
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN1_7

        JMP     DOWN1_7CALL

DOWN1_7NEXTFORM3:
        CMP     FORM1, 03D
        JNE     DOWN1_7NEXTFORM4          ; if not form 3 jmp to test next type

        ADD     DI, 09D

        CMP     POSY1, 20D               ; if element stay at buttom of block
        JAE     ENDDOWN1_7

        CMP     WORD PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_7
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN1_7

DOWN1_7CALL:
        INC     BYTE PTR POSY1
        CALL    CLEARMOVING1
        CALL    ELEMENT1
        JMP     RETDOWN1_7

ENDDOWN1_7:
        CALL    NODOWN1
RETDOWN1_7:
        RET

DOWN1_7NEXTFORM4:
        CMP     FORM1, 04D
        JNE     ENDDOWN1_7                ; if not form 4 jmp no match type

        ADD     DI, 09D
        CMP     POSY1, 19D               ; if element stay at buttom of block
        JAE     ENDDOWN1_7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving down
        JNE     ENDDOWN1_7
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDDOWN1_7

        JMP     DOWN1_7CALL

DOWN1_7   ENDP
;-------------------------------------------------------------------
                        ; procedure for moving right element
RIGHT   PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        ;++++++++++++++++++++++++++++++++++++

        MOV     AX, DS
        MOV     ES, AX

        MOV     AL, 10D                 ; store posy for multiply
        LEA     DI, ARRAY               ; clear si for put position

        MUL     POSY                    ; calculate for put element
        ADD     DI, AX
        MOV     AX, 00H
        MOV     AL, POSX
        ADD     DI, AX                  ; di = center position of element

        CMP     TYPEELE, 01D            ; check type1
        JNE     TESTNEXTTYPER2
        CALL    RIGHT1
        JMP     ENDRIGHT
TESTNEXTTYPER2:
        CMP     TYPEELE, 02D            ; check type2
        JNE     TESTNEXTTYPER3
        CALL    RIGHT2
        JMP     ENDRIGHT

TESTNEXTTYPER3:
        CMP     TYPEELE, 03D            ; check type3
        JNE     TESTNEXTTYPER4
        CALL    RIGHT3
        JMP     ENDRIGHT

TESTNEXTTYPER4:
        CMP     TYPEELE, 04D            ; check type4
        JNE     TESTNEXTTYPER5
        CALL    RIGHT4
        JMP     ENDRIGHT

TESTNEXTTYPER5:
        CMP     TYPEELE, 05D            ; check type5
        JNE     TESTNEXTTYPER6
        CALL    RIGHT5
        JMP     ENDRIGHT

TESTNEXTTYPER6:
        CMP     TYPEELE, 06D            ; check type6
        JNE     TESTNEXTTYPER7
        CALL    RIGHT6
        JMP     ENDRIGHT

TESTNEXTTYPER7:
        CMP     TYPEELE, 07D            ; check type7
        JNE     ENDRIGHT
        CALL    RIGHT7

ENDRIGHT:
        ;++++++++++++++++++++++++++++++++++++
        POP     DI
        POP     ES
        POP     AX

        RET

RIGHT   ENDP
;-------------------------------------------------------------------
                        ; moving type 1 right
RIGHT1  PROC    NEAR

        CMP     FORM, 01D
        JNE     RIGHT1NEXTFORM2         ; if not form 1 jmp to test next type

        ADD     DI, 03D

        CMP     POSX, 07D               ; if element stay at right of block
        JAE     ENDRIGHT1
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1

        JMP     RIGHT1CALL

RIGHT1NEXTFORM2:
        CMP     FORM, 02D
        JNE     ENDRIGHT1               ; if not form 2 jmp no match type

        SUB     DI, 09D

        CMP     POSX, 09D               ; if element stay at buttom of block
        JAE     ENDRIGHT1
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1

        MOV     CX, 03D
LOOP_RIGHT1FORM2:
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1
        LOOP    LOOP_RIGHT1FORM2

RIGHT1CALL:
        INC     BYTE PTR POSX
        CALL    CLEARMOVING
        CALL    ELEMENT
        
ENDRIGHT1:
        RET
RIGHT1   ENDP
;-------------------------------------------------------------------
                        ; moving type 2 right
RIGHT2  PROC    NEAR

        CMP     FORM, 01D
        JNE     RIGHT2NEXTFORM2         ; if not form 1 jmp to test next type

        INC     DI

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT2
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT2
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT2

        JMP     RIGHT2CALL

RIGHT2NEXTFORM2:
        CMP     FORM, 02D
        JNE     ENDRIGHT2                ; if not form 2 jmp no match type

        SUB     DI, 08D

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT2

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT2
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT2
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT2
        
RIGHT2CALL:
        INC     BYTE PTR POSX
        CALL    CLEARMOVING
        CALL    ELEMENT
                    
ENDRIGHT2:
        RET
RIGHT2  ENDP
;-------------------------------------------------------------------
                        ; moving type 3 right
RIGHT3  PROC    NEAR

        CMP     FORM, 01D
        JNE     ENDRIGHT3               ; if not form 1 jmp no match type

        ADD     DI, 02D

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT3

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT3
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT3

        INC     BYTE PTR POSX

        CALL    CLEARMOVING
        CALL    ELEMENT
                    
ENDRIGHT3:
        RET
RIGHT3  ENDP
;-------------------------------------------------------------------
                        ; moving type 4 right
RIGHT4  PROC    NEAR

        CMP     FORM, 01D
        JNE     RIGHT4NEXTFORM2         ; if not form 1 jmp to test next type

        ADD     DI, 02D

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT4
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT4
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT4

        JMP     RIGHT4CALL

RIGHT4NEXTFORM2:
        CMP     FORM, 02D
        JNE     ENDRIGHT4               ; if not form 2 jmp no match type

        SUB     DI, 09D

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT4

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT4
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT4
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT4

RIGHT4CALL:
        INC     BYTE PTR POSX
        CALL    CLEARMOVING
        CALL    ELEMENT

ENDRIGHT4:
        RET
RIGHT4  ENDP
;-------------------------------------------------------------------
                        ; moving type 5 right
RIGHT5   PROC    NEAR

        CMP     FORM, 01D
        JNE     RIGHT5NEXTFORM2         ; if not form 1 jmp to test next type

        ADD     DI, 02D

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT5
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT5
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT5

        JMP     RIGHT5CALL

RIGHT5NEXTFORM2:
        CMP     FORM, 02D
        JNE     RIGHT5NEXTFORM3          ; if not form 2 jmp to test next type

        INC     DI

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT5

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT5
        SUB     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT5
        ADD     DI, 19D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT5

        JMP     RIGHT5CALL

RIGHT5NEXTFORM3:
        CMP     FORM, 03D
        JNE     RIGHT5NEXTFORM4          ; if not form 3 jmp to test next type

        SUB     DI, 10D

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT5

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT5
        ADD     DI, 12D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT5

RIGHT5CALL:
        INC     BYTE PTR POSX
        CALL    CLEARMOVING
        CALL    ELEMENT
ENDRIGHT5:
        RET

RIGHT5NEXTFORM4:
        CMP     FORM, 04D
        JNE     ENDRIGHT5                ; if not form 4 jmp no match type

        INC     DI
        CMP     POSX, 09D               ; if element stay at right of block
        JAE     ENDRIGHT5

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT5
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT5
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT5

        JMP     RIGHT5CALL

RIGHT5  ENDP
;-------------------------------------------------------------------
                        ; moving type 6 right
RIGHT6  PROC    NEAR

        CMP     FORM, 01D
        JNE     RIGHT6NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 02D

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT6
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT6
        ADD     DI, 08D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT6

        JMP     RIGHT6CALL

RIGHT6NEXTFORM2:
        CMP     FORM, 02D
        JNE     RIGHT6NEXTFORM3          ; if not form 2 jmp to test next type

        INC     DI

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT6
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT6
        ADD     DI, 21D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT6

        JMP     RIGHT6CALL

RIGHT6NEXTFORM3:
        CMP     FORM, 03D
        JNE     RIGHT6NEXTFORM4          ; if not form 3 jmp to test next type

        ADD     DI, 02D

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT6
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT6

RIGHT6CALL:
        INC     BYTE PTR POSX
        CALL    CLEARMOVING
        CALL    ELEMENT
ENDRIGHT6:
        RET

RIGHT6NEXTFORM4:
        CMP     FORM, 04D
        JNE     ENDRIGHT6                ; if not form 4 jmp no match type

        INC     DI

        CMP     POSX, 09D               ; if element stay at right of block
        JAE     ENDRIGHT6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT6
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT6
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT6

        JMP     RIGHT6CALL

RIGHT6  ENDP
;-------------------------------------------------------------------
                        ; moving type 7 right
RIGHT7  PROC    NEAR

        CMP     FORM, 01D
        JNE     RIGHT7NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 02D

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT7
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT7
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT7

        JMP     RIGHT7CALL

RIGHT7NEXTFORM2:
        CMP     FORM, 02D
        JNE     RIGHT7NEXTFORM3          ; if not form 2 jmp to test next type

        SUB     DI, 09D

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT7
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT7
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT7
        
        JMP     RIGHT7CALL

RIGHT7NEXTFORM3:
        CMP     FORM, 03D
        JNE     RIGHT7NEXTFORM4          ; if not form 3 jmp to test next type

        ADD     DI, 02D

        CMP     POSX, 08D               ; if element stay at right of block
        JAE     ENDRIGHT7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT7
        SUB     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT7

RIGHT7CALL:
        INC     BYTE PTR POSX
        CALL    CLEARMOVING
        CALL    ELEMENT
ENDRIGHT7:
        RET
        
RIGHT7NEXTFORM4:
        CMP     FORM, 04D
        JNE     ENDRIGHT7                ; if not form 4 jmp no match type

        INC     DI

        CMP     POSX, 09D               ; if element stay at right of block
        JAE     ENDRIGHT7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT7
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT7
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT7

        JMP     RIGHT7CALL

RIGHT7  ENDP
;-------------------------------------------------------------------
                        ; procedure for moving left element
LEFT    PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        ;++++++++++++++++++++++++++++++++++++

        MOV     AX, DS
        MOV     ES, AX

        MOV     AL, 10D                 ; store posy for multiply
        LEA     DI, ARRAY               ; clear si for put position

        MUL     POSY                    ; calculate for put element
        ADD     DI, AX
        MOV     AX, 00H
        MOV     AL, POSX
        ADD     DI, AX                  ; di = center position of element
        
        CMP     TYPEELE, 01D            ; check type1
        JNE     TESTNEXTTYPEL2
        CALL    LEFT1
        JMP     ENDLEFT
TESTNEXTTYPEL2:
        CMP     TYPEELE, 02D            ; check type2
        JNE     TESTNEXTTYPEL3
        CALL    LEFT2
        JMP     ENDLEFT

TESTNEXTTYPEL3:
        CMP     TYPEELE, 03D            ; check type3
        JNE     TESTNEXTTYPEL4
        CALL    LEFT3
        JMP     ENDLEFT

TESTNEXTTYPEL4:
        CMP     TYPEELE, 04D            ; check type4
        JNE     TESTNEXTTYPEL5
        CALL    LEFT4
        JMP     ENDLEFT

TESTNEXTTYPEL5:
        CMP     TYPEELE, 05D            ; check type5
        JNE     TESTNEXTTYPEL6
        CALL    LEFT5
        JMP     ENDLEFT

TESTNEXTTYPEL6:
        CMP     TYPEELE, 06D            ; check type6
        JNE     TESTNEXTTYPEL7
        CALL    LEFT6
        JMP     ENDLEFT

TESTNEXTTYPEL7:
        CMP     TYPEELE, 07D            ; check type7
        JNE     ENDLEFT
        CALL    LEFT7
        
ENDLEFT:
        ;++++++++++++++++++++++++++++++++++++
        POP     DI
        POP     ES
        POP     AX

        RET

LEFT    ENDP
;-------------------------------------------------------------------
                        ; moving type 1 left
LEFT1   PROC    NEAR

        CMP     FORM, 01D
        JNE     LEFT1NEXTFORM2          ; if not form 1 jmp to test next type

        SUB     DI, 02D

        CMP     POSX, 01D               ; if element stay at left of block
        JBE     ENDLEFT1
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1

        JMP     LEFT1CALL

LEFT1NEXTFORM2:
        CMP     FORM, 02D
        JNE     ENDLEFT1               ; if not form 2 jmp no match type

        SUB     DI, 11D

        CMP     POSX, 00D               ; if element stay at buttom of block
        JBE     ENDLEFT1
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1

        MOV     CX, 03D
LOOP_LEFT1FORM2:
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1
        LOOP    LOOP_LEFT1FORM2

LEFT1CALL:
        DEC     BYTE PTR POSX
        CALL    CLEARMOVING
        CALL    ELEMENT
        
ENDLEFT1:
        RET
LEFT1   ENDP
;-------------------------------------------------------------------
                        ; moving type 2 left
LEFT2   PROC    NEAR

        CMP     FORM, 01D
        JNE     LEFT2NEXTFORM2         ; if not form 1 jmp to test next type

        SUB     DI, 02D

        CMP     POSX, 01D               ; if element stay at left of block
        JBE     ENDLEFT2
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT2
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT2

        JMP     LEFT2CALL

LEFT2NEXTFORM2:
        CMP     FORM, 02D
        JNE     ENDLEFT2                ; if not form 2 jmp no match type

        DEC     DI

        CMP     POSX, 00D               ; if element stay at left of block
        JBE     ENDLEFT2

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT2
        SUB     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT2
        ADD     DI, 19D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT2
        
LEFT2CALL:
        DEC     BYTE PTR POSX
        CALL    CLEARMOVING
        CALL    ELEMENT

ENDLEFT2:
        RET
LEFT2   ENDP
;-------------------------------------------------------------------
                        ; moving type 3 left
LEFT3   PROC    NEAR

        CMP     FORM, 01D
        JNE     ENDLEFT3               ; if not form 1 jmp no match type

        DEC     DI

        CMP     POSX, 00D               ; if element stay at left of block
        JBE     ENDLEFT3

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT3
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT3

        DEC     BYTE PTR POSX

        CALL    CLEARMOVING
        CALL    ELEMENT
                    
ENDLEFT3:
        RET
LEFT3  ENDP
;-------------------------------------------------------------------
                        ; moving type 4 left
LEFT4  PROC    NEAR

        CMP     FORM, 01D
        JNE     LEFT4NEXTFORM2         ; if not form 1 jmp to test next type

        DEC     DI

        CMP     POSX, 01D               ; if element stay at left of block
        JBE     ENDLEFT4
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT4
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT4

        JMP     LEFT4CALL

LEFT4NEXTFORM2:
        CMP     FORM, 02D
        JNE     ENDLEFT4               ; if not form 2 jmp no match type

        DEC     DI

        CMP     POSX, 00D               ; if element stay at left of block
        JBE     ENDLEFT4

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT4
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT4
        ADD     DI, 21D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT4

LEFT4CALL:
        DEC     BYTE PTR POSX
        CALL    CLEARMOVING
        CALL    ELEMENT
                    
ENDLEFT4:
        RET
LEFT4   ENDP
;-------------------------------------------------------------------
                        ; moving type 5 left
LEFT5   PROC    NEAR

        CMP     FORM, 01D
        JNE     LEFT5NEXTFORM2         ; if not form 1 jmp to test next type

        SUB     DI, 02D

        CMP     POSX, 01D               ; if element stay at left of block
        JBE     ENDLEFT5
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT5
        ADD     DI, 12D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT5

        JMP     LEFT5CALL

LEFT5NEXTFORM2:
        CMP     FORM, 02D
        JNE     LEFT5NEXTFORM3          ; if not form 2 jmp to test next type

        DEC     DI

        CMP     POSX, 00D               ; if element stay at left of block
        JBE     ENDLEFT5

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT5
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT5
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT5

        JMP     LEFT5CALL

LEFT5NEXTFORM3:
        CMP     FORM, 03D
        JNE     LEFT5NEXTFORM4          ; if not form 3 jmp to test next type

        SUB     DI, 02D

        CMP     POSX, 01D               ; if element stay at left of block
        JBE     ENDLEFT5

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT5
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT5

LEFT5CALL:
        DEC     BYTE PTR POSX
        CALL    CLEARMOVING
        CALL    ELEMENT
ENDLEFT5:
        RET

LEFT5NEXTFORM4:
        CMP     FORM, 04D
        JNE     ENDLEFT5                ; if not form 4 jmp no match type

        DEC     DI
        CMP     POSX, 01D               ; if element stay at left of block
        JBE     ENDLEFT5

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT5
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT5
        ADD     DI, 19D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT5

        JMP     LEFT5CALL

LEFT5  ENDP
;-------------------------------------------------------------------
                        ; moving type 6 left
LEFT6  PROC    NEAR

        CMP     FORM, 01D
        JNE     LEFT6NEXTFORM2          ; if not form 1 jmp to test next type

        SUB     DI, 02D

        CMP     POSX, 01D               ; if element stay at left of block
        JBE     ENDLEFT6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT6
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT6

        JMP     LEFT6CALL

LEFT6NEXTFORM2:
        CMP     FORM, 02D
        JNE     LEFT6NEXTFORM3          ; if not form 2 jmp to test next type

        DEC     DI

        CMP     POSX, 00D               ; if element stay at left of block
        JBE     ENDLEFT6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT6
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT6
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT6

        JMP     LEFT6CALL

LEFT6NEXTFORM3:
        CMP     FORM, 03D
        JNE     LEFT6NEXTFORM4          ; if not form 3 jmp to test next type

        SUB     DI, 02D

        CMP     POSX, 01D               ; if element stay at left of block
        JBE     ENDLEFT6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT6
        SUB     DI, 08D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT6

LEFT6CALL:
        DEC     BYTE PTR POSX
        CALL    CLEARMOVING
        CALL    ELEMENT
ENDLEFT6:
        RET

LEFT6NEXTFORM4:
        CMP     FORM, 04D
        JNE     ENDLEFT6                ; if not form 4 jmp no match type

        DEC     DI

        CMP     POSX, 01D               ; if element stay at left of block
        JBE     ENDLEFT6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT6
        SUB     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT6
        ADD     DI, 21D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT6

        JMP     LEFT6CALL

LEFT6   ENDP
;-------------------------------------------------------------------
                        ; moving type 7 left
LEFT7   PROC    NEAR

        CMP     FORM, 01D
        JNE     LEFT7NEXTFORM2          ; if not form 1 jmp to test next type

        SUB     DI, 02D

        CMP     POSX, 01D               ; if element stay at left of block
        JBE     ENDLEFT7
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT7
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT7

        JMP     LEFT7CALL

LEFT7NEXTFORM2:
        CMP     FORM, 02D
        JNE     LEFT7NEXTFORM3          ; if not form 2 jmp to test next type

        DEC     DI

        CMP     POSX, 00D               ; if element stay at left of block
        JBE     ENDLEFT7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT7
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT7
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT7
        
        JMP     LEFT7CALL

LEFT7NEXTFORM3:
        CMP     FORM, 03D
        JNE     LEFT7NEXTFORM4          ; if not form 3 jmp to test next type

        SUB     DI, 02D

        CMP     POSX, 01D               ; if element stay at left of block
        JBE     ENDLEFT7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT7
        SUB     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT7

LEFT7CALL:
        DEC     BYTE PTR POSX
        CALL    CLEARMOVING
        CALL    ELEMENT
ENDLEFT7:
        RET
        
LEFT7NEXTFORM4:
        CMP     FORM, 04D
        JNE     ENDLEFT7                ; if not form 4 jmp no match type

        SUB     DI, 02D

        CMP     POSX, 01D               ; if element stay at left of block
        JBE     ENDLEFT7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT7
        SUB     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT7
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT7

        JMP     LEFT7CALL

LEFT7  ENDP
;-------------------------------------------------------------------
                        ; procedure for rotate element
ROTATE  PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        ;++++++++++++++++++++++++++++++++++++

        MOV     AX, DS
        MOV     ES, AX

        MOV     AL, 10D                 ; store posy for multiply
        LEA     DI, ARRAY               ; clear si for put position

        MUL     POSY                    ; calculate for put element
        ADD     DI, AX
        MOV     AX, 00H
        MOV     AL, POSX
        ADD     DI, AX                  ; di = center position of element

        CMP     TYPEELE, 01D            ; check type1
        JNE     TESTNEXTTYPEO2
        CALL    ROTATE1
        JMP     ENDROTATE
TESTNEXTTYPEO2:
        CMP     TYPEELE, 02D            ; check type2
        JNE     TESTNEXTTYPEO3
        CALL    ROTATE2
        JMP     ENDROTATE

TESTNEXTTYPEO3:
        CMP     TYPEELE, 03D            ; check type3
        JNE     TESTNEXTTYPEO4
        JMP     ENDROTATE

TESTNEXTTYPEO4:
        CMP     TYPEELE, 04D            ; check type4
        JNE     TESTNEXTTYPEO5
        CALL    ROTATE4
        JMP     ENDROTATE

TESTNEXTTYPEO5:
        CMP     TYPEELE, 05D            ; check type5
        JNE     TESTNEXTTYPEO6
        CALL    ROTATE5
        JMP     ENDROTATE

TESTNEXTTYPEO6:
        CMP     TYPEELE, 06D            ; check type6
        JNE     TESTNEXTTYPEO7
        CALL    ROTATE6
        JMP     ENDROTATE

TESTNEXTTYPEO7:
        CMP     TYPEELE, 07D            ; check type7
        JNE     ENDROTATE
        CALL    ROTATE7
        
ENDROTATE:
        ;++++++++++++++++++++++++++++++++++++
        POP     DI
        POP     ES
        POP     AX        
        RET

ROTATE  ENDP
;-------------------------------------------------------------------
                        ; rotate type 1
ROTATE1 PROC    NEAR

        ; form 1 ---> 2

        CMP     FORM, 01D
        JNE     ROTATE1NEXTFORM2        ; if not form 1 jmp to test next type

        CMP     POSY, 18D               ; if element stay at left of block
        JA      ENDROTATE1
        

        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1

        MOV     FORM, 02D
        JMP     ROTATE1CALL

ROTATE1NEXTFORM2:                       ; form 2 ---> 1
        CMP     FORM, 02D
        JNE     ENDROTATE1              ; if not form 2 jmp no match type


        CMP     POSX, 01D               ; if element stay at left of block
        JB      ENDROTATE1
        CMP     POSX, 07D               ; if element stay at right of block
        JA      ENDROTATE1
                  
        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1
        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1

        MOV     FORM, 01D

ROTATE1CALL:
        CALL    CLEARMOVING
        CALL    ELEMENT
        
ENDROTATE1:
        RET
ROTATE1 ENDP
;-------------------------------------------------------------------
                        ; rotate type 2
ROTATE2 PROC    NEAR

        ; form 1 ---> 2

        CMP     FORM, 01D
        JNE     ROTATE2NEXTFORM2         ; if not form 1 jmp to test next type

        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE2
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE2

        MOV     FORM, 02D
        JMP     ROTATE2CALL

ROTATE2NEXTFORM2:                       ; form 2 ---> 1
        CMP     FORM, 02D
        JNE     ENDROTATE2              ; if not form 2 jmp no match type

        CMP     POSX, 01D               ; if element stay at left of block
        JB      ENDROTATE2

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE2
        ADD     DI, 12D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE2

        MOV     FORM, 01D
        
ROTATE2CALL:
        CALL    CLEARMOVING
        CALL    ELEMENT
                    
ENDROTATE2:
        RET
ROTATE2 ENDP
;-------------------------------------------------------------------
                        ; rotate form 4
ROTATE4 PROC    NEAR

        ; form 1 ---> 2

        CMP     FORM, 01D
        JNE     ROTATE4NEXTFORM2         ; if not form 1 jmp to test next type

        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE4
        ADD     DI, 21D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE4

        MOV     FORM, 02D
        JMP     ROTATE4CALL

ROTATE4NEXTFORM2:                       ; form 2 ---> 1
        CMP     FORM, 02D
        JNE     ENDROTATE4              ; if not form 2 jmp no match type

        CMP     POSX, 01D               ; if element stay at left of block
        JB      ENDROTATE4

        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE4
        INC     DI
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE4

        MOV     FORM, 01D

ROTATE4CALL:
        CALL    CLEARMOVING
        CALL    ELEMENT
                    
ENDROTATE4:
        RET
ROTATE4 ENDP
;-------------------------------------------------------------------
                        ; rotate type 5
ROTATE5 PROC    NEAR

        ; form 1 ---> 2

        CMP     FORM, 01D
        JNE     ROTATE5NEXTFORM2        ; if not form 1 jmp to test next type

        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE5
        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE5                                               
        ADD     DI, 19D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE5

        MOV     FORM, 02D
        JMP     ROTATE5CALL

ROTATE5NEXTFORM2:                       ; form 2 ---> 3
        CMP     FORM, 02D
        JNE     ROTATE5NEXTFORM3        ; if not form 2 jmp to test next type

        CMP     POSX, 01D               ; if element stay at left of block
        JB      ENDROTATE5

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE5
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE5
        ADD     DI, 12D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE5

        MOV     FORM, 03D
        JMP     ROTATE5CALL

ROTATE5NEXTFORM3:                       ; form 3 ---> 4
        CMP     FORM, 03D
        JNE     ROTATE5NEXTFORM4        ; if not form 3 jmp to test next type

        CMP     POSY, 19D               ; if element stay at buttom of block
        JA      ENDROTATE5

        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE5
        ADD     DI, 19D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE5
        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE5
        
        MOV     FORM, 04D

ROTATE5CALL:
        CALL    CLEARMOVING
        CALL    ELEMENT
ENDROTATE5:
        RET

ROTATE5NEXTFORM4:                       ; form 4 ---> 1
        CMP     FORM, 04D
        JNE     ENDROTATE5              ; if not form 4 jmp no match type

        CMP     POSX, 08D               ; if element stay at right of block
        JA      ENDROTATE5

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE5
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE5
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE5

        MOV     FORM, 01D
        JMP     ROTATE5CALL

ROTATE5  ENDP
;-------------------------------------------------------------------
                        ; rotate type 6
ROTATE6 PROC    NEAR

        ; form 1 ---> 2

        CMP     FORM, 01D
        JNE     ROTATE6NEXTFORM2        ; if not form 1 jmp to test next type

        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE6
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE6
        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE6
        
        MOV     FORM, 02D
        JMP     ROTATE6CALL

ROTATE6NEXTFORM2:                       ; form 2 ---> 3
        CMP     FORM, 02D
        JNE     ROTATE6NEXTFORM3        ; if not form 2 jmp to test next type

        CMP     POSX, 01D               ; if element stay at left of block
        JB      ENDROTATE6

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE6
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE6
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE6

        MOV     FORM, 03D
        JMP     ROTATE6CALL

ROTATE6NEXTFORM3:                       ; form 3 ---> 4
        CMP     FORM, 03D
        JNE     ROTATE6NEXTFORM4        ; if not form 3 jmp to test next type

        CMP     POSY, 19D               ; if element stay at left of block
        JA      ENDROTATE6

        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE6
        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE6
      
        ADD     DI, 21D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE6

        MOV     FORM, 04D

ROTATE6CALL:
        CALL    CLEARMOVING
        CALL    ELEMENT
ENDROTATE6:
        RET

ROTATE6NEXTFORM4:                       ; form 4 ---> 1
        CMP     FORM, 04D
        JNE     ENDROTATE6              ; if not form 4 jmp no match type

        CMP     POSX, 08D               ; if element stay at right of block
        JA      ENDROTATE6

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE6
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE6
        ADD     DI, 08D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE6

        MOV     FORM, 01D
        JMP     ROTATE6CALL

ROTATE6 ENDP
;-------------------------------------------------------------------
                        ; rotate type 7
ROTATE7 PROC    NEAR

        ; form 1 ---> 2

        CMP     FORM, 01D
        JNE     ROTATE7NEXTFORM2          ; if not form 1 jmp to test next type

        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE7

        MOV     FORM, 02D
        JMP     ROTATE7CALL

ROTATE7NEXTFORM2:                       ; form 2 ---> 3
        CMP     FORM, 02D
        JNE     ROTATE7NEXTFORM3        ; if not form 2 jmp to test next type

        CMP     POSX, 01D               ; if element stay at left of block
        JB      ENDROTATE7

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE7
        
        MOV     FORM, 03D
        JMP     ROTATE7CALL

ROTATE7NEXTFORM3:                       ; form 3 ---> 4
        CMP     FORM, 03D
        JNE     ROTATE7NEXTFORM4        ; if not form 3 jmp to test next type

        CMP     POSY, 19D               ; if element stay at buttom of block
        JA      ENDROTATE7

        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE7

        MOV     FORM, 04D

ROTATE7CALL:
        CALL    CLEARMOVING
        CALL    ELEMENT
ENDROTATE7:
        RET
        
ROTATE7NEXTFORM4:                       ; form 4 ---> 1
        CMP     FORM, 04D
        JNE     ENDROTATE7                ; if not form 4 jmp no match type


        CMP     POSX, 08D               ; if element stay at right of block
        JA      ENDROTATE7

        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE7
        INC     DI
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE7

        MOV     FORM, 01D
        JMP     ROTATE7CALL

ROTATE7  ENDP
;-------------------------------------------------------------------
                        ; procedure for moving right element 1
RIGHT_1 PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        ;++++++++++++++++++++++++++++++++++++

        MOV     AX, DS
        MOV     ES, AX

        MOV     AL, 10D                 ; store posy for multiply
        LEA     DI, ARRAY1              ; clear si for put position

        MUL     POSY1                   ; calculate for put element
        ADD     DI, AX
        MOV     AX, 00H
        MOV     AL, POSX1
        ADD     DI, AX                  ; di = center position of element

        CMP     TYPEELE1, 01D            ; check type1
        JNE     TESTNEXTTYPER1_2
        CALL    RIGHT1_1
        JMP     ENDRIGHT_1
TESTNEXTTYPER1_2:
        CMP     TYPEELE1, 02D            ; check type2
        JNE     TESTNEXTTYPER1_3
        CALL    RIGHT1_2
        JMP     ENDRIGHT_1

TESTNEXTTYPER1_3:
        CMP     TYPEELE1, 03D            ; check type3
        JNE     TESTNEXTTYPER1_4
        CALL    RIGHT1_3
        JMP     ENDRIGHT_1

TESTNEXTTYPER1_4:
        CMP     TYPEELE1, 04D            ; check type4
        JNE     TESTNEXTTYPER1_5
        CALL    RIGHT1_4
        JMP     ENDRIGHT_1

TESTNEXTTYPER1_5:
        CMP     TYPEELE1, 05D            ; check type5
        JNE     TESTNEXTTYPER1_6
        CALL    RIGHT1_5
        JMP     ENDRIGHT_1

TESTNEXTTYPER1_6:
        CMP     TYPEELE1, 06D            ; check type6
        JNE     TESTNEXTTYPER1_7
        CALL    RIGHT1_6
        JMP     ENDRIGHT_1

TESTNEXTTYPER1_7:
        CMP     TYPEELE1, 07D            ; check type7
        JNE     ENDRIGHT_1
        CALL    RIGHT1_7

ENDRIGHT_1:
        ;++++++++++++++++++++++++++++++++++++
        POP     DI
        POP     ES
        POP     AX

        RET

RIGHT_1 ENDP
;-------------------------------------------------------------------
                        ; moving type 1 right 1
RIGHT1_1                PROC    NEAR

        CMP     FORM1, 01D
        JNE     RIGHT1_1NEXTFORM2         ; if not form 1 jmp to test next type

        ADD     DI, 03D

        CMP     POSX1, 07D               ; if element stay at right of block
        JAE     ENDRIGHT1_1
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_1

        JMP     RIGHT1_1CALL

RIGHT1_1NEXTFORM2:
        CMP     FORM1, 02D
        JNE     ENDRIGHT1_1             ; if not form 2 jmp no match type

        SUB     DI, 09D

        CMP     POSX1, 09D               ; if element stay at buttom of block
        JAE     ENDRIGHT1_1
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_1

        MOV     CX, 03D
LOOP_RIGHT1_1FORM2:
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_1
        LOOP    LOOP_RIGHT1_1FORM2

RIGHT1_1CALL:
        INC     BYTE PTR POSX1
        CALL    CLEARMOVING1
        CALL    ELEMENT1

ENDRIGHT1_1:
        RET
RIGHT1_1        ENDP
;-------------------------------------------------------------------
                        ; moving type 2 right 1
RIGHT1_2  PROC    NEAR

        CMP     FORM1, 01D
        JNE     RIGHT1_2NEXTFORM2         ; if not form 1 jmp to test next type

        INC     DI

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_2
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_2
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_2

        JMP     RIGHT1_2CALL

RIGHT1_2NEXTFORM2:
        CMP     FORM1, 02D
        JNE     ENDRIGHT1_2                ; if not form 2 jmp no match type

        SUB     DI, 08D

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_2

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_2
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_2
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_2

RIGHT1_2CALL:
        INC     BYTE PTR POSX1
        CALL    CLEARMOVING1
        CALL    ELEMENT1

ENDRIGHT1_2:
        RET
RIGHT1_2        ENDP
;-------------------------------------------------------------------
                        ; moving type 3 right 1
RIGHT1_3        PROC    NEAR

        CMP     FORM1, 01D
        JNE     ENDRIGHT1_3               ; if not form 1 jmp no match type

        ADD     DI, 02D

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_3

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_3
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_3

        INC     BYTE PTR POSX1

        CALL    CLEARMOVING1
        CALL    ELEMENT1

ENDRIGHT1_3:
        RET
RIGHT1_3        ENDP
;-------------------------------------------------------------------
                        ; moving type 4 right 1
RIGHT1_4        PROC    NEAR

        CMP     FORM1, 01D
        JNE     RIGHT1_4NEXTFORM2         ; if not form 1 jmp to test next type

        ADD     DI, 02D

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_4
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_4
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_4

        JMP     RIGHT1_4CALL

RIGHT1_4NEXTFORM2:
        CMP     FORM1, 02D
        JNE     ENDRIGHT1_4               ; if not form 2 jmp no match type

        SUB     DI, 09D

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_4

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_4
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_4
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_4

RIGHT1_4CALL:
        INC     BYTE PTR POSX1
        CALL    CLEARMOVING1
        CALL    ELEMENT1

ENDRIGHT1_4:
        RET
RIGHT1_4        ENDP
;-------------------------------------------------------------------
                        ; moving type 5 right 1
RIGHT1_5        PROC    NEAR

        CMP     FORM1, 01D
        JNE     RIGHT1_5NEXTFORM2         ; if not form 1 jmp to test next type

        ADD     DI, 02D

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_5
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_5
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_5

        JMP     RIGHT1_5CALL

RIGHT1_5NEXTFORM2:
        CMP     FORM1, 02D
        JNE     RIGHT1_5NEXTFORM3          ; if not form 2 jmp to test next type

        INC     DI

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_5

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_5
        SUB     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_5
        ADD     DI, 19D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_5

        JMP     RIGHT1_5CALL

RIGHT1_5NEXTFORM3:
        CMP     FORM1, 03D
        JNE     RIGHT1_5NEXTFORM4          ; if not form 3 jmp to test next type

        SUB     DI, 10D

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_5

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_5
        ADD     DI, 12D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_5

RIGHT1_5CALL:
        INC     BYTE PTR POSX1
        CALL    CLEARMOVING1
        CALL    ELEMENT1
ENDRIGHT1_5:
        RET

RIGHT1_5NEXTFORM4:
        CMP     FORM1, 04D
        JNE     ENDRIGHT1_5                ; if not form 4 jmp no match type

        INC     DI
        CMP     POSX1, 09D               ; if element stay at right of block
        JAE     ENDRIGHT1_5

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_5
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_5
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_5

        JMP     RIGHT1_5CALL

RIGHT1_5        ENDP
;-------------------------------------------------------------------
                        ; moving type 6 right 1
RIGHT1_6        PROC    NEAR

        CMP     FORM1, 01D
        JNE     RIGHT1_6NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 02D

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_6
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_6
        ADD     DI, 08D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_6

        JMP     RIGHT1_6CALL

RIGHT1_6NEXTFORM2:
        CMP     FORM1, 02D
        JNE     RIGHT1_6NEXTFORM3          ; if not form 2 jmp to test next type

        INC     DI

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_6
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_6
        ADD     DI, 21D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_6

        JMP     RIGHT1_6CALL

RIGHT1_6NEXTFORM3:
        CMP     FORM1, 03D
        JNE     RIGHT1_6NEXTFORM4          ; if not form 3 jmp to test next type

        ADD     DI, 02D

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_6
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_6

RIGHT1_6CALL:
        INC     BYTE PTR POSX1
        CALL    CLEARMOVING1
        CALL    ELEMENT1
ENDRIGHT1_6:
        RET

RIGHT1_6NEXTFORM4:
        CMP     FORM1, 04D
        JNE     ENDRIGHT1_6                ; if not form 4 jmp no match type

        INC     DI

        CMP     POSX1, 09D               ; if element stay at right of block
        JAE     ENDRIGHT1_6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_6
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_6
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_6

        JMP     RIGHT1_6CALL

RIGHT1_6        ENDP
;-------------------------------------------------------------------
                        ; moving type 7 right 1
RIGHT1_7        PROC    NEAR

        CMP     FORM1, 01D
        JNE     RIGHT1_7NEXTFORM2          ; if not form 1 jmp to test next type

        ADD     DI, 02D

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_7
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_7
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_7

        JMP     RIGHT1_7CALL

RIGHT1_7NEXTFORM2:
        CMP     FORM1, 02D
        JNE     RIGHT1_7NEXTFORM3          ; if not form 2 jmp to test next type

        SUB     DI, 09D

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_7
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_7
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_7

        JMP     RIGHT1_7CALL

RIGHT1_7NEXTFORM3:
        CMP     FORM1, 03D
        JNE     RIGHT1_7NEXTFORM4          ; if not form 3 jmp to test next type

        ADD     DI, 02D

        CMP     POSX1, 08D               ; if element stay at right of block
        JAE     ENDRIGHT1_7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_7
        SUB     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_7

RIGHT1_7CALL:
        INC     BYTE PTR POSX1
        CALL    CLEARMOVING1
        CALL    ELEMENT1
ENDRIGHT1_7:
        RET

RIGHT1_7NEXTFORM4:
        CMP     FORM1, 04D
        JNE     ENDRIGHT1_7                ; if not form 4 jmp no match type

        INC     DI

        CMP     POSX1, 09D               ; if element stay at right of block
        JAE     ENDRIGHT1_7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving right
        JNE     ENDRIGHT1_7
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_7
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDRIGHT1_7

        JMP     RIGHT1_7CALL

RIGHT1_7        ENDP
;-------------------------------------------------------------------
                        ; procedure for moving left element 1
LEFT_1  PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        ;++++++++++++++++++++++++++++++++++++

        MOV     AX, DS
        MOV     ES, AX

        MOV     AL, 10D                 ; store posy for multiply
        LEA     DI, ARRAY1              ; clear si for put position

        MUL     POSY1                   ; calculate for put element
        ADD     DI, AX
        MOV     AX, 00H
        MOV     AL, POSX1
        ADD     DI, AX                  ; di = center position of element

        CMP     TYPEELE1, 01D            ; check type1
        JNE     TESTNEXTTYPEL1_2
        CALL    LEFT1_1
        JMP     ENDLEFT_1
TESTNEXTTYPEL1_2:
        CMP     TYPEELE1, 02D            ; check type2
        JNE     TESTNEXTTYPEL1_3
        CALL    LEFT1_2
        JMP     ENDLEFT_1

TESTNEXTTYPEL1_3:
        CMP     TYPEELE1, 03D            ; check type3
        JNE     TESTNEXTTYPEL1_4
        CALL    LEFT1_3
        JMP     ENDLEFT_1

TESTNEXTTYPEL1_4:
        CMP     TYPEELE1, 04D            ; check type4
        JNE     TESTNEXTTYPEL1_5
        CALL    LEFT1_4
        JMP     ENDLEFT_1

TESTNEXTTYPEL1_5:
        CMP     TYPEELE1, 05D            ; check type5
        JNE     TESTNEXTTYPEL1_6
        CALL    LEFT1_5
        JMP     ENDLEFT_1

TESTNEXTTYPEL1_6:
        CMP     TYPEELE1, 06D            ; check type6
        JNE     TESTNEXTTYPEL1_7
        CALL    LEFT1_6
        JMP     ENDLEFT_1

TESTNEXTTYPEL1_7:
        CMP     TYPEELE1, 07D            ; check type7
        JNE     ENDLEFT_1
        CALL    LEFT1_7

ENDLEFT_1:
        ;++++++++++++++++++++++++++++++++++++
        POP     DI
        POP     ES
        POP     AX

        RET

LEFT_1  ENDP
;-------------------------------------------------------------------
                        ; moving type 1 left 1
LEFT1_1         PROC    NEAR

        CMP     FORM1, 01D
        JNE     LEFT1_1NEXTFORM2          ; if not form 1 jmp to test next type

        SUB     DI, 02D

        CMP     POSX1, 01D               ; if element stay at left of block
        JBE     ENDLEFT1_1
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_1

        JMP     LEFT1_1CALL

LEFT1_1NEXTFORM2:
        CMP     FORM1, 02D
        JNE     ENDLEFT1_1             ; if not form 2 jmp no match type

        SUB     DI, 11D

        CMP     POSX1, 00D               ; if element stay at buttom of block
        JBE     ENDLEFT1_1
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_1

        MOV     CX, 03D
LOOP_LEFT1_1FORM2:
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_1
        LOOP    LOOP_LEFT1_1FORM2

LEFT1_1CALL:
        DEC     BYTE PTR POSX1
        CALL    CLEARMOVING1
        CALL    ELEMENT1

ENDLEFT1_1:
        RET
LEFT1_1 ENDP
;-------------------------------------------------------------------
                        ; moving type 2 left 1
LEFT1_2 PROC    NEAR

        CMP     FORM1, 01D
        JNE     LEFT1_2NEXTFORM2         ; if not form 1 jmp to test next type

        SUB     DI, 02D

        CMP     POSX1, 01D               ; if element stay at left of block
        JBE     ENDLEFT1_2
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_2
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_2

        JMP     LEFT1_2CALL

LEFT1_2NEXTFORM2:
        CMP     FORM1, 02D
        JNE     ENDLEFT1_2                ; if not form 2 jmp no match type

        DEC     DI

        CMP     POSX1, 00D               ; if element stay at left of block
        JBE     ENDLEFT1_2

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_2
        SUB     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_2
        ADD     DI, 19D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_2

LEFT1_2CALL:
        DEC     BYTE PTR POSX1
        CALL    CLEARMOVING1
        CALL    ELEMENT1

ENDLEFT1_2:
        RET
LEFT1_2 ENDP
;-------------------------------------------------------------------
                        ; moving type 3 left 1
LEFT1_3 PROC    NEAR

        CMP     FORM1, 01D
        JNE     ENDLEFT1_3               ; if not form 1 jmp no match type

        DEC     DI

        CMP     POSX1, 00D               ; if element stay at left of block
        JBE     ENDLEFT1_3

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_3
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_3

        DEC     BYTE PTR POSX1

        CALL    CLEARMOVING1
        CALL    ELEMENT1

ENDLEFT1_3:
        RET
LEFT1_3 ENDP
;-------------------------------------------------------------------
                        ; moving type 4 left 1
LEFT1_4 PROC    NEAR

        CMP     FORM1, 01D
        JNE     LEFT1_4NEXTFORM2         ; if not form 1 jmp to test next type

        DEC     DI

        CMP     POSX1, 01D               ; if element stay at left of block
        JBE     ENDLEFT1_4
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_4
        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_4

        JMP     LEFT1_4CALL

LEFT1_4NEXTFORM2:
        CMP     FORM1, 02D
        JNE     ENDLEFT1_4               ; if not form 2 jmp no match type

        DEC     DI

        CMP     POSX1, 00D               ; if element stay at left of block
        JBE     ENDLEFT1_4

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_4
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_4
        ADD     DI, 21D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_4

LEFT1_4CALL:
        DEC     BYTE PTR POSX1
        CALL    CLEARMOVING1
        CALL    ELEMENT1

ENDLEFT1_4:
        RET
LEFT1_4 ENDP
;-------------------------------------------------------------------
                        ; moving type 5 left 1
LEFT1_5 PROC    NEAR

        CMP     FORM1, 01D
        JNE     LEFT1_5NEXTFORM2         ; if not form 1 jmp to test next type

        SUB     DI, 02D

        CMP     POSX1, 01D               ; if element stay at left of block
        JBE     ENDLEFT1_5
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_5
        ADD     DI, 12D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_5

        JMP     LEFT1_5CALL

LEFT1_5NEXTFORM2:
        CMP     FORM1, 02D
        JNE     LEFT1_5NEXTFORM3          ; if not form 2 jmp to test next type

        DEC     DI

        CMP     POSX1, 00D               ; if element stay at left of block
        JBE     ENDLEFT1_5

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_5
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_5
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_5

        JMP     LEFT1_5CALL

LEFT1_5NEXTFORM3:
        CMP     FORM1, 03D
        JNE     LEFT1_5NEXTFORM4          ; if not form 3 jmp to test next type

        SUB     DI, 02D

        CMP     POSX1, 01D               ; if element stay at left of block
        JBE     ENDLEFT1_5

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_5
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_5

LEFT1_5CALL:
        DEC     BYTE PTR POSX1
        CALL    CLEARMOVING1
        CALL    ELEMENT1
ENDLEFT1_5:
        RET

LEFT1_5NEXTFORM4:
        CMP     FORM1, 04D
        JNE     ENDLEFT1_5                ; if not form 4 jmp no match type

        DEC     DI
        CMP     POSX1, 01D               ; if element stay at left of block
        JBE     ENDLEFT1_5

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_5
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_5
        ADD     DI, 19D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_5

        JMP     LEFT1_5CALL

LEFT1_5  ENDP
;-------------------------------------------------------------------
                        ; moving type 6 left 1
LEFT1_6 PROC    NEAR

        CMP     FORM1, 01D
        JNE     LEFT1_6NEXTFORM2          ; if not form 1 jmp to test next type

        SUB     DI, 02D

        CMP     POSX1, 01D               ; if element stay at left of block
        JBE     ENDLEFT1_6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_6
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_6

        JMP     LEFT1_6CALL

LEFT1_6NEXTFORM2:
        CMP     FORM1, 02D
        JNE     LEFT1_6NEXTFORM3          ; if not form 2 jmp to test next type

        DEC     DI

        CMP     POSX1, 00D               ; if element stay at left of block
        JBE     ENDLEFT1_6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_6
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_6
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_6

        JMP     LEFT1_6CALL

LEFT1_6NEXTFORM3:
        CMP     FORM1, 03D
        JNE     LEFT1_6NEXTFORM4          ; if not form 3 jmp to test next type

        SUB     DI, 02D

        CMP     POSX1, 01D               ; if element stay at left of block
        JBE     ENDLEFT1_6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_6
        SUB     DI, 08D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_6

LEFT1_6CALL:
        DEC     BYTE PTR POSX1
        CALL    CLEARMOVING1
        CALL    ELEMENT1
ENDLEFT1_6:
        RET

LEFT1_6NEXTFORM4:
        CMP     FORM1, 04D
        JNE     ENDLEFT1_6                ; if not form 4 jmp no match type

        DEC     DI

        CMP     POSX1, 01D               ; if element stay at left of block
        JBE     ENDLEFT1_6

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_6
        SUB     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_6
        ADD     DI, 21D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_6

        JMP     LEFT1_6CALL

LEFT1_6 ENDP
;-------------------------------------------------------------------
                        ; moving type 7 left 1
LEFT1_7 PROC    NEAR

        CMP     FORM1, 01D
        JNE     LEFT1_7NEXTFORM2          ; if not form 1 jmp to test next type

        SUB     DI, 02D

        CMP     POSX1, 01D               ; if element stay at left of block
        JBE     ENDLEFT1_7
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_7
        ADD     DI, 11D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_7

        JMP     LEFT1_7CALL

LEFT1_7NEXTFORM2:
        CMP     FORM1, 02D
        JNE     LEFT1_7NEXTFORM3          ; if not form 2 jmp to test next type

        DEC     DI

        CMP     POSX1, 00D               ; if element stay at left of block
        JBE     ENDLEFT1_7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_7
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_7
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_7

        JMP     LEFT1_7CALL

LEFT1_7NEXTFORM3:
        CMP     FORM1, 03D
        JNE     LEFT1_7NEXTFORM4          ; if not form 3 jmp to test next type

        SUB     DI, 02D

        CMP     POSX1, 01D               ; if element stay at left of block
        JBE     ENDLEFT1_7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_7
        SUB     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_7

LEFT1_7CALL:
        DEC     BYTE PTR POSX1
        CALL    CLEARMOVING1
        CALL    ELEMENT1
ENDLEFT1_7:
        RET

LEFT1_7NEXTFORM4:
        CMP     FORM1, 04D
        JNE     ENDLEFT1_7                ; if not form 4 jmp no match type

        SUB     DI, 02D

        CMP     POSX1, 01D               ; if element stay at left of block
        JBE     ENDLEFT1_7

        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for moving left
        JNE     ENDLEFT1_7
        SUB     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_7
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDLEFT1_7

        JMP     LEFT1_7CALL

LEFT1_7  ENDP
;-------------------------------------------------------------------
                        ; procedure for rotate element 1
ROTATE_1        PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        ;++++++++++++++++++++++++++++++++++++

        MOV     AX, DS
        MOV     ES, AX

        MOV     AL, 10D                 ; store posy for multiply
        LEA     DI, ARRAY1              ; clear si for put position

        MUL     POSY1                   ; calculate for put element
        ADD     DI, AX
        MOV     AX, 00H
        MOV     AL, POSX1
        ADD     DI, AX                  ; di = center position of element

        CMP     TYPEELE1, 01D            ; check type1
        JNE     TESTNEXTTYPEO1_2
        CALL    ROTATE1_1
        JMP     ENDROTATE_1
TESTNEXTTYPEO1_2:
        CMP     TYPEELE1, 02D            ; check type2
        JNE     TESTNEXTTYPEO1_3
        CALL    ROTATE1_2
        JMP     ENDROTATE_1

TESTNEXTTYPEO1_3:
        CMP     TYPEELE1, 03D            ; check type3
        JNE     TESTNEXTTYPEO1_4
        JMP     ENDROTATE_1

TESTNEXTTYPEO1_4:
        CMP     TYPEELE1, 04D            ; check type4
        JNE     TESTNEXTTYPEO1_5
        CALL    ROTATE1_4
        JMP     ENDROTATE_1

TESTNEXTTYPEO1_5:
        CMP     TYPEELE1, 05D            ; check type5
        JNE     TESTNEXTTYPEO1_6
        CALL    ROTATE1_5
        JMP     ENDROTATE_1

TESTNEXTTYPEO1_6:
        CMP     TYPEELE1, 06D            ; check type6
        JNE     TESTNEXTTYPEO1_7
        CALL    ROTATE1_6
        JMP     ENDROTATE_1

TESTNEXTTYPEO1_7:
        CMP     TYPEELE1, 07D            ; check type7
        JNE     ENDROTATE_1
        CALL    ROTATE1_7

ENDROTATE_1:
        ;++++++++++++++++++++++++++++++++++++
        POP     DI
        POP     ES
        POP     AX

        RET

ROTATE_1        ENDP
;-------------------------------------------------------------------
                        ; rotate type 1 1
ROTATE1_1       PROC    NEAR

        ; form 1 ---> 2

        CMP     FORM1, 01D
        JNE     ROTATE1_1NEXTFORM2        ; if not form 1 jmp to test next type

        CMP     POSY1, 18D               ; if element stay at left of block
        JA      ENDROTATE1_1


        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_1
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_1
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_1

        MOV     FORM1, 02D
        JMP     ROTATE1_1CALL

ROTATE1_1NEXTFORM2:                       ; form 2 ---> 1
        CMP     FORM1, 02D
        JNE     ENDROTATE1_1              ; if not form 2 jmp no match type


        CMP     POSX1, 01D               ; if element stay at left of block
        JB      ENDROTATE1_1
        CMP     POSX1, 07D               ; if element stay at right of block
        JA      ENDROTATE1_1

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_1
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_1
        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_1

        MOV     FORM1, 01D

ROTATE1_1CALL:
        CALL    CLEARMOVING1
        CALL    ELEMENT1

ENDROTATE1_1:
        RET
ROTATE1_1       ENDP
;-------------------------------------------------------------------
                        ; rotate type 2 1
ROTATE1_2       PROC    NEAR

        ; form 1 ---> 2

        CMP     FORM1, 01D
        JNE     ROTATE1_2NEXTFORM2         ; if not form 1 jmp to test next type

        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_2
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_2

        MOV     FORM1, 02D
        JMP     ROTATE1_2CALL

ROTATE1_2NEXTFORM2:                     ; form 2 ---> 1
        CMP     FORM1, 02D
        JNE     ENDROTATE1_2            ; if not form 2 jmp no match type

        CMP     POSX1, 01D               ; if element stay at left of block
        JB      ENDROTATE1_2

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_2
        ADD     DI, 12D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_2

        MOV     FORM1, 01D

ROTATE1_2CALL:
        CALL    CLEARMOVING1
        CALL    ELEMENT1

ENDROTATE1_2:
        RET
ROTATE1_2       ENDP
;-------------------------------------------------------------------
                        ; rotate form 4 1
ROTATE1_4       PROC    NEAR

        ; form 1 ---> 2

        CMP     FORM1, 01D
        JNE     ROTATE1_4NEXTFORM2         ; if not form 1 jmp to test next type

        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_4
        ADD     DI, 21D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_4

        MOV     FORM1, 02D
        JMP     ROTATE1_4CALL

ROTATE1_4NEXTFORM2:                       ; form 2 ---> 1
        CMP     FORM1, 02D
        JNE     ENDROTATE1_4              ; if not form 2 jmp no match type

        CMP     POSX1, 01D               ; if element stay at left of block
        JB      ENDROTATE1_4

        ADD     DI, 09D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_4
        INC     DI
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_4

        MOV     FORM1, 01D

ROTATE1_4CALL:
        CALL    CLEARMOVING1
        CALL    ELEMENt1

ENDROTATE1_4:
        RET
ROTATE1_4       ENDP
;-------------------------------------------------------------------
                        ; rotate type 5 1
ROTATE1_5       PROC    NEAR

        ; form 1 ---> 2

        CMP     FORM1, 01D
        JNE     ROTATE1_5NEXTFORM2        ; if not form 1 jmp to test next type

        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_5
        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_5
        ADD     DI, 19D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_5

        MOV     FORM1, 02D
        JMP     ROTATE1_5CALL

ROTATE1_5NEXTFORM2:                       ; form 2 ---> 3
        CMP     FORM1, 02D
        JNE     ROTATE1_5NEXTFORM3        ; if not form 2 jmp to test next type

        CMP     POSX1, 01D               ; if element stay at left of block
        JB      ENDROTATE1_5

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_5
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_5
        ADD     DI, 12D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_5

        MOV     FORM1, 03D
        JMP     ROTATE1_5CALL

ROTATE1_5NEXTFORM3:                       ; form 3 ---> 4
        CMP     FORM1, 03D
        JNE     ROTATE1_5NEXTFORM4        ; if not form 3 jmp to test next type

        CMP     POSY1, 19D               ; if element stay at buttom of block
        JA      ENDROTATE1_5

        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_5
        ADD     DI, 19D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_5
        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_5

        MOV     FORM1, 04D

ROTATE1_5CALL:
        CALL    CLEARMOVING1
        CALL    ELEMENT1
ENDROTATE1_5:
        RET

ROTATE1_5NEXTFORM4:                       ; form 4 ---> 1
        CMP     FORM1, 04D
        JNE     ENDROTATE1_5              ; if not form 4 jmp no match type

        CMP     POSX1, 08D               ; if element stay at right of block
        JA      ENDROTATE1_5

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_5
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_5
        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_5

        MOV     FORM1, 01D
        JMP     ROTATE1_5CALL

ROTATE1_5       ENDP
;-------------------------------------------------------------------
                        ; rotate type 6 1
ROTATE1_6       PROC    NEAR

        ; form 1 ---> 2

        CMP     FORM1, 01D
        JNE     ROTATE1_6NEXTFORM2        ; if not form 1 jmp to test next type

        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_6
        ADD     DI, 20D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_6
        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_6

        MOV     FORM1, 02D
        JMP     ROTATE1_6CALL

ROTATE1_6NEXTFORM2:                       ; form 2 ---> 3
        CMP     FORM1, 02D
        JNE     ROTATE1_6NEXTFORM3        ; if not form 2 jmp to test next type

        CMP     POSX1, 01D               ; if element stay at left of block
        JB      ENDROTATE1_6

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_6
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_6
        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_6

        MOV     FORM1, 03D
        JMP     ROTATE1_6CALL

ROTATE1_6NEXTFORM3:                       ; form 3 ---> 4
        CMP     FORM1, 03D
        JNE     ROTATE1_6NEXTFORM4        ; if not form 3 jmp to test next type

        CMP     POSY1, 19D               ; if element stay at left of block
        JA      ENDROTATE1_6

        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_6
        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_6

        ADD     DI, 21D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_6

        MOV     FORM1, 04D

ROTATE1_6CALL:
        CALL    CLEARMOVING1
        CALL    ELEMENT1
ENDROTATE1_6:
        RET

ROTATE1_6NEXTFORM4:                       ; form 4 ---> 1
        CMP     FORM1, 04D
        JNE     ENDROTATE1_6              ; if not form 4 jmp no match type

        CMP     POSX1, 08D               ; if element stay at right of block
        JA      ENDROTATE1_6

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_6
        ADD     DI, 02D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_6
        ADD     DI, 08D
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_6

        MOV     FORM1, 01D
        JMP     ROTATE1_6CALL

ROTATE1_6       ENDP
;-------------------------------------------------------------------
                        ; rotate type 7 1
ROTATE1_7       PROC    NEAR

        ; form 1 ---> 2

        CMP     FORM1, 01D
        JNE     ROTATE1_7NEXTFORM2          ; if not form 1 jmp to test next type

        SUB     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_7

        MOV     FORM1, 02D
        JMP     ROTATE1_7CALL

ROTATE1_7NEXTFORM2:                       ; form 2 ---> 3
        CMP     FORM1, 02D
        JNE     ROTATE1_7NEXTFORM3        ; if not form 2 jmp to test next type

        CMP     POSX1, 01D               ; if element stay at left of block
        JB      ENDROTATE1_7

        DEC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_7

        MOV     FORM1, 03D
        JMP     ROTATE1_7CALL

ROTATE1_7NEXTFORM3:                       ; form 3 ---> 4
        CMP     FORM1, 03D
        JNE     ROTATE1_7NEXTFORM4        ; if not form 3 jmp to test next type

        CMP     POSY1, 19D               ; if element stay at buttom of block
        JA      ENDROTATE1_7

        ADD     DI, 10D
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_7

        MOV     FORM1, 04D

ROTATE1_7CALL:
        CALL    CLEARMOVING1
        CALL    ELEMENT1
ENDROTATE1_7:
        RET

ROTATE1_7NEXTFORM4:                       ; form 4 ---> 1
        CMP     FORM1, 04D
        JNE     ENDROTATE1_7                ; if not form 4 jmp no match type


        CMP     POSX1, 08D               ; if element stay at right of block
        JA      ENDROTATE1_7

        INC     DI
        CMP     BYTE PTR DS:[DI], 00D   ; test for empty block for rotate
        JNE     ENDROTATE1_7
        INC     DI
        CMP     BYTE PTR DS:[DI], 00D
        JNE     ENDROTATE1_7

        MOV     FORM1, 01D
        JMP     ROTATE1_7CALL

ROTATE1_7       ENDP
;-------------------------------------------------------------------

                        ; procedure for change 1 to 2 (moving => store element)
NODOWN  PROC    NEAR
        PUSH    DI
        PUSH    CX
        ;+++++++++++++++++++++++++++

        LEA     DI, ARRAY
        MOV     CX, 210D                ; repeat 210 element

NODOWN_1:
        CMP     BYTE PTR DS:[DI], 01D
        JNE     NEXTBLOCK
        MOV     BYTE PTR DS:[DI], 02D

NEXTBLOCK:
        INC     DI
        LOOP    NODOWN_1

        call    check_line
        call    check_end
        
        cmp     byte ptr player, 03h
        jne     cmp_next_gen
        jmp     can_gen
cmp_next_gen:
        cmp     byte ptr player, 01h
        jne     no_gen

can_gen:
        CALL    GENNEXTELE
        jmp     exit_nodown
no_gen:
       call     refresh
exit_nodown:

        ;+++++++++++++++++++++++++++
        POP     CX
        POP     DI
        RET           

NODOWN  ENDP
;-------------------------------------------------------------------
                        ; procedure for generate next element after no down
GENNEXTELE      PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        PUSH    CX
        PUSH    DX
        ;+++++++++++++++++++++++++++

        MOV     AL, 00H                 ; read second from CMOS
        OUT     70H, AL
        IN      AL, 71H
        MOV     DH, AL

        AND     DH, 07H
        CMP     DH, 00H
        JNE     NOZERO
        MOV     DH, 04D
NOZERO:
        MOV     TYPEELE, DH
        MOV     FORM, 01D

        CMP     DH, 05D
        JNE     SETXY
        CMP     DH, 07D
        JNE     SETXY
        MOV     FORM, 03D

SETXY:
        MOV     POSX, 04D
        MOV     POSY, 00D

        ;+++++++++++++++++++++++++++
        POP     DX
        POP     CX
        POP     DI
        POP     ES
        POP     AX
        RET

GENNEXTELE      ENDP
;-------------------------------------------------------------------
                        ; procedure for change 1 to 2 (moving => store element)
NODOWN1 PROC    NEAR
        PUSH    DI
        PUSH    CX
        ;+++++++++++++++++++++++++++

        LEA     DI, ARRAY1
        MOV     CX, 210D                ; repeat 210 element

NODOWN1_1:
        CMP     BYTE PTR DS:[DI], 01D
        JNE     NEXTBLOCK_1
        MOV     BYTE PTR DS:[DI], 02D

NEXTBLOCK_1:
        INC     DI
        LOOP    NODOWN1_1

        call    check_line1
        call    check_end1

        cmp     byte ptr player, 03d            ; test player for 3 or 2
        jne     cmp_next_gen1
        jmp     can_gen1
cmp_next_gen1:
        cmp     byte ptr player, 02d
        jne     no_gen1
can_gen1:
        CALL    GENNEXTELE1
        jmp     exit_nodown1
no_gen1:
        call    refresh1
exit_nodown1:
        ;+++++++++++++++++++++++++++
        POP     CX
        POP     DI
        RET

NODOWN1 ENDP
;-------------------------------------------------------------------
                        ; procedure for generate next element after no down
GENNEXTELE1      PROC    NEAR
        PUSH    AX
        PUSH    ES
        PUSH    DI
        PUSH    CX
        PUSH    DX
        ;+++++++++++++++++++++++++++

        MOV     AL, 00H                 ; read second from CMOS
        OUT     70H, AL
        IN      AL, 71H
        MOV     DH, AL

        add     dh, 03d                 ; it could be equal with array0
        AND     DH, 07H
        CMP     DH, 00H
        JNE     NOZERO1
        MOV     DH, 04D
NOZERO1:
        MOV     TYPEELE1, DH
        MOV     FORM1, 01D

        CMP     DH, 05D
        JNE     SETXY1
        CMP     DH, 07D
        JNE     SETXY1
        MOV     FORM1, 03D

SETXY1:
        MOV     POSX1, 04D
        MOV     POSY1, 00D

        ;+++++++++++++++++++++++++++
        POP     DX
        POP     CX
        POP     DI
        POP     ES
        POP     AX
        RET

GENNEXTELE1     ENDP
;-------------------------------------------------------------------
                        ; procedure to check line
check_line      proc    near
        PUSH    ax
        PUSH    cx
        PUSH    dx
        PUSH    di
        PUSH    si
        ;+++++++++++++++++++++++++++

        push    ds                      ; prepare segment
        pop     es

        LEA     di, array
        MOV     cx, 21d
check_line_loop1:
        PUSH    cx
        MOV     cx, 10d

check_line_loop2:
        CMP     byte ptr ds:[di], 00h
        JE      no_ok_line              ; skip if it contain empty element
        INC     di
        LOOP    check_line_loop2

        ; --------- do if all element in line contain block
                  
        push    di

        dec     di
        mov     si, di
        sub     si, 10d

        lea     dx, array               ; generate number of moving
        mov     ax, si
        sub     ax, dx
        sub     ax, 10d
        mov     cx, ax
        std                             ; set direction flag (di&si-1)
check_line_loop4:                       ; loop for replacement
        rep     MOVSB
        cld

        MOV     cx, 10d
        LEA     di, array
        mov     al, 00d
check_line_loop5:                       ; loop for store 0 to top of block
        rep     stosb

        call    count_score
        pop     di
        jmp     no_add_cx

no_ok_line:
        add     di, cx

no_add_cx:
        POP     cx

        LOOP    check_line_loop1

        ;+++++++++++++++++++++++++++
        POP    si
        POP    di
        POP    dx
        POP    cx
        POP    ax
        RET

check_line      endp
;-------------------------------------------------------------------
                        ; procedure to check line 1
check_line1     proc    near
        PUSH    ax
        PUSH    cx
        PUSH    dx
        PUSH    di
        PUSH    si
        ;+++++++++++++++++++++++++++

        push    ds                      ; prepare segment
        pop     es

        LEA     di, array1
        MOV     cx, 21d
check_line_loop1_1:
        PUSH    cx
        MOV     cx, 10d

check_line_loop1_2:
        CMP     byte ptr ds:[di], 00h
        JE      no_ok_line_1            ; skip if it contain empty element
        INC     di
        LOOP    check_line_loop1_2

        ; --------- do if all element in line contain block

        push    di

        dec     di
        mov     si, di
        sub     si, 10d

        lea     dx, array1               ; generate number of moving
        mov     ax, si
        sub     ax, dx
        sub     ax, 10d
        mov     cx, ax
        std                             ; set direction flag (di&si-1)
check_line_loop1_4:                     ; loop for replacement
        rep     MOVSB
        cld

        MOV     cx, 10d
        LEA     di, array1
        mov     al, 00d
check_line_loop1_5:                       ; loop for store 0 to top of block
        rep     stosb

        call    count_score1
        pop     di
        jmp     no_add_cx_1

no_ok_line_1:
        add     di, cx

no_add_cx_1:
        POP     cx

        LOOP    check_line_loop1_1

        ;+++++++++++++++++++++++++++
        POP    si
        POP    di
        POP    dx
        POP    cx
        POP    ax
        RET

check_line1      endp
;-------------------------------------------------------------------

                        ; procedure for set new game
set_new proc    near
        push    es
        push    di
        push    cx
        push    ax
        ;+++++++++++++++++++++++++++

        push    ds
        pop     es
                                ; set new player1 (block0)
        lea     di, array
        mov     cx, 210d
        mov     al, 00d
        rep     stosb

        mov     cx, 03d                         ; clear score
        lea     di, score
        MOV     AL, 00D
        REP     STOSB

        mov     byte ptr typeele1, 00h          ; clear element in block
        mov     byte ptr form1, 00h

        call    show_score

        call    gennextele

                        ; set new player2 (block1)
        push    ds
        pop     es
        lea     di, array1                      ; clear block1
        mov     cx, 210d
        mov     al, 00d
        rep     stosb

        mov     cx, 03d                         ; clear score
        lea     di, score1
        MOV     AL, 00D
        REP     STOSB
        call    refresh1

        call    show_score1
        cmp     byte ptr player, 01d
        je     no_genplayer2

        call    gennextele1


no_genplayer2:

        ;+++++++++++++++++++++++++++
        pop    ax
        pop    cx
        pop    di
        pop    es
        ret
set_new endp
;-------------------------------------------------------------------
                        ; procedure to count up score
COUNT_SCORE     PROC    NEAR
        push    ax
        push    cx
        push    di
        push    si
        push    es
        ;+++++++++++++++++++++++++++

        LEA     DI, SCORE
        ADd     DI, 02d
        MOV     AL, BYTE PTR DS:[DI]    ; load score1 from memory
        INC     AL
        CMP     AL, 10D
        Jb      NO_CARRY3
        MOV     AL, 00D
NO_CARRY1:
        mov     byte ptr ds:[di], al
        dec     di
        MOV     AL, BYTE PTR DS:[DI]    ; load score2 from memory
        inc     al
        CMP     AL, 10D
        Jb      NO_CARRY3
        MOV     AL, 00D
NO_CARRY2:
        mov     byte ptr ds:[di], al
        dec     di
        MOV     AL, BYTE PTR DS:[DI]    ; load score3 from memory
        inc     Al
        CMP     AL, 10D
        Jb      NO_CARRY3
        MOV     AL, 00D
NO_CARRY3:
        mov     byte ptr ds:[di], al

        call    show_score

        ;+++++++++++++++++++++++++++
        pop     es
        pop     si
        pop     di
        pop     cx
        pop     ax
        ret
count_score     endp
;-------------------------------------------------------------------
show_score      proc    near
        push    ax
        push    cx
        push    es
        push    di
        push    si
        ;+++++++++++++++++++++++++++

        mov     ax, 0b800h
        mov     es, ax
        mov     di, 3820d                ; position on screen
        mov     ah, 0fh                 ; set attribute
        mov     cx, 03d
        lea     si, score
loop_count_score1:
        lodsb
        add     al, 30h
        stosw
        loop    loop_count_score1
        
        ;+++++++++++++++++++++++++++
        pop     si              
        pop     di
        pop     es
        pop     cx
        pop     ax
        ret
show_score      endp
;-------------------------------------------------------------------
                        ; procedure to count up score 1
COUNT_SCORE1    PROC    NEAR
        push    ax
        push    cx
        push    di
        push    si
        push    es
        ;+++++++++++++++++++++++++++

        LEA     DI, SCORE1
        ADd     DI, 02d
        MOV     AL, BYTE PTR DS:[DI]    ; load score1 from memory
        INC     AL
        CMP     AL, 10D
        Jb      NO_CARRY1_3
        MOV     AL, 00D
NO_CARRY1_1:
        mov     byte ptr ds:[di], al
        dec     di
        MOV     AL, BYTE PTR DS:[DI]    ; load score2 from memory
        inc     al
        CMP     AL, 10D
        Jb      NO_CARRY1_3
        MOV     AL, 00D
NO_CARRY1_2:
        mov     byte ptr ds:[di], al
        dec     di
        MOV     AL, BYTE PTR DS:[DI]    ; load score3 from memory
        inc     Al
        CMP     AL, 10D
        Jb      NO_CARRY1_3
        MOV     AL, 00D
NO_CARRY1_3:
        mov     byte ptr ds:[di], al

        call    show_score1

        ;+++++++++++++++++++++++++++
        pop     es
        pop     si
        pop     di
        pop     cx
        pop     ax
        ret
count_score1     endp
;-------------------------------------------------------------------
show_score1     proc    near
        push    ax
        push    cx
        push    es
        push    di
        push    si
        ;+++++++++++++++++++++++++++

        mov     ax, 0b800h
        mov     es, ax
        mov     di, 3718d                ; position on screen
        mov     ah, 0bh                 ; set attribute
        mov     cx, 03d
        lea     si, score1
loop_show_score1_1:
        lodsb
        add     al, 30h
        stosw
        loop    loop_show_score1_1
        
        ;+++++++++++++++++++++++++++
        pop     si              
        pop     di
        pop     es
        pop     cx
        pop     ax
        ret
show_score1      endp
;-------------------------------------------------------------------
                        ; procedure for change font
chgfon  proc    near
        PUSH    BP
        PUSH    ES
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        ;+++++++++++++++++++++++++++


        MOV     AX, DS          ; STORE SEGMENT OF TABLE TO ES
        MOV     ES, AX

        LEA     BP, BOX1        ; STORE OFFSET OF TABLE TO BP 1
        MOV     CX, 01H         ; DO ONE CHARACTER AT A TIME
        MOV     DX, 0b1h        ; START WITH CHARACTER 0b1h
        MOV     BL, 0           ; CHANG TABLE 0 (0-2)
        MOV     BH, 16d         ; 16 BYTE PER CHARACTER

        MOV     AH, 11H         ; FUNCTION = LOAD CHARACTER GENERATOR
        MOV     AL, 00H         ; SUBFUNCTION = CUSTOM CHAR. GEN.
        INT     10H             ; CALL INTERRUPT

        LEA     BP, BOX2        ; STORE OFFSET OF TABLE TO BP 2
        MOV     CX, 01H         ; DO ONE CHARACTER AT A TIME
        MOV     DX, 0b2h        ; START WITH CHARACTER 0b1h
        MOV     BL, 0           ; CHANG TABLE 0 (0-2)
        MOV     BH, 16d         ; 16 BYTE PER CHARACTER

        MOV     AH, 11H         ; FUNCTION = LOAD CHARACTER GENERATOR
        MOV     AL, 00H         ; SUBFUNCTION = CUSTOM CHAR. GEN.
        INT     10H             ; CALL INTERRUPT

        ;+++++++++++++++++++++++++++
        POP     DX
        POP     CX
        POP     BX
        POP     AX
        POP     ES
        POP     BP
        RET
CHGFON  ENDP
;-------------------------------------------------------------------
                        ; procedure for delay using port 61h
DELAY61 PROC    NEAR
        push    cx
        push    ax
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++

        IN      al, 61h                              
        AND     al, 10h                              
        MOV     ah, al                               
        MOV     cx, word ptr TIMEPORT
CNT1:                                                
        IN      al, 61h                              
        AND     al, 10h                              
        CMP     al, ah                               
        je      cnt1                                 
        mov     ah, al                               
        dec     cx
        jnz     cnt1

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     ax
        pop     cx
        ret
DELAY61 ENDP
;-------------------------------------------------------------------
                        ; fade screen to black
FADE_IN proc    near
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++

        MOV     CX, 64D
LOOPCOLOR_in:
        PUSH    CX

        call    readpal

        LEA     DI, COLOR
        MOV     CX, 768D
DECRE_in:
        CMP     BYTE PTR DS:[DI], 00H
        JE      NODEC_in
        DEC     BYTE PTR DS:[DI]
NODEC_in:
        INC     DI
        LOOP    DECRE_in

        call    delay61
        call    wait_retrace                    ; wait for retrace
        call    setpal

NOINT_in:
        POP     CX
        LOOP    LOOPCOLOR_in

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     di
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
FADE_IN endp
;-------------------------------------------------------------------
                        ; fade screen to write
FADE_OUT        proc    near
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++

        MOV     CX, 64D
LOOPCOLOR_out:
        PUSH    CX

        call    readpal

        LEA     DI, COLOR
        MOV     CX, 768D
INCRE_out:
        CMP     BYTE PTR DS:[DI], 03fH
        JE      NOINC_out
        INC     BYTE PTR DS:[DI]
NOINC_out:
        INC     DI
        LOOP    INCRE_out

        call    delay61

        call    wait_retrace                    ; wait for retrace
        call    setpal

noint_out:
        POP     CX
        LOOP    LOOPCOLOR_out

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     di
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
FADE_OUT        endp
;-------------------------------------------------------------------
                        ; get color for implement
getpallate      proc    near
        push    di
        push    cx
        push    ax
        push    dx

        lea     di, colorbase
        MOV     CX, 00D                         ; begin color
loop_getpal1:
        push    cx
        mov     al, cl
        mov     dx, 03c7h                       ; port for read color
        out     dx, al                          ; for read color
        mov     cx, 03d
loop_getpal2:
        mov     dx, 03c9h                       ; read color from port
        in      al, dx
        stosb
        loop    loop_getpal2
        pop     cx
        inc     cx
        cmp     cx, 255d                        ; last number of color
        jbe     loop_getpal1

        pop     dx
        pop     ax
        pop     cx
        pop     si
        ret
getpallate      endp
;-------------------------------------------------------------------
                        ; fade screen from write to original
FADE_INTO       proc    near
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++

        MOV     CX, 64D
LOOPCOLOR_into:
        PUSH    CX

        call    readpal

        lea     si, colorbase
        LEA     DI, COLOR
        MOV     CX, 768D
DECRE_into:
        mov     al, byte ptr ds:[si]
        CMP     BYTE PTR DS:[DI], al
        JE      NODEC_into
        DEC     BYTE PTR DS:[DI]
NODEC_into:
        INC     DI
        inc     si
        LOOP    DECRE_into

        call    delay61

        call    wait_retrace
        call    setpal

NOINT_into:
        POP     CX
        LOOP    LOOPCOLOR_into

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     si
        pop     di
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
FADE_INTO       endp
;-------------------------------------------------------------------
                        ; fade screen from black to original
FADE_outof       proc    near
        push    ax
        push    bx
        push    cx
        push    dx
        push    di
        push    si
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++

        MOV     CX, 64D
LOOPCOLOR_outof:
        PUSH    CX

        call    readpal

        lea     si, colorbase
        LEA     DI, COLOR
        MOV     CX, 768D
INCRE_outof:
        mov     al, byte ptr ds:[si]
        CMP     BYTE PTR DS:[DI], al
        JE      NOINC_outof
        INC     BYTE PTR DS:[DI]
NOINC_outof:
        INC     DI
        inc     si
        LOOP    INCRE_outof

        call    delay61

        call    wait_retrace
        call    setpal


NOINT_outof:
        POP     CX
        LOOP    LOOPCOLOR_outof

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     si
        pop     di
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
FADE_outof       endp
;-------------------------------------------------------------------
                        ; wait retrace
wait_retrace    proc    near
        push    ax
        push    dx
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++

        mov     dx, 03dah
wait_RE:
        in      al, dx
        and     al, 08h
        jnz     wait_RE

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     dx
        pop     ax
        ret
wait_retrace    endp
;-------------------------------------------------------------------
                        ; procedure for set pallate
setpal  proc    near
        push    si
        push    cx
        push    ax
        push    dx
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++

        lea     si, color
        MOV     CX, 00D                         ; begin color
loop_setpal1:
        push    cx
        mov     al, cl
        mov     dx, 03c8h                       ; port for write color
        out     dx, al                          ; for set color
        mov     cx, 03d
loop_setpal2:
        lodsb
        mov     dx, 03c9h
        out     dx, al                          ; set color
        loop    loop_setpal2
        pop     cx
        inc     cx
        cmp     cx, 255d                        ; last number of color
        jbe     loop_setpal1

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     dx
        pop     ax
        pop     cx
        pop     si
        ret
setpal  endp
;-------------------------------------------------------------------
                        ; procedure for read pallate
readpal proc    near
        push    di
        push    cx
        push    ax
        push    dx
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++

        lea     di, color
        MOV     CX, 00D                         ; begin color
loop_readpal1:
        push    cx
        mov     al, cl
        mov     dx, 03c7h                       ; port for read color
        out     dx, al                          ; for read color
        mov     cx, 03d
loop_readpal2:
        mov     dx, 03c9h                       ; read color from port
        in      al, dx
        stosb
        loop    loop_readpal2
        pop     cx
        inc     cx
        cmp     cx, 255d                        ; last number of color
        jbe     loop_readpal1

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     dx
        pop     ax
        pop     cx
        pop     si
        ret
readpal endp
;-------------------------------------------------------------------
                        ; procedure for clear screen
clear_screen    proc    near
        push    ax
        push    cx
        push    es
        push    di
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++

        mov     ax, 0b800h
        mov     es, ax
        mov     di, 00h
        mov     ax, 00h
        mov     cx, 2000d
        rep     stosw

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     di
        pop     es
        pop     cx
        pop     ax
        ret
clear_screen    endp
;-------------------------------------------------------------------
                        ; procedure for pause
pause_press     proc    near
        push    ax
        push    es
        push    di
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++

        call    fade_out
        call    fade_in

        mov     ax, 0040h
        mov     es, ax
        mov     di, 00feh
        MOV     BYTE PTR ES:[DI], 00H           ; CLEAR BUFFER

no_key_press:
        mov     ax, 0040h               ; wait for any key ...
        mov     es, ax
        mov     di, 00feh
        mov     al, byte ptr es:[di]
        cmp     al, 00h
        je      no_key_press
        call    fade_out
        call    fade_into

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     di
        pop     es
        pop     ax
        ret
pause_press     endp
;-------------------------------------------------------------------
                        ; procedure for show speed        
show_speed      proc    near
        push    ax
        push    cx
        push    es
        push    si
        push    di
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++

        mov     ax, 0b800h
        mov     es, ax
        mov     di, 390d                ; STARTING ADDRESS
        lea     si, speed
        mov     cx, 08d
        mov     ah, 0fh
loop_show_speed:
        lodsb
        stosw
        loop    loop_show_speed

        mov     ah, byte ptr time
        mov     al, 10d
        sub     al, ah
        add     al, 30h
        mov     ah, 14d
        stosw

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     di
        pop     si
        pop     es
        pop     cx
        pop     ax
        ret
show_speed      endp
;-------------------------------------------------------------------
                        ; procedure for check end block0
check_end       proc    near
        push    di
        push    cx

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++

        lea     di, array
        mov     cx, 10d
loop_check_end:
        cmp     byte ptr ds:[di], 02d   ; test for stored element
        jne     no_end

        sub     byte ptr player, 01d    ; if player=3 then player:=2
                                        ; if player=1 then player:=0

        mov     byte ptr typeele, 00h   ; clear element in block0
        mov     byte ptr form, 00h

        jmp     exit_check_end

no_end:
        inc     di
        loop    loop_check_end

exit_check_end:

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     cx
        pop     di
        ret
check_end       endp
;-------------------------------------------------------------------
                        ; procedure for check end block1
check_end1      proc    near
        push    di
        push    cx

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++

        lea     di, array1
        mov     cx, 10d
loop_check_end1:
        cmp     byte ptr ds:[di], 02d   ; test for stored element
        jne     no_end1

        sub     byte ptr player, 02d    ; if player=3 then player:=1
                                        ; if player=2 then player:=0
        
        mov     byte ptr typeele1, 00h  ; clear element in block1
        mov     byte ptr form1, 00h     
        
        jmp     exit_check_end1

no_end1:
        inc     di
        loop    loop_check_end1

exit_check_end1:

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     cx
        pop     di
        ret
check_end1      endp
;-------------------------------------------------------------------
show_help       proc    near
        push    ax
        push    cx
        push    es
        push    di
        push    si
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++

        call    fade_in
        call    clear_screen

        mov     ax, 0b800h
        mov     es, ax
        mov     di, 198d                ; starting address
        lea     si, help
        mov     cx, 23d
loop_show_helpr:
        push    cx
        mov     cx, 47d
loop_show_helpc:
        lodsb
        mov     ah, 00ah                ; set text attribute
        stosw
        loop    loop_show_helpc
        add     di, 66d
        pop     cx
        loop    loop_show_helpr

                                        ; show high score
        mov     di, 3448d
        lea     si, highs
        mov     cx, 03d
loop_show_high_score:
        lodsb
        mov     ah, 0bh                 ; attribute of high score
        add     al, 30h
        stosw
        loop    loop_show_high_score

        call    fade_outof
        
        mov     ax, 0040h
        mov     es, ax
        mov     di, 00feh
        MOV     BYTE PTR ES:[DI], 00H           ; CLEAR BUFFER

no_Alt_press:                                   ; wait for Key
        mov     ax, 0040h
        mov     es, ax
        mov     di, 00feh
        mov     al, byte ptr es:[di]
        cmp     al, 01h
        jne     no_Alt_press
        
        call    fade_in
        call    clear_screen
        call    printbar
        call    border
        call    show_speed
        call    show_score
        call    show_score1
        call    refresh
        call    refresh1
        call    fade_outof
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     si
        pop     di
        pop     es
        pop     cx
        pop     ax
        ret
show_help        endp
;-------------------------------------------------------------------
                                        

read_score      proc    near
        push    ax
        push    bx
        push    cx
        push    dx
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++
        
        mov     ah, 3dh                         ; open file
        mov     al, 02h                         ; with read/write
        lea     dx, highfile
        int     21h
        jc      cant_open                       ; jmp if can't open file
        mov     filehandle, ax

        mov     ah, 3fh                         ; read score from file
        mov     bx, filehandle
        mov     cx, 03d                         ; number of byte
        lea     dx, highs
        int     21h

        mov     ah, 3eh                         ; close file
        mov     bx, filehandle
        int     21h
        
cant_open:
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
read_score       endp
;-------------------------------------------------------------------
                        ; procedure for show title
Show_title      proc    near
        push    ax
        push    cx
        push    es
        push    di
        push    si
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++
                          
        mov     ax, 0b800h
        mov     es, ax
        mov     di, 1174d                       ; starting address
        lea     si, title1                      ; write A s s e m ...
        mov     cx, 28d                         ; 28 charactor
loop_title1:
        lodsb
        mov     ah, 0Bh
        stosw
        loop    loop_title1

        mov     di, 1518d                       ; write by
        mov     cx, 02d                         ; 2 charactor
loop_title2:
        lodsb
        mov     ah, 0Bh
        stosw
        loop    loop_title2

        mov     di, 1814d                       ; write Dusit ...
        mov     cx, 28d                         ; 22 charactor
loop_title3:
        lodsb
        mov     ah, 0Bh
        stosw
        loop    loop_title3

        mov     di, 2158d                       ; write to
        mov     cx, 02d                         ; 2 charactor
loop_title4:
        lodsb
        mov     ah, 0Bh
        stosw
        loop    loop_title4

        mov     di, 2460d                       ; Arjarn ...
        mov     cx, 22d                         ; 22 charactor
loop_title5:
        lodsb
        mov     ah, 0Bh
        stosw
        loop    loop_title5

        mov     di, 2892d                       ; Computer ...
        mov     cx, 69d                         ; 22 charactor
loop_title6:
        lodsb
        mov     ah, 0Bh
        stosw
        loop    loop_title6


        call    fade_outof

        mov     time, 48d                       ; wait about 3 sec
        call    delay

        call    fade_in
        call    clear_screen

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     si
        pop     di
        pop     es
        pop     cx
        pop     ax
        ret
Show_title      endp
;-------------------------------------------------------------------
                        ; procedure for check and write high score
check_high      proc    near
        push    ax
        push    bx
        push    cx
        push    dx
        push    es
        push    di
        push    si
        ;+++++++++++++++++++++++++++++++++++++++++++++++++++
               
        mov     cx, 03d                 ; compare 2 times
        lea     si, highs
        lea     di, score
loop_check_score:
        lodsb
        cmp     byte ptr ds:[di], AL
        jb      check_score1
        ja      store_score
        inc     di
        loop    loop_check_score
        jmp     check_score1

store_score:
        push    ds                              ; do if score above highs
        pop     es
        lea     di, highs
        lea     si, score
        mov     cx, 03d
                                                ; replace highs with score
        rep     movsb

check_score1:
        mov     cx, 03d                 ; compare 2 times
        lea     si, highs
        lea     di, score1
loop_check_score1:
        lodsb
        cmp     byte ptr ds:[di], AL
        jb      store_file
        ja      store_score1
        inc     di
        loop    loop_check_score1
        jmp     end_check_high

store_score1:
                                        ; do if score1 above highs
        push    ds
        pop     es
        lea     di, highs
        lea     si, score1
        mov     cx, 03d
                                                ; replace highs with score
        rep     movsb

store_file:
;        mov     ah, 3ch                 ; call dos service for create file
;        mov     cx, 00h                 ; file attribute(normal)
;        lea     dx, highfile
;        int     21h

        mov     ah, 3dh                         ; open file
        mov     al, 02h                         ; with read/write
        lea     dx, highfile
        int     21h
        jc      end_check_high

        jc      end_check_high          ; jmp if can't open file
        mov     filehandle, ax          ; store file handle

        mov     ah, 40h                 ; call dos service for write file
        mov     bx, filehandle
        mov     cx, 03d                 ; write 3 byte
        lea     dx, highs
        int     21h

        mov     ah, 3eh                 ; call dos service for close file
        mov     bx, filehandle
        int     21h

end_check_high:

        ;+++++++++++++++++++++++++++++++++++++++++++++++++++
        pop     si
        pop     di
        pop     es
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret
check_high      endp
;-------------------------------------------------------------------
        END     MAIN

