  lab3 segment
	assume cs:lab3,ds:lab3
	org     100h
	jmp     start
	msgi  db      '[.......EXIT PROGRAM.....]$'
		
start:
	mov     ah,09h
	lea     dx,msgi
	int     21h
	
	call    sound

	int       20h

;/////////////////////////////////////////////
    ;sub program sound
;/////////////////////////////////////////////
sound proc near
	IN 	AL,61
	OR	AL,03
	OUT	61,AL
	IN	AL,61
	OUT	61,AL
    ret
sound endp
;==========================================

lab3    ends
end     main1
