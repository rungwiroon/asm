page	59,132
comment 
                             COMPRES & RESTOR
                             ----------------

     Purpose:
     --------

     COMPRES and RESTOR are sample program to show how huffman
     compression works.  Single files can be compressed by the
     COMPRES program, then decompressed by the RESTOR program.

     Using COMPRES & RESTOR
     ----------------------

     To compress a file type "COMPRES file1 file2".  The first
     file (file1) is the file to be compressed and the
     second file is what to call the result.  RESTOR works
     in the reverse.  "RESTOR file1 file2" will decompress
     file1 and put at file2.

     Compression Overview
     --------------------

     The compression/decompression engines are initiated with a
     pointer to two routines.  One routine will feed data to the
     engine and the other will store the output.  Next, one call
     to the compression entry point will continue compressing
     until the input (feed) routine runs out of data.
     
     Performance
     -----------

     Compression speed and size is respectable, but not competative
     with programs such as PKZIP and ARJ.  For most compression jobs
     of less than a megabyte the speed will be acceptable.

     
	extrn	shrink:far
	extrn	expand:far
	extrn	DWORD_TO_HEX_CRT:far
	extrn	library_setup:far
	extrn	library_terminate:far
;;	extrn	lib_error_handler:far
	extrn	parse_first:far
	extrn	parse_next:far
	extrn	file_size1:far
	extrn	SHOW_CURSOR:far
	extrn	key_read:far
	extrn	lib_info:byte	
	
.xlist
	include  mac.inc
	include	common.inc
.list
  
code	segment
	assume	cs:code,ds:nothing
;‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
; FEED - fill buffer for shrink/expand
;  inputs: ds:dx = buffer ptr of size (disk_buf_size)
;             ax = requested amount
;  output:    ax = number of bytes placed in buffer, 0=end of input
;-------------------
feed_handle	dw	0
feed_count	dd	0
;-------------------
feed	proc	far
	apush	cx,bx
	mov	cx,ax			;amount of data to read
	mov	bx,cs:feed_handle	;file handle
	mov	ah,3fh			;read code
	int	21h
	add	word ptr cs:feed_count,ax
	adc	word ptr cs:feed_count+2,0
	apush	ax,dx
	mov	ah,3
	mov	bh,0
	int	10h			;read cursor posn -> dx
	mov	dl,8
	mov	ah,2
	int	10h			;set cursor posn
	mov	ax,word ptr cs:feed_count	
	mov	dx,word ptr cs:feed_count+2
	call	DWORD_TO_HEX_CRT
	apop	dx,ax
	apop	bx,cx
	retf
feed	endp

;‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
; STORE - save buffer data somewhere
;  inputs:  ds:dx = buffer ptr
;	       ax = amount of data present in buffer
;  output:  none
;-------------------
store_handle	dw	0
store_count	dd	0
;-------------------
store	proc	far
	apush	ax,bx,cx
	add	word ptr cs:store_count,ax
	adc	word ptr cs:store_count+2,0
	mov	cx,ax			;set write length
	mov	bx,cs:store_handle
	mov	ah,40h
	int	21h
	push	dx
	mov	ah,3
	mov	bh,0
	int	10h			;read cursor posn -> dx
	mov	dl,27
	mov	ah,2
	int	10h			;set cursor posn
	mov	ax,word ptr cs:store_count	
	mov	dx,word ptr cs:store_count+2
	call	DWORD_TO_HEX_CRT
	pop	dx
	apop	cx,bx,ax
	retf
store	endp


;‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹

	assume	cs:code,ds:code


;€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€€
	
infile_asciiz	db	40 dup (0)
outfile_asciiz	db	40 dup (0)
help_msg      db 0dh,0ah
	      db  'COMPRESS compresses a file to smaller size.',0dh,0Ah
              db  'usage: ',0dh,0Ah
              db  '   COMPRESS <file1> <file2> ',0dh,0ah
              db 0dh,0ah
              db  ' <file1> is compressed and stored at <file2>',0dh,0ah
              db  'Press any key to continue.$'
info_msg	db	'Reading            Writing$'              
;--------------------------
start           proc    far
		cld
		mov	bp,ds		;save PSP seg
		mov	bx,cs
		mov	ds,bx
		mov	es,bx

; next, release memory beyond the end of the program
; The  definition for ZSEG marks the
; end of the program's code, data and stack area.

	mov	ax,zseg

	mov	bx,bp
	mov	es,bp
	sub	bx,ax
	neg	bx			; size of program in paragraphs
	mov	ah,4Ah			; resize memory block
	int	21h
	push	ds
	pop	es
;
; check if enough memory free to run program
;
	mov	ax,bp    		;pass psp segment to setup
	mov	bx,0			;number of floating point variables
	call	library_setup
	cmp	ax,128
	jae	got_enough_mem		;jmp if 128k of memory avail
;;	mov	al,7
;;	mov	ah,fatal_return
;;	call	lib_error_handler
	jmp	exitx
	
got_enough_mem:
	push	ds
	pop	es
	mov	di,offset infile_asciiz
	call	parse_first
	cmp	bh,7
	jne	parse_err
	mov	di,offset outfile_asciiz
	call	parse_next
	cmp	bh,7
	jne	parse_err
;
; open the input file
;
	mov	ax,3d00h
	mov	dx,offset infile_asciiz
	int	21h
	jc	parse_err
	mov	feed_handle,ax
	mov	ax,3c00h
	mov	cx,0				;file attributes
	mov	dx,offset outfile_asciiz
	int	21h
	mov	store_handle,ax
;
; setup to display
;
	mov	dx,1800h
	call	SHOW_CURSOR
	mov	ah,9
	mov	dx,offset info_msg
	int	21h	
;
; setup for shrink/expand call
;
	mov	si,offset feed
	mov	di,offset store
	push	cs
	pop	es
;
; decode operation type
;
	mov	bx,feed_handle
	call	file_size1
	call	shrink
	jmp	exitx

parse_err:
	mov	dx,offset help_msg
	mov	ah,9
	int	21h
	call	key_read

; normal program exit

exitx:	mov	bx,feed_handle
	cmp	bx,0
	je	exitx1
	mov	ah,3eh
	int	21h			;close infile
exitx1:	mov	bx,store_handle
	cmp	bx,0
	je	exitx2
	mov	ah,3eh
	int	21h
		
exitx2:	mov	ax,1			;do not clear screen
	call	library_terminate
	mov	ax,4C00h
	int	21h
	
start           endp
  
;‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
  
code	ENDS
;--------------------------------------------------------- stack_seg_e  ---
stack     segment para stack
                db      2048 dup (0)
stack     ends
;
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

zseg	segment para public 'ZZ'
zseg	ends

                end     start
