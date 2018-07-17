;*****************************   SCAN.ASM  **********************************
PAGE  70,132
comment 
                                SCAN
                             -------------

     Purpose:
     --------

     Scan disk for string.

     Using newscan
     ----------
     SCAN <files/path> <pattern>

     SCAN starts searching from the current directory and checks each
     each file which matches the <files/path> specification for the
     <pattern>

     Example:  To scan all .ASM files in the current directory
               for include files:

                     SCAN *.asm include

               To scan all the files in the current and its subdirectories
               for include files:

                     SCAN *.* include             

     The <files/path> parameter applies to both files and subdirectories.
     Thus, if you type "SCAN X*.* include" it will look in the current
     directory and all subdirectories which begin with "X" for files
     which begin with "X"
     
     Compiling
     ---------

     The commands needed to build newscan.EXE using MASM are:
		masm newscan;
		link newscan,newscan,,alib.lib;

     
	include	mac.inc
	include	common.inc
;-----------------------------------------------------------------------------
	extrn	library_setup:far
	extrn	library_terminate:far	
	extrn	dos_mem_allocate:far
	extrn	dos_mem_release:far
;;	extrn	walk_path:far
	extrn	scan_block_fopen:far
	extrn	scan_block_fast:far
	extrn	scan_block_fclose:far
	extrn	parse_first:far
	extrn	parse_next:far
	extrn	stdout_string:far
	extrn	stdout_crlf:far
	extrn	stdout_spaces:far
	extrn	stdout_char:far
	extrn	is_text:far
	extrn	is_stdout_console:far
	extrn	key_read:far
;------------------------------------------------------------------------------
code		segment byte
		assume	cs:code, ds:code
;-----------------------------------------------------------------------------
;
 
data_area	struc
file_mask	db	33 dup (?)
compare_string	db	40 dup (?)
match_posn	dw	?		;split buffer match handling

fname_off	dw	?
fname_seg	dw	?
file_handle	dw	?

;buffer_size	equ	512 * 125
buffer_size	equ	512 * 100
buffer		db	buffer_size dup (?)
last_read_amount dw	?

match_line	db	76 dup (?)
open_flag	db	?			;set to one if new file opened

stdout_flag	db	?			;0=redirected 2=console

		dw	300 dup (?)		;stack
stack_		dw	?
data_area	ends

pspseg		dw	0
data_seg	dw	0
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
	cmp	ax,128
	jae	got_enough_mem		;jmp if 128k of memory avail
;;	mov	al,7
;;	mov	ah,fatal_return
;;	call	lib_error_handler
	jmp	exitx
	
got_enough_mem:
	mov	ax,size data_area
	mov	dx,0
	call	dos_mem_allocate
	mov	cs:data_seg,es
	push	es
	pop	ds
;
; clear data area
;
	cld
	mov	al,0
	mov	cx,size data_area
	mov	di,0
	rep	stosb

	mov	di,offset file_mask
	call	parse_first
;
; add error checks here and help display
;
	mov	di,offset compare_string
	mov	ds,cs:pspseg
	mov	si,82h			;compute the parse next postion
	add	si,cx
	mov	cx,0
	lodsb
	cmp	al,' '
	jne	end_parse

parse_loop:
	lodsb
	cmp	al,0dh
	je	end_parse
	inc	cx
	stosb
	jmp	parse_loop		

end_parse:
	mov	al,0
	stosb
	mov	ds,cs:data_seg		;restore ds
;	call	parse_next

	call	is_stdout_console
	mov	[ds:stdout_flag],al

	mov	si,offset compare_string
	mov	dl,20h			;match either case
	call	scan_block_fopen
				
	mov	si,offset file_mask
	mov	ax,offset our_process
	mov	cx,10h			;walk directories also
	call	FAR PTR walk_path

	call	scan_block_fclose
	
; normal program exit

exitx:	mov	es,cs:data_seg
	call	dos_mem_release
	mov	ax,1
	call	library_terminate
	mov	ax,4C00h
	int	21h

;----------------------------------------------------------------------
; our_process - process each file found by walk_path
;  inputs:  es:di point at fully quailified filename including drive.
;                 Also, the path is set to same location as file.
;
our_process	proc	far
	push	es
	pop	ds
	mov	dx,di
	add	dx,2		;move past drive
	mov	ax,3d00h	;open file for read-only
	int	21h
	mov	ds,[cs:data_seg]
	mov	[ds:open_flag],1 ;signal we opened a new file
	mov	[ds:fname_off],di
	mov	[ds:fname_seg],es
	mov	es,[cs:data_seg]
	mov	[ds:file_handle],ax
	mov	di,offset compare_string
