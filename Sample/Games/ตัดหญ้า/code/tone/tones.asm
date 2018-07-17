;PROGRAM TONES ASM: PLAY a simple sequence of tones on PC's speaker.

.MODEL SMALL
.STACK 100H
.DATA
;Note: Output frequency equals
;1.19 Mhz/counter-value (divisor)	
;divisor duration
TONES	DW	4548,10000	;1st tone,freq: 1KHz, duration: 25000
		DW	200,1		;pause
		DW	4293,10000	;2nd tone, freq: 119 Hz, longer duration (5000)
		DW	200,1		;pause
		DW	4052,10000	;3rd tone, freq: 60 Hz, 3rd longest duration
		DW	200,1		;pause
		DW	3824,10000	;4th tone,freq: 29 Hz, longest duration
		DW	200,1		;pause
		DW	3610,10000	;5th tone, freq: 5 KHz, medium duration
		DW	200,1		;pause
		DW	3407,10000	;4th tone,freq: 29 Hz, longest duration
		DW	200,1		;pause
		DW	3216,10000	;4th tone,freq: 29 Hz, longest duration
		DW	200,1		;pause
		DW	3035,10000	;4th tone,freq: 29 Hz, longest duration
		DW	200,1		;pause
		DW	2865,10000	;4th tone,freq: 29 Hz, longest duration
		DW	200,1		;pause
		DW	2704,10000	;4th tone,freq: 29 Hz, longest duration
		DW	200,1		;pause
		DW	2552,10000	;4th tone,freq: 29 Hz, longest duration
		DW	200,1		;pause
		DW	2409,10000	;4th tone,freq: 29 Hz, longest duration
		DW	200,1		;pause
		DW	2274,10000	;4th tone,freq: 29 Hz, longest duration
		DW	0			;end-of-tone word
		
.CODE

MAIN	PROC

		MOV	AX,@DATA
		MOV	DS,AX
		
		MOV		SI,0
NEXT:	MOV		CX,TONES[SI]	;set up pointer to tones table
		CMP		CX,0			;read frequency division value
		JZ		EXIT			
		MOV		DX,TONES[SI+2]	;else, read duration value
		ADD		SI,4			;point to next divisor/duration pair
		CMP		DX,1			;if duration = 1 we pause
		JZ		PAUSE
		CALL	SPKRON			;turn speaker on
		CALL	LDTIMER			;set speaker frequency
		CALL	DELAY			;wait for chosen duration
		CALL	SPKROFF			;turn speaker off
		JMP		NEXT			;go load next divisor/duration pair
		
PAUSE:	MOV		DX,CX			
PAUSE2:	MOV		CX,50000		;pause is a multiple of 50000 ticks
TICK:	LOOP	TICK			
		DEC		DX				;decrement pause counter
		JNZ		PAUSE2			;until it is 0
		JMP		NEXT			;go load jnext divisor/duration pair

EXIT:	MOV	AH,4CH
		INT	21H
		
MAIN	ENDP
		
;==================================================================
;
;==================================================================		
SPKRON	PROC	NEAR
		IN		AL,61H			;read current state of port 61h
		OR		AL,3			;set speaker control bits
		OUT		61H,AL			;output new state
		RET
SPKRON	ENDP

SPKROFF	PROC	NEAR
		IN		AL,61H			;read current state of port 61h
		AND		AL,0FCH			;clear speaker control bits
		OUT		61H,AL			;output new state
		RET
SPKROFF	ENDP

DELAY	PROC	NEAR
WAIT1:	MOV		CX,50000		;a sunple 500-loop delay
WAIT2:	LOOP	WAIT2
		DEC		DX				;give another 500-loop delay
		JNZ		WAIT1			;unlese dx went to zero
		RET
DELAY	ENDP

LDTIMER	PROC	NEAR
		MOV		AL,0B6H			;timer 2 control word
		OUT		43H,AL
		MOV		AL,CL			;output lower byte of count
		OUT		42H,AL
		MOV		AL,CH			;output upper byte of count
		OUT		42H,AL
		RET
LDTIMER	ENDP
		END
		
		
		
