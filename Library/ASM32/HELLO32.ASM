; HELLO32.ASM - a simple ASM32 demonstration program

include	model.inc

public	main32			; this is the main code, called by START_DP

include	dataseg.inc
hello	db 'Hello from 32-bit P-mode',0Dh,0Ah,'$'
@curseg	ends

include	codeseg.inc

main32	proc	near

; use ordinary DOS function to print string on screen

	lea	edx,hello
	mov	ah,9
	int	21h

; return to startup/exit code
	ret

main32	endp

@curseg	ends
	end
