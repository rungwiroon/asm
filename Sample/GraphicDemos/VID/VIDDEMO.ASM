TITLE 'Video Demo Program'

;
; This is a short program to demonstrate the VIDEO.ASM TASM Assembler module.
; You may use VIDDEMO.MAK to automate the assembly of this program.  It is
; only designed to work in a 80x25 mode. (Video Modes 2, 3, & 7)
;
; All lines that make use of VIDEO.ASM routines or VIDEO.INC equates have
; been marked with ($) so you can scan through this file and see how to
; use the routine fairly easily.
;
; -- Dave
;

IDEAL                   ; Use TASM's ideal mode

DOSSEG                  ; Use DOS segment ordering

MODEL SMALL             ; Small memory model

INCLUDE 'VIDEO.INC'     ; Global declarations for VIDEO.ASM

; ------
; Macros
; ------

MACRO   Pause   Seconds
	LOCAL PauseLoop, KeyFound
	;
	; This macro will pause until a key is pressed.
	;
	; Uses:
	;       KeyPressed, ClearKBD
	;
		push    ax              ; Save regs
		push    cx
	IFNB <Seconds>
		mov     cx, (Seconds*18)+(Seconds/5)    ; 5 is recip of .2!
	ELSE
		mov     cx, 91          ; 5 Seconds
	ENDIF
	PauseLoop:
		call    KeyPressed      ; check for pressed key
		or      al, al          ; Sets the zero flag if null
		jnz     KeyFound        ; loop until key is pressed
		call    Delay           ; Delay for .055 of a second
		loop    PauseLoop
	KeyFound:
		call    ClearKBD        ; Clear the key
		pop     cx              ; Restore registers
		pop     ax
ENDM

; ---------------
; Program Equates
; ---------------

	Version         EQU     '1.0'
	Date            EQU     '11/9/88'

	MaxRows         EQU     25              ; Maximum rows
	CenterRow       EQU     (MaxRows/2)     ; Center row
	MaxCols         EQU     80              ; Maximum columns
	CenterCol       EQU     (MaxCols/2)     ; Center column
	FillRows        EQU     5               ; Number of rows for fill demo
	FillCols        EQU     20              ; Number of cols for fill demo

; -------------
; Stack Segment
; -------------

STACK   7FFFh           ; 32k Stack (Much more than enough)

; -------------
; Data Segement
; -------------

; NOTE: Program relies on data being in current order.  Do not reorder, delete
;       or insert new data into the list.  Data can be appended to this segment
;       definition.

DATASEG

	Title1          DB 'VIDEO.ASM - Direct Screen Writing Routines', 0
	LABEL           T1End BYTE
	T1Len           EQU     (T1End-Title1-1)

	Title2          DB 'Author: Dave Bennett / CompuServe 74635,1671', 0
	LABEL           T2End BYTE
	T2Len           EQU     (T2End-Title2-1)

	Title3          DB 'Version ', Version, ' - Date: ', Date, 0
	LABEL           T3End BYTE
	T3Len           EQU     (T3End-Title3-1)

	Title4          DB 'Features:', 0
	Title5          DB ' - Video mode detection', 0
	Title6          DB ' - Monochrome/CGA/EGA support', 0
	Title7          DB ' - Snow suppression', 0
	Title8          DB ' - Direct character & string writing', 0
	Title9          DB ' - Screen saving & restoring', 0
	Title10         DB ' - Area fills (character, attribute, and both)', 0
	Title11         DB ' - Cursor on & off control', 0
	Title12         DB ' - All commands w/ or w/o attribute changes',0

	Msg             DB 'Direct Screen Writing is Fast!!!', 0
	LABEL           MsgEnd BYTE
	MsgLen          EQU     (MsgEnd-Msg-1)

	SaveMsg         DB ' Screen has been saved... ', 0
	LABEL           SMsgEnd BYTE
	SMsgLen         EQU     (SMsgEnd-SaveMsg-1)

	CharMsg1        DB ' Character ', 0
	CharMsg2        DB ' Writing!! ', 0

	Wheel           DB 179, '/-\', 179, '/-\'  ; Wheel Chars
	LABEL           WheelEnd BYTE
	MaxWheel        EQU     (WheelEnd-Wheel-1)      ; Maximum Wheel offset

	FillMsg1        DB '-AREA-', 0
	FillMsg2        DB '-FILL-', 0

	RestoreMsg      DB ' Here''s your saved screen image! ', 0
	LABEL           RMsgEnd BYTE
	RMsgLen         EQU     (RMsgEnd - RestoreMsg - 1)

	VidModErr       DB 'Invalid Video Mode!', 0Dh, 0Ah, '$'

	RDir            DB 0                    ; Row Direction
	CDir            DB 0                    ; Col Direction

