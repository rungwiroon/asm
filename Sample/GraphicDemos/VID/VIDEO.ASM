TITLE 'Direct Video Routines'

;
; Author: David Bennett - Version 1.0 - Date: 11/9/88
;
; This is a module of direct video writing routines for TASM.  Please see the
; file VIDEO.DOC for more information.  Examples of most routines are set forth
; in VIDDEMO.ASM.
;
; -Dave

IDEAL                   ; Uses TASM's IDEAL mode  (Get used to this!)

MODEL SMALL             ; Small memory model

INCLUDE 'VIDEO.INC'     ; Equates / Global decs etc...

; ------
; Macros
; ------

MACRO   WaitRetrace
	LOCAL   WaitNoH, WaitH, End
	;
	; This macro waits for the horizontial retrace signal from the
	; monitor before continuing. Interrupts should be disabled B4
	; calling this routine with CLI. Of course, make sure int's are
	; reenabled afterwards with STI.
	;
	; Modifies
	;       DX, AL
	;
		mov     dx, 3DAh                ; CGA status register
	WaitNoH:
		in      al, dx                  ; Get 6845 Status
		test    al,8                    ; Check vert retrace
		jnz     End                     ;   In Progress? go
		rcr     al,1                    ; Wait for end of
		jc      WaitNoH                 ;   horizontial retrace
	WaitH:
		in      al, dx                  ; Get 6845 status again
		rcr     al, 1                   ; Wait for horizontial
		jnc     WaitH                   ;   retrace
	End:
ENDM

DATASEG

	GLOBAL BaseOfScreen:WORD
	GLOBAL SnowCheck:BYTE
	GLOBAL VideoMode:BYTE

	BaseOfScreen    DW      CGASeg          ; Offset for current vid mode
	SnowCheck       DB      0               ; Check for retrace 1/0
	VideoMode       DB      0               ; Current BIOS INT 10 vid mode

; ---------
; Code area
; ---------

CODESEG

