;SNARF.ASM	1-Sep-2006	Loren Blaney	loren_blaney@idcomm.com
;Version 1.3 (Also see errMsg and MessageOK.)
;This takes a snapshot of the currently displayed graphic or text screen and
; saves the image in a file called SNARFxxx.BMP in the current directory. It
; works for CGA, EGA, VGA and VESA graphic and text modes, and runs under DOS
; and Windows. The code is based on a TSR presented in the MS-DOS Encyclopedia
; written by Richard Wilton (and painstakingly typed in by Jim Phillips).
;Assemble with MASM 6.11 (5.10 gives phase errors).
;
;This program is free software; you can redistribute it and/or modify it under
; the terms of the GNU General Public License version 2 as published by the
; Free Software Foundation.
;This program is distributed in the hope that it will be useful, but WITHOUT
; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
; FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
; details.
;You should have received a copy of the GNU General Public License along with
; this program (in the file LICENSE.TXT); if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;
;REVISIONS
;V1.2, 21-Jul-2006, Distributed on Internet
;V1.3, 1-Sep-2006, Support VESA 2.0 by masking off bits 13, 14 & 15 on mode info

DefHotKey	EQU	31		;default hot key scan code (Alt+S)
MultiplexID	EQU	0DAH		;unique INT 2FH ID value for this TSR

TSRStackSize	EQU	100H		;resident stack size in bytes

KB_FLAG 	EQU	17H		;offset of shift-key status flag in
					; BIOS keyboard data area
KBIns		EQU	80H		;bit masks for KB_FLAG
KBCaps		EQU	40H
KBNum		EQU	20H
KBScroll	EQU	10H
KBAlt		EQU	08H
KBCtl		EQU	04H
KBleft		EQU	02H
KBRight 	EQU	01H

CR		EQU	0DH
LF		EQU	0AH
TRUE		EQU	-1
FALSE		EQU	0
		PAGE

;###############################################################################
;                          RAM-Resident Routines
;###############################################################################

RESIDENT_GROUP	GROUP	RESIDENT_TEXT,RESIDENT_DATA,RESIDENT_STACK

RESIDENT_TEXT	SEGMENT BYTE PUBLIC 'CODE'
		ASSUME	CS:RESIDENT_GROUP,DS:RESIDENT_GROUP

;-----------------------------------------------------------------------------
; System verification routines
;-----------------------------------------------------------------------------

VerifyDOSState	PROC	NEAR		; Returns:  carry flag set if DOS
					;	    is busy
		PUSH	DS		; preserve registers
		PUSH	BX
		PUSH	AX

		LDS	BX,CS:ErrorModeAddr
		MOV	AH,[BX] 	; AH = ErrorMode flag

		LDS	BX,CS:InDOSAddr
		MOV	AL,[BX] 	; AL = InDOS flag

		XOR	BX,BX		; BH = 00H, BL = 00H
		CMP	BL,CS:InISR28	; carry flag set if INT 28H handler
					; is running
		RCL	BL,01H		; BL = 01H if handler is running

		CMP	BX,AX		; carry flag zero if AH = 00H
					; and AL <= BL
		POP	AX		; restore registers
		POP	BX
		POP	DS
		RET
VerifyDOSState	ENDP

;-----------------------------------------------------------------------------

VerifyIntState	PROC	NEAR		; Returns:  carry flag set if hardware
					;	    or BIOS is unstable
		PUSH	AX		; preserve AX

; Verify hardware interrupt status by interrogating Intel 8259A Programmable
; Interrupt Controller

		MOV	AX,00001011B	;AH = 0, AL = 0CW3 for Intel 8259A
					; (RR = 1, RIS = 1)
		OUT	20H,AL		; request 8259A's in-service register
		JMP	SHORT L10	; wait a few cycles
L10:		IN	AL,20H		; AL = hardware interrupts currently
					; being serviced (bit =1 if in-service)
		CMP	AH,AL
		JC	L11		; exit if any hardware interrupts still
					; being serviced

; Verify status of BIOS interrupt handlers

		XOR	AL,AL		; AL = 00H

		CMP	AL,CS:InISR5
		JC	L11		; exit if currently in INT 05H handler

		CMP	AL,CS:InISR9
		JC	L11		; exit if currently in INT 09H handler

		CMP	AL,CS:InISR10
		JC	L11		; exit if currently in INT 010H handler

		CMP	AL,CS:InISR13	; set carry flag if currently in
					; INT 13H handler
L11:		POP	AX		; restore AX and return
		RET
VerifyIntState	ENDP

;-----------------------------------------------------------------------------
; Returns carry flag clear if TSR application can execute

VerifyTSRState	PROC	NEAR		; Returns: carry flag set if TSR cannot
					;	   be activated
		ROL	CS:HotFlag,1	; carry flag set if (HotFlag = TRUE)
		CMC			; flip TRUE to FALSE
					; carry is now set if HotFlag = FALSE
		JC	L20		; exit if hot key not struck

		ROR	CS:ActiveTSR,1	; carry flag set if (ActiveTSR = TRUE)
		JC	L20		; exit if already active

		CALL	VerifyDOSState
		JC	L20		; exit if DOS is unstable

		CALL	VerifyIntState	; set carry flag if hardware or BIOS
					; is unstable
L20:		RET
VerifyTSRState	ENDP
		PAGE

;------------------------------------------------------------------------------
; System interrupt handlers
;------------------------------------------------------------------------------

ISR5		PROC	FAR		; INT 05H handler
					; (BIOS Print Screen)
		INC	CS:InISR5	; increment status flag
		PUSHF
		CLI
		CALL	CS:PrevISR5	; chain to previous INT 5 handler

		DEC	CS:InISR5	; decrement status flag
		IRET
ISR5		ENDP

;------------------------------------------------------------------------------

ISR8		PROC	FAR		; INT 08H handler
		PUSHF			; (BIOS System Timer Tick)
		CLI
		CALL	CS:PrevISR8	; chain to previous INT 8 handler

		CMP	CS:InISR8,0
		JNE	L31		; exit if already in this handler

		INC	CS:InISR8	; increment status flag

		STI			; interrupts are ok
		CALL	VerifyTSRState
		JC	L30		; skip if TSR cannot run

		MOV	BYTE PTR CS:ActiveTSR,TRUE
		CALL	TSRapp
		MOV	BYTE PTR CS:ActiveTSR,FALSE

L30:		DEC	CS:InISR8	; increment status flag
L31:		IRET
ISR8		ENDP

;------------------------------------------------------------------------------

ISR9	PROC	FAR		;INT 09H handler
				;(Keyboard Interrupt IRQ1)
	push	ds		;preserve registers
	push	ax
	pushf			;and flags

	push	cs
	pop	ds		;ds -> RESIDENT_GROUP

	mov	ah, ds:InISR9	;if already in this handler
	or	ah, ds:HotFlag	; or currently processing the hot key
	jne	L47		; then jump to exit

	inc	ds:InISR9	;increment status flag
	sti			;now interrupts are ok

;Check for hot key

	in	al, 60h		;al = current scan code
	cmp	al, ds:HotKey	;test scan code
	jne	L45		;jump if no match

;Check shift-key flags

	push	ds
	mov	ax, 40h
	mov	ds, ax		;ds -> BIOS data area
	mov	al, ds:[17h]	;ah = BIOS shift-key flags
	pop	ds

	and	al, ds:HotKBMask ;al = flags anded with "don't care" mask
	cmp	al, ds:HotKBFlag
	jne	L45		;jump if shift state does not match