; --------------------------
; Uninitialized Data Segment
; --------------------------

UDATASEG

	LowTick         DW (?)          ; Tick holder for Delay routine
	SaveScr         DB 4000 dup (?) ; Screen Save Area

; ------------
; Code Segment
; ------------

CODESEG

	mov     ax, @data       ; Set the
	mov     ds, ax          ;   Data segment
	call    GetVideoMode    ; Get vid mode data.  MUST BE CALLED FIRST ($)

	cmp     [VideoMode], BW80       ; ($)
	je      VideoMode_OK            ; Video Mode BW80 is ok
	cmp     [VideoMode], CO80       ; ($)
	je      VideoMode_OK            ; Video Mode CO80 is ok
	cmp     [VideoMode], Mono       ; ($)
	je      VideoMode_OK            ; Monochrome is ok

	mov     dx, OFFSET VidModErr    ; All other modes are unacceptable
	mov     ah, 09                  ; DOS print string func
	int     21h                     ; Call DOS
	jmp     ErrExit                 ; Exit the program

VideoMode_OK:
;       mov     [SnowCheck], 0  ; No Snow Checking! ($)
	call    CursorOff       ; Turn the cursor off ($)

; ------------
; Title Screen
; ------------

	call    ClrScr                  ; Clear the screen
	mov     si, (OFFSET Title1)     ; First Message
	mov     bh, Normal              ; Gray on Black ($)
	mov     ah, 1                   ; Start at top row
	mov     al, (CenterCol-(T1Len/2))       ; Center the message
	call    DWriteStr               ; Write without attribute ($)
	inc     ah                      ; Double
	inc     ah                      ;   Space
	mov     al, (CenterCol-(T2Len/2))       ; Center Title Msg 2

	; NOTE: SI Already points to Title2 (See DATASEG)

	call    DWriteStr               ; Write the string to the scr ($)
	inc     ah                      ; Single Space
	mov     al, (CenterCol-(T3Len/2))       ; Center title Msg 3
	call    DWriteStr               ; Write string to scr ($)
	inc     ah                      ; Double
	inc     ah                      ;   Space
	mov     al, (CenterCol-(T1Len/2)) ; Align with first row
	call    DWriteStr               ; Write str to scr ($)
	inc     ah                      ; Double
	inc     ah                      ;   Space
	inc     al                      ; Indent
	inc     al                      ;   2 Spaces
	mov     cx, 8                   ; 8 Feature lines
TS_Features:
	call    DWriteStr               ; Write a feature ($)
	inc     ah                      ; Double
	inc     ah                      ;   Space
	loop    TS_Features             ; Loop for all feature lines

	Pause   <10>                    ; Wait for a pressed key (10 seconds)

;---------------
; DFillAttr Demo
; --------------

	cmp     [VideoMode], Mono       ; This code is'nt suited for mono ($)
	je      DWN_Begin               ; So goto DWriteStNA demo if mono

	mov     ax, 0101h               ; First row/First column
	mov     bh, MaxRows             ; All rows
	mov     bl, MaxCols             ; All columns
	mov     dh, 1                   ; Initialize attribute

DFA_Top:
	and     dh, 00001111b           ; Clear all but foreground
	cmp     dh, 0                   ; Check for no attribute
	jne     DFA_Fill                ; Go ahead if attribute
	inc     dh                      ; Make sure theres and attr
DFA_Fill:
	call    DFillAttr               ; Fill screen with attribute ($)
	call    Delay                   ; Delay for .055 of a second
	inc     dh                      ; Next Attribture
	push    ax                      ; Store row/col info
	call    KeyPressed              ; Check for a key
	or      al, al                  ; Sets zero flag if no char
	pop     ax                      ; Restore row/col info
	jz      DFA_Top                 ; If no key the loop
	call    ClearKBD                ; Clear key(s) from buffer

;-----------------
; DWriteStrNA Demo
; ----------------

