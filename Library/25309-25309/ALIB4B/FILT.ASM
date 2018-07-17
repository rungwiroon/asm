;*****************************  FILT.ASM   **********************************
PAGE  70,132
comment 
                             FILT file
                             ---------

     Purpose:
     --------

     FILT is a program to find comment blocks in a file and send to stdout.
     Currently it is configured to scan through library files and was used
     to create the file CALLS.DOC.
     

     Using FILT
     ----------

     To filter file XX and send comments to file OUT

                   FILT XX > OUT

     To append file XX comment blocks to end of file OUT

                  FILT XX >> OUT

     All the block comments in the library source files can be extracted
     by building a batch file which calls FILT for each file in the
     library.  Using "DIR /on /b *.asm > doit.bat" is a first step in
     creation of the batch file.

     It is assumed that all files are in the same directory and FILT
     may not work if files are scattered around the disk.
     
;-----------------------------------------------------------------------------


	include	mac.inc
	include	common.inc
;-----------------------------------------------------------------------------
	extrn	library_setup:far
	extrn	library_terminate:far
	extrn	parse_first:far
	extrn	stdout_char:far
	extrn	filechar_open:far
	extrn	filechar_close:far
	extrn	filechar_read:far
	extrn	expand_filename:far
;------------------------------------------------------------------------------
code		segment para public 'CODE'
		assume	cs:code, ds:code
;-----------------------------------------------------------------------------
;
 
pspseg		dw	0
lib_info_ptr	dw	0
lib_info_seg	dw	0
tail_text	db	'Source File: '
file_asciiz		db	80 dup (0)

		dw	200 dup (0)		;stack
stack_		dw	0


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
	jmp	exitx
	
got_enough_mem:
	call	ck_for_filename
	jc	exitx
;
; open file
;
	mov	dx,offset file_asciiz
	call	filechar_open
	jc	exitx
;
; read next char
;	
lp1:	call	filechar_read
	jc	exit1
	cmp	al,0
	je	exit1

	cmp	al,'C'
	je	doit
	cmp	al,'c'
	jne	lp1	
;
; we have found a 'c' go check for comment
;
doit:	call	comment_check
	jmp	lp1			

exit1:	call	filechar_close

; normal program exit

exitx:	mov	ax,1
	call	library_terminate
	mov	ax,4C00h
	int	21h

;---------------------------------------------------------------------------
; ck_for_filename - get preliminary information from user
;   inputs: 	none
;   outputs:    carry = aborting, insufficient info.
;            no carry = all questions answered ok
;
ck_for_filename:
	mov	ax,cs
	mov	es,ax
	mov	di,offset file_asciiz
	call	parse_first
	cmp	bh,0
	jne	aq_test_file		;jmp if file ok
	stc
	jmp	aq_exit
aq_test_file:
;;	mov	si,offset file_asciiz
;;	call	expand_filename
	clc
aq_exit:
	ret
;------------------------------------------------------
comment_check:
	call	filechar_read
	jc	exit2
	cmp	al,'o'
	jne	exit2
	call	filechar_read
	cmp	al,'m'
	jne	exit2
	call	filechar_read
	cmp	al,'m'
	jne	exit2
	call	filechar_read
	cmp	al,'e'
	jne	exit2
	call	filechar_read
	cmp	al,'n'
	jne	exit2
	call	filechar_read
	cmp	al,'t'
	jne	exit2
	call	filechar_read
	cmp	al,' '
	jne	exit2
	call	filechar_read
	cmp	al,1fh
	jne	exit2

;
; we have found 'comment', send everything to stdout till end
;
lp2:	call	filechar_read
	cmp	al,1fh
	je	add_tail
	call	stdout_char
	jmp	lp2
;
; append filename on end
;
add_tail:
	mov	si,offset tail_text
lp3:	mov	al,byte ptr [si]
	cmp	al,0
	je	crlf
	inc	si
	call	stdout_char
	jmp	lp3

crlf:	mov	al,0dh
	call	stdout_char
	mov	al,0ah
	call	stdout_char
exit2:	ret	
;------------------------------------------------------



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