;
; read the file
;
rd_lp:	mov	[ds:match_posn],di
	mov	bx,[ds:file_handle]
	mov	cx,buffer_size
	mov	dx,offset buffer
	mov	ah,3fh
	int	21h
	jc	exit_and_close
	cmp	ax,0
	je	exit_and_close
	mov	[ds:last_read_amount],ax
;
; search the buffer for string
;
	mov	cx,ax			;length of buffer
	mov	si,offset buffer
mt_lp:	call	scan_block_fast
	cmp	ax,0
	jne	no_match
;
; we have found a match.  ds:si points at match end
;
	cmp	[ds:open_flag],1
	jne	show_match		;jmp if file name already displayed
	mov	[ds:open_flag],0

	apush	si,di,ds	
	call	linefeed
	lds	si,dword ptr [ds:fname_off]	;display the file name
	call	stdout_string
	call	linefeed
	apop	ds,di,si
show_match:
	call	display_match
	jcxz	rd_lp
	jmp	mt_lp	

;
; no match was found, check for partial match,
;
no_match:

;
; check if more data in file
;
	cmp	[ds:last_read_amount],buffer_size
	je	rd_lp				;jmp if more data in file
;
; close the file and exit
;
exit_and_close:
	mov	bx,[ds:file_handle]
	mov	ah,3eh
	int	21h	
	retf
our_process	endp	
;-----------------------------------------------------------------------------
; display match line
;   inputs:  ds:si point at match
;               cx = amount of data remaining in buffer
;   output:  match_line has line with match text, and it is sent to stdout
;
display_match	proc	near
	apush	cx,dx,si,di,bp
	push	ds
	pop	es
	mov	ah,4
	call	stdout_spaces
;
; register use: si=left end  di=right end  bp=amount collected
;	
	mov	bp,0			;init amount of data collected
	mov	di,si			;init right end
	mov	ah,0			;set mode for IS_TEXT
;
; go left and collect data
;
left_lp:cmp	si,offset buffer
	je	got_left		;jmp if can't go left
	mov	al,ds:[si-1]
	call	is_text
	jc	got_left		;jmp if not text
	inc	bp			;bump amount collected
	dec	si			;move ptr to new char posn
	cmp	bp,75
	jb	left_lp			;jmp if not at limit yet
;
; now  scan right
;
got_left:
	jcxz	got_right		;jmp if no data in buffer
	mov	al,ds:[di]		;get next char
	call	is_text
	jc	got_right
	inc	bp
	inc	di
	dec	cx
	jcxz	got_right
	cmp	bp,75
	jb	got_left
got_right:
	mov	cx,bp			;amount of data collected
	mov	di,offset match_line
	cld
;
; move data to local buffer
;
mv_lp:	lodsb
	cmp	al,9				;check for tab
	jne	moveon
	mov	al,' '
moveon:	stosb
	loop	mv_lp
	mov	byte ptr [di],0			;put zero at end
	mov	si,offset match_line
	call	stdout_string
	call	linefeed

	apop	bp,di,si,dx,cx
	ret
display_match	endp
;-------------------------------------------------------------------------
; linefeed - move to next display line, count line
;  inputs: none
;
line_counter	db	0
pause_msg	db	'(ESC=abort, any other key to continue)',0

linefeed:
	apush	ax,si,ds
	mov	ax,cs
	mov	ds,ax
	
	call	stdout_crlf
	mov	al,cs:line_counter
	inc	al
	cmp	al,23
	jb	lf_exit
	cmp	es:stdout_flag,0
	je	lf_exit1		;jmp if console redirected
	mov	si,offset pause_msg
	call	stdout_string
	call	key_read
	cmp	ax,3
	je	abort
	cmp	ax,1bh
	je	abort
	mov	al,0dh
	call	stdout_char
	mov	ah,40
	call	stdout_spaces
	mov	al,0dh
	call	stdout_char
lf_exit1:
	mov	al,0	
lf_exit:
	mov	cs:line_counter,al
	apop	ds,si,ax
	ret

abort:	jmp	exitx			;!! beware this exits program	
code		ends

	page	66,132
;******************************** DISKE.ASM  *********************************

		public	walk_path

LIBSEG           segment byte public "LIB"
		assume cs:LIBSEG , ds:nothing

;----------------------------------------------------------------------------
.xlist
	include  mac.inc
	extrn	expand_filename:far
.list
;----------------------------------------------------------------------------
LocalAlloc	equ	2ch		;size of DTA for stack allocation

