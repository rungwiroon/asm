    OUTDEX  PROC
    ;prints AX as a signed decimal integer
    ;input: AX
    ;output: none
            PUSH    AX              ;save registers
            PUSH    BX
            PUSH    CX
            PUSH    DX              
    ;if AX < 0
            OR      AX,AX           ;AX < 0?
            JGE     @@END_IF1        ;no, > 0
    ;then
            PUSH    AX              ;save number
            MOV     DL,'-'          ;get '-'
            MOV     AH,2            ;print char fcn
            INT     21H             ;print '-'
            POP     AX              ;get AX back
            NEG     AX              ;AX = -AX               
    @@END_IF1:
    ;get decimal digits
            XOR     CX,CX           ;CX counts digits                 
            MOV     BX,10D          ;BX has divisor
    @@REPEAT1:
            XOR     DX,DX           ;prepare high part of dividend  
            DIV     BX              ;AX = quotient, DX = remainder
            PUSH    DX              ;save remainder on stack
            INC     CX              ;count = count + 1
    ;until
            OR      AX,AX           ;quotient = 0?
            JNE     @@REPEAT1        ;no, keep going
    ;convert digits to characters and print
            ;MOV     AH,2            ;print char fcn
    ;for count times do
	 mov	ax,bmp_x;156
	 mov	bx,bmp_y;16
	 
    @@@PRINT_LOOP:
            POP     DX              ;digit in DL
            OR      DL,30H          ;convert to character
            cmp	dl,'0'
	    je	digit0
	    cmp	dl,'1'
	    je  digit1
	    cmp	dl,'2'
	    je  digit2
	    cmp	dl,'3'
	    je  digit3
	    cmp	dl,'4'
	    je  digit4
	    cmp	dl,'5'
	    je  digit5
	    cmp	dl,'6'
	    je  digit6
	    cmp	dl,'7'
	    je  digit7
	    cmp	dl,'8'
	    je  digit8
	    cmp	dl,'9'
	    je  digit9
digit0:
	lea	si,dg0
	jmp	outdigit
digit1:
	lea	si,dg1
	jmp	outdigit
digit2:
	lea	si,dg2
	jmp	outdigit
digit3:
	lea	si,dg3
	jmp	outdigit
digit4:
	lea	si,dg4
	jmp	outdigit
digit5:
	lea	si,dg5
	jmp	outdigit
@@print_loop:
jmp @@@print_loop
digit6:
	lea	si,dg6
	jmp	outdigit
digit7:
	lea	si,dg7
	jmp	outdigit
digit8:
	lea	si,dg8
	jmp	outdigit
digit9:
	lea	si,dg9
	jmp	outdigit
outdigit:    
	 movebmp ax,bx,8,10,si	 
	 add	ax,8
	    ;INT     21H             ;print digit
	    dec     cx
            jnz    @@PRINT_LOOP     ;loop until done
    ;end_for
            POP     DX              ;restore registers
            POP     CX
            POP     BX
            POP     AX
            RET
    OUTDEX  ENDP

