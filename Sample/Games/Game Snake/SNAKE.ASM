		PAGE    60,132


data_58b	=	58Bh
data_58f	=	58Fh
data_8eb	=	8EBh


;ÄÄÄÄÄÄÄÄÄÄ CODE_SEG_1  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

CODE_SEG_1	segment para public
CODE_SEG_1	ends



;ÄÄÄÄÄÄÄÄÄÄ DATA_SEG_2  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

DATA_SEG_2	segment para public
DATA_SEG_2	ends



;ÄÄÄÄÄÄÄÄÄÄ STACK_SEG_3  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

STACK_SEG_3	segment stack
STACK_SEG_3	ends



;ÄÄÄÄÄÄÄÄÄÄ CODE_SEG_1  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

CODE_SEG_1	segment para public
		assume  CS:CODE_SEG_1, DS:nothing, SS:STACK_SEG_3, ES:nothing

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		ENTRY POINT
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±


;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		PROCEDURE proc_start
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

proc_start	proc	far
start:		; N-Ref=0
		mov	AX,DATA_SEG_2		
		mov	DS,AX			

;ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		assume  DS:DATA_SEG_2
;ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ

		mov	AH,0Fh			
		int	10h			; BIOS Service func ( ah ) = 0Fh
						; Get current video mode
						;AH-width AL-mode BH-page
		mov	Byte Ptr var2_0,AL	; [74DF:0000] = 4800h
		mov	AX,13h			
		int	10h			; BIOS Service func ( ah ) = 0
						; Set video mode
						;AL = video mode

		dw	68h, 7A0h, 2CBAh, 0E80Ah
		dw	0E9Ah, 6C7h, 59Fh, 0FFFh
		dw	27E8h, 0BA0Fh, 0A3Eh, 8BE8h
		dw	0C70Eh, 9F06h, 0FF05h, 0E8FFh
		dw	0F18h
loc_1:		; N-Ref=3
		mov	DX,95Dh			
		call	near ptr proc_10	
		mov	DX,offset var2_9b2	
		call	near ptr proc_10	
		call	near ptr proc_1		
		cmp	Word Ptr var2_5bf,+1	; [74DF:05BF] = 0
		je	loc_2			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		cmp	Word Ptr var2_5bf,+2	; [74DF:05BF] = 0
		je	loc_3			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		cmp	Word Ptr var2_5bf,+3	; [74DF:05BF] = 0
		je	loc_4			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		cmp	Word Ptr var2_5bf,+4	; [74DF:05BF] = 0
		je	loc_5			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
loc_2:		; N-Ref=1
		call	near ptr proc_3		
		jmp	short loc_1		
loc_3:		; N-Ref=1
		call	near ptr proc_2		
		jmp	short loc_1		
loc_4:		; N-Ref=1
		mov	DX,offset var2_96e	
		call	near ptr proc_10	
		mov	Word Ptr var2_59f,0FFFFh; [74DF:059F] = 1FFFh
		call	near ptr proc_11	
		jmp	short loc_1		
loc_5:		; N-Ref=1
		mov	DX,offset var2_a50	
		call	near ptr proc_10	
		mov	Word Ptr var2_59f,0FFFFh; [74DF:059F] = 1FFFh
		call	near ptr proc_11	
		mov	AH,0			
		mov	AL,Byte Ptr var2_0	; [74DF:0000] = 4800h
		int	10h			; BIOS Service func ( ah ) = 0
						; Set video mode
						;AL = video mode
		mov	AX,4C00h		
		int	21h			; DOS func ( ah ) = 4Ch
						; Terminate process
						;AL-ret code
proc_start	endp



;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		PROCEDURE proc_1
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

proc_1		proc	near

		dw	0B860h, 1, 33CDh
loc_6:		; N-Ref=5
		mov	AX,3			
		int	33h			
		cmp	BX,+1			
		jne	loc_6			; Jump if not equal ( != )
		cmp	CX,0EAh			
		jb	loc_6			; Jump if below ( < )
		cmp	CX,19Ch			
		jnle	loc_6			; Jump if greater ( > )
		cmp	DX,+39h			
		jb	loc_7			; Jump if below ( < )
		nop				; No operation
		nop				; No operation
		cmp	DX,+4Ah			
		jnle	loc_7			; Jump if greater ( > )
		nop				; No operation
		nop				; No operation
		mov	Word Ptr var2_5bf,offset var2_1	; [74DF:05BF] = 0
		jmp	short loc_10		

		db	90h
loc_7:		; N-Ref=2
		cmp	DX,+53h			
		jb	loc_8			; Jump if below ( < )
		nop				; No operation
		nop				; No operation
		cmp	DX,+64h			
		jnle	loc_8			; Jump if greater ( > )
		nop				; No operation
		nop				; No operation
		mov	Word Ptr var2_5bf,2	; [74DF:05BF] = 0
		jmp	short loc_10		

		db	90h
loc_8:		; N-Ref=2
		cmp	DX,+6Fh			
		jb	loc_9			; Jump if below ( < )
		nop				; No operation
		nop				; No operation
		cmp	DX,80h			
		jnle	loc_9			; Jump if greater ( > )
		nop				; No operation
		nop				; No operation
		mov	Word Ptr var2_5bf,3	; [74DF:05BF] = 0
		jmp	short loc_10		

		db	90h
loc_9:		; N-Ref=2
		cmp	DX,8Bh			
		jb	loc_6			; Jump if below ( < )
		cmp	DX,offset proc_1	
		jnle	loc_6			; Jump if greater ( > )
		mov	Word Ptr var2_5bf,4	; [74DF:05BF] = 0
loc_10:		; N-Ref=3
		mov	AX,2			
		int	33h			
proc_1		endp



		dw	0C361h

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		PROCEDURE proc_2
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

proc_2		proc	near

		dw	0B860h, 15h, 7EE8h, 0B809h
		dw	16h, 78E8h, 0C709h, 0A106h
		db	5, 1, 0
loc_11:		; N-Ref=1
		mov	BX,offset var2_1	
		mov	SI,offset var2_6f1	
		call	near ptr proc_8		
		mov	BX,2			
		mov	SI,offset var2_78d	
		call	near ptr proc_8		
