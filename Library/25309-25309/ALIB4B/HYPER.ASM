;****************************  HYPER.ASM   **********************************
PAGE  66,132
comment 
                             HYPER.ASM 
                             ---------

     Purpose:
     --------

     HYPER.ASM is intended to demonstrate a simple hyper database
     which describes ALIB.LIB use.

     Using HYPER.ASM
     ---------------

     The files HYPER.EXE and HYPER.DAT must be in the same directory.
     HYPER is started by typing "HYPER"<cr> without any parameters.
     

     Compiling
     ---------

     HYPER.ASM was compiled using MASM and then linked with LINK.
     
     The following commands can be used:

		masm HYPER;
		link HYPER,HYPER,,alib.lib;

     The file HYPER.DAT was built using EDREC.		



	include	mac.inc
	include	common.inc
;-----------------------------------------------------------------------------
	extrn	library_setup:far
	extrn	library_terminate:far	
;;	extrn	lib_error_handler:far
	extrn	message:far
;------------------------------------------------------------------------------
code		segment para public 'CODE'
		assume	cs:code, ds:code
;-----------------------------------------------------------------------------
;
filename	db	'HYPER.DAT',0

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
;;	mov	al,7
;;	mov	ah,fatal_return
;;	call	lib_error_handler
	jmp	exit2
	
got_enough_mem:
	
; prevent an unintended program crash; trap Ctrl+Break, Ctrl+C and
; Ctrl+Alt+Del key combinations

;	call	BREAK_KEY_INTERCEPT	;optional

	mov	al,0			;separator character for database
	mov	bh,25			;rows in display window
	mov	bl,80			;columns in display window
	mov	cx,1			;initial record#
	mov	dx,0			;window upper left corner
	mov	si,offset filename
	mov	bp,msg_hyper+msg_open+msg_close+msg_disp
	call	message	
	

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