;Eat the hot key (don't pass it to the main program)

	in	al, 61h		;clear keyboard IRQ
	mov	ah, al
	or	al, 80h
	out	61h, al
	mov	al, ah
	out	61h, al
	mov	al, 20h		;clear hardware interrupt by sending
	out	20h, al		; an end-of-interrupt (EOI) to 8259A

	mov	byte ptr ds:HotFlag, TRUE ;hot key is found
	dec	ds:InISR9	;decrement status flag
	popf			;balance stack
	jmp	L49		;exit

;Chain to previous INT 9 handler
L45:				;simulate an int instruction
	dec	ds:InISR9	;decrement status flag
L47:				;flags have been pushed onto the stack
	cli			; (necessary if chaining from another TSR)
	call	ds:PrevISR9	;let previous handler execute
L49:
	pop	ax		;restore registers
	pop	ds
	iret
ISR9	ENDP

;------------------------------------------------------------------------------

ISR10		PROC	FAR		; INT 10H handler (BIOS Video I/O)
		INC	CS:InISR10	; increment status flag

		PUSHF
		CLI
		CALL	CS:PrevISR10	; chain to previous INT 10H handler

		DEC	CS:InISR10	; decrement status flag
		IRET
ISR10		ENDP

;------------------------------------------------------------------------------

ISR13		PROC	FAR		; INT 13H handler
					; (BIOS Fixed Disk I/O)
		INC	CS:InISR13	; increment status flag

		PUSHF
		CLI
		CALL	CS:PrevISR13	; chain to previous INT 13H handler

		PUSHF			; preserve returned flags
		DEC	CS:InISR13	; decrement status flag
		POPF			; restore flags register

		STI			; enable interrupts
		RET	2		; simulate IRET without popping flags
ISR13		ENDP

;------------------------------------------------------------------------------

ISR1B		PROC	FAR		; INT 1BH trap (BIOS Ctrl-Break)
		MOV	BYTE PTR CS:Trap1B,TRUE
		IRET
ISR1B		ENDP

;------------------------------------------------------------------------------

ISR23		PROC	FAR		; INT 23H trap (DOS Ctrl-C)
		MOV	BYTE PTR CS:Trap23,TRUE
		IRET
ISR23		ENDP

;------------------------------------------------------------------------------

ISR24		PROC	FAR		; INT 24H trap (DOS Critical Error)

		MOV	BYTE PTR CS:Trap24,TRUE
		XOR	AL,AL		; AL = 00H (DOS 2.X)
		CMP	CS:MajorVersion,2   ; ignore the error
		JE	L50

		MOV	AL,3		; AL = 03H (DOS 3.X)
					; fail the DOS call in which
					; the critical error occurred
L50:		IRET
ISR24		ENDP

;------------------------------------------------------------------------------

ISR28		PROC	FAR		; INT 28H handler
					; (DOS Idle Interrupt)
		PUSHF
		CLI
		CALL	CS:PrevISR28	; chain to previous INT 28H handler

		CMP	CS:InISR28,0
		JNE	L61		; exit if already inside this handler

		INC	CS:InISR28	; increment status flag
		CALL	VerifyTSRState
		JC	L60		; skip if TSR cannot run

		MOV	BYTE PTR CS:ActiveTSR,TRUE
		CALL	TSRapp
		MOV	BYTE PTR CS:ActiveTSR,FALSE

L60:		DEC	CS:InISR28	; decrement status flag
L61:		IRET
ISR28		ENDP

;------------------------------------------------------------------------------

ISR2F		PROC	FAR		; INT 2FH handler
					; (DOS Multiplex Interrupt)
					; Caller:   AH = handler ID
					;	    AL = function number
					; Returns for function 0:   AL = 0FFH
					; for all other functions:  nothing

		CMP	AH,MultiplexID
		JE	L70		; jump if handler is requested

		JMP	CS:PrevISR2F	; chain to previous INT 2FH handler

L70:		TEST	AL,AL
		JNZ	MultiplexIRET	; jump if reverved or undefined funct

; Function 0:	get installed state

		MOV	AL,0FFH 	; AL = 0FFH (this handler is installed)

MultiplexIRET:	IRET			; return from interrupt
ISR2F		ENDP
		PAGE

;===============================================================================
; AuxInt21--sets ErrorMode while executing INT 21H to force use of the
;	AuxStack instead of the IOStack.
;
AuxInt21	PROC	NEAR		; Caller:   registers for INT 21H
					; Returns:  registers from INT 21H
		PUSH	DS
		PUSH	BX
		LDS	BX,ErrorModeAddr
		INC	BYTE PTR [BX]	; ErrorMode is now nonzero
		POP	BX
		POP	DS

		INT	21H		; perform DOS function

		PUSH	DS
		PUSH	BX
		LDS	BX,ErrorModeAddr
		DEC	BYTE PTR [BX]	; restore ErrorMode
		POP	BX
		POP	DS
		RET
AuxInt21	ENDP

;------------------------------------------------------------------------------

Int21v		PROC	NEAR		; perform INT 21H or AuxInt21
					; depending on DOS version
		CMP	DOSVersion,30AH
		JB	L80		; jump if earlier than 3.1

		INT	21H		; versions 3.1 and later
		RET

L80:		CALL	AuxInt21	; versions earlier than 3.1
		RET
Int21v		ENDP
		PAGE

;===============================================================================
;                        RAM-Resident Application
;===============================================================================

TSRapp		PROC	NEAR

; Set up a safe stack

		PUSH	DS		; save previous DS on previous stack

		PUSH	CS
		POP	DS		; DS -> RESIDENT_GROUP

		MOV	PrevSP,SP	; save previous SS:SP
		MOV	PrevSS,SS

		MOV	SS,TSRSS	; SS:SP -> RESIDENT_STACK
		MOV	SP,TSRSP

		PUSH	ES		; preserve remaining registers
		.386			;80386 required
		pushad
		.8086
		CLD			; clear direction flag

; Set break and critical error traps

		MOV	CX,NTrap
		MOV	SI,OFFSET RESIDENT_GROUP:StartTrapList

L90:		LODSB			; AL = interrupt number
					; DS:SI -> byte past interrupt number

		MOV	BYTE PTR [SI],FALSE	; zero trap flag

		PUSH	AX		; preserve AX
		MOV	AH,35H		; INT 21H function 35H
					; (get interrupt vector)
		INT	21H		; ES:BX = previous interrupt vector
		MOV	[SI+1],BX	; save offset and segment
		MOV	[SI+3],ES	;   of previous handler
		POP	AX		; AL = interrupt number
		MOV	DX,[SI+5]	; DS:DX -> this TSR's trap
		MOV	AH,25H		; INT 21H function 25H
		INT	21H		; (set interrupt vector)
		ADD	SI,7		; DS:SI -> next in list

		LOOP	L90

; Disable DOS break checking during disk I/O

		MOV	AX,3300H	; AH = INT 21H function number
					; AL = 00H (req current break state)
		INT	21H		; DL = current break state
		MOV	PrevBreak,DL	; preserve current break state

		XOR	DL,DL		; DL = 00H (disable disk I/O break
					; checking
		MOV	AX,3301H	; AL = 01H (set break state)
		INT	21H

; Preserve previous extended error information

		CMP	DOSVersion,30AH
		JB	L91		; jump if version earlier than 3.1
		PUSH	DS		; preserve DS
		XOR	BX,BX		; BX = 00H (required for function 59H)
		MOV	AH,59H		; INT 21H function 59H
		CALL	Int21v		; (get extended error info)

		MOV	CS:PrevExtErrDS,DS
		POP	DS
		MOV	PrevExtErrAX,AX ; preserve error information
		MOV	PrevExtErrBX,BX ; in data structure
		MOV	PrevExtErrCX,CX
		MOV	PrevExtErrDX,DX
		MOV	PrevExtErrSI,SI
		MOV	PrevExtErrDI,DI
		MOV	PrevExtErrES,ES

; Inform DOS about current PSP

L91:		MOV	AH,51H		; INT 21H function 51H (get PSP addr)
		CALL	Int21v		; BX = forground PSP

		MOV	PrevPSP,BX	; preserve previous PSP

		MOV	BX,TSRPSP	; BX = resident PSP
		MOV	AH,50H		; INT 21H function 50H (set PSP addr)
		CALL	Int21v

; Inform DOS about current DTA (not really necessary in this application
; because DTA is not used)

		MOV	AH,2FH		; INT 21H function 2FH
		INT	21H		; (get DTA address) into ES:BX
		MOV	PrevDTAoffs,BX
		MOV	PrevDTAseg,ES

		PUSH	DS		; preserve DS
		MOV	DS,TSRPSP
		MOV	DX,80H		; DS:DX -> default DTA at PSP:0080H
		MOV	AH,1AH		; INT 21H function 1AH
		INT	21H		; (set DTA address)
		POP	DS		; restore DS

;===============================================================================
 if 0	;disable original routine
; Open a file, Write to it, Close it

		MOV	AX,0E07H	; AH = INT 10H function NUMBER
					; (write teletype)
					; AL = 07H (bell character)
		INT	10H		; emit beep

		MOV	DX,OFFSET RESIDENT_GROUP:SnapFile
		MOV	AH,3CH		; INT 21H function 3CH
					; (create file handle)
		MOV	CX,0		; file attribute
		INT	21H
		JC	L94		; jump if file not opened

		PUSH	AX		; push file handle
		MOV	AH,0FH		; INT 10H func 0FH (get video status)
		INT	10H		; AL = video mode number
					; AH = number of character columns
		POP	BX		; BX = file handle

		CMP	AH,80
		JNE	L93		; jump if not 80 column mode

		MOV	DX,0B800H	; DX = color video buffer segment
		CMP	AL,3
		JBE	L92		; jump if color alphanumeric mode

		CMP	AL,7
		JNE	L93		; jump if not monochrome mode

		MOV	DX,0B000H	; DX = monochrome video buffer segment

L92:		PUSH	DS
		MOV	DS,DX
		XOR	DX,DX		; DS:DX -> start of video buffer
		MOV	CX,80*25*2	; CX = number of bytes to write
		MOV	AH,40H		; INT 21H function 40H (write file)
		INT	21H
		POP	DS

L93:		MOV	AH,3EH		; INT 21H function 3EH (close file)
		INT	21H

		MOV	AX,0E07H	; AH = INT 10H function NUMBER
					; (write teletype)
					; AL = 07H (bell character)
		INT	10H		; emit beep
 endif
;===============================================================================
;New routine: dumps graphic images to disk file

tblSize	equ	44		;number of entries in modeTbl
scrPag	equ	0462h		;address of currently displayed page variable

	.386			;80386 required
	push	es		;(for safety)
	sti			;enable interrupts
	call	beep		;indicate capture has started

	mov	ax, 0002h	;turn off mouse pointer (otherwise int 10h is
	int	33h		; called, which is not reentrant and it'll blow)

;Preserve location of VESA window (otherwise flood fills get glitched)
	mov	ax, 4F05h	;CPU video memory window control
	mov	bx, 0100h	;return location of window A
	int	10h
	mov	savePage, dx	;record current window location

	mov	ax, 4F03h	;get video mode
	mov	bx, -1		;set default mode to -1 in case VESA interrupt
	int	10h		; functions are not available
	xchg	ax, bx		;save mode in ax
	and	ax, 1FFFh	;remove bits 15, 14 and 13 for VBE 3.0

;Find video mode (in ax) in table
	mov	si, offset RESIDENT_GROUP: modeTbl
	mov	cx, tblSize
fm10:	cmp	ax, [si]	;is si register pointing to mode entry?
	je	fm30		;skip if so
	add	si, 2*4		;else next entry in table
	loop	fm10		;loop for all modes in table
	mov	bx, 1		;error 1: unsupported mode
fail:
;Display error message and error codes
	push	ax		;save error codes
	push	bx

	mov	ax, 0003h	;clear screen and set normal text mode
	int	10h

;	mov	ah, 09h		;display string "Snarf Error: xxxxx xxxxx"
;	mov	dx, offset RESIDENT_GROUP: errMsg
;	int	21h
;The above causes the computer to hang

	mov	si, offset RESIDENT_GROUP: errMsg
	call	textOut

	pop	ax		;display code originally in bx (1, 2, 3)
	call	numOut		;(destroys ax and dx)

	mov	al, ' '		;space character
	int	29h

	pop	ax		;display code in ax (details)
	call	numOut		;(destroys ax and dx)

	mov	al, CR		;carriage return
	int	29h
	mov	al, LF		;line feed
	int	29h

	mov	ax, 0E07h	;indicate failure: a regular bell sound
	int	10h
	jmp	getOut9		;error exit
fm30:
;(ax=mode, si=pointer to mode's table entry)

	mov	mode, ax
	mov	cx, [si+2]	;if width = 0 then graphMode:= false
	mov	graphMode, cx	; else graphMode:= true (non-zero)

	call	setVESA		;set up VESA parameters
	call	setText		;set up Text mode parameters

;Determine size of color map (which is only used by planar graphic modes & text)
	xor	di, di		;di = color map size (entries)
	mov	cx, [si+6]	;TVD
	cmp	cl, 8		;di:= if TVD<=8 then 1<<TVD else 0
	jg	fm40
	 inc	di		;di:= 1
	 shl	di, cl
fm40:
;Set up .bmp file header array
; (si = modeTbl entry; di = size of color map)

	xor	eax, eax	;prepare for 32-bit calculation
	imul	ax, di, 4	;color map size * 4 (convert entries to bytes)
	add	ax, 54		;+ header size (bytes)
	mov	word ptr [header+10], ax ;set offset to image data
	push	eax		;save partial result

	mov	ax, [si+2]	;TVW
	cmp	graphMode, 0	;graphics mode?
	jne	fm42		;skip if so
	 mov	ax, textWidth	;set screen's text width in pixels
	 shl	ax, 3		;*8
fm42:
	mov	word ptr [header+18], ax ;set image width (pixels)
	shr	ax, 3		;/8 (all widths are evenly divisible by 8)
	mov	cx, [si+6]	;*TVD
	cmp	cl, 15		;15-bit 5:5:5 format?
	jne	fm50		;skip if not
	 inc	cx		;say that it's 16 bits
fm50:	mov	word ptr [header+28], cx ;set bits per pixel
	imul	ax, cx

	xor	ecx, ecx
	mov	cx, [si+4]	;*TVH
	cmp	graphMode, 0	;graphics mode?
	jne	fm52		;skip if so
	 mov	cx, textHeight	;set screen's text height in pixels
	 imul	cx, fontHeight
fm52:
	mov	word ptr [header+22], cx ;set image height (pixels)
	imul	eax, ecx
	pop	ecx
	add	eax, ecx
	mov	dword ptr [header+2], eax ;set size of .bmp file (bytes)

;Open file for output

	mov	ax, offset RESIDENT_GROUP: buffer
	mov	[outPtr], ax	;set pointer to start of output buffer

	mov	bx, offset RESIDENT_GROUP: fileName+5
	mov	ax, '00'	;initialize file name counter to "000"
	mov	[bx], ax
	mov	[bx+2], al

;Try to open fileName for input
fn10:	mov	ax, 3D00h
	mov	dx, offset RESIDENT_GROUP: fileName
	int	21h
	pushf			;save carry flag
	xchg	bx, ax		;save handle in bx register
	mov	ah, 3Eh		;release handle
	int	21h		;(only a few handles can be open at one time)
	popf
	jc	fn20		;skip if file does not exist

;FileName is already used so try the next name
	mov	bx, offset RESIDENT_GROUP: fileName+7 ;point to end of file name
fn15:	inc	byte ptr [bx]	;increment counter in name
	cmp	byte ptr [bx], '9'
	jle	fn10		;loop if valid number
	mov	byte ptr [bx], '0' ;else roll over to next higher place
	dec	bx
	cmp	bx, offset RESIDENT_GROUP: fileName+5 ;999 = maximum count
	jae	fn15		;loop until unused file name is found
	mov	bx, 2		;error 2: more than 999 snarf files
	jmp	fail		;exit if maximum count is exceeded

;File does not exist, so open fileName for output
; (dx=fileName)
fn20:	mov	bx, 3		;error 3: cannot open output file
	mov	ah, 3Ch		;function to open a file for output
	xor	cx, cx		;no attributes
	int	21h
	jc	fail		;(root directory might be full)
	xchg	bx, ax		;save handle in bx register

;Write header array
; (bx = file handle)

	mov	cx, 54		;number of bytes in header array
	push	si		;save pointer into modeTbl
	mov	si, offset RESIDENT_GROUP: header
wh10:	lodsb			;al:= ds:[si++]
	call	byteOut
	loop	wh10
	pop	si

;Write color map (if used)

	mov	al, 0		;point h/w index register to first color reg.
	mov	dx, 3C7h	;(assume 256 colors are used)
	out	dx, al

;Get Color Plane Enable register (so we use only the displayed planes)
	mov	dl, 0DAh	;reset flip-flop (must do each time)
	cmp	mode, 7		;deal with monochrome mode, which uses a
	jne	wcm05		; different address
	 mov	dl, 0BAh
wcm05:
	cli			;for safety
	in	al, dx
	mov	dl, 0C0h	;select Color Plane Enable register (12h)
	mov	al, 12h+20h	;12h + Palette Address Source (PAS) bit
	out	dx, al
	inc	dx		;read the register (3C1h)
	in	al, dx
	sti
	mov	planeMask, al	;save the mask of the displayed planes

	xor	cx, cx		;first color register = 0
wcm10:	cmp	cx, di		;while cx < ColorMapSize do...
	jge	wcm30

	cmp	di, 16		;if ColorMapSize <= 16 then...
	jg	wcm20		;(skip if not)

;Use the color register that is selected by the palette register
	mov	dl, 0DAh	;reset flip-flop (must do each time)
	cmp	mode, 7		;deal with monochrome mode, which uses a
	jne	wcm15		; different address
	 mov	dl, 0BAh
wcm15:
	cli
	in	al, dx
	mov	dl, 0C0h	;select palette register I
	mov	al, cl
	and	al, planeMask	;however only select the displayed planes
	out	dx, al		; (PAS bit must be 0)
	inc	dx		;read palette register (3C1h)
	in	al, dx
	mov	dl, 0C7h	;select color register J
	out	dx, al
	sti
wcm20:
	mov	dl, 0C9h	;read color register's red, green & blue values
	in	al, dx
	push	ax
	in	al, dx
	push	ax
	in	al, dx		;63 = full intensity for register

	cmp	mode, 7		;deal with monochrome mode
	jne	wcm28		;skip if not

	add	sp, 2*2		;discard 2 items from stack
	imul	ax, cx, 6	;provide a gradient of gray shades, making
	cmp	al, 63		; sure that 0=black (0), 7=white (42), and
	jbe	wcm25		; F=bright white (63)
	 mov	al, 63
wcm25:
	push	ax		;push new values onto stack
	push	ax
wcm28:
	call	byteOutx4	;255 = full intensity for .bmp
	pop	ax		;(.bmp colors are backwards)
	call	byteOutx4
	pop	ax
	call	byteOutx4
	mov	al, 0
	call	byteOut

	inc	cx		;next color register
	jmp	wcm10
wcm30:
;Make sure Palette Address Source (PAS) bit is set so that the display
; hardware can access the palette registers and display an image.

	mov	dl, 0DAh	;reset flip-flop (must do each time)
	cmp	mode, 7		;deal with monochrome mode, which uses a
	jne	wcm35		; different address
	 mov	dl, 0BAh
wcm35:
	cli
	in	al, dx
	mov	dl, 0C0h	;attribute address register
	mov	al, 20h		;set PAS bit
	out	dx, al
	sti

	cmp	graphMode, 0	;graphics mode?
	je	rp50		;jump if not (it must be text mode)

;Write the image data
;BMP images are upside down, so bottom scan line is output first
; (bx = file handle; si = modeTbl entry)

	mov	dx, [si+4]	;dx = Y coord
	dec	dx		;start at TVH-1
rp10:	xor	cx, cx		;cx = X coord; start at 0

rp20:	mov	ax, [si+6]	;TVD
	cmp	al, 1		;2 colors (monochrome)?
	jne	rpx4		;skip if not

	mov	di, 0100h	;set up shift register to loop 8 times
rp25:	call	readPix
	inc	cx		;next X
	rcr	al, 1		;pack 8 pixels per byte
	rcl	di, 1
	jnc	rp25		;loop 8 times

	dec	cx		;compensate for "inc cx" below
	xchg	ax, di		;al = values of 8 pixels
	jmp	rp30		;go output al
rpx4:
	cmp	al, 4		;16 colors (also 4-color CGA)?
	jne	rpx8		;skip if not

	call	readPix
	shl	al, 4		;pack 2 pixels per byte
	xchg	di, ax		;leftmost pixel is high nibble
	inc	cx
	call	readPix
	and	al, 0Fh
	or	ax, di
	jmp	rp30		;go output al
rpx8:
	cmp	al, 8		;256 colors?
	jne	rpx15		;skip if not

	call	readPix
	jmp	rp30		;go output al
rpx15:
	cmp	al, 15		;32768 colors?
	jne	rpx16		;skip if not

	call	readPix		;read 5:5:5 format
	jmp	rp28		;go output 2 bytes
rpx16:
	cmp	al, 16		;65536 colors?
	jne	rpx24		;skip if not

	call	readPix
	mov	di, ax		;convert 5:6:5 format to 5:5:5
	shr	ax, 1		; which is the form used by .bmp
	and	al, 0E0h
	and	di, 001Fh
	add	ax, di
	call	byteOut
	mov	al, ah
	jmp	rp30		;go output al
rpx24:
	cmp	al, 24		;16,777,216 colors?
	jne	rp32		;skip if not

	call	readPix
	call	byteOut		;B
	shr	eax, 8
rp28:	call	byteOut		;G
	mov	al, ah
rp30:	call	byteOut		;R
rp32:
	inc	cx		;next X
	cmp	cx, [si+2]	;loop until X = TVW
	jne	rp20

	dec	dx		;next Y (upward)
	jns	rp10
	jmp	rp80
rp50:

;Convert text screen to graphics and write it to disk file
; Inputs bx = handle
; Register usage:
;  ax = Ch, At, scratch
;  bx = Y = font scan line, handle
;  cl = X = counter for bit pairs in a font byte
;  ch = font byte
;  dl = color of first pixel pair
;  dh = color of second pixel pair
;  si = scratch
;  di = I = character column position 
;  bp = J = text line

wrtTxt:
	pusha			;preserve registers
	mov	handle, bx

	mov	bp, textHeight	;start at bottom text line and scan upward
	dec	bp

rt10:	mov	bx, fontHeight	;start at bottom scan line in font
	dec	bx

rt20:	xor	di, di		;for all character columns on a line...

;Get character and its attribute from text screen
;   Ch:= Peek(TextBase, (I-J*TextWidth)*2   + PageOffset);
;   At:= Peek(TextBase, (I-J*TextWidth)*2+1 + PageOffset);
rt30:	mov	es, textBase	;segment address of text screen
	mov	ax, bp		;J*TextWidth
	mul	byte ptr textWidth ;ax:= al*textWidth
	add	ax, di		;+I; column position
	shl	ax, 1		;*2; address words (not bytes)
	add	ax, pageOffset	;+PageOffset
	mov	si, ax
	mov	ax, es:[si]	;al=Ch; ah=At

;Output one scan line of the character
; Byte:= Peek(FontSeg, FontOff+Ch*FontHeight-Y);
	push	ax		;save attribute (in ah)
	mul	byte ptr fontHeight ;ax:= al*fontHeight
	mov	si, fontOffset
	add	si, ax
	mov	es, fontSeg
	mov	ch, es:[bx+si] 	;get byte from font table
	pop	ax		;restore attribute
;ch=byte

;ah=At
	mov	al, ah
	and	al, 0Fh		;al = foreground color
	shr	ah, 4		;ah = background color

	mov	cl, 4		;for each pair of bits in ch...
	test	ch, ch		;test MSB of Byte
rt40:	mov	dh, al		;assume foreground color
	js	rt42		;skip if MSB is set
	 mov	dh, ah		;use background color
rt42:
	shl	ch, 1		;next bit
	mov	dl, al		;assume foreground color
	js	rt46		;skip if MSB is set
	 mov	dl, ah		;use background color
rt46:
	push	ax		;save foreground and background colors
	mov	al, dl		;pack two pixels per byte
	and	al, 0Fh
	shl	dh, 4		;leftmost pixel is in high nibble
	add	al, dh

	push	bx
	mov	bx, handle
	call	byteOut	
	pop	bx
	pop	ax

	shl	ch, 1		;next bit
	loop	rt40		;loop for 4 pairs of bits (ch will = 0)

	inc	di		;next text column (I)
	cmp	di, textWidth	;loop for all columns
	jne	rt30

	dec	bx		;next font scan line (Y)
	jns	rt20		;loop for all scan lines

	dec	bp		;next line of text (J)
	jns	rt10

	popa			;restore registers

;Close output file
rp80:
	mov	cx, [outPtr]	;size = outPtr - offset buffer
	sub	cx, offset RESIDENT_GROUP: buffer
	je	rp90		;skip if nothing to write
	 call	wrtBuf		;bx = handle
	 mov	handle, bx	;error 4
	 mov	bx, 4		;if number of bytes written is not equal the
	 jne	fail		; number of bytes requested then error
	 mov	bx, handle
rp90:
	mov	ah, 3Eh		;close DOS file
	int	21h		;bx = handle
	mov	bx, 5		;error 5
	jc	fail
	jmp	getOut		;all done

;-------------------------------------------------------------------------------
;Routine to make a pleasant sounding beep on the speaker
;
beep:	push	ax		;preserve registers
	push	es

	push	40h		;point to BIOS variables
	pop	es

	mov	al, 0B6h	;set channel 2 for mode 3
	out	43h, al		;set command register

	cli			;enable speaker and timer 2 output
	in	al, 61h
	push	ax		;preserve port
	or	al, 03h
	out	61h, al
	sti

;Synchronize to the start of a timer tick to get a consistent beep duration
	mov	al, es:[6Ch]	;get system timer tick
beep10:	cmp	al, es:[6Ch]	;wait for tick count to change
	je	beep10

	mov	ah, 7		;start with low tone
beep15:	mov	al, 0D0h
	out	42h, al		;start beep
	mov	al, ah
	and	al, 7Fh
	out	42h, al

	mov	al, es:[6Ch]	;get system timer tick
beep20:	cmp	al, es:[6Ch]	;wait for tick count to change
	je	beep20

	xor	ah, 84h		;flip carry and change tone from low to high
	jc	beep15		;loop

	pop	ax		;restore port
	out	61h, al

	mov	al, 0FFh	;(This keeps the Puzzle program happy.
	out	42h, al		;There is no way to read what timer 2 has been
	out	42h, al		; programmed for--only the output latch can be
				; read, not the input counter)
	pop	es		;restore registers
	pop	ax
	ret

;-------------------------------------------------------------------------------
;The VESA graphic modes require more video RAM than can fit in the allotted
; space (A0000h-AFFFFh). Thus it's mapped into this 64K space a page at a time.
;
;Routine to set up parameters to support reading pixels in a VESA image.
; Input: ax = video mode
; Outputs: vxMode, vXSize, vYSize, vxPage, vGranSh, bytesPerLine, bytesPerPix
; WARNING: These outputs are only guaranteed for VESA modes >= 100h and mode 13h
; BytesPerPix is set to zero for all planar modes (VESA and VGA).

setVESA:push	ax
	push	bx			;preserve registers
	push	cx
	push	dx
	push	di
	push	es

	mov	vxMode, ax		;record the video mode

;Select page 0 (even if non-VESA mode)
	mov	ax, 4F05h		;CPU video memory window control
	xor	bx, bx			;window A
	xor	dx, dx			;page 0
	mov	vxPage, dx		;record selected page (used by mode 13h)
	int	10h

	mov	ax, 320			;initialize in case mode is 13h
	mov	word ptr bytesPerLine, ax
	mov	vXSize, ax
	mov	vYSize, 200
	mov	vGranSh, bl		;vGranSh:= 0
	inc	bx			;bytesPerPix:= 1

	cmp	vxMode, 13h		;skip if mode 13h
	je	sv17			;(short jump trick)
	 dec	bx			;bytesPerPix:= 0
	 cmp	vxMode, 7Fh		;skip if not an SVGA mode >= 100h (mode
sv17:	jbe	sv20			; 6Ah is a planar mode and not set up)

	mov	ax, 4F01h		;return SVGA info in 256-byte "buffer"
	mov	cx, vxMode
	mov	di, offset RESIDENT_GROUP: buffer
	push	ds
	pop	es
	int	10h

;Pick out the info we need
	mov	ax, word ptr [buffer+16] ;bytesPerLine = buffer(16)
	mov	word ptr bytesPerLine, ax
	mov	ax, word ptr [buffer+18] ;vXSize = buffer(18)
	mov	vXSize, ax
	mov	ax, word ptr [buffer+20] ;vYSize = buffer(20)
	mov	vYSize, ax

;vGranSh = ln2(64/granularity)
	mov	bx, word ptr [buffer+4] ;granularity = buffer(4)
	xor	ax, ax			;avoid div by 0--assume a 64K window
	test	bx, bx			;if bx = 0 then vGranSh:= 0
	je	sv19
	 mov	al, 64
	 div	bl			;al(q):ah(r) <- ax / bl
	 cbw				;vGranSh:= ln2(al)
	 bsr	ax, ax			;Bit Scan Reverse; ax:= bit # of set bit
sv19:	mov	vGranSh, al

	xor	bx, bx			;bitsPerPixel = [buffer+25]
	mov	bl, [buffer+25]
	add	bl, 3			;bytesPerPixel = (bitsPerPixel+3)>>3
	shr	bl, 3
sv20:
	mov	word ptr bytesPerPix, bx

	pop	es			;restore registers
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret

;-------------------------------------------------------------------------------
;Routine to set up parameters to support reading pixels in a text image.
; Input: ax=video mode, si=pointer to mode's table entry
; Outputs: textBase, textWidth, textHeight, pageOffset, fontOffset, fontSeg, and
; fontHeight.

setText:pusha
	push	es

	mov	dx, 0B800h		;set base segment address of screen
	cmp	al, 7			;TextBase:= if Mode = $7 then $B000
	jne	st10			; else $B800;
	 mov	dh, 0B0h
st10:	mov	textBase, dx

;TextWidth:= Peek($40,$4A) + Peek($40,$4B)<<8;
	push	40h
	pop	es
	mov	ax, es:[4Ah]
	mov	textWidth, ax

;PageOffset:= Peek($40,$4E) + Peek($40,$4F)<<8;
	mov	ax, es:[4Eh]
	mov	pageOffset, ax

	mov	ax, es:[84h]		;TextHeight:= Peek($40,$84) + 1;
	inc	ax
	mov	byte ptr textHeight, al
	mov	al, ah			;FontHeight:= Peek($40,$85);
;(al=fontHeight)
;case of
;  FontHeight >= 16:
;	[CpuReg(1):= $0600; FontHeight:= 16];	\ROM 8x16 font
;  FontHeight >= 14:
;	[CpuReg(1):= $0200; FontHeight:= 14]	\ROM 8x14 font
;other	[CpuReg(1):= $0300; FontHeight:= 8];	\ROM 8x8 font (00..7F)
	cmp	al, 16
	jb	st20
	 mov	bh, 6
	 mov	al, 16
	 jmp	st30
st20:
	cmp	al, 14
	jb	st25
	 mov	bh, 2
	 mov	al, 14
	 jmp	st30
st25:
	mov	bh, 3
	mov	al, 8
st30:
	mov	byte ptr fontHeight, al

	mov	ax, 1130h		;get font table location
	int	10h			;SoftInt($10);
	mov	fontOffset, bp		;FontOffset:= CpuReg(6) & $FFFF;
	mov	fontSeg, es		;FontSeg:= CpuReg(11) & $FFFF;

	pop	es			;restore registers
	popa
	ret

;-------------------------------------------------------------------------------
;Routine to return the color of a pixel on the graphics screen.
; Inputs: cx=X; dx=Y coordinates
; Outputs: eax

readPix:push	es			;preserve registers
	push	edx

	cmp	bytesPerPix, 0		;skip if planar mode (<=12h, 102, 4, 6h)
	je	rp100

	xor	eax, eax		;some VESA modes exceed 64K pixels
	mov	ax, dx			;Y
	imul	eax, bytesPerLine	;edx:= Y*bytesPerLine + X*bytesPerPix
	xor	edx, edx
	mov	dx, cx			;X
	imul	edx, bytesPerPix
	add	edx, eax

;High word of edx = required 64K video page
	ror	edx, 16			;dx:= page
	cmp	dx, vxPage		;skip if pixel is in the currently
	je	rp11			; selected page

;Select page in dx (i.e. move it into the 64K window at A0000h)
	push	bx
	mov	ax, 4F05h		;CPU video memory window control
	xor	bx, bx			;window A
	mov	vxPage, dx		;record selected page

;Set window position in video memory in window granularity units. Unfortunately
; some SVGA manufacturers don't use a granularity of 64K, and this causes a lot
; of trouble.
	push	dx
	push	cx
	mov	cl, vGranSh
	shl	dx, cl
	pop	cx

	int	10h
	pop	dx
	pop	bx			;restore registers
rp11:
	push	0A000h			;point es to video memory
	pop	es
	push	si
	rol	edx, 16			;restore offset into 64K page
	mov	si, dx			;and use si to access it
	mov	al, byte ptr bytesPerPix ;read 1, 2, 3 or 4 bytes of color

	cmp	al, 1
	jne	jj10
	mov	al, es:[si]		;read 1 byte of color
	movzx	eax, al
	jmp	jj90
jj10:
	cmp	al, 2
	jne	jj20
	mov	ax, es:[si]		;read 2 bytes of color
	movzx	eax, ax
	jmp	jj90
jj20:
	cmp	al, 3
	jne	jj30


;Read 3 bytes of color
; 65536 is not evenly divisible by 3 so a single pixel can span two windows)
	push	cx
	mov	cx, 3			;read 3 bytes of color (total)
rp22:	mov	al, es:[si]		;read 1 byte of color (LSB first)
	inc	edx			;next address

;High word of edx = required 64K video page
	ror	edx, 16			;dx:= page
	cmp	dx, vxPage		;skip if pixel is in the currently
	je	rp23			; selected page

;Select page in dx (i.e. move it into the 64K window at A0000h)
	push	eax
	push	bx
	mov	ax, 4F05h		;CPU video memory window control
	xor	bx, bx			;window A
	mov	vxPage, dx		;record selected page

;Set window position in video memory in window granularity units. Unfortunately
; some SVGA manufacturers don't use a granularity of 64K, and this causes a lot
; of trouble.
	push	dx
	push	cx
	mov	cl, vGranSh
	shl	dx, cl
	pop	cx

	int	10h
	pop	dx
	pop	bx			;restore registers
	pop	eax
rp23:
	rol	edx, 16			;normal format
	mov	si, dx
	ror	eax, 8			;next RGB color
	loop	rp22			;loop for 3 bytes
	shr	eax, 8

	pop	cx
	jmp	jj90

jj30:
	mov	eax, es:[si]		;read 4 bytes of color
jj90:
	pop	si
	pop	edx
	pop	es
	ret

;Use BIOS to handle planar modes (very slow, but it handles all the modes)
rp100:	push	bx

	push	0			;to access BIOS variables
	pop	es
	mov	bh, es:scrPag		;get currently displayed screen page
	mov	ah, 0Dh			;pixel read function
	int	10h			;do the function

	movzx	eax, al			;zero high bytes
	pop	bx			;restore registers

	pop	edx
	pop	es
	ret

;-------------------------------------------------------------------------------
;Write byte in al to buffered output file
; bx = file handle

byteOutx4:				;alternate entry point
	shl	al, 2			;multiply by 4 (for color registers)

byteOut:push	di			;main entry point

	mov	di, [outPtr]		;get pointer
	cmp	di, offset RESIDENT_GROUP: bufEnd
	jb	bo50			;skip if buffer is not full
	 push	cx
	 mov	cx, bufEnd - buffer	;number of bytes to write
	 call	wrtBuf
	 pop	cx
	 mov	di, offset RESIDENT_GROUP: buffer ;reset pointer to start
bo50:
	mov	[di], al		;store byte into buffer at the pointer
	inc	di			;point to next entry
	mov	[outPtr], di		;save pointer

	pop	di			;restore register
	ret

;-------------------------------------------------------------------------------
;Write the output buffer to disk file
; bx = handle
; cx = number of bytes to write

wrtBuf:	push	dx			;preserve registers
	push	ax

	mov	ah, 40h			;DOS function to write to a file
	mov	dx, offset RESIDENT_GROUP: buffer
	int	21h
	cmp	ax, cx			;return status ne if number written is
					; not equal the number requested
	pop	ax			;restore registers
	pop	dx
	ret

;-------------------------------------------------------------------------------
;Display the string pointed to by the ds:si register. The (ASCIIZ) string must
; be terminated with a 0 byte. The direction (D) flag must be clear.
; The al and si registers are altered.

to10:	int	29h		;display character
textOut:lodsb			;al:= ds:[si++]
	test	al, al
	jne	to10
	ret

;-------------------------------------------------------------------------------
;Display the positive integer in the ax register in the range 0..65535.
; The ax and dx registers are altered.

numOut:	xor	dx, dx		;Q:= N/10;
	div	cs:noTen	;dx:ax/10
	push	dx		;R:= rem(0);
	test	ax, ax		;if Q # 0 then NumOut(Q); \recurse
	je	no20
	 call	numOut
no20:	pop	ax		;ChOut(0, R+^0);
	add	al, '0'
	int	29h
	ret

noTen	dw	10

;-------------------------------------------------------------------------------
;All done
;Restore VESA window page

getOut:	mov	ax, 4F05h	;CPU video memory window control
	xor	bx, bx		;return position for window A
	mov	dx, savePage	;restore saved page
	int	10h

	mov	ax, 0001h	;turn on mouse pointer if it was on initially
	int	33h		; (a counter in int 33h handles with this)

getOut9:call	beep		;indicate that image capture is all done
	pop	es
	.8086

;===============================================================================

;		MOV	AX,0E07H	; emit another beep
;		INT	10H

; Restore previous DTA

L94:		PUSH	DS		; preserve DS
		LDS	DX,PrevDTA	; DS:DX -> previous DTA
		MOV	AH,1AH		; INT 21H function IAH (set DTA addr)
		INT	21H
		POP	DS

; Restore previous PSP

		MOV	BX,PrevPSP	; BX = previous PSP
		MOV	AH,50H		; INT 21H function 50H
		CALL	Int21v		; (set PSP address)

; Restore previous extended error information

		MOV	AX,DOSVersion
		CMP	AX,30AH 
		JB	L95		; jump if DOS ver earlier than 3.1
		CMP	AX,0A00H
		JAE	L95		; jump if MS OS/2-DOS 3.x box

		MOV	DX,OFFSET RESIDENT_GROUP:PrevExtErrInfo
		MOV	AX,5D0AH
		INT	21H		; (restore extended error information)

; Restore previous DOS break checking

L95:		MOV	DL,PrevBreak	; DL = previous state
		MOV	AX,3301H
		INT	21H

; Restore previous break and critical error traps

		MOV	CX,NTrap
		MOV	SI,OFFSET RESIDENT_GROUP:StartTrapList
		PUSH	DS		; preserve DS

L96:		LODS	BYTE PTR CS:[SI]    ; AL = interrupt number
					; CS:SI -> byte past interrupt number

		LDS	DX,CS:[SI+1]	; DS:DX ->  previous handler
		MOV	AH,25H		; INT 21H function 25H
		INT	21H		; (set interrupt vector)
		ADD	SI,7		; DS:SI -> next in list
		LOOP	L96
		POP	DS

; Restore all registers

		.386			;80386 required
		popad
		.8086
		POP	ES

		MOV	SS,PrevSS
		MOV	SP,PrevSP
		POP	DS

; Finally reset status flag and return

		MOV	BYTE PTR CS:HotFlag,FALSE
		RET
TSRapp		ENDP
RESIDENT_TEXT	ENDS

;===============================================================================

RESIDENT_DATA	SEGMENT WORD PUBLIC 'DATA'

ErrorModeAddr	DD	?		; address of DOS ErrorMode flag
InDOSAddr	DD	?		; address of DOS InDOS flag

NISR		DW	(EndISRList-StartISRList)/8 ; number of installed ISRs

StartISRList	DB	05H		; INT number
InISR5		DB	FALSE		; flag
PrevISR5	DD	?		; address of previous handler
		DW	OFFSET RESIDENT_GROUP:ISR5

		DB	08H
InISR8		DB	FALSE
PrevISR8	DD	?
		DW	OFFSET RESIDENT_GROUP:ISR8

		DB	09H
InISR9		DB	FALSE
PrevISR9	DD	?
		DW	OFFSET RESIDENT_GROUP:ISR9

		DB	10H
InISR10 	DB	FALSE
PrevISR10	DD	?
		DW	OFFSET RESIDENT_GROUP:ISR10


		DB	13H
InISR13 	DB	FALSE
PrevISR13	DD	?
		DW	OFFSET RESIDENT_GROUP:ISR13


		DB	28H
InISR28 	DB	FALSE
PrevISR28	DD	?
		DW	OFFSET RESIDENT_GROUP:ISR28


		DB	2FH
InISR2F 	DB	FALSE
PrevISR2F	DD	?
		DW	OFFSET RESIDENT_GROUP:ISR2F

EndISRList	LABEL	BYTE

TSRPSP		DW	?		; resident PSP segment address
TSRSP		DW	TSRStackSize	; resident SS:SP
TSRSS		DW	SEG RESIDENT_STACK
PrevPSP 	DW	?		; previous PSP
PrevSP		DW	?		; previous SS:SP
PrevSS		DW	?

HotKey		DB	DefHotKey	;scan code of hot key

HotKBFlag	DB	KBAlt
HotKBMask	DB	(KBIns OR KBCaps OR KBNum OR KBScroll) XOR 0FFH
HotFlag 	DB	FALSE		;currently processing hot key

ActiveTSR	DB	FALSE

DOSVersion	LABEL	WORD
		DB	?		;minor version number
MajorVersion	DB	?		;major version number

; The following data is used by TSR application

NTrap		DW	(EndTrapList-StartTrapList)/8	;number of traps

StartTrapList	DB	1BH
Trap1B		DB	FALSE
PrevISR1B	DD	?
		DW	OFFSET RESIDENT_GROUP:ISR1B

		DB	23H
Trap23		DB	FALSE
PrevISR23	DD	?
		DW	OFFSET RESIDENT_GROUP:ISR23

		DB	24H
Trap24		DB	FALSE
PrevISR24	DD	?
		DW	OFFSET RESIDENT_GROUP:ISR24

EndTrapList	LABEL	BYTE

PrevBreak	DB	?		; previous break-checking flag

PrevDTA 	LABEL	DWORD		; previous DTA address
PrevDTAoffs	DW	?
PrevDTAseg	DW	?

PrevExtErrInfo	LABEL	BYTE		; previous extended error information
PrevExtErrAX	DW	?
PrevExtErrBX	DW	?
PrevExtErrCX	DW	?
PrevExtErrDX	DW	?
PrevExtErrSI	DW	?
PrevExtErrDI	DW	?
PrevExtErrDS	DW	?
PrevExtErrES	DW	?
		DW	3 DUP(0)

;SnapFile	DB	'\snap.img'	; output file name in root directory

;-------------------------------------------------------------------------------

	align	2
savePage dw	0		;initial page in VESA window
outPtr	dw	0		;output buffer byte pointer
planeMask db	0Fh		;value read from Color Plane Enable register

fileName db	'SNARF000.BMP', 0
errMsg	 db	'Snarf 1.3 Error: ', 0

	align	2
;		Mode	Width	Height	Depth
modeTbl	dw	04h,	320,	200,	4	;depth is actually 2, but use 4
	dw	05h,	320,	200,	4	; because 2 is not a legal .bmp
	dw	06h,	640,	200,	1	; format
	dw	0Dh,	320,	200,	4
	dw	0Eh,	640,	200,	4
	dw	0Fh,	640,	350,	1
	dw	10h,	640,	350,	4
	dw	11h,	640,	480,	1
	dw	12h,	640,	480,	4
	dw	13h,	320,	200,	8
	dw	6Ah,	800,	600,	4
	dw	100h,	640,	400,	8
	dw	101h,	640,	480,	8
	dw	102h,	800,	600,	4
	dw	103h,	800,	600,	8
	dw	104h,	1024,	768,	4
	dw	105h,	1024,	768,	8
	dw	106h,	1280,	1024,	4
	dw	107h,	1280,	1024,	8
	dw	10Dh,	320,	200,	15
	dw	10Eh,	320,	200,	16
	dw	10Fh,	320,	200,	24
	dw	110h,	640,	480,	15
	dw	111h,	640,	480,	16
	dw	112h,	640,	480,	24
	dw	113h,	800,	600,	15
	dw	114h,	800,	600,	16
	dw	115h,	800,	600,	24
	dw	116h,	1024,	768,	15
	dw	117h,	1024,	768,	16
	dw	118h,	1024,	768,	24
	dw	119h,	1280,	1024,	15
	dw	11Ah,	1280,	1024,	16
	dw	11Bh,	1280,	1024,	24
	dw	0h,	0,	0,	4	;text
	dw	1h,	0,	0,	4
	dw	2h,	0,	0,	4
	dw	3h,	0,	0,	4
	dw	7h,	0,	0,	4	;(need at least 3 colors)
	dw	108h,	0,	0,	4	;VESA text
	dw	109h,	0,	0,	4
	dw	10Ah,	0,	0,	4
	dw	10Bh,	0,	0,	4
	dw	10Ch,	0,	0,	4

header	db	'BM'		; 0: file must begin with "BM" (Bit Map)
	dd	54 + 256*4 + 640*480 ;2: size of entire file (default mode 101h)
	dw	0		; 6: 0
	dw	0		; 8: 0
	dd	54 + 256*4	;10: offset from start of file to image data
	dd	40		;14: size of sub-header (bytes)
	dd	640		;18: image width in pixels  (TVW for mode 101h)
	dd	480		;22: image height in pixels (TVH for mode 101h)
	dw	1		;26: planes
	dw	8		;28: bits per pixel	    (TVD for mode 101h)
	dd	0		;30: compression type (not used)
	dd	0		;34: size of compressed image data (not used)
	dd	0		;38: horizontal resolution (not used)
	dd	0		;42: vertical resolution (not used)
	dd	0		;46: number of colors used (not used)
	dd	0		;50: number of "important" colors (not used)

;WARNING: These values (except vxMode) are only valid for modes >= 100h & 13h
	align	2
vXSize	dw	0	;width of image in pixels
vYSize	dw	0	;height of image in pixels
bytesPerPix  dd	0	;bytes per pixel (0, 1, 2, 3, or 4)
bytesPerLine dd	0	;bytes per scan line (e.g: 320, 1920, 2560, 2048)
vxMode	dw	3	;currently selected video mode
vxPage	dw	0	;64K page of video RAM mapped into A0000h
vGranSh	db	0	;window posn = vxPage << (ln2(64/granularity))
	align	2
;Variables for text capture:
mode		dw	0	;mode number
handle		dw	0	;file handle
graphMode	dw	0	;flag: graphic mode if non-zero (vs. text mode)
textBase	dw	0	;base segment address of screen (B800 or B000)
textWidth	dw	0	;screen width in character columns
textHeight	dw	0	;screen height in character lines
pageOffset	dw	0	;offset to currently active page (bytes)
fontOffset	dw	0	;address of BIOS font table (offset and segment)
fontSeg		dw	0
fontHeight	dw	0	;character height in pixels = number of bytes
				; per character in font table
buffer	db	256 dup (?)	;VESA mode information block and disk buffer
bufEnd	equ	$		;end of buffer +1

RESIDENT_DATA	ENDS

;-------------------------------------------------------------------------------

RESIDENT_STACK	SEGMENT WORD STACK 'STACK'

		DB	TSRStackSize DUP(?)

RESIDENT_STACK	ENDS
		PAGE

;###############################################################################
;         Program Entry Point -- Transient Installation Routines
;###############################################################################

TRANSIENT_TEXT	SEGMENT PARA PUBLIC 'TCODE'
		ASSUME	CS:TRANSIENT_TEXT,DS:RESIDENT_DATA,SS:RESIDENT_STACK

installSnapTSR	PROC	FAR		; At entry: CS:IP -> installSnapTSR
					;	    SS:SP -> stack
					;	    DS,ES -> PSP
; Save PSP segment

		MOV	AX,SEG RESIDENT_DATA
		MOV	DS,AX		; DS -> RESIDENT_DATA

		MOV	TSRPSP,ES	; save PSP segment

	call	numIn		;get scan code on command line for hot key 
	je	L99		;skip if none provided--use the default
	 mov	HotKey, al	;set specified hot key scan code
L99:

; Check DOS version

		CALL	GetDOSVersion	; AH = major version number
					; AL = minor version number

; Verify that this TSR is not already installed
;
;	Before executing INT 21H in DOS versions 2.x, test whether INT 2FH
;	vector is in use.  If so, abort if PRINT.COM is using it.
;
;	(Thus, in DOS 2.x, if both this program and PRINT.COM are used,
;	this program should be made resident before PRINT.COM.)

		CMP	AH,2
		ja	L101		; jump if version 3.0 or later

		MOV	AX,352FH	; AH = INT 21H function number
					; AL = interrupt number
		INT	21H		; ES:BX = INT 2FH vector

		MOV	AX,ES
		OR	AX,BX		; jump if current INT 2FH vector
		JNZ	L100		; is nonzero

		PUSH	DS
		MOV	AX,252FH	; AH = INT 21H function number
					; AL = interrupt number
		MOV	DX,SEG RESIDENT_GROUP
		MOV	DS,DX
		MOV	DX,OFFSET RESIDENT_GROUP:MultiplexIRET

		INT	21H		; point INT 2FH vector to IRET
		POP	DS
		JMP	SHORT L103	; jump to install this TSR

L100:		MOV	AX,0FF00H	; look for PRINT.COM
		INT	2FH		; if resident, AH = print queue length
					; otherwise, AH is unchanged

		CMP	AH,0FFH 	; if PRINT.COM is not resident
		JE	L101		; use multiplex interrupt

		MOV	AL,1
		CALL	FatalError	; abort if PRINT.COM already installed

L101:		MOV	AH,MultiplexID	; AH = multiplex interrupt in value
		XOR	AL,AL		; AL = 00H
		INT	2FH		; multiplex interrupt

		TEST	AL,AL
		JZ	L103		; jump if ok to install

		CMP	AL,0FFH 
		JNE	L102		; jump if not already installed

		MOV	AL,2
		CALL	FatalError	; already installed

L102:		MOV	AL,3
		CALL	FatalError	; can't install

; Get addresses of InDOS and ErrorMode flags

L103:		CALL	GetDOSFlags

;Display message indicating that Snarf is installed and ready

	push	ds
	mov	ax, seg TRANSIENT_DATA
	mov	ds, ax
	mov	ah, 09h		;int 21h function 09h (display string)
	mov	dx, offset MessageOk
	int	21h
	pop	ds

; Install this TSR's interrupt handlers

;		PUSH	ES		; preserve PSP segment
; WRONG! ES does not necessarily contain PSP at this point

		MOV	CX,NISR
		MOV	SI,OFFSET StartISRList

L104:		LODSB			; AL = interrupt number
					; DS:ES -> byte past interrupt number
		PUSH	AX		; previous AX
		MOV	AH,35H		; INT 21H function 35H
		INT	21H		; ES:BX = previous interrupt vector
		MOV	[SI+1],BX	; save offset and segment
		MOV	[SI+3],ES	; of previous handler

		POP	AX		; AL = interrupt number
		PUSH	DS		; preserve DS
		MOV	DX,[SI+5]
		MOV	BX,SEG RESIDENT_GROUP
		MOV	DS,BX		; DS:DX -> this TSR's handler
		MOV	AH,25H		; INT 21H function 25H
		INT	21H		; (set interrupt vector)
		POP	DS		; restore DS
		ADD	SI,7		; DS:SI -> next in list
		LOOP	L104

; Free the environment block

;		POP	ES		; ES = PSP segment
		mov	es, TSRPSP
		PUSH	ES		; preserve PSP segment

		MOV	ES,ES:[2CH]	; ES = segment of environment block
		MOV	AH,49H		; INT 21H function 49H
		INT	21H		; (free memory block)

; Terminate and stay resident

		POP	AX		; AX = PSP segment address
		MOV	DX,CS		; DX = paragraph address of start of
					; transient portion (end of resident
					; portion)
		SUB	DX,AX		; DX = size of resident portion (paras)
		MOV	AX,3100H	; AH = INT 21H function number
					; AL = 00H (return code)
		INT	21H
InstallSnapTSR	ENDP

;-----------------------------------------------------------------------------

GetDOSVersion	PROC	NEAR		; Caller:   DS = seg RESIDENT_DATA
					;	    ES = PSP
					; Returns:  AH = major version
					;	    AL = minor version
		ASSUME	DS:RESIDENT_DATA

		MOV	AH,30H		; INT 21H function 30H
					; (get DOS version)
		INT	21H
		CMP	AL,2
		JB	L110		; jump if versions 1.x

		XCHG	AH,AL		; AH = major version
					; AL = minor version
		MOV	DOSVersion,AX	; save with major version in
					; high order byte
		RET

L110:		MOV	AL,00H
		CALL	FatalError	; abort if versions 1.x
GetDOSVersion	ENDP

;-----------------------------------------------------------------------------

GetDOSFlags	PROC	NEAR		; Caller    DS = seg RESIDENT_DATA
					; Returns:  InDOSAddr -> InDOS
					;	    ErrorModeAddr -> ErrorMode
					; Destroys: AX,BX,CX,DI
		ASSUME	DS:RESIDENT_DATA

; Get InDOS address from DOS

		PUSH	ES

		MOV	AH,34H		; INT 21H function number
		INT	21H		; ES:BX -> InDOS

		MOV	WORD PTR InDOSAddr,BX
		MOV	WORD PTR InDOSAddr+2,ES

; Determine ErrorMode address

		MOV	WORD PTR ErrorModeAddr+2,ES	; assume ErrorMode is
							; in the same segment
							; as InDOS
		MOV	AX,DOSVersion
		CMP	AX,30AH 
		JB	L120		; jump if DOS version earlier
					; than 3.1
		CMP	AX,0A00H
		JAE	L120		;   or MS OS/2-DOS 3.x box

; if you fell through to here you get to do it the easy way

		DEC	BX		; in DOS 3.1 and later ErrorMode
		MOV	WORD PTR ErrorModeAddr,BX	; is just before InDOS
		JMP	SHORT L125

; Ok do it the hard way because user is running a weird version of DOS
; scan DOS segment for ErrorMode

L120:		MOV	CX,0FFFFH	; CX = maximum number of bytes to scan
		XOR	DI,DI		; ES:DI -> start of DOS segment

L121:		MOV	AX,WORD PTR CS:LF2  ; AX = opcode for INT 28H

L122:		REPNE	SCASB		; scan for first byte of fragment
		JNE	L126		; jump if not found

		CMP	AH,ES:[DI]		; inspect second byte of opcode
		JNE	L122			; junm if not found

		MOV	AX,WORD PTR CS:LF1 + 1	; AX = opcode for CMP
		CMP	AX,ES:[DI] [LF1-LF2]
		JNE	L123			; jump if opcode not CMP

		MOV	AX,ES:[DI][(LF1-LF2)+2] ; AX = offset of ErrorMode
		JMP	SHORT L124		; in DOS segment

L123:		MOV	AX,WORD PTR CS:LF3 + 1	; AX = opcode for TEST
		CMP	AX,ES:[DI] [LF3-LF4]
		JNE	L121			; jump if opcode not TEST

		MOV	AX,ES:[DI][(LF3-LF4)+2] ; AX = offset of ErrorMode

L124:		MOV	WORD PTR ErrorModeAddr,AX

L125:		POP	ES
		RET

; You arrived here if address of ErrorMode not found

L126:		MOV	AL,04H
		CALL	FatalError

; Code fragments for scanning for ErrorMode flag

LFnear		LABEL	NEAR		; dummy labels for addressing
LFbyte		LABEL	BYTE
LFword		LABEL	WORD

LF1:		CMP	SS:LFbyte,0	; CMP ErrorMode,0
		JNE	LFnear
LF2:		INT	28H

LF3:		TEST	SS:LFbyte,0FFH	; TEST ErrorMode,0FFH
		JNE	LFnear
		PUSH	SS:LFword
LF4:		INT	28H
GetDOSFlags	ENDP

;-------------------------------------------------------------------------------
;Routine to read a decimal integer from the command line and return it in ax.
; Range 0..255
; Returns 0 if no number on command line
	.386
numIn:	push	ds		;preserve registers
	push	dx
	push	si

	mov	ds, TSRPSP	;point to PSP
	mov	si, 81h		;point to info on command line
	xor	dx, dx		;zero accumulator

ni10:	mov	al, ds:[si]	;fetch character from command line
	inc	si
	cmp	al, CR		;carriage return?
	je	ni30		;exit if so
	sub	al, '0'		;is it a digit?
	jl	ni10		;loop if not
	cmp	al, 9
	jg	ni10
	mov	dl, al		;put first char into accumulator

ni20:	mov	al, ds:[si]	;accumulate digits in dx until non-digit
	inc	si
	sub	al, '0'		;is character a digit?
	jl	ni30		;exit if not
	cmp	al, 9
	jg	ni30
	imul	dx, 10		;accumulate decimal integer
	cbw			;ah:= 0
	add	dx, ax
	jmp	ni20		;loop until non-digit is found
ni30:
	xchg	ax, dx		;return with integer in ax
	pop	si		;restore registers
	pop	dx
	pop	ds
	ret
	.8086

;-----------------------------------------------------------------------------

FatalError	PROC	NEAR		; Caller:   AL = message number
					;	    ES = PSP
		ASSUME	DS:TRANSIENT_DATA

		PUSH	AX		; save message number on stack

		MOV	BX,SEG TRANSIENT_DATA
		MOV	DS,BX

; Display the requested message

		MOV	BX,OFFSET MessageTable
		XOR	AH,AH		; AH = message number
		SHL	AX,1		; AX = offset into MessageTable
		ADD	BX,AX		; DS:BX -> address of message
		MOV	DX,[BX] 	; DS:DX -> message
		MOV	AH,09H		; INT 21H function 09H (display string)
		INT	21H		; display error message

		POP	AX		; AL = message number
		OR	AL,AL
		JZ	L130		; jump if message number is zero
					; (DOS version 1.x)
; Terminate (DOS 2.x and later)

		MOV	AH,4CH		; INT 21H function 4CH
		INT	21H		; (terminate process with return code)

; Terminate (DOS 1.x)

;-----------------------------------------------------------------------------

L130		PROC	FAR
		PUSH	ES		; push PSP:0000H
		XOR	AX,AX
		PUSH	AX
		RET
L130		ENDP
FatalError	ENDP
TRANSIENT_TEXT	ENDS
		PAGE

;-------------------------------------------------------------------------------
; Transient data segment
;-------------------------------------------------------------------------------

TRANSIENT_DATA	SEGMENT WORD PUBLIC 'DATA'

MessageTable	DW	Message0	; DOS version error
		DW	Message1	; PRINT.COM found in DOS 2.x
		DW	Message2	; already installed
		DW	Message3	; can't install
		DW	Message4	; can't find flag

Message0	DB  CR,LF,'DOS version 2.0 or later is required',CR,LF,'$'
Message1	DB  CR,LF,'Can''t install because PRINT.COM is active',CR,LF,'$'
Message2	DB  CR,LF,'This program is already installed',CR,LF,'$'
Message3	DB  CR,LF,'Can''t install this program',CR,LF,'$'
Message4	DB  CR,LF,'Unable to locate DOS ErrorMode flag',CR,LF,'$'

MessageOk	db  CR,LF,'Snarf 1.3 is now installed in memory',CR,LF,'$'

TRANSIENT_DATA	ENDS
		END	InstallSnapTSR