loc_12:		; N-Ref=1
		call	near ptr loc_notfound	
		mov	DX,95Dh			
		call	near ptr proc_10	
		mov	DX,offset var2_9a1	
		call	near ptr proc_10	
		mov	DX,offset var2_990	
		call	near ptr proc_10	
		mov	SI,offset var2_59b	
		call	near ptr loc_notfound	
		call	near ptr loc_notfound	
		mov	Word Ptr var2_59f,8FFh	; [74DF:059F] = 1FFFh
		call	near ptr loc_notfound	
		cmp	Word Ptr var2_74b,+5	; [74DF:074B] = 0
		je	loc_notfound		; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		cmp	Word Ptr var2_74b,+0	; [74DF:074B] = 0
		je	loc_notfound		; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		cmp	Word Ptr var2_74b,+1	; [74DF:074B] = 0
		je	loc_notfound		; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		cmp	Word Ptr var2_74b,+2	; [74DF:074B] = 0

		dw	840Fh, 167h, 3E83h, 74Bh
		dw	0F03h, 0A084h, 8301h, 4B3Eh
		dw	407h, 840Fh, 1A9h, 3E83h
		dw	7E7h, 0F00h, 2184h, 8301h
		dw	0E73Eh, 107h, 840Fh, 124h
		dw	3E83h, 7E7h, 0F02h, 3A84h
		dw	8301h, 0E73Eh, 307h, 840Fh
		dw	185h, 3E83h, 7E7h, 0F04h
		dw	6A84h, 0BB01h, 1, 0F1BEh
		dw	0E806h, 0BB2h, 6AE9h, 0FFFFh
		dw	0A106h, 0BA05h, 95Dh, 0D9E8h
		dw	0BA0Ch, 9A1h, 0D3E8h, 0BA0Ch
		dw	990h, 0CDE8h, 0BE0Ch, 59Bh
		dw	8DE8h, 0B00Eh, 0E6B6h, 0B843h
		dw	8E9h, 42E6h, 0C48Ah, 42E6h
		dw	61E4h, 0E08Ah, 30Ch, 61E6h
		db	0B9h, 1, 0
loop_loc_13:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_13		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,0A97h		
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_14:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_14		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,6ADh			
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_15:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_15		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,96Fh			
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_16:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_16		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,0BE3h		
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_17:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_17		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,6ADh			
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_18:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_18		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		jmp	loc_11			
proc_2		endp



		dw	2BBh, 0BE00h, 78Dh, 0B5E8h
		dw	0E90Ah, 0FE6Dh, 6FFh, 5A1h
		dw	5DBAh, 0E809h, 0BDCh, 0A1BAh
		dw	0E809h, 0BD6h, 90BAh, 0E809h
		dw	0BD0h, 9BBEh, 0E805h, 0D90h
		dw	3CE9h, 0BAFEh, 9D4h, 0C1E8h
		dw	0BA0Bh, 9C3h, 0BBE8h, 0E80Bh
		dw	0FD9Fh, 3E83h, 5BFh, 7401h
		dw	9020h, 8390h, 0BF3Eh, 205h
		dw	1D74h, 9090h, 3E83h, 5BFh
		dw	0F04h, 2484h, 0C7FEh, 9F06h
		dw	0FF05h, 0E80Fh, 0C2Ah, 2EEBh
		dw	0E890h, 250h, 12E9h, 0E8FEh
		dw	1F7h, 0CE9h, 0BAFEh, 9F6h
		dw	7FE8h, 0C70Bh, 9F06h, 0FF05h
		dw	0E8FFh, 0C0Ch, 10EBh, 0BA90h
		dw	0A08h, 6DE8h, 0C70Bh, 9F06h
		dw	0FF05h, 0E8FFh, 0BFAh, 0C361h

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		PROCEDURE proc_3
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

proc_3		proc	near

		dw	0B860h, 15h, 42E8h, 0B807h
		dw	0, 3CE8h, 0C707h, 0A106h
		db	5, 1, 0
loc_19:		; N-Ref=2
		mov	BX,offset var2_1	
		mov	SI,offset var2_6f1	
		call	near ptr proc_8		
		mov	BX,2			
		mov	SI,offset var2_78d	
		call	near ptr proc_8		
loc_20:		; N-Ref=1
		call	near ptr loc_notfound	
		mov	DX,95Dh			
		call	near ptr proc_10	
		mov	DX,offset var2_9a1	
		call	near ptr proc_10	
		mov	DX,offset var2_97f	
		call	near ptr proc_10	
		mov	SI,offset var2_59b	
		call	near ptr loc_notfound	
		call	near ptr loc_notfound	
		mov	Word Ptr var2_59f,0FFFh	; [74DF:059F] = 1FFFh
		call	near ptr loc_notfound	
		cmp	Word Ptr var2_74b,+0	; [74DF:074B] = 0
		je	loc_notfound		; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		cmp	Word Ptr var2_74b,+1	; [74DF:074B] = 0
		je	loc_notfound		; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		cmp	Word Ptr var2_74b,+2	; [74DF:074B] = 0

		dw	840Fh, 105h, 3E83h, 74Bh
		dw	0F03h, 3E84h, 8301h, 4B3Eh
		dw	407h, 840Fh, 147h, 98EBh
		dw	6FFh, 5A1h, 5DBAh, 0E809h
		dw	0ADDh, 0A1BAh, 0E809h, 0AD7h
		dw	7FBAh, 0E809h, 0AD1h, 9BBEh
		dw	0E805h, 0C91h, 0B6B0h, 43E6h
		dw	0E9B8h, 0E608h, 8A42h, 0E6C4h
		dw	0E442h, 8A61h, 0CE0h, 0E603h
		dw	0B961h, 1
loop_loc_21:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_21		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,0A97h		
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_22:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_22		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,6ADh			
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_23:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_23		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,96Fh			
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_24:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_24		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,0BE3h		
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_25:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_25		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,6ADh			
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_26:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_26		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		jmp	loc_19			
proc_3		endp



		dw	0D4BAh, 0E809h, 9F0h, 0C3BAh
		dw	0E809h, 9EAh, 0CEE8h, 83FBh
		dw	0BF3Eh, 105h, 2074h, 9090h
		dw	3E83h, 5BFh, 7402h, 901Dh
		dw	8390h, 0BF3Eh, 405h, 840Fh
		dw	0FE8Fh, 6C7h, 59Fh, 0FFFh
		dw	59E8h, 0EB0Ah, 902Eh, 26E8h
		dw	0E901h, 0FE7Dh, 0CDE8h, 0E900h
		dw	0FE77h, 0E5BAh, 0E809h, 9AEh
		dw	6C7h, 59Fh, 0FFFFh, 3BE8h
		dw	0EB0Ah, 9010h, 1ABAh, 0E80Ah
		dw	99Ch, 6C7h, 59Fh, 0FFFFh
		db	0E8h
var1_520	db	29h, 0Ah, 61h, 0C3h

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		PROCEDURE proc_4
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

proc_4		proc	near

		dw	0BA60h, 5B1h, 3DB4h, 0B0h
		dw	21CDh, 0BDA3h, 7205h, 9042h
		dw	8B90h, 0BD1Eh, 0B905h, 4
		dw	9BBAh, 0B405h, 0CD3Fh, 8B21h
		dw	0BD1Eh, 0B905h, 54h, 0F1BAh
		dw	0B406h, 0CD3Fh, 8B21h, 0BD1Eh
		dw	0B905h, 54h, 8DBAh, 0B407h
		dw	0CD3Fh, 8B21h, 0BD1Eh, 0B905h
		dw	4, 0A1BAh, 0B405h, 0CD3Fh
		dw	0B421h, 8B3Eh, 0BD1Eh, 0CD05h
		db	21h