DWN_Begin:
	call    ClrScr          ; Clear the screen
	mov     ax, 0           ; Initialize row/col
	mov     bh, Normal      ; Initialize Attribute ($)

 DWN_MoveMsg:
	mov     si, OFFSET Msg  ; Point to Msg
	test    [RDir], 1       ; Check the direction
	jz      DWN_RInc        ; If direction is right then goto RInc
	dec     ah              ; Decrement the row
	cmp     ah, 1           ; Check to see if row eq 1
	jne     DWN_CheckCol    ;   If not then check columns
	inc     [RDir]          ; Change the direction
	jmp     DWN_CheckCol    ; Check columns
DWN_RInc:
	inc     ah              ; Increment the row
	cmp     ah, MaxRows     ; Check to see if row eq MaxRows
	jne     DWN_CheckCol    ;   If not then check columns
	inc     [RDir]          ; Change the row-wise direction
DWN_CheckCol:
	test    [CDir], 1       ; Check column wise direction
	jz      DWN_CInc        ; If direction is down then goto CInt
	dec     al              ; Decrement the row (Go up)
	cmp     al, 1           ; Check to see if this is column one
	jne     DWN_WriteIt     ;   If not then check attr
	inc     [CDir]          ; Change the direction
	jmp     DWN_WriteIt     ; Check the attr
DWN_CInc:
	inc     al              ; Increment the row
	cmp     al, (MaxCols-MsgLen) ; Check to see if row eq MaxCols
	jne     DWN_WriteIt     ;           If not then check attr
	inc     [CDir]          ; Change the column-wise direction
DWN_WriteIt:
	call    DWriteStrNA     ; Write the str on scr w/o attr change ($)
	push    ax              ; Store ax reg
	call    KeyPressed      ; Check to see if a key has been pressed
	or      al, al          ; Does AL eq zero?
	pop     ax              ; Restore registers
	jz      DWN_MoveMsg     ; if Yes then Redisplay message
	call    ClearKBD        ; Clear the keyboard

; --------------
; DWriteStr Demo
; --------------

	cmp     [VideoMode], Mono       ; Demo not well suited for mono ($)
	je      STM_Begin               ; so goto StoreToMem demo if mono

DW_MoveMsg:
	mov     si, OFFSET Msg  ; Point to Msg
	test    [RDir], 1       ; Check the direction
	jz      DW_RInc         ; If direction is right then goto RInc
	dec     ah              ; Decrement the row
	cmp     ah, 1           ; Check to see if row eq 1
	jne     DW_CheckCol     ;   If not then check columns
	inc     [RDir]          ; Change the direction
	jmp     DW_CheckCol     ; Check columns
DW_RInc:
	inc     ah              ; Increment the row
	cmp     ah, MaxRows     ; Check to see if row eq MaxRows
	jne     DW_CheckCol     ;   If not then check columns
	inc     [RDir]          ; Change the row-wise direction
DW_CheckCol:
	test    [CDir], 1       ; Check column wise direction
	jz      DW_CInc         ; If direction is down then goto CInt
	dec     al              ; Decrement the row (Go up)
	cmp     al, 1           ; Check to see if this is column one
	jne     DW_CheckAttr    ;   If not then check attr
	inc     [CDir]          ; Change the direction
	jmp     DW_CheckAttr    ; Check the attr
DW_CInc:
	inc     al              ; Increment the row
	cmp     al, (MaxCols - MsgLen) ; Check to see if row eq MaxCols
	jne     DW_CheckAttr     ;           If not then check attr
	inc     [CDir]          ; Change the column-wise direction
DW_CheckAttr:
	inc     bh              ; Increment the attribute
	test    bh, Blink       ; Test to see if blink bit is on
	jz      DW_WriteIt      ; If not then skip to WriteIt
	mov     bh, 1           ; Set BH eq 1
DW_WriteIt:
	call    DWriteStr       ; Write the string on the screen ($)
	push    ax              ; Store ax reg
	call    KeyPressed      ; Check to see if a key has been pressed
	or      al, al          ; Does AL eq zero?
	pop     ax              ; Restore registers
	jz      DW_MoveMsg      ; if Yes then Redisplay message
	call    ClearKBD        ; Clear the keyboard

; ----------------------------------------------------------
; Move current screen image to save area (StoreToMem - Demo)
; ----------------------------------------------------------