; ----------------
; Video Procedures
; ----------------

	PROC MoveXY_DI
	;
	; This procedure moves to the offset indicated by an X & Y cusor
	; location.
	;
	; Input
	;       AH = Row
	;       AL = Column
	; Output
	;       DI = Memory Offset
	;
		push    cx              ; Save CX
		xor     cl, cl          ; Clear CL
		mov     ch, ah          ; CX = Row * 256
		dec     ch              ; CX = (Row - 1) {0-24 Based}
		shr     cx, 1           ; CX = Row * 128
		mov     di, cx          ; Store in DI
		shr     di, 1           ; DI = Row * 64
		shr     di, 1           ; DI = Row * 32
		add     di, cx          ; DI = (Row * 128)+(Row * 32) {Row*160}
		xor     ch, ch          ; Clear CH register
		mov     cl, al          ; CX = Columns
		dec     cx              ; Make 0-79
		shl     cx, 1           ; Account for attribute
		add     di, cx          ; DI = (Row * 160) + (Col * 2)
		pop     cx              ; Restore CX register
		ret

	ENDP MoveXY_DI

	PROC MoveXY_SI
	;
	; This procedure moves to the offset indicated by an X & Y cusor
	; location.
	;
	; Input
	;       AH = Row
	;       AL = Column
	; Output
	;       SI = Memory Offset - Points 1 byte beyond null of str displayed
	;
		push    cx              ; Save CX
		xor     cl, cl          ; Clear CL
		mov     ch, ah          ; CX = Row * 256
		dec     ch              ; CX = (Row - 1) {0-24 Based}
		shr     cx, 1           ; CX = Row * 128
		mov     si, cx          ; Store in SI
		shr     si, 1           ; SI = Row * 64
		shr     si, 1           ; SI = Row * 32
		add     si, cx          ; SI = (Row * 128)+(Row * 32) {Row*160}
		xor     ch, ch          ; Clear CH register
		mov     cl, al          ; CX = Columns
		dec     cx              ; Make 0-79
		shl     cx, 1           ; Account for attribute
		add     si, cx          ; DI = (Row * 160) + (Col * 2)
		pop     cx              ; Restore CX register
		ret

	ENDP MoveXY_SI

	GLOBAL  EGAInstalled:PROC
	PROC    EGAInstalled
	;
	; This procedure checks to see if the current adapter card is an
	; EGA.
	;
	; Output
	;       AL = 1 if EGA Adapter is found / 0 if not
	; Modified
	;       AX
	;
		push    bx              ; Store used registers
		push    cx
		mov     ax, 1200h       ; BIOS INT 10 function 12h
		mov     bx, 10h         ; sub-func 10h (Get EGA info)
		mov     cx, 0FFFFh      ; lite all bits of CX
		int     10h             ; call INT 10
		xor     ax, ax          ; Clear AX reg
		cmp     cx, 0FFFFh      ; If CX not modified by INT call
		je      EI_Done         ;   then this is not an EGA
		inc     AL              ; Increment AL to show this is EGA
	EI_Done:
		pop     cx              ; Restore regs
		pop     bx
		ret

	ENDP EGAInstalled

	GLOBAL  GetVideoMode:PROC
	PROC    GetVideoMode
	;
	; This procedure checks the video mode and sets the BaseOfScreen
	; accordingly.  It also sets SnowCheck to 1 if adapter is a CGA.
	;
	; Output
	;       BaseOfScreen
	;       VideoMode
	;       SnowCheck
	; Uses
	;       EGAInstalled
	;
		push    ax                      ; Store registers
		push    di
		push    ds
		mov     ax, @data               ; Move DATASEG segment
		mov     ds, ax                  ;   into DS registers
		mov     di, CGASeg              ; move offset of CGA to DI
		mov     ah, 0Fh                 ; INT 10 get vid mode func
		int     10h                     ; get the video mode
		xor     ah, ah                  ; clear the AH reg
		mov     [VideoMode], al         ; place mode into VideoMode
		cmp     al, 7                   ; Is this a mono screen?
		jne     NotMono                 ; if not jump to NotMono
		mov     di, MonoSeg             ; move offset of mono to DI
		mov     [SnowCheck], 0          ; NEVER CHECK RETRACE ON MONO!
		jmp     GVM_Done
	NotMono:                                ; Process CGA/EGA/VGA adap.
		call    EGAInstalled            ; Check for EGA adap.
		rcr     al, 1                   ; Move bit 1 to carry flag
		jc      GVM_Done                ; If EGA then no snow check
		mov     [SnowCheck], 1          ; Not EGA so set snow check
	GVM_Done:
		mov     [BaseOfScreen], di      ; Move DI to base of screen
		pop     ds                      ; Restore regs
		pop     di
		pop     ax
		ret

	ENDP GetVideoMode

	GLOBAL  DWriteCH:PROC
	PROC    DWriteCH
	;
	; Writes a character to the screen using direct memory access.
	;
	; *** IMPORTANT -- CALL GetVideoMode Before using this routine!
	;
	; Input
	;       AH      Row on screen 1-25
	;       AL      Column on screen 1-80
	;       BH      Video Attribute
	;       BL      Character
	;       CX      Number of times
	; Output
	;       Screen memory (B000:0000 or 8000 CGA/MONO
	;
		push    ax              ; Store the registers
		push    cx
		push    dx
		push    es
		push    di

		call    MoveXY_DI       ; Set DI to row / column offset
		mov     es, [BaseOfScreen]      ; Move screen seg to ES
		mov     al, [SnowCheck]         ; Move snow check to al
		rcr     al, 1           ; SnowCheck
		jnc     DWC_NoWait      ; if no snowcheck goto FW_NoWait
	DWC_Next:
		cli                     ; Disable interrupts
		WaitRetrace             ; Macro to wait for horiz retrace
		mov     ax, bx          ; Move char/attr into AX
		stosw                   ; Move char/attr to screen
		sti                     ; Enable interrupts
		loop    DWC_Next        ; Repeat CX times
		jmp     DWC_Exit        ; Exit this routine
	DWC_NoWait:
		mov     ax, bx          ; Move char/attr into AX
		rep     stosw           ; Move char/attr to screen CX times

	DWC_Exit:
		pop     di              ; Restore the registers
		pop     es
		pop     dx
		pop     cx
		pop     ax
		ret

	ENDP    DWriteCH

	GLOBAL  DWriteCHNA:PROC
	PROC    DWriteCHNA
	;
	; Writes a character to the screen using direct memory access.
	; This procedure does not disturb current attr setting.
	;
	; *** IMPORTANT -- CALL GetVideoMode Before using this routine!
	;
	; Input
	;       AH      Row on screen 1-25
	;       AL      Column on screen 1-80
	;       BL      Character
	;       CX      Number of times
	; Output
	;       Screen memory (B000:0000 or 8000 CGA/MONO
	;
		push    ax              ; Store the registers
		push    cx
		push    dx
		push    es
		push    di

		call    MoveXY_DI       ; Set DI to row / column offset
		mov     es, [BaseOfScreen]      ; Move screen seg to ES
		mov     al, [SnowCheck]         ; Move snow check to al
		rcr     al, 1           ; SnowCheck
		jnc     DWCN_NoWait     ; if no snowcheck goto FW_NoWait
	DWCN_Next:
		cli                     ; Disable interrupts
		WaitRetrace             ; Macro to wait for horiz retrace
		mov     al, bl          ; Move char into al
		stosb                   ; Move char to screen
		sti                     ; Enable interrupts
		inc     di              ; Skip over attr
		loop    DWCN_Next       ; Repeat CX times
		jmp     DWCN_Exit       ; Exit this routine
	DWCN_NoWait:
		mov     al, bl          ; Move char into AX
	DWCN_NoWaitLoop:
		stosb                   ; Move char to screen
		inc     di              ; Skip over attr
		loop    DWCN_NoWaitLoop ; Repeat CX times

	DWCN_Exit:
		pop     di              ; Restore the registers
		pop     es
		pop     dx
		pop     cx
		pop     ax
		ret

	ENDP    DWriteCHNA

	GLOBAL  DWriteStr:PROC
	PROC    DWriteStr
	;
	; This procedure writes a null delimited string to the screen using
	; direct memory access.
	;
	; *** IMPORTANT -- CALL GetVideoMode Before using this routine!
	;
	; Input
	;       DS:SI   Null terminated string to print
	;       AH      Row on screen 1-25
	;       AL      Column on screen 1-80
	;       BH      Video Attribute
	; Output
	;       Screen memory (B000:0000 or 8000 CGA/MONO
	; Modifies
	;       SI - Points 1 byte beyond null of str displayed
	;
		push    ax              ; Store the registers
		push    bx
		push    cx
		push    dx
		push    es
		push    di

		call    MoveXY_DI       ; Set DI to row / column offset
		mov     es, [BaseOfScreen]      ; Move screen seg to ES
		mov     cl, [SnowCheck]         ; Move snow check to al
		cld                     ; Clear the direction flag
		rcr     cl, 1           ; SnowCheck
		mov     ah, bh          ; Place video attr in AH
		jnc     DWS_NoWait      ; if no snowcheck goto DWS_NoWait
	DWS_Next:
		lodsb                   ; Get a character from source
		or      al, al          ; Check for NULL
		jz      DWS_Exit        ; If NULL then exit
		mov     bx, ax          ; Store video word into BX
		cli                     ; Disable interrupts
		WaitRetrace             ; Macro to wait for horiz retrace
		mov     ax, bx          ; Move word back to AX...
		stosw                   ; Move word to screen
		sti                     ; Enable interrupts
		jmp     DWS_Next        ; Continue
	DWS_NoWait:
		lodsb                   ; Get a character from string
		or      al, al          ; Check for NULL
		jz      DWS_Exit        ; If NULL then exit
		stosw                   ; Move word to screen
		loop    DWS_NoWait      ; Continue
	DWS_Exit:
		pop     di              ; Restore the registers
		pop     es
		pop     dx
		pop     cx
		pop     bx
		pop     ax
		ret

	ENDP    DWriteStr

	GLOBAL  DWriteStrNA:PROC
	PROC    DWriteStrNA
	;
	; This procedure writes a null delimited string to the screen using
	; direct memory access, attribute is not changed.
	;
	; *** IMPORTANT -- CALL GetVideoMode Before using this routine!
	;
	; Input
	;       DS:SI   Null terminated string to print
	;       AH      Row on screen 1-25
	;       AL      Column on screen 1-80
	; Output
	;       Screen memory (B000:0000 or 8000 CGA/MONO)
	; Modifies
	;       SI - Points 1 byte beyond null of str displayed
	;
		push    ax              ; Store the registers
		push    bx
		push    cx
		push    dx
		push    es
		push    di

		call    MoveXY_DI       ; Set DI to screen offset pos
		mov     es, [BaseOfScreen]      ; Move screen seg to ES
		mov     cl, [SnowCheck]         ; Move snow check to cl
		cld                     ; Clear the direction flag
		rcr     cl, 1           ; SnowCheck
		jnc     DWSN_NoWait     ; if no snowcheck goto DWSN_NoWait
	DWSN_Next:
		lodsb                   ; Get a character from source
		or      al, al          ; Check for NULL
		jz      DWSN_Exit       ; If NULL then exit
		mov     bx, ax          ; Store video word into BX
		cli                     ; Turn off interrupts
		WaitRetrace             ; Macro - Waits for horiz retrace
		mov     ax, bx          ; Move word back to AX...
		stosb                   ; Move word to screen
		sti                     ; Enable interrupts
		inc     di              ; Skip the attribute.
		jmp     DWSN_Next       ; Continue
	DWSN_NoWait:
		lodsb                   ; Get a character from string
		or      al, al          ; Check for NULL
		jz      DWSN_Exit       ; If NULL then exit
		stosb                   ; Store the byte on screen
		inc     di              ; Skip attribute byte
		loop    DWSN_NoWait     ; Continue
	DWSN_Exit:
		pop     di              ; Restore the registers
		pop     es
		pop     dx
		pop     cx
		pop     bx
		pop     ax
		ret

	ENDP DWriteStrNA

	GLOBAL  DFillCH:PROC
	PROC    DFillCH
	;
	; This procedure fills an area of the screen with the specified
	; character and attribute.
	;
	; *** IMPORTANT -- CALL GetVideoMode Before using this routine!
	;
	; Input
	;       AH      = Top Row
	;       AL      = Left Column
	;       BH      = Number of rows
	;       BL      = Number of columns
	;       DH      = Attribute
	;       DL      = Character
	;
		push    ax                      ; Store Registers
		push    bx
		push    cx
		push    dx
		push    es
		push    di

		mov     es, [BaseOfScreen]      ; Move screen seg to ES
		mov     cl, [SnowCheck]         ; Move snow check to CL

		cld                     ; Clear the direction flag
		rcr     cl, 1           ; SnowCheck
		mov     ch, 0           ; Clear CH
		jnc     DFC_NoWait      ; if no snowcheck goto DFC_NoWait

	DFC_Top:
		mov     cl, bl          ; Load the number of columns
		call    MoveXY_DI       ; Set DI to screen offset pos
		push    ax              ; Store Registers AX, BX
		push    bx

	DFC_Next:
		cli                     ; Turn off interrupts
		push    dx              ; Store video word
		WaitRetrace             ; Macro - Waits for horiz retrace
		pop     dx              ; Restore video word
		mov     ax, dx          ; Move word into AX
		stosw                   ; Move word to screen
		sti                     ; Enable interrupts
		loop    DFC_Next        ; Continue

		pop     bx              ; Restore registers BX, AX
		pop     ax
		inc     ah              ; Next row
		dec     bh              ; Decrement the number of rows done
		or      bh, bh          ; Check Number of columns
		jnz     DFC_Top         ; Do next column if not done
		jmp     DFC_Exit        ; Exit routine

	DFC_NoWait:
		mov     cl, bl          ; Load the number of columns
		call    MoveXY_DI       ; Set DI to screen offset pos
		push    ax              ; Store the char/attr
		mov     ax, dx          ; Move char/attr into ax
		rep     stosw           ; Thats it!
		pop     ax              ; Restore the char/attr
		inc     ah              ; Next row
		dec     bh              ; Decrement number of rows done
		or      bh, bh          ; Check number of columns
		jnz     DFC_NoWait      ; Do next column

	DFC_Exit:
		pop     di              ; Restore registers
		pop     es
		pop     dx
		pop     cx
		pop     bx
		pop     ax
		ret

	ENDP DFillCH

	GLOBAL  DFillCHNA:PROC
	PROC    DFillCHNA
	;
	; This procedure fills an area of the screen with the specified
	; character. Attribute remains the same.
	;
	; *** IMPORTANT -- CALL GetVideoMode Before using this routine!
	;
	; Input
	;       AH      = Top Row
	;       AL      = Left Column
	;       BH      = Number of rows
	;       BL      = Number of columns
	;       DL      = Character
	;
		push    ax                      ; Store Registers
		push    bx
		push    cx
		push    dx
		push    es
		push    di

		mov     es, [BaseOfScreen]      ; Move screen seg to ES
		mov     cl, [SnowCheck]         ; Move snow check to CL

		cld                     ; Clear the direction flag
		rcr     cl, 1           ; SnowCheck
		mov     ch, 0           ; Clear CH
		jnc     DFCN_NoWait     ; if no snowcheck goto DFCN_NoWait

	DFCN_Top:
		mov     cl, bl          ; Load the number of columns
		call    MoveXY_DI       ; Set DI to screen offset pos
		push    ax              ; Store Registers AX, BX
		push    bx

	DFCN_Next:
		cli                     ; Turn off interrupts
		push    dx              ; Save video word
		WaitRetrace             ; Macro - Waits for horiz retrace
		pop     dx              ; Restore video word
		mov     al, dl          ; Move character into al
		stosb                   ; Move word to screen
		sti                     ; Enable interrupts
		inc     di              ; Skip attr
		loop    DFCN_Next       ; Continue

		pop     bx              ; Restore registers BX, AX
		pop     ax
		inc     ah              ; Next row
		dec     bh              ; Decrement the number of rows done
		or      bh, bh          ; Check Number of columns
		jnz     DFCN_Top        ; Do next column if not done
		jmp     DFCN_Exit       ; Exit routine

	DFCN_NoWait:
		mov     cl, bl          ; Load the number of columns
		call    MoveXY_DI       ; Set DI to screen offset pos
		push    ax              ; Store the row/col info
		mov     al, dl          ; Move char into ax
	DFCN_NoWaitLoop:
		stosb                   ; Thats it!
		inc     di              ; Skip over attr
		loop    DFCN_NoWaitLoop ; Loop for all columns
		pop     ax              ; Restore the row/col info
		inc     ah              ; Next row
		dec     bh              ; Decrement number of rows done
		or      bh, bh          ; Check number of columns
		jnz     DFCN_NoWait     ; Do next column

	DFCN_Exit:
		pop     di              ; Restore registers
		pop     es
		pop     dx
		pop     cx
		pop     bx
		pop     ax
		ret

	ENDP DFillCHNA

	GLOBAL  DFillAttr:PROC
	PROC    DFillAttr
	;
	; This procedure fills an area of the screen with the specified
	; attribute. Character remains the same.
	;
	; *** IMPORTANT -- CALL GetVideoMode Before using this routine!
	;
	; Input
	;       AH      = Top Row
	;       AL      = Left Column
	;       BH      = Number of rows
	;       BL      = Number of columns
	;       DH      = Attribute
	;
		push    ax                      ; Store Registers
		push    bx
		push    cx
		push    dx
		push    es
		push    di

		mov     es, [BaseOfScreen]      ; Move screen seg to ES
		mov     cl, [SnowCheck]         ; Move snow check to CL

		cld                     ; Clear the direction flag
		rcr     cl, 1           ; SnowCheck
		mov     ch, 0           ; Clear CH
		jnc     DFA_NoWait      ; if no snowcheck goto DFA_NoWait

	DFA_Top:
		mov     cl, bl          ; Load the number of columns
		call    MoveXY_DI       ; Set DI to screen offset pos
		push    ax              ; Store Registers AX, BX
		push    bx

	DFA_Next:
		cli                     ; Turn off interrupts
		push    dx              ; Save attribute in DH
		WaitRetrace             ; Macro - Waits for horiz retrace
		pop     dx              ; Restore attr
		inc     di              ; Skip character
		mov     al, dh          ; Move attr into al
		stosb                   ; Move attr to screen
		sti                     ; Enable interrupts
		loop    DFA_Next        ; Continue

		pop     bx              ; Restore registers BX, AX
		pop     ax
		inc     ah              ; Next row
		dec     bh              ; Decrement the number of rows done
		or      bh, bh          ; Check Number of columns
		jnz     DFA_Top         ; Do next column if not done
		jmp     DFA_Exit        ; Exit routine

	DFA_NoWait:
		mov     cl, bl          ; Load the number of columns
		call    MoveXY_DI       ; Set DI to screen offset pos
		push    ax              ; Store the row/col info
		mov     al, dh          ; Move attr into ax
	DFA_NoWaitLoop:
		inc     di              ; Skip over character
		stosb                   ; Thats it!
		loop    DFA_NoWaitLoop  ; Loop for all columns
		pop     ax              ; Restore the row/col info
		inc     ah              ; Next row
		dec     bh              ; Decrement number of rows done
		or      bh, bh          ; Check number of columns
		jnz     DFA_NoWait      ; Do next column

	DFA_Exit:
		pop     di              ; Restore registers
		pop     es
		pop     dx
		pop     cx
		pop     bx
		pop     ax
		ret

	ENDP DFillAttr

	GLOBAL  StoreToMem:PROC
	PROC    StoreToMem
	;
	; This procedure moves an image from the screen to the designated
	; memory area.
	;
	; *** IMPORTANT -- CALL GetVideoMode Before using this routine!
	;
	; Input
	;       AH      = Top Row
	;       AL      = Left Column
	;       BH      = Number of rows
	;       BL      = Number of columns
	;       ES:DI   = Memory Destination
	; Modifies
	;       DI
	;
		push    ax
		push    bx
		push    cx
		push    dx
		push    ds              ; Store registers
		push    si

		mov cl, [SnowCheck]     ; Move snow check to CL
		mov ds, [BaseOfScreen]  ; Move screen seg to DS mov cl,

		cld                     ; Clear the direction flag
		rcr     cl, 1           ; SnowCheck
		mov     ch, 0           ; Clear CH
		jnc     STM_NoWait      ; if no snowcheck goto STM_NoWait

	STM_Top:
		mov     cl, bl          ; Load the number of columns
		call    MoveXY_SI       ; Set SI to screen offset pos
		push    ax              ; Store row/column info
		push    bx              ; Store number of row/columns info
	STM_Next:
		lodsw                   ; Get a char/word from screen
		mov     bx, ax          ; Store video word into BX
		cli                     ; Turn off interrupts
		WaitRetrace             ; Macro - Waits for horiz retrace
		mov     ax, bx          ; Move word back to AX...
		stosw                   ; Move word to memory
		sti                     ; Enable interrupts
		loop    STM_Next        ; Continue
		pop     bx              ; Restore number of row/columns info
		pop     ax              ; Restore row/column info
		inc     ah              ; Next row
		dec     bh              ; Decrement the number of rows done
		or      bh, bh          ; Check Number of columns
		jnz     STM_Top         ; Do next column if not done
		jmp     STM_Exit        ; Exit routine

	STM_NoWait:
		mov     cl, bl          ; Load the number of columns
		call    MoveXY_SI       ; Set SI to screen offset pos
		rep     movsw           ; Thats it!
		inc     ah              ; Next row
		dec     bh              ; Decrement number of rows done
		or      bh, bh          ; Check number of columns
		jnz     STM_NoWait      ; Do next column

	STM_Exit:
		pop     si
		pop     ds
		pop     dx
		pop     cx
		pop     bx
		pop     ax
		ret

	ENDP StoreToMem

	GLOBAL  StoreToScr:PROC
	PROC    StoreToScr
	;
	; This procedure moves an image from memory to the designated
	; screen location.
	;
	; *** IMPORTANT -- CALL GetVideoMode Before using this routine!
	;
	; Input
	;       AH      = Top Row
	;       AL      = Left Column
	;       BH      = Number of rows
	;       BL      = Number of columns
	;       DS:SI   = Memory Area of image
	; Modifies
	;       SI
	;
		push    ax                      ; Store Registers
		push    bx
		push    cx
		push    dx
		push    es
		push    di

		mov     es, [BaseOfScreen]      ; Move screen seg to ES
		mov     cl, [SnowCheck]         ; Move snow check to CL

		cld                     ; Clear the direction flag
		rcr     cl, 1           ; SnowCheck
		mov     ch, 0           ; Clear CH
		jnc     STS_NoWait      ; if no snowcheck goto STS_NoWait

	STS_Top:
		mov     cl, bl          ; Load the number of columns
		call    MoveXY_DI       ; Set DI to screen offset pos
		push    ax              ; Store Registers AX, BX
		push    bx

	STS_Next:
		lodsw                   ; Get a char/word from memory
		mov     bx, ax          ; Store video word into BX
		cli                     ; Turn off interrupts
		WaitRetrace             ; Macro - Waits for horiz retrace
		mov     ax, bx          ; Move word back to AX...
		stosw                   ; Move word to screen
		sti                     ; Enable interrupts
		loop    STS_Next        ; Continue

		pop     bx              ; Restore registers BX, AX
		pop     ax
		inc     ah              ; Next row
		dec     bh              ; Decrement the number of rows done
		or      bh, bh          ; Check Number of columns
		jnz     STS_Top         ; Do next column if not done
		jmp     STS_Exit        ; Exit routine

	STS_NoWait:
		mov     cl, bl          ; Load the number of columns
		call    MoveXY_DI       ; Set DI to screen offset pos
		rep     movsw           ; Thats it!
		inc     ah              ; Next row
		dec     bh              ; Decrement number of rows done
		or      bh, bh          ; Check number of columns
		jnz     STS_NoWait      ; Do next column

	STS_Exit:
		pop     di              ; Restore registers
		pop     es
		pop     dx
		pop     cx
		pop     bx
		pop     ax
		ret

	ENDP StoreToScr

	GLOBAL CursorOff:PROC
	PROC   CursorOff
	;
	; This procedure simply turns the Cursor off
	;

		push    ax
		push    bx
		push    cx
		push    dx
		mov     ah, 03h         ; BIOS INT 10 func 3 (Get Cursor pos)
		int     10h             ; Call INT 10
		or      ch, 0100000b    ; Turn on cursor bit
		mov     ah, 01h         ; BIOS INT 10 func 1 (Set cursor type)
		int     10h             ; Call INT 10
		pop     dx
		pop     cx
		pop     bx
		pop     ax
		ret
	ENDP CursorOff

	GLOBAL CursorOn:PROC
	PROC   CursorOn
	;
	; This procedure simply turns the Cursor on
	;
		push    ax
		push    bx
		push    cx
		push    dx
		mov     ah, 03h         ; BIOS INT 10 func 3 (Get Cursor pos)
		int     10h             ; Call INT 10
		and     ch, 1011111b    ; Turn off cursor bit
		mov     ah, 01h         ; BIOS INT 10 func 1 (Set cursor type)
		int     10h             ; Call INT 10
		pop     dx
		pop     cx
		pop     bx
		pop     ax
		ret

	ENDP CursorOn

END ; Of Video.ASM