loc_27:		; N-Ref=0
proc_4		endp



		dw	0C361h, 0BA60h, 5B1h, 0B9h
		dw	0B400h, 0CD3Ch, 0A321h, 5AFh
		dw	4272h, 9090h, 1E8Bh, 5BDh
		dw	4B9h, 0BA00h, 59Bh, 40B4h
		dw	21CDh, 1E8Bh, 5BDh, 54B9h
		dw	0BA00h, 6F1h, 40B4h, 21CDh
		dw	1E8Bh, 5BDh, 54B9h, 0BA00h
		dw	78Dh, 40B4h, 21CDh, 1E8Bh
		dw	5BDh, 4B9h, 0BA00h, 5A1h
		dw	40B4h, 21CDh, 3EB4h, 1E8Bh
		dw	5BDh, 21CDh, 0C361h

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		PROCEDURE proc_5
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

proc_5		proc	near

		dw	0BA60h, 5A3h, 3DB4h, 0B0h
		dw	21CDh, 0AFA3h, 7205h, 9042h
		dw	8B90h, 0AF1Eh, 0B905h, 4
		dw	9BBAh, 0B405h, 0CD3Fh, 8B21h
		dw	0AF1Eh, 0B905h, 54h, 0F1BAh
		dw	0B406h, 0CD3Fh, 8B21h, 0AF1Eh
		dw	0B905h, 54h, 8DBAh, 0B407h
		dw	0CD3Fh, 8B21h, 0AF1Eh, 0B905h
		dw	4, 0A1BAh, 0B405h, 0CD3Fh
		dw	0B421h, 8B3Eh, 0AF1Eh, 0CD05h
		dw	6121h, 60C3h, 0A3BAh, 0B905h
		dw	0, 3CB4h, 21CDh, 0AFA3h
		dw	7205h, 9042h, 8B90h, 0AF1Eh
		dw	0B905h, 4, 9BBAh, 0B405h
		dw	0CD40h, 8B21h, 0AF1Eh, 0B905h
		dw	54h, 0F1BAh, 0B406h, 0CD40h
		dw	8B21h, 0AF1Eh, 0B905h, 54h
		dw	8DBAh, 0B407h, 0CD40h, 8B21h
		dw	0AF1Eh, 0B905h, 4, 0A1BAh
		dw	0B405h, 0CD40h, 0B421h, 8B3Eh
		dw	0AF1Eh, 0CD05h, 6121h, 60C3h
		dw	0F1BFh, 0BE06h, offset loc_30
		dw	0DDE8h
		dw	0BF06h, 78Dh, 0E9BEh, 0E807h
		dw	6D4h, 91BFh, 0BE05h, 8A9h
		dw	0CBE8h, 8B06h, 8F3Eh, 0BE05h
		dw	829h, 0C1E8h, 0C706h, 4506h
		dw	7, 0C700h, 0E106h, 7
		dw	0BF00h, 0, 0FBE8h, 8305h
		dw	453Eh, 0FF07h, 840Fh, 232h
		dw	2BAh, 0BE00h, 591h, 49A1h
		dw	0E807h, 54Ch, 3E83h, 58Bh
		dw	7501h, 902Dh, 0B890h, 0Bh
		dw	0CEE8h, 0BE03h, 59Bh, 0A7E8h
		dw	0BE09h, 59Bh, 3C83h, 0F67h
		dw	1684h, 0BE02h, 869h, 8FE8h
		dw	0E807h, 8DFh, 91BFh, 0BE05h
		dw	8A9h, 69E8h, 0BF06h, 1
loc_28:		; N-Ref=0
		mov	AX,Word Ptr var2_745	; [74DF:0745] = 0
		mov	SI,offset var2_6f1	
		call	near ptr proc_9		
		mov	AX,Word Ptr var2_589	; [74DF:0589] = 0
		mov	Word Ptr var2_749,AX	; [74DF:0749] = 0
		mov	AX,Word Ptr var2_587	; [74DF:0587] = 0
		mov	Word Ptr var2_747,AX	; [74DF:0747] = 0
		mov	BX,Word Ptr var2_749	; [74DF:0749] = 0
		mov	Word Ptr var2_57d,BX	; [74DF:057D] = 0
		mov	SI,offset loc_30	
		call	near ptr loc_notfound	
		mov	AX,Word Ptr var2_749	; [74DF:0749] = 0
		call	near ptr loc_notfound	
		cmp	Word Ptr var2_58b,+1	; [74DF:058B] = 0
		jne	loc_29			; Jump if not equal ( != )
		nop				; No operation
		nop				; No operation
		mov	AX,offset var2_1	
		call	near ptr proc_6		
		jmp	loc_37			
loc_29:		; N-Ref=1
		mov	DX,offset var2_1	
		mov	SI,offset var2_78d	
		mov	BX,Word Ptr var2_749	; [74DF:0749] = 0
		call	near ptr proc_7		
		cmp	Word Ptr var2_58b,+1	; [74DF:058B] = 0
		jne	loc_30			; Jump if not equal ( != )
		nop				; No operation
		nop				; No operation
		mov	AX,offset var2_1	
		call	near ptr proc_6		
		jmp	loc_37			
loc_30:		; N-Ref=1
		mov	DX,0			
		mov	SI,offset var2_6f1	
		mov	BX,Word Ptr var2_749	; [74DF:0749] = 0
		call	near ptr proc_7		
		cmp	Word Ptr var2_58b,+1	; [74DF:058B] = 0
		jne	loc_31			; Jump if not equal ( != )
		nop				; No operation
		nop				; No operation
		mov	AX,offset var2_1	
		call	near ptr proc_6		
		jmp	loc_37			
loc_31:		; N-Ref=1
		mov	DX,offset var2_1	
		mov	SI,Word Ptr var2_58f	; [74DF:058F] = 0
		mov	BX,Word Ptr var2_749	; [74DF:0749] = 0
		call	near ptr proc_7		
		cmp	Word Ptr var2_58b,+1	; [74DF:058B] = 0
		jne	loc_32			; Jump if not equal ( != )
		nop				; No operation
		nop				; No operation
		mov	AX,offset var2_1	
		call	near ptr proc_6		
		jmp	loc_37			
loc_32:		; N-Ref=1
		mov	BX,Word Ptr var2_747	; [74DF:0747] = 0
		mov	Word Ptr var2_57d,BX	; [74DF:057D] = 0
		mov	SI,869h			
		call	near ptr loc_notfound	
		call	near ptr proc_11	
		mov	SI,offset var2_6f1	
		mov	BX,Word Ptr [SI]	
		cmp	BX,+1Eh			

		dw	840Fh, 11Eh, 9BBEh, 8305h
		dw	3Ch, 840Fh, 150h, 0BFh
		dw	0E800h, 4ECh, 3E83h, 7E1h
		dw	0FFFh, 6E84h, 0BA01h, 2
		dw	91BEh, 0A105h, 7E5h, 3DE8h
		dw	8304h, 8B3Eh, 105h, 2E75h
		dw	9090h, 0CB8h, 0E800h, 2BFh
		dw	9BBEh, 0E805h, 898h, 9BBEh
		dw	8305h, 27Ch, 0F67h, 5184h
		dw	0BE01h, 869h, 7FE8h, 0E806h
		dw	7CFh, 91BFh, 0BE05h, 8A9h
		dw	59E8h, 0BF05h, 1, 0E1A1h
		dw	0BE07h, 78Dh, 0C5E8h, 0A105h
		dw	589h, 0E5A3h, 0A107h, 587h
		dw	0E3A3h, 8B07h, 0E51Eh, 8907h
		dw	7D1Eh, 0BE05h, 7E9h, 4DE8h
		dw	0A106h, 7E5h, 3AE8h, 8304h
		dw	8B3Eh, 105h, 0B75h, 9090h
		dw	2B8h, 0E800h, 261h, 0E3E9h
		db	0