STM_Begin:
	mov     ax, @data       ; Place data segment into AX
	mov     es, ax          ; segment for saved image area

	; This might be a good place for some stack checking code. (hint hint)

	mov     di, OFFSET SaveScr      ; offset to saved image area (See Stack)
	mov     ax, 0101h       ; Row 1 / Col 1
	mov     bh, MaxRows     ; capture all rows &
	mov     bl, MaxCols     ;         all columns
	call    StoreToMem      ; Save the screen to memory ($)

	; Note: SI Already points to SaveMsg (See DATASEG)

	mov     ah, CenterRow   ; Center of screen
	mov     al, (CenterCol-(SMsgLen/2)) ; Center the message
	mov     bh, Reverse+Blink ; Reverse attr (Black on White) & Blink ($)
	call    DWriteStr       ; Display the string! ($)

	Pause   <10>            ; Macro to pause for 10 seconds

; -------------
; DWriteCH Demo
; -------------

	CharMsg1Col     =       24
	CharMsg2Col     =       48
	RowStart        =       1       ; Row to start in
	ColStart        =       6       ; Column to start in

	; Note: SI already points to CharMsg1 (See DATASEG)

	call    ClrScr                  ; Clear the screen
	mov     ah, CenterRow           ; Middle row of screen
	mov     bh, (Brown*10h+Blue)    ; Blue on Brown (Also ul mono) ($)
	mov     al, CharMsg1Col         ; Point to column for first msg
	call    DWriteStr               ; Write the first string ($)

	; Note: SI now points to CharMsg2 (See DATASEG)

	mov     al, CharMsg2Col         ; Column for second msg
	call    DWriteStr               ; Write the second string ($)

	mov     ah, RowStart            ; Start row
	mov     al, ColStart            ; Start column
	mov     bh, White               ; White on black ($)
	mov     cx, 1                   ; One Character
	mov     si, OFFSET Wheel        ; Offset of wheel characters
DWC_Top:
	mov     bl, [Byte Ptr si]       ; Load character into bl
DWC_WriteIt:
	call    DWriteCH                ; Write the character ($)
	inc     ah                      ; Next row
	inc     al                      ; Next column
	cmp     ah, MaxRows             ; Check AH against Maximum rows
	jle     DWC_CheckCol            ; If less then then Check columns
	mov     ah, 1                   ; Reset row
DWC_CheckCol:
	cmp     al, MaxCols             ; Check AL agains max cols
	jle     DWC_WriteIt             ; If less than max cols then write
	mov     ah, RowStart            ; Reset row
	mov     al, ColStart            ; Reset col
;       call    Delay                   ; Wait 1 / 18.2 of a second
	inc     si                      ; Point to next character in wheel
	cmp     si, (OFFSET Wheel + MaxWheel)   ; Maximum offset of Wheel
	jle     DWC_Top
DWC_InKey:
	push    ax              ; Store row/col info
	call    KeyPressed      ; Check to see if a key has been pressed
	or      al, al          ; Sets zero flag if al eq 0
	pop     ax              ; Restore row/col info
	jnz     DWC_End         ; If a key has been press (not null) then end
	mov     si, OFFSET Wheel ; Set SI to offset zero of wheel
	jmp     DWC_Top         ; If zero flag set then loop
DWC_End:
	call    ClearKBD        ; Clear the keyboard

; ------------
; DFillCH Demo
; ------------

	FillMsgCol      =       36      ; Fill Msgs in column 25
	FillMsg1Row     =       3       ; Message one in row 3
	FillMsg2Row     =       20      ; Message two in row 20
	FillWid         =       15      ; Width of fill
	FillHt          =       4       ; Fill Height
	RInc            =       2       ; Row Increment
	CInc            =       7       ; Column Increment

	call    ClrScr          ; Clear the screen
	mov     ah, FillMsg1Row ; Row for first msg
	mov     al, FillMsgCol  ; Col for the msg
	mov     bh, LightBlue+Blink ; LightBlue on Black w/ Blink (ul mono) ($)

	; NOTE: SI Points to first msg already

	call    DWriteStr       ; Write the first message (SI points to 2nd) ($)
	mov     ah, FillMsg2Row ; Row for the second message
	call    DWriteStr       ; Write the second message to the screen ($)

	mov     ax, 0101h       ; Top row / Left Col
	mov     bh, FillHt      ; Number of rows
	mov     bl, FillWid     ; Number of columns
	mov     dh, 00h         ; Initialize attr