filename	db	128 dup (0)
UpOneLevel	db	"..",0
FileMask	db	13 dup (0)
process		label	dword
process_offset	dw	0
process_seg	dw	0

comment 
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -(  DISK   )
;walk_path - compress data block
;
; inputs:  ds:si = pointer to asciiz file mask
;          ax    = pointer to processing for each file match.
;                  This must be a FAR routine with same CS as calling
;                  program.
;          cx    = file attributes to match.
;                  0000 - match normal data files
;                  0001 - find read only files
;                  0002 - find hidden files
;                  0004 - find system files and directories
;                  0008 - find volume labels
;                  0010 - walk subdirectories also
;
;                  note: attributes may be combined in some cases.
;
; output:  The feed proceedure is called with:  es:di = ptr to file found.
;          The file name found is fully quailfied and includes drive.
;          The current directory is where the match file was found.
;
;          After all files are processed walk_path exits with all regiseters
;          restored.
;
; note:  The path walk starts with the current directory and includes each
;        subdirectory found.
;* * * * * * * * * * * * * *

walk_path         proc     far
	apush	ax,bx,cx,dx,si,di,bp,ds,es
	mov	bp,sp
	mov	cs:process_offset,ax
	mov	ax,word ptr [bp+20]		;get callers cs
	mov	cs:process_seg,ax
;
; copy file mask from ds:si to cs:FileMask
;
	cld
	push	cs
	pop	es
	mov	di,offset FileMask
wp_lp1:
	lodsb
	stosb
	test	al,al
	jnz	wp_lp1
	push	cs
	pop	ds
	call	recursive_walk
	apop	es,ds,bp,di,si,dx,cx,bx,ax
        retf
walk_path         endp
;
;--------------------------------------------------------------------------
; recursive_walk - walk till out of files/directories.
;  inputs:  ds,es = our code/data segment
;           FileMask =  match mask in asciiz form.
;           Process  =  far ptr to processing routine           
;
recursive_walk:
	push	bp
        mov     ah,2Fh                  ;Get DTA address
        int     21h
        push    bx                      ;Save it on the stack
        push    es
        sub     sp,LocalAlloc           ;Allocate stack space
        mov     bp,sp                   ;Stack pointer in BP
        push	ss
        pop	ds
        mov     ah,1Ah                  ;Change DTA to location
        mov     dx,bp                   ;on the stack
        int     21h
;
	mov	ah,4eh			;DOS function (find first)	
rs_loop:				;mov cx,10h ;attribute = files & dir's
	mov	dx,offset FileMask
	push	cs
	pop	ds
	int	21h
	jc	exit			;jmp if end of this dir
	cmp	byte ptr [bp+1eh],'.'	;check if directory header
	je	tail			;jmp if header file
	test	byte ptr [bp+15h],10h	;check if directory entry
	jz	file_fnd		;jmp if not dir, and is file
;
; we have encountered a directory, switch to it and look for files
;
	mov	ah,3bh
	mov	dx,bp
	add	dx,30
	push	ss
	pop	ds	
	int	21h	

	push	bp
	call	recursive_walk
	pop	bp
;
; we are back from directory processing, restore origional dir.
;
	mov	ah,3bh
	mov	dx,offset UpOneLevel
	push	cs
	pop	ds
	int	21h
	jmp	tail
;
; we have found a file the caller wants to process
;
file_fnd:
	mov	si,bp
	add	si,30
	push	ss
	pop	ds

	push	cs
	pop	es	
	mov	di,offset filename
move_it:
	lodsb
	stosb
	cmp	al,0
	jne	move_it

	mov	si,offset filename
	push	es
	pop	ds
	call	expand_filename
	mov	di,si

	call	process

tail:	mov	ah,4fh
	jmp	rs_loop	
;
; restore origional DTA from stack.
;
exit:	add	sp,LocalAlloc	;deallocate stack space
	
	mov	bx,ds
	mov	ah,1ah		;restore previous DTA
	pop	ds
	pop	dx
	int	21h
	mov	ds,bx
	pop	bp
	ret
	
	
LIBSEG	ENDS
;;	end	
;-------------------------------------------------------------------------
;
; This segment definition is needed so linker will put the LIBSEG here
; before the ZSEG.  We want ZSEG to be last so memory allocation will
; work correctly.
;
LIBSEG           segment byte public 'LIB'
	assume	cs:LIBSEG
LIBSEG	ENDS

;-------------------------------------------------------------------------
; zseg must be at the end of the program for memory allocation from
; DOS.
;
zseg	segment	para public 'ZZ'
zseg	ends

		end	start