loc_33:		; N-Ref=1
		mov	DX,offset var2_1	
		mov	SI,offset var2_6f1	
		mov	BX,Word Ptr var2_7e5	; [74DF:07E5] = 0
		call	near ptr proc_7		
		cmp	Word Ptr var2_58b,+1	; [74DF:058B] = 0
		jne	loc_34			; Jump if not equal ( != )
		nop				; No operation
		nop				; No operation
		mov	AX,2			
		call	near ptr proc_6		
		jmp	loc_38			
loc_34:		; N-Ref=1
		mov	DX,0			
		mov	SI,offset var2_78d	
		mov	BX,Word Ptr var2_7e5	; [74DF:07E5] = 0
		call	near ptr proc_7		
		cmp	Word Ptr var2_58b,+1	; [74DF:058B] = 0
		jne	loc_35			; Jump if not equal ( != )
		nop				; No operation
		nop				; No operation
		mov	AX,2			
		call	near ptr proc_6		
		jmp	loc_38			
loc_35:		; N-Ref=1
		mov	DX,offset var2_1	
		mov	SI,Word Ptr var2_58f	; [74DF:058F] = 0
		mov	BX,Word Ptr var2_7e5	; [74DF:07E5] = 0
		call	near ptr proc_7		
		cmp	Word Ptr var2_58b,+1	; [74DF:058B] = 0
		jne	loc_36			; Jump if not equal ( != )
		nop				; No operation
		nop				; No operation
		mov	AX,2			
		call	near ptr proc_6		
		jmp	loc_38			
loc_36:		; N-Ref=1
		mov	BX,Word Ptr var2_7e3	; [74DF:07E3] = 0
		mov	Word Ptr var2_57d,BX	; [74DF:057D] = 0
		mov	SI,869h			
		call	near ptr loc_notfound	
		call	near ptr proc_11	
		mov	SI,offset var2_78d	
		mov	BX,Word Ptr [SI]	
		cmp	BX,+1Eh			
		je	loc_notfound		; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		mov	SI,offset var2_59b	
		cmp	Word Ptr [SI+2],+0	

		dw	840Fh, 8Ah, 0DDE9h, 0C7FDh
		dw	4B06h, 107h, 0C700h, 0E706h
		dw	507h, 0E900h, 84h
loc_37:		; N-Ref=4
		mov	Word Ptr var2_74b,0	; [74DF:074B] = 0
		mov	Word Ptr var2_7e7,5	; [74DF:07E7] = 0
		jmp	short loc_39		

		dw	0C790h, 4B06h, 207h, 0C700h
		dw	0E706h, 507h, 0EB00h, 9067h
		dw	6C7h, 74Bh, 3, 6C7h
		dw	7E7h, 5, 58EBh, 0C790h
		dw	4B06h, 407h, 0C700h, 0E706h
		dw	507h, 0EB00h, 9049h, 6C7h
		dw	7E7h, 1, 6C7h, 74Bh
		db	5, 0, 0EBh, 3Ah, 90h
loc_38:		; N-Ref=3
		mov	Word Ptr var2_7e7,0	; [74DF:07E7] = 0
		mov	Word Ptr var2_74b,5	; [74DF:074B] = 0
		jmp	short loc_39		

		dw	0C790h, 0E706h, 207h, 0C700h
		dw	4B06h, 507h, 0EB00h, 901Ch
		dw	6C7h, 7E7h, 3, 6C7h
		dw	74Bh, 5, 0DEBh, 0C790h
		dw	0E706h, 407h, 0C700h, 4B06h
		db	7, 5, 0
loc_39:		; N-Ref=2

		dw	0C361h, 0BF60h, 6F1h, 4DBEh
		dw	0E807h, 3F3h, 91BFh, 0BE05h
		dw	8A9h, 0EAE8h, 8B03h, 8F3Eh
		dw	0BE05h, 829h, 0E0E8h, 0C703h
		db	6, 45h, 7, 0, 0
loc_40:		; N-Ref=1
		mov	DI,0			
		call	near ptr loc_notfound	
		cmp	Word Ptr var2_745,-1	; [74DF:0745] = 0

		dw	840Fh, 0F4h, 0F1BEh, 8B06h
		dw	831Ch, 1EFBh, 840Fh, 0D6h
		dw	2BAh, 0BE00h, 591h, 49A1h
		dw	0E807h, 265h, 3E83h, 58Bh
		dw	7501h, 902Dh, 0B890h, 0Bh
		dw	0E7E8h, 0BE00h, 59Bh, 0C0E8h
		dw	0BE06h, 59Bh, 3C83h, 0F67h
		dw	0C684h, 0BE00h, 869h, 0A8E8h
		dw	0E804h, 5F8h, 91BFh, 0BE05h
		dw	8A9h, 82E8h, 0BF03h, 1
		dw	45A1h, 0BE07h, 6F1h, 0EEE8h
		dw	0A103h, 589h, 49A3h, 0A107h
		dw	587h, 47A3h, 8B07h, 491Eh
		dw	8907h, 7D1Eh, 0BE05h, offset loc_30
		dw	76E8h, 0A104h, 749h, 63E8h
		dw	8302h, 8B3Eh, 105h, 0B75h
		dw	9090h, 1B8h, 0E800h, 8Ah
		db	0EBh, 65h, 90h
loc_41:		; N-Ref=1
		mov	DX,0			
		mov	SI,offset var2_6f1	
		mov	AX,Word Ptr var2_749	; [74DF:0749] = 0
		call	near ptr proc_7		
		cmp	Word Ptr var2_58b,+1	; [74DF:058B] = 0
		jne	loc_42			; Jump if not equal ( != )
		nop				; No operation
		nop				; No operation
		mov	AX,offset var2_1	
		call	near ptr proc_6		
		jmp	short loc_44		

		db	90h
loc_42:		; N-Ref=1
		mov	DX,offset var2_1	
		mov	SI,Word Ptr var2_58f	; [74DF:058F] = 0
		mov	AX,Word Ptr var2_749	; [74DF:0749] = 0
		call	near ptr proc_7		
		cmp	Word Ptr var2_58b,+1	; [74DF:058B] = 0
		jne	loc_43			; Jump if not equal ( != )
		nop				; No operation
		nop				; No operation
		mov	AX,1			
		call	near ptr proc_6		
		jmp	short loc_44		

		db	90h
loc_43:		; N-Ref=1
		mov	BX,Word Ptr var2_747	; [74DF:0747] = 0
		mov	Word Ptr var2_57d,BX	; [74DF:057D] = 0
		mov	SI,869h			
		call	near ptr loc_notfound	
		call	near ptr proc_11	
		mov	SI,offset var2_59b	
		cmp	Word Ptr [SI],+0	
		je	loc_45			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		jmp	loc_40			

		dw	6C7h, 74Bh, 1, 22EBh
		db	90h