DFCH_Top:
	inc     dh              ; Increment dh
	mov     dl, dh          ; Move attribute to character
	call    DFillCh         ; Do the fill ($)
	add     ah, RInc        ; Increment rows
	add     al, CInc        ; Increment columns
	cmp     ah, (MaxRows-FillHt)    ; compare ah to max rows - fill ht
	jle     DFCH_CheckCol   ; If less than or equal to then check columns
	jmp     DFCH_SecPart    ; Goto the second part
DFCH_CheckCol:
	cmp     al, (MaxCols-FillWid)   ; compare al to max cols - fill width
	jle     DFCH_Top                ; Jump to the top if in bounds
DFCH_SecPart:
	mov     dh, 0           ; Initialize the attribute
	mov     ah, 1           ; Top Row
	mov     al, (MaxCols-FillWid) ; Right Side
DFCH_Top2:
	inc     dh              ; Increment dh
	mov     dl, dh          ; Move attribute to character
	call    DFillCh         ; Do the fill
	add     ah, RInc        ; Increment rows
	sub     al, CInc         ; Decrement columns
	cmp     ah, (MaxRows-FillHt)    ; compare ah to max rows - fill ht
	jle     DFCH_CheckCol2  ; If less than or equal to then check columns
	jmp     DFCH_Pause      ; Goto the pause routine
DFCH_CheckCol2:
	cmp     al, 1           ; compare al to 1 (First column)
	jg      DFCH_Top2       ; Jump to the top if in bounds
DFCH_Pause:
	Pause   <10>            ; Macro to pause 10 seconds

; ---------------
; StoreToScr Demo
; ---------------

	mov     ax, 0101h       ; First row & col
	mov     bh, MaxRows     ; All rows
	mov     bl, MaxCols     ; All columns
	mov     si, OFFSET SaveScr ; Point to area where screen was saved
	call    StoreToScr      ; Restore the saved screen ($)

	mov     si, OFFSET RestoreMsg ; Point to restore screen message
	mov     ah, CenterRow   ; Center of screen
	mov     al, (CenterCol-(RMsgLen/2)) ; Center the message
	mov     bh, Reverse+Blink ; Reverse attr (Black on White) & Blink ($)
	call    DWriteStr       ; Display the string! ($)

	Pause   <10>             ; Macro - Pause for 10 secs or until key press

Exit:
	call    ClrScr          ; Clean up the display
ErrExit:
	call    CursorOn        ; Turn the cursor on ($)
	mov     ah, 4Ch         ; DOS exit function
	int     21h             ; Call DOS to exit

; -------------------
; Programs Procedures
; -------------------

	PROC ClrScr
	;
	; This procedure Clears the screen using VIDEO.ASM
	;
		push    ax              ; Store registers
		push    bx
		push    dx
		mov     ax, 0101h       ; First row & col
		mov     bh, MaxRows     ; All Rows
		mov     bl, MaxCols     ; All Columns
		mov     dh, Normal      ; Attr = Gray on Black ($)
		mov     dl, ' '         ; Fill scr with spaces
		call    DFillCH         ; Do it! ($)
		pop     dx              ; Restore registers
		pop     bx
		pop     ax
		ret

	ENDP ClrScr

	PROC KeyPressed
	;
	; This procedure uses DOS to check if a key has been pressed.
	;
	; Output
	;       AL = FFh/0  Yes/No
	; Modifies
	;       AX
	;
		mov     ah, 0Bh         ; DOS func 0Bh (Check for pressed key)
		int     21h             ; Call DOS
		xor     ah, ah          ; Clear AH reg
		ret

	ENDP KeyPressed

	PROC ClearKBD
	;
	; This procedure uses DOS to clear the keyboard buffer.
	;
		push    ax              ; Store AX reg
		mov     ax, 0C00h       ; Dos func 0Ch = Clear KBD
		int     21h             ; Call DOS
		pop     ax              ; Restore AX
		ret

	ENDP ClearKBD

	PROC Delay
	;
	; This procedure delays the CPU for about 1 timer tick or 1/18.2 of
	; of a second.
	;
		push    ax
		push    cx
		push    dx
		mov     ah,0            ; INT 1A GetTime function
		int     01ah            ; Call timer interrupt
		mov     [LowTick], dx   ; DX returns low timer tick value
	DelayLoop:
		mov     ah, 0           ; INT 1A GetTime function
		int     01ah            ; Call timer interrupt
		cmp     dx, [LowTick]   ; Compare current val to first
		je      DelayLoop       ; If still the same then loop
		pop     dx
		pop     cx
		pop     ax
		ret

	ENDP Delay

END ; Of VidDemo.ASM
