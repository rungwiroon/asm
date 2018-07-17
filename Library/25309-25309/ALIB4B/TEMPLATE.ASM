;**************************** TEMPLATE.ASM **********************************
PAGE  66,132
comment 
                             TEMPLATE.ASM
                             ------------

     Purpose:
     --------

     TEMPLATE.ASM is a skeleton assembly language program which
     can be used as the basis to start a new program.

     Using TEMPLATE.ASM
     ------------------

     The setup in TEMPLATE should work for most programs without using
     alot of memory.  If no floating point variables are used then
     some memory can be saved by modifying the call to library_open
     to specify zero floating variables.  Next, add code to the
     area of TEMPLATE.ASM which indicates the main body of the program
     goes here.
     
     TEMPLATE.ASM was tested with MASM and OPTASM, but any assembler
     should work.  

     Compiling
     ---------

     The following commands can be used to compile TEMPLATE and
     create TEMPLATE.EXE:
		masm TEMPLATE;
		link TEMPLATE,TEMPLATE,,alib.lib;



     

; Sample template for creating programs using ALIB.LIB
;
	include	mac.inc
	include	common.inc
;-----------------------------------------------------------------------------
	extrn	library_setup:far
	extrn	library_terminate:far	
;------------------------------------------------------------------------------
code		segment para public 'CODE'
		assume	cs:code, ds:code
;-----------------------------------------------------------------------------
;
pspseg		dw	0			;Program Segment Prefix
		dw	200 dup (0)		;stack
stack_		dw	0
;-----------------------------------------------------------------------------
start:
	cli
	mov	cs:pspseg,es	;save PSP segment
	mov	ax,cs		;get CODE segment
	mov	ss,ax
	mov	ds,ax
	mov	es,ax
	mov	sp,offset stack_
	sti
	
; next, release memory beyond the end of the program
; The  definition for ZSEG marks the
; end of the program's code, data and stack area.
; When linking be sure ZSEG is at the end of the program.

	mov	ax,zseg

	mov	bx,cs:pspseg		;
	mov	es,bx
	sub	bx,ax
	neg	bx			; size of program in paragraphs
	mov	ah,4Ah			; resize memory block
	int	21h

	mov	ax,cs
	mov	es,ax
;
; check if enough memory free to run program
;
	mov	ax,pspseg		;pass psp segment to setup
	mov	bx,8			;number of floating point variables
	call	library_setup
	cmp	ax,128			;check if 128k of memory is available
	jae	got_enough_mem		;jmp if 128k of memory avail
;
; If you want to have a small program, replace the following error_handler
; call with your own error display.  The error_handler is a real memory
; hog.
;
;	mov	al,7
;	mov	ah,fatal_return
;	call	lib_error_handler
;	jmp	exit2
	
got_enough_mem:
	
; prevent an unintended program crash; trap Ctrl+Break, Ctrl+C and
; Ctrl+Alt+Del key combinations

;	call	BREAK_KEY_INTERCEPT	;optional


;  add main body of program here ............


	

; normal program exit
;
exit1:	
;
; de-activate the Ctrl+Break trap
;	call	BREAK_KEY_RESTORE	;needed only if BREAK_KEY_INTERCEPT called

exit2:	mov	ax,0
	call	library_terminate
	mov	ax,4C00h
	int	21h
;------------------------
code		ends
;-------------------------------------------------------------------------
;
; This segment definition is needed so linker will put the LIBSEG here
; before the ZSEG.  We want ZSEG to be last so memory allocation will
; work correctly.
;
LIBSEG           segment byte public 'LIB'
LIBSEG	ENDS
;-------------------------------------------------------------------------
; zseg must be at the end of the program for memory allocation from
; DOS.
;
zseg	segment	para public 'ZZ'

zseg	ends

		end	start