loc_44:		; N-Ref=2
		mov	Word Ptr var2_74b,0	; [74DF:074B] = 0
		jmp	short loc_46		

		dw	0C790h, 4B06h, 207h, 0EB00h
		dw	9010h, 6C7h, 74Bh, 3
		db	0EBh, 7, 90h
loc_45:		; N-Ref=1
		mov	Word Ptr var2_74b,4	; [74DF:074B] = 0
loc_46:		; N-Ref=1
proc_5		endp



		dw	0C361h

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		PROCEDURE proc_6
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

proc_6		proc	near

		dw	0BE60h, 59Bh, 13Dh, 7400h
		dw	902Fh, 3D90h, 2, 840Fh
		dw	0A7h, 0B3Dh, 0F00h, 2384h
		dw	3D01h, 0Ch, 840Fh, 126h
		dw	153Dh, 0F00h, 2B84h, 3D01h
		dw	16h, 840Fh, 12Bh, 3Dh
		dw	0F00h, 3384h, 0E901h, 135h
		dw	48Bh, 3Dh, 0F00h, 2C84h
		dw	3D01h, 5, 820Fh, 119h
		dw	52Dh, 8900h, 0B004h, 0E6B6h
		dw	0B843h, 8E9h, 42E6h, 0C48Ah
		dw	42E6h, 61E4h, 0E08Ah, 30Ch
		db	0E6h, 61h, 0B9h, 1, 0
loop_loc_47:		; N-Ref=2
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_47		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,0A97h		
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_48:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_48		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,6ADh			
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_49:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_49		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		jmp	loc_53			

		dw	448Bh, 3D02h, 0, 840Fh
		dw	0AAh, 53Dh, 0F00h, 9E82h
		dw	2D00h, 5, 4489h, 0B002h
		dw	0E6B6h, 0B843h, 8E9h, 42E6h
		dw	0C48Ah, 42E6h, 61E4h, 0E08Ah
		db	0Ch, 3, 0E6h, 61h, 0B9h, 1
		db	0
loop_loc_50:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_50		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,0A97h		
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_51:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_51		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		mov	AL,0B6h			
		out	43h,AL			; 'C'
		mov	AX,6ADh			
		out	42h,AL			; 'B'
		mov	AL,AH			
		out	42h,AL			; 'B'
		in	AL,61h			; 'a'
		mov	AH,AL			
		or	AL,3			
		out	61h,AL			; 'a'
		mov	CX,offset var2_1	
loop_loc_52:		; N-Ref=1
		push	CX			
		call	near ptr proc_12	
		pop	CX			
		loop	loop_loc_52		; Loop if CX > 0
		mov	AL,AH			
		out	61h,AL			; 'a'
		jmp	short loc_53		

		dw	8B90h, 504h, 1, 489h
		dw	28EBh, 8B90h, 244h, 105h
		dw	8900h, 244h, 1CEBh, 0C790h
		dw	604h, 0EB00h, 9015h, 44C7h
		dw	602h, 0EB00h, 900Dh, 4C7h
		dw	0, 6EBh, 0C790h, 244h
		dw	0
loc_53:		; N-Ref=2
proc_6		endp



		dw	0C361h

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		PROCEDURE proc_7
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

proc_7		proc	near

		dw	0C760h, 8B06h, 105h, 8B00h
		dw	830Ch, 0F9h, 2474h, 9090h
		dw	0C683h, 8304h, 1FAh, 0D74h
		dw	9090h, 0FA83h, 7402h, 901Ch
		db	90h, 49h, 83h, 0C6h, 2
loop_loc_54:		; N-Ref=1
		mov	BX,Word Ptr [SI]	
		cmp	AX,BX			
		je	loc_56			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		add	SI,+2			
		loop	loop_loc_54		; Loop if CX > 0
		mov	Word Ptr var2_58b,0	; [74DF:058B] = 0
		jmp	short loc_56		

		dw	8B90h, 3B1Ch, 74C3h, 9011h
		dw	8990h, 7D1Eh, 8B05h, 25Ch
		dw	0C33Bh, 0B74h, 9090h, 0E0EBh
loc_55:		; N-Ref=1
		mov	BX,Word Ptr [SI+2]	
		mov	Word Ptr var2_57d,BX	; [74DF:057D] = 0
loc_56:		; N-Ref=2

		dw	0C361h, 0C760h, 8B06h, 105h
		dw	3D00h, 1Ch, 3176h, 9090h
		dw	0B83Dh, 7302h, 902Ah, 0B990h
		db	17h, 0, 0BBh, 1Dh, 0
loop_loc_57:		; N-Ref=1
		cmp	AX,BX			
		je	loc_59			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		add	BX,+1Dh			
		loop	loop_loc_57		; Loop if CX > 0
		mov	CX,17h			
		mov	BX,39h			
loop_loc_58:		; N-Ref=1
		cmp	AX,BX			
		je	loc_59			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		add	BX,+1Dh			
		loop	loop_loc_58		; Loop if CX > 0
		mov	Word Ptr var2_58b,0	; [74DF:058B] = 0
loc_59:		; N-Ref=2

		dw	0C361h, 0B460h, 0CD11h, 7516h
		dw	9005h, 0E990h, 0A6h, 10B4h
		dw	16CDh, 773Dh, 7411h, 9049h
		db	90h
var1_cbc	db	'=d tK'
		db	90h, 90h, 3Dh, 73h, 1Fh, 74h
		db	4Dh, 90h, 90h, 3Dh, 61h, 1Eh
		db	74h, 4Fh, 90h, 90h, 3Dh, 70h
		db	19h, 74h, 51h, 90h, 90h
var1_cd8	db	'=''(tS'
		db	90h, 90h
var1_cdf	db	'=;''tU'
		db	90h, 90h
var1_ce6	db	'=l&tW'
		db	90h, 90h, 3Dh, 1Bh, 1, 74h
		db	59h, 90h, 90h, 0C7h, 6, 0E1h
		db	7, 0, 0, 0C7h, 6, 45h
		db	7, 0, 0, 0EBh, 55h, 90h
loc_60:		; N-Ref=1
		mov	Word Ptr var2_745,0AAAAh; [74DF:0745] = 0
		jmp	short loc_65		

		dw	0C790h, 4506h, 0BB07h, 0EBBBh
		dw	9043h
loc_61:		; N-Ref=0
		mov	Word Ptr var2_745,0CCCCh; [74DF:0745] = 0
		jmp	short loc_65		

		dw	0C790h, 4506h, 0DD07h, 0EBDDh
		dw	9031h
loc_62:		; N-Ref=0
		mov	Word Ptr var2_7e1,0AAAAh; [74DF:07E1] = 0
		jmp	short loc_65		

		dw	0C790h, 0E106h, 0BB07h, 0EBBBh
		dw	901Fh
loc_63:		; N-Ref=0
		mov	Word Ptr var2_7e1,0CCCCh; [74DF:07E1] = 0
		jmp	short loc_65		

		dw	0C790h, 0E106h, 0DD07h, 0EBDDh
		dw	900Dh
