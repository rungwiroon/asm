;**************************** QUOTE.ASM *********************************
PAGE  70,132
comment 
                             QUOTE.ASM 
                             ---------

     Purpose:
     --------

     QUOTE.ASM is intended to demonstrate calling a random generator
     and finding files located in same directory as executable.
     It will display a random quote each time it is called.

     Using QUOTE.ASM
     ---------------

     The files QUOTE.EXE and QUOTE.DAT must be in the same directory.
     QUOTE is started by typing "QUOTE"<cr> without any parameters.
     

     Compiling
     ---------

     QUOTE.ASM was compiled using MASM and then linked with LINK.
     
     The following commands can be used:

		masm QUOTE;
		link QUOTE,QUOTE,,alib.lib;

     The file QUOTE.DAT was built using EDREC.		



;----------------------------------------------------------------------------
.xlist
	include  mac.inc
	include  common.inc
	extrn	library_setup:far
	extrn	library_terminate:far
	extrn	message:far
	extrn	insert_home_path:far
	extrn	last_charc:far
	extrn	random_word1:far
.list
	
;------------------------------------------------------------------------------
code		segment para public 'CODE'
		assume	cs:code, ds:code
;-----------------------------------------------------------------------------
; 

stacksize	equ	1024
	db	stacksize dup (0)
stack_	label	word
;
pspseg		dw	0		;program segment prefix

file_asciiz   	db	'quote.dat',0
file_path      	db	50 dup (0)
;-----------------------------------------------------------------------------
start:	cli
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
;
; setup the library information
;
	mov	ax,pspseg		;pass psp segment to setup
	mov	bx,0			;number of floating point variables
	call	library_setup

	mov	ax,cs
	mov	es,ax
;
; find where this program was loaded from, then assume the
; quote.dat file is at that location.
;
	mov	si,offset file_asciiz
	mov	di,offset file_path
	call	insert_home_path
;
; now get our random record#
;
	mov	bx,1
	mov	bp,166
	call	random_word1
	mov	cx,ax
	
;
; 
;  inputs:    al = separator           (if flag msg_open)
;             bh = rows in box         (if flag msg_disp)
;             bl = columns in box      (if flag msg_disp)
;             cx = record #            (if flag msg_disp & not msg_rand)
;             dx = box upper left loc  (if flag msg_disp)
;          ds:si = ptr to file name    (if flag msg_open and not msg_ram)
;          ds:si = ptr to msg text     (if flag msg_ram and msg_open)
;             bp = flags, see equates
;             es = file selector       (if not flag msg_open)
; 
; The following equates are inputs to the MESSAGE routine to contol its
; actions.  See flags in -BP-
;
; msg_save_win	equ	001h	;save screen area before drawing box
; msg_restore_win equ	002h	;restore screen before exit
; msg_hyper	equ	004h	;this is a hyper msg & key processing
; msg_yesno	equ	008h	;this message needs yes/no response
; msg_anykey	equ	010h	;this message waits for any key
; msg_nokey	equ	020h	;this message does not pause for key
; msg_close	equ	040h	;close message file before exit
; msg_open	equ	080h	;open message file before attempting read
;         	equ	100h	;                          
; msg_disp	equ	200h	;display the message
; msg_ram		equ	400h	;message in memory (ds:si) rather than in file
;
	mov	al,0		;message separators
	mov	bh,5		;box is 5 rows
	mov	bl,75		;box length
	mov	dx,0905h	;put box here
	mov	si,offset file_path
	mov	bp,msg_save_win+msg_restore_win+msg_anykey+msg_open+msg_close+msg_disp
	call	message

	mov	ax,1
	call	library_terminate
exit2:
      	mov	ax,4C00h
	int	21h

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
