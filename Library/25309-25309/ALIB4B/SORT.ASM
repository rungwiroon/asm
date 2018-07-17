;*****************************   SORT.ASM  **********************************
PAGE  70,132
comment 
                                SORT
                             -------------

     Purpose:
     --------

     Sort disk file using the "merge sort" algorithm.

     Using sort
     ----------
     SORT <file> <starting column> <length of sort field>

     SORT reads the given file, sorts the records using the specified
     column.  One line ending with cr/lf is assumed to be one record.
     
     Example:  To sort all TEST.DAT using columns 1-5.

               SORT test.dat 1 5


     Compiling
     ---------

     The commands needed to build sort.EXE using MASM are:
		masm sort;
		link sort,sort,,alib.lib;

     
	include	mac.inc
	include	common.inc
;-----------------------------------------------------------------------------
	extrn	library_setup:far
;;	extrn	lib_error_handler:far
	extrn	library_terminate:far	
	extrn	parse_first:far
	extrn	parse_next:far
	extrn	merge_sort_file:far
	extrn	message:far
;------------------------------------------------------------------------------
code		segment para public 'CODE'
		assume	cs:code, ds:code
;-----------------------------------------------------------------------------
;
 
pspseg		dw	0
lib_info_ptr	dw	0
lib_info_seg	dw	0

file_name	db	40 dup (0)
starting_column	dw	0
field_length	dw	0

		dw	300 dup (?)		;stack
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
	mov	lib_info_ptr,si		;save ptr to library info block
	mov	lib_info_seg,es         ; see COMMON.INC or LIBRARY_SETUP
	cmp	ax,128
	jae	got_enough_mem		;jmp if 128k of memory avail
;;	mov	al,7
;;	mov	ah,fatal_return
;;	call	lib_error_handler
	jmp	exitx
	
got_enough_mem:
	push	ds
	pop	es

	mov	di,offset file_name
	call	parse_first
	cmp	bh,7
	jne	parm_err

	mov	di,offset starting_column
	call	parse_next
	cmp	ax,0
	je	parm_err
	dec	ax
	mov	starting_column,ax
	cmp	bh,8
	jne	parm_err

	mov	di,offset field_length
	call	parse_next
	cmp	ax,0
	je	parm_err
	cmp	ax,50
	ja	parm_err
	mov	field_length,ax
	cmp	bh,8
	jne	parm_err

	mov	di,offset file_name
	mov	bx,0			;variable len records
	mov	al,0ah			;end of record char
	mov	dx,starting_column
	mov	ah,byte ptr field_length
	call	merge_sort_file	
	jmp	exitx

error_msg	label	byte
 db 'Parameter error,  SORT must be called as follows:',0dh,0ah
 db '  ',0dh,0ah
 db 'SORT <file> <first sort column>  <length of sort field>',0dh,0ah
 db '  ',0dh,0ah
 db 'Press any key to continue'
 db 0
 
parm_err:
	mov	al,0			;message ends with zero
	mov	bh,9			;rows in box
	mov	bl,60			;columns in box
	mov	dx,040ah		;box position row/column
	mov	si,offset error_msg
	mov	bp,msg_save_win+msg_restore_win+msg_anykey+msg_ram+msg_disp
	call	message
		
	
; normal program exit

exitx:	mov	ax,1
	call	library_terminate
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