loc_64:		; N-Ref=0
		mov	Word Ptr var2_7e1,0FFFFh; [74DF:07E1] = 0
		mov	Word Ptr var2_745,0FFFFh; [74DF:0745] = 0
loc_65:		; N-Ref=8
proc_7		endp



		dw	0C361h, 8B60h, 830Dh, 0F9h
		dw	1E74h, 9090h, 0F983h, 74FFh
		dw	9017h, 8390h, 4C7h, 58Bh
		dw	89A3h, 8B05h, 0A305h, 57Dh
		dw	0F9E8h, 8300h, 2C7h, 0F3E2h
		dw	0C361h

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		PROCEDURE proc_8
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

proc_8		proc	near

		dw	8360h, 0FF3Ch, 774h, 9090h
		dw	0C8Bh, 4EBh, 0B990h, 2
		dw	4C7h, 2, 0C683h, 8302h
		dw	1FBh, 1775h, 9090h, 4C7h
		dw	0BBBBh, 0C683h, 0C702h, 5A04h
		dw	8300h, 2C6h, 4C7h, 59h
		db	0EBh, 13h, 90h
loc_66:		; N-Ref=2
		mov	Word Ptr [SI],0DDDDh	
		add	SI,+2			
		mov	Word Ptr [SI],27Ah	
		add	SI,+2			
		mov	Word Ptr [SI],27Bh	
		add	SI,+2			
		mov	Word Ptr [SI],0FFFFh	
		loop	loc_notfound		; Loop if CX > 0
proc_8		endp



		dw	0C361h

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		PROCEDURE proc_9
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

proc_9		proc	near

		dw	8B60h, 830Ch, 2C6h, 148Bh
		dw	0C683h, 8B02h, 831Ch, 1FFh
		dw	0A75h, 9090h, 4483h, 1FCh
		dw	0EB41h, 900Ah, 3Dh, 7500h
		db	4, 90h, 90h
loc_67:		; N-Ref=10
		mov	AX,DX			
		cmp	AX,0AAAAh		
		je	loc_68			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		cmp	AX,0BBBBh		
		je	loc_69			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		cmp	AX,0CCCCh		
		je	loc_70			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		cmp	AX,0DDDDh		
		je	loc_71			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		jmp	short loc_67		
loc_68:		; N-Ref=1
		cmp	DX,0CCCCh		
		je	loc_67			; Jump if equal ( = )
		mov	Word Ptr [SI-2],AX	
		mov	DX,BX			
		sub	DX,+1Dh			
		mov	Word Ptr [SI],DX	
		jmp	short loc_72		

		db	90h
loc_69:		; N-Ref=1
		cmp	DX,0DDDDh		
		je	loc_67			; Jump if equal ( = )
		mov	Word Ptr [SI-2],AX	
		mov	DX,BX			
		add	DX,+1			
		mov	Word Ptr [SI],DX	
		jmp	short loc_72		

		db	90h
loc_70:		; N-Ref=1
		cmp	DX,0AAAAh		
		je	loc_67			; Jump if equal ( = )
		mov	Word Ptr [SI-2],AX	
		mov	DX,BX			
		add	DX,+1Dh			
		mov	Word Ptr [SI],DX	
		jmp	short loc_72		

		db	90h
loc_71:		; N-Ref=1
		cmp	DX,0BBBBh		
		je	loc_67			; Jump if equal ( = )
		mov	Word Ptr [SI-2],AX	
		mov	DX,BX			
		sub	DX,+1			
		mov	Word Ptr [SI],DX	
loc_72:		; N-Ref=3
		mov	Word Ptr var2_589,DX	; [74DF:0589] = 0
		dec	CX			
		add	SI,+2			
		mov	AX,Word Ptr [SI]	
		mov	Word Ptr [SI],BX	
		mov	BX,AX			
		loop	loc_notfound		; Loop if CX > 0
		mov	Word Ptr var2_587,BX	; [74DF:0587] = 0
proc_9		endp



		dw	0C361h, 0A160h, 57Dh, 0D22Bh
		dw	36F7h, 585h, 26F6h, 583h
		dw	105h, 0A300h, 581h, 0C28Bh
		dw	26F6h, 584h, 7FA3h, 0BF05h
		dw	8, 0E8Bh, 57Fh, 8BBh
		dw	8B00h, 8116h, 0B405h, 8A0Ch
		dw	4604h, 10CDh, 4B42h, 0FB83h
		dw	7500h, 41F2h, 834Fh, 0FFh
		dw	0E475h, 0C361h

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		PROCEDURE proc_10
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

proc_10		proc	near
		push	AX			
		push	BX			
		push	CX			
		push	DX			
		push	DI			
		push	SI			
		mov	AL,2			
		mov	AH,3Dh			; '='
		int	21h			; DOS func ( ah ) = 3Dh
						; Open file
						;CX-acsess code
						;  DS:DX-ASCIIZ string
						;AX-file handle
						; if CF=1 AX-error code
		mov	BX,AX			
		mov	AH,3Fh			; '?'
		mov	CX,36h			
		mov	DX,offset var2_1	
		int	21h			; DOS func ( ah ) = 3Fh
						; Read from file or device
						;BX-file handle
						; CX-bytes to read  DS:DX-DTA
						;if CF=0 AX-bytes read
						; else AX-ret code
		mov	AX,Word Ptr var2_b	; [74DF:000B] = 4848h
		sub	AX,36h			

		dw	0E8C1h, 0A302h, 577h, 3FB4h
		dw	0E8Bh, 577h, 0E1C1h, 0BA02h
		dw	37h, 21CDh, 37BEh, 8B00h
		dw	770Eh, 0BA05h, 3C8h, 0B0h
		dw	42EEh, 448Ah, 0C002h, 2E8h
		dw	8AEEh, 144h, 0E8C0h, 0EE02h
		dw	48Ah, 0E8C0h, 0EE02h, 0C683h
		dw	0E204h, 0B9E7h, 0C8h
loop_loc_73:		; N-Ref=1
		push	CX			
		mov	DI,CX			

		dw	0E1C1h, 0C106h, 8E7h, 0F903h
		dw	3FB4h, 40B9h, 0BA01h, 437h
		dw	21CDh, 40B9h, 0BE01h, 437h
loop_loc_74:		; N-Ref=2
		mov	AL,Byte Ptr [SI]	
		cmp	AL,0FDh			
		je	loc_75			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		mov	AL,Byte Ptr [SI]	
		mov	Byte Ptr ES:[DI],AL	
loc_75:		; N-Ref=1
		inc	SI			
		inc	DI			
		loop	loop_loc_74		; Loop if CX > 0
		pop	CX			
		loop	loop_loc_73		; Loop if CX > 0
		mov	AH,3Eh			; '>'
		int	21h			; DOS func ( ah ) = 3Eh
						; Close file handle
						;BX-file handle
						;if CF=1 AX-ret code
		pop	SI			
		pop	DI			
		pop	DX			
		pop	CX			
		pop	BX			
		pop	AX			
		retn				
proc_10		endp



;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		PROCEDURE proc_11
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

proc_11		proc	near

		dw	0BB60h, 0FFFFh, 168Bh, 59Fh
		dw	754Ah, 4BFDh, 0F675h, 0C361h
		db	1Eh
