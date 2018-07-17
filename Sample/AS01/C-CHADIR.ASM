;     written 11/8/84 gwf
;CHANGDIR --- This program will change current working directories.
;
;		    FOR CBASIC
;

;
;
;     ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
;       CALL CHANGDIR(TO.WHERE)	 
; Call with parameter desired directory name +CHR$(0).
;     ÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷÷
;
;		      Example program to compile
;
;		  def changdir(new.dir$) EXTERNAL
;		  fend
;		  input"Desired directory ";ans$
;		  Y$=ans$+CHR$(0)
;		  CALL changdir(y$)
;		  end
;
;
ch_dir	equ	3bh	;Change directory function call
doscall equ	21h	;DOS interrupt number


cgroup	group	cseg
;

;Names must have a byte zero to indicate their termination
;				called ASCIIZ



;*****************************************************************************


cseg	segment  PARA PUBLIC 'CODE'         ;define code segment
;---------------------------------------------------------------------

   assume cs:cgroup
   public changdir


changdir proc NEAR	 ;main part of program



;set up stack for return
	push bp 	;save for return
	mov  bp,sp	;set base for passed names
	push ds 	;save old data segment
	push es 	;save for return


;MAIN PART OF PROGRAM.
;DX points to new directory name

	mov  si,ss:[bp+4]    ;get address of parameter passed
	mov  ax,si	     ;
	add  ax,2	     ;	actual address of string is 2 later
	mov  dx,ax	     ;DS:DX must point to ASCIIZ string
	mov  ah,ch_dir	     ;change directory function number
	int  doscall	     ;Call DOS

	pop  es
	pop  ds
	pop  bp
	ret  2			;return to calling program
changdir endp			;end of main part of program
;---------------------------------------------------------------------
cseg	ends		;end of code segment
;*********************************************************************
	end		;end of assembly
