;
; Program for password protection of the system
;	Written by Dave Staehlin
;	5430 Candleglow NE
;	Albuquerque,NM 87111
;	(505) 822-1889
;
; Enter the password desired at the 'psw' label.  Note that this routine
; is set up for a 20 character maximum length password.
;
; Use this program by entering your password below and assembling this 
; program into a .COM type file by using EXE2BIN.  Then place the command
; PASSWORD as the first line in your AUTOEXEC.BAT file.  This program
; will not keep anyone that knows what their doing off your system but
; it will keep the kids, wifey, and nosey secretaries from gaining
; unauthorized access to your system.  It serves its purpose on a hard
; disk system.  I don't know how useful it would be on a floppy based system
; however.
;
; Since this is my first attempt at 8088 assembler, I assume no responsibility
; for my oddball way of coding this!  I've still got a lot to learn!
;
;							Dave
;
;
password	segment				;set up code and data section
		assume	cs:password,ds:password,es:password ;tell assembler about conditions at entry
		org	100h			;com programs begin here
main:		jmp	begin			;skip area for data
;
;	*** DATA AREA ***
;
;  *** Put your password between the quotes in the line below. ***
;
psw		db	'Put Password Here   '	;room for 20 byte password
;
inpsw		db	'                    '	;store user input password here
prompt		db	1bh,'[2J',1bh,'[32;40mPlease enter system password: $'
match		db	13,10,10,1bh,'[2JPassword Accepted - Initializing system.....',13,10,'$'
;
;	*** PROGRAM STARTS HERE ***
begin:		mov	dx,offset prompt	;output the prompt to the consol
		call	stringout
		mov	cl,20			;maximum length of password
		mov	bx,offset inpsw		;put input password here
inloop:		call	charin			;consol input w/o echo
		cmp	al,08h			;backspace?
		jnz	goon			;go on if not
		cmp	cl,20			;at the beginning?
		jz	inloop			;ignore if so
		inc	cl			;else increment the counter
		dec	bx			;and decrement the memory pointer
		mov	al,' '
		mov	[bx],al			;erase last char in input string
		call	backspc			;output a backspace to console
		jmp 	inloop
;
;
goon:		cmp	al,0dh			;carriage return?
		jz	checkit			;done with input if so
		dec	cl			;count one input done
		jz	checkit			;done if 20 chars input
		mov	[bx],al			;else save the char
		inc	bx			;increment save address by one
echo:		mov	dl,'.'			;output a period echo
		call	charout
		jmp	inloop			;and get another
;
checkit:	mov	cx,20			;set up counter for string compare
		mov	dx,offset match		;assume a match
		mov	si,offset psw		;compare the strings
		mov	di,offset inpsw
		cld				;clear the df flag for compare
		repe	cmpsb
		cmp	cx,0			;did cl reach zero?
		jz	gotmatch		;if they match
		jmp	inloop			;oops - bomb system
;
;	we have a match - return system to the user
;
gotmatch:	mov	ah,9			
		int	21h	
		ret				;return to system
;
; subroutines
;
stringout:	mov	ah,9			;output a string to the console
		int	21h
		ret
charout:	mov	ah,2			;output a character to the console
		int	21h
		ret
charin:		mov	ah,7			;input console char w/o echo
		int	21h
		ret
backspc:	mov	dl,08h			;output a backspace
		call	charout
		mov	dl,' '			;output a backspace
		call	charout
		mov	dl,08h			;output a backspace
		call	charout
		ret
;
password	ends				;end of code and data section
		end	main