var1_f5c	db	'PSQ'
		db	0B8h, 40h, 0, 8Eh, 0D8h, 0BBh
		db	6Ch, 0, 8Bh, 7, 0BBh
var1_f6a	dw	DATA_SEG_2
		dw	0DB8Eh, 0EDBBh, 8308h, 2C3h
		db	0B9h, 37h, 0
loop_loc_76:		; N-Ref=1
		add	Word Ptr [BX],AX	
		add	BX,+2			
		loop	loop_loc_76		; Loop if CX > 0
		pop	CX			
		pop	BX			
		pop	AX			
		pop	DS			

;ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
		assume  DS:nothing
;ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ

		retn				
proc_11		endp



		dw	5153h, 1E8Bh, 8E9h, 8F8Bh
		dw	8EDh, 1E8Bh, 8EBh, 878Bh
		dw	8EDh, 0C103h, 8789h, 8EDh
		dw	2E83h, 8E9h, 8302h, 0EB2Eh
		dw	208h, 3E83h, 8E9h, 7500h
		dw	9008h, 0C790h, 0E906h, 6E08h
		dw	8300h, 0EB3Eh, 8, 875h
		dw	9090h, 6C7h, 8EBh, 6Eh
loc_77:		; N-Ref=1
		pop	CX			
		pop	BX			
		retn				

		dw	0BE60h, 591h, 4C7h, 2
		dw	0C683h, 5604h, 86E8h, 0E8FFh
		dw	0FFABh, 0D22Bh, 0B8BBh, 0F702h
		dw	8BF3h, 0E8C2h, 0FC82h, 3E83h
		dw	58Bh, 7401h, 0BAEAh, 1
		dw	368Bh, 58Fh, 0D88Bh, 14E8h
		dw	83FCh, 8B3Eh, 105h, 0D774h
		dw	1BAh, 0BE00h, 6F1h, 0D88Bh
		dw	2E8h, 83FCh, 8B3Eh, 105h
		dw	0C574h, 1BAh, 0BE00h, 78Dh
		dw	0D88Bh, 0F0E8h, 83FBh, 8B3Eh
		dw	105h, 0B374h, 895Eh, 8304h
		dw	2C6h, 0E856h, 0FF57h, 0D22Bh
		dw	0B8BBh, 0F702h, 8BF3h, 0E8C2h
		dw	0FC2Eh, 3E83h, 58Bh, 7401h
		dw	0BAEAh, 1, 368Bh, 58Fh
		dw	0D88Bh, 0C0E8h, 83FBh, 8B3Eh
		dw	105h, 0D774h, 1BAh, 0BE00h
		dw	6F1h, 0D88Bh, 0AEE8h, 83FBh
		dw	8B3Eh, 105h, 0C574h, 1BAh
		dw	0BE00h, 78Dh, 0D88Bh, 9CE8h
		dw	83FBh, 8B3Eh, 105h, 0B374h
		dw	895Eh, 6104h, 60C3h, 0CB4h
		dw	0F9B0h, 3C83h, 7400h, 9020h
		dw	0B990h, 10Ah, 9DBAh, 8B00h
		db	3Ch
loc_78:		; N-Ref=1
		mov	BX,14h			
		mov	CX,10Ah			
loc_79:		; N-Ref=1
		int	10h			; BIOS Service func ( ah ) = 0FFFFh
						; Screen function
		dec	BX			
		dec	CX			
		cmp	BX,+0			
		jne	loc_79			; Jump if not equal ( != )
		dec	DX			
		dec	DI			
		cmp	DI,+0			
		jne	loc_78			; Jump if not equal ( != )
		add	SI,+2			
		cmp	Word Ptr [SI],+0	
		je	loc_82			; Jump if equal ( = )
		nop				; No operation
		nop				; No operation
		mov	AH,0Ch			
		mov	CX,12Bh			
		mov	DX,9Dh			
		mov	DI,Word Ptr [SI]	
loc_80:		; N-Ref=2
		mov	BX,14h			
		mov	CX,12Bh			
loc_81:		; N-Ref=1
		int	10h			; BIOS Service func ( ah ) = 0Ch
						; Write pixel dot
						;AL-color CX-pixel column
						; DL-pixel row
		dec	BX			
		dec	CX			
		cmp	BX,+0			
		jne	loc_81			; Jump if not equal ( != )
		dec	DX			
		dec	DI			
		cmp	DI,+0			
		jne	loc_80			; Jump if not equal ( != )
loc_82:		; N-Ref=1

		dw	0C361h, 8360h, 0A13Eh, 105h
		dw	2C74h, 9090h, 3E83h, 5A1h
		dw	7402h, 9029h, 8390h, 0A13Eh
		dw	305h, 2674h, 9090h, 3E83h
		dw	5A1h, 7404h, 9023h, 8390h
		dw	0A13Eh, 505h, 2074h, 9090h
		dw	6C7h, 5A1h, 1, 0C1BEh
		dw	0EB05h, 9019h, 0C5BEh, 0EB05h
		dw	9013h, 9BEh, 0EB06h, 900Dh
loc_83:		; N-Ref=0
		mov	SI,63Dh			
		jmp	short loc_84		

		db	90h, 0BEh, 93h, 6, 0EBh, 1
		db	90h
loc_84:		; N-Ref=7
		mov	Word Ptr DS:data_58f,SI	

		dw	0C361h

;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
;±
;±		PROCEDURE proc_12
;±
;±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

proc_12		proc	near
proc_12		endp



		dw	0B9h, 0E480h, 2461h, 3A10h
		dw	74C4h, 8AF8h, 0E2E0h, 61F4h
		dw	0C3h
		db	4 dup (0)
CODE_SEG_1	ends


;ÄÄÄÄÄÄÄÄÄÄ DATA_SEG_2  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

DATA_SEG_2	segment para public
		assume  CS:DATA_SEG_2, DS:DATA_SEG_2, SS:STACK_SEG_3, ES:nothing

var2_0		db	0
var2_1		db	10 dup (48h)
var2_b		dw	22 dup (4848h)
		dw	15 dup (5050h)
var2_55		db	994 dup (50h)
		db	326 dup (0)
var2_57d	db	6 dup (0)
		dw	808h, 1Dh
var2_587	dw	0
var2_589	dw	0
var2_58b	db	4 dup (0)
var2_58f	dw	0
		dw	5 dup (0FFFFh)
var2_59b	dw	0
var2_59d	dw	0
var2_59f	dw	1FFFh
var2_5a1	dw	0
var2_5a3	db	53h, 61h
var2_5a5	dw	6576h
var2_5a7	dw	6E4Fh
var2_5a9	dw	2E65h
var2_5ab	db	'sav'
		db	0, 0, 0
var2_5b1	db	'SaveTwo.sav'
		db	0, 0, 0
