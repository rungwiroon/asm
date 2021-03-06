;ROUTINE TO GET	FILE SPECIFIER
;
getspec	      proc	far
;
	      push	ds
	      push	es
	      push	si
	      push	di
	      push	cx
;
;set up	pointer	to get parameters
	      lds	si,dta	  ;point to dta	for parameters
	      mov	cl,[si]	  ;get length of string
	      mov	ch,0	  ;make	16-bit
	      inc	si	  ;skip	the length byte
;scan past the spaces
	      mov	al,' '	  ;skip	spaces
getspec1:     cmp	[si],al	  ;check for space
	      jne	getspec2  ;exit	the loop if nonsapce
	      inc	si	  ;otherwise point to next byte
	      loop	getspec1  ;loop	back for more
	      jcxz	getspec3  ;no file specifier?
;
;move the rest into place
getspec2:
	      mov	di,dx	  ;index points	to destination
	      cld		  ;forward direction
	      rep	movsb	  ;make	the transfer
	      clc		  ;no error so no carry
	      jmp	getspecexit ; and return
;
getspec3:
	      mov	ax,20	  ;no file specified
	      stc		  ;set carry for error
	      jmp	getspecexit  ;and exit
;
getspecexit:
	      pop	cx	  ;save	registers
	      pop	di
	      pop	si
	      pop	es
	      pop	ds
	      ret
;
getspec	      end
                