var2_5bf	db	4 dup (0)
		dw	0FFFFh, 20h, 0FFFFh, 0B4h
		dw	0B5h, 0B6h, 0B7h, 0B8h
		dw	0C0h, 0C1h, 0C2h, 0C3h
		dw	0C4h, 0D1h, 0EEh, 10Bh
		dw	0E1h, 0FEh, 11Bh, 1B9h
		dw	1D6h, 1F3h, 1C9h, 1E6h
		dw	203h, 210h, 211h, 212h
		dw	213h, 214h, 21Ch, 21Dh
		dw	21Eh, 21Fh, 220h, 18h
		dw	0FFFFh, 96h, 0B4h, 0D2h
		dw	0F0h, 10Eh, 12Ch, 0A8h
		dw	0C4h, 0E0h, 0FCh, 118h
		dw	134h, 22Ch, 210h, 1F4h
		dw	1D8h, 1BCh, 1A0h, 1A8h
		dw	1C6h, 1E4h, 202h, 220h
		dw	23Eh, 29h, 0FFFFh, 0B4h
		dw	0B5h, 0B6h, 0B7h, 0B8h
		dw	0C0h, 0C1h, 0C2h, 0C3h
		dw	0C4h, 0D1h, 0EEh, 10Bh
		dw	0E1h, 0FEh, 11Bh, 1B9h
		dw	1D6h, 1F3h, 1C9h, 1E6h
		dw	203h, 210h, 211h, 212h
		dw	213h, 214h, 21Ch, 21Dh
		dw	21Eh, 21Fh, 220h, 78h
		dw	96h, 0A8h, 8Ch, 23Eh
		dw	25Ch, 16Ah, 22Ch, 248h
		dw	2Dh, 0FFFFh, 0B4h, 0B5h
		dw	0B6h, 0B7h, 0B8h, 0C0h
		dw	0C1h, 0C2h, 0C3h, 0C4h
		dw	0D1h, 0EEh, 10Bh, 0E1h
		dw	0FEh, 11Bh, 1B9h, 1D6h
		dw	1F3h, 1C9h, 1E6h, 203h
		dw	210h, 211h, 212h, 213h
		dw	214h, 21Ch, 21Dh, 21Eh
		dw	21Fh, 220h, 113h, 130h
		dw	14Dh, 167h, 168h, 169h
		dw	16Ah, 16Bh, 16Ch, 16Dh
		dw	187h, 1A4h, 1C1h
var2_6f1	dw	42 dup (0FFFFh)
var2_745	dw	0
var2_747	dw	0
var2_749	dw	0
var2_74b	dw	0
		dw	4 dup (101h)
		dw	0F901h
		db	5 dup (0F9h)
		dw	101h, 8F9h, 808h, 0F908h
		dw	101h, 8F9h, 404h, 0F908h
		dw	101h, 8F9h, 404h, 0F908h
		dw	101h, 8F9h, 808h, 0F908h
		dw	101h
		db	6 dup (0F9h)
		dw	4 dup (101h)
		db	1
var2_78d	dw	42 dup (0FFFFh)
var2_7e1	dw	0
var2_7e3	dw	0
var2_7e5	dw	0
var2_7e7	dw	0
var2_7e9	db	9 dup (0Ah)
		db	6 dup (32h)
		db	0Ah, 0Ah
		db	'2PPPP2'
		db	0Ah, 0Ah
		db	'2PnnP2'
		db	0Ah, 0Ah
		db	'2PnnP2'
		db	0Ah, 0Ah
		db	'2PPPP2'
		db	0Ah, 0Ah
		db	6 dup (32h)
		db	9 dup (0Ah)
		db	9 dup (6)
		db	6 dup (1)
		db	6, 6, 1
		db	4 dup (8)
		db	1, 6, 6, 1, 8, 6
		db	6, 8, 1, 6, 6, 1
		db	8, 6, 6, 8, 1, 6
		db	6, 1
		db	4 dup (8)
		db	1, 6, 6
		db	6 dup (1)
		db	9 dup (6)
		db	66 dup (0FAh)
		db	0F9h, 0F9h
		db	5 dup (0FAh)
		db	4 dup (0F9h)
		db	0FAh, 0FAh, 0FAh
		db	6 dup (0F9h)
		db	0FAh, 0FAh, 0FAh
		db	6 dup (0F9h)
		db	0FAh, 0FAh
		db	6 dup (0F9h)
		db	0FAh
		db	6 dup (0F9h)
		db	0FAh, 0FAh, 0FAh
		db	4 dup (0F9h)
		db	5 dup (0FAh)
		db	0F9h, 0F9h
		db	4 dup (0FAh)
		db	30h, 0, 6Eh, 0, 0, 0
		db	10h, 1Fh, 0E0h, 0A6h, 6Dh, 0DEh
		db	0D1h, 0BAh, 81h, 0CCh, 0DDh, 12h
		db	85h
var2_8fc	db	'}[tt'
		db	1Bh, 54h, 0F3h, 30h, 0B4h, 28h
		db	88h, 9Eh, 0F8h, 28h, 52h, 0C4h
		db	0F4h, 3Ch, 0EFh, 0F1h, 88h, 7Dh
		db	90h, 0D5h, 0ABh, 0DBh, 0B3h, 0A3h
		db	0BDh, 0B8h, 0AAh, 35h, 74h, 8Ah
var2_91e	db	'U''(|'
		db	0BCh, 0FAh, 8Ah, 0Ch, 6Dh, 31h
		db	0Eh, 0ADh, 0C4h, 77h, 83h, 65h
		db	90h, 0B6h, 0BDh, 6Fh, 0A9h, 40h
		db	3Bh, 0D9h, 76h, 0E9h
var2_938	db	' ''|)'
		db	0Eh, 0EDh, 5Ch, 3Eh, 92h, 77h
		db	0FDh
var2_943	db	'GJd'
		db	0A8h, 69h, 0F0h, 45h, 61h, 0EDh
		db	0E3h, 42h, 0CCh, 5Fh, 0F2h, 0B5h
		db	52h, 0AFh, 69h, 0CBh, 6Ch, 53h
		db	0BBh
var2_959	db	')8b8Picture\pic1.BMP'
		db	0
var2_96e	db	'Picture\pic2.BMP'
		db	0
var2_97f	db	'Picture\pic3.BMP'
		db	0
var2_990	db	'Picture\pic4.BMP'
		db	0
var2_9a1	db	'Picture\pic5.BMP'
		db	0
var2_9b2	db	'Picture\pic6.BMP'
		db	0
var2_9c3	db	'Picture\pic7.BMP'
		db	0
var2_9d4	db	'Picture\pic8.BMP'
		db	0
var2_9e5	db	'Picture\pic9.BMP'
		db	0
var2_9f6	db	'Picture\pic10.BMP'
		db	0
var2_a08	db	'Picture\pic11.BMP'
		db	0
var2_a1a	db	'Picture\pic12.BMP'
		db	0
var2_a2c	db	'Picture\pic13.BMP'
		db	0
var2_a3e	db	'Picture\pic14.BMP'
		db	0
var2_a50	db	'Picture\pic15.BMP'
		db	0
		db	14 dup (?)

DATA_SEG_2	ends


;ÄÄÄÄÄÄÄÄÄÄ STACK_SEG_3  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

STACK_SEG_3	segment stack
		assume  CS:STACK_SEG_3, DS:STACK_SEG_3, SS:STACK_SEG_3, ES:nothing

		db	1024 dup (?)

STACK_SEG_3	ends



		end	start

