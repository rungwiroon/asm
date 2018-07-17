;**************************** MEMORY.ASM ********************************
PAGE  70,132
comment 
                             MEMORY.ASM
                             ----------

     Purpose:
     --------

     MEMORY.ASM display the memory information available from
     ALIB.  Include are the MCB chain, and the size of DOS,
     XMS, and EMS memory.

     Compiling
     ---------

     MEMORY.ASM was compiled using MASM and then linked with LINK.
     
     The following commands can be used:

		masm MEMORY;
		link MEMORY,MEMORY,,alib.lib;




;----------------------------------------------------------------------------
.xlist
	include  mac.inc
	include  common.inc
	extrn	library_setup:far
	extrn	library_terminate:far
	extrn	stdout_string:far
	extrn	stdout_char:far
	extrn	word_to_hex_stdout:far
	extrn	stdout_crlf:far
	extrn	stdout_spaces:far
	extrn	word_to_dec_stdout:far
	extrn	dword_to_dec_stdout:far
	extrn	a20_check:far
	extrn	xms_check:far
	extrn	mcb_find_first:far
	extrn	mcb_find_next:far
	extrn	mcb_find_name:far
	extrn	mcb_display_name:far
	extrn	check_dos_memory:far
	extrn	xms_umb_check:far
	extrn	ems_check:far
	extrn	ext_check:far	
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

	mov	ax,cs
	mov	es,ax
;
; setup the library information
;
	mov	ax,pspseg		;pass psp segment to setup
	mov	bx,0			;number of floating point variables
	call	library_setup
;
; now remove the memory manager so we can check available memory.
; The memory manager grabs all available memory, and we will always
; get zero available if it is active.
;
	mov	ax,1
	call	library_terminate

	call	a20_status
	call	mcb_status
	call	conventional_status
	call	xms_status
	call	ems_status
	call	ext_status
	
exit2:
      	mov	ax,4C00h
	int	21h
;--------------------------------------------------------------------------
wrap_msg	db	'A20 line is wrapping',0
no_wrap_msg	db	'A20 line is not wrapping',0
xwrap_msg	db	', XMS driver reports A20 is wrapping',0
xno_wrap_msg	db	', XMS driver reports A20 is not wrapping',0
break		label	byte
 db '------------------------------------------------------------------------'
crlf		db	0dh,0ah,0

a20_status:
	mov	si,offset break
	call	stdout_string
	call	a20_check
	mov	si,offset wrap_msg
	cmp	al,0
	je	a20_1			;jmp if wrapping
	mov	si,offset no_wrap_msg
a20_1:	call	stdout_string
	call	xms_check
	mov	si,offset crlf
	cmp	bx,0
	je	a20_2			;jmp if no xms driver
	mov	si,offset xwrap_msg
	cmp	cx,0
	je	a20_2
	mov	si,offset xno_wrap_msg
a20_2:	call	stdout_string
	call	stdout_crlf
	ret
;--------------------------------------------------------------------------

MCB	STRUC
  mcb_code1	db	0		;4d=start 5a=end
  prog_seg1	dw	0		;program segment
  mcb_len1	dw	0		;length of memory ctrl	block
MCB	ENDS
;
mcb_status:
	mov	si,offset break
	call	stdout_string
	mov	si,offset header
	call	stdout_string
;
; chain high mcb's in
;
	mov	ax,5803h
	mov	bx,1
	int	21h
	
	call	mcb_find_first
	jmp	show_mcb
mcb_loop:
	call	mcb_find_next
show_mcb:
	pushf
	mov	ah,2
	call	stdout_spaces
	mov	ax,es
	call	word_to_hex_stdout
	mov	ah,4
	call	stdout_spaces
	mov	ax,es:[prog_seg1]
	call	word_to_hex_stdout
	mov	ah,4
	call	stdout_spaces
	mov	ax,es:[mcb_len1]
	call	word_to_hex_stdout
	mov	ah,4
	call	stdout_spaces
	call	mcb_find_name
	jnc	skip
	call	mcb_display_name
skip:	call	stdout_crlf
	popf
	jnc	mcb_loop
;
; unchain high mcb's
;
 	mov	ax,5803h
	mov	bx,0
	int	21h
       ret

header	db	0dh,0ah,0dh,0ah
	db	'  MCB     Block   Block   Process',0dh,0ah
	db	'  Seg     Owner   Size    Name   ',0dh,0ah
     	db	'  -----------------------------------------------',0dh,0ah
	db	0
;---------------------------------------------------------------------------

c_msg1	db	'Available DOS memory = ',0
c_msg2	db	'  Total memory size (bytes) = ',0
;
; display conventional memory status
;
conventional_status:
	mov	si,offset break
	call	stdout_string
	mov	ax,zseg
	call	check_dos_memory
	mov	si,offset c_msg1
	call	stdout_string
	mov	cx,16
	mul	cx
	call	dword_to_dec_stdout
	mov	ah,4
	call	stdout_spaces
	mov	si,offset c_msg2
	call	stdout_string
	mov	ax,bx
	mov	cx,16
	mul	cx
	call	dword_to_dec_stdout
	call	stdout_crlf
	ret
;---------------------------------------------------------------------------
no_xms	db	'The XMS driver was not found',0
found_xms db	'The total avaliable XMS memory (bytes) = ',0
no_umb	db	'XMS reports the UMB area is not available',0
found_umb db	'XMS reports available UMB area (bytes) = ',0

;
; display xms status
;
xms_status:
	mov	si,offset break
	call	stdout_string
	call	xms_check
	mov	si,offset no_xms
	cmp	bx,0
	je	xms1			;jmp if no xms
	mov	si,offset found_xms
xms1:	call	stdout_string
	cmp	bx,0
	je	xms9			;jmp if no xms
	mov	ax,dx
	mov	cx,1024
	mul	cx
	call	dword_to_dec_stdout
	call	stdout_crlf

	call	xms_umb_check
	mov	si,offset no_umb
	cmp	bx,0
	je	xms2			;jmp if no xms
	mov	si,offset found_umb
xms2:	call	stdout_string
	cmp	bx,0
	je	xms9			;jmp if no xms
	mov	ax,dx
	mov	cx,1024
	mul	cx
	call	dword_to_dec_stdout
xms9:	call	stdout_crlf
	ret
;---------------------------------------------------------------------------
no_ems_msg db 'EMS memory was not found',0dh,0ah,0
ems_size_msg db 'EMS free memory was found, size (bytes) = ',0
ems_tsize_msg db 'Total EMS size is (bytes) = ',0

ems_status:
	mov	si,offset break
	call	stdout_string
	call	ems_check
	mov	si,offset no_ems_msg
	jc	ems9
	push	dx
	mov	si,offset ems_size_msg
	call	stdout_string
	mov	ax,bx
	mov	cx,16384
	mul	cx
	call	dword_to_dec_stdout
	call	stdout_crlf
	mov	si,offset ems_tsize_msg
	call	stdout_string
	pop	ax
	mul	cx
	call	dword_to_dec_stdout
	mov	si,offset crlf
ems9:	call	stdout_string
	ret
;---------------------------------------------------------------------------
ext_msg1 db 'Available EXT memory reported by BIOS (bytes) = ',0
ext_msg2 db 'Total EXT reported by CMOS (bytes) = ',0

ext_status:
	mov	si,offset break
	call	stdout_string
	mov	si,offset ext_msg1
	call	stdout_string
	call	ext_check
	mov	cx,1024
	mul	cx
	call	dword_to_dec_stdout
	call	stdout_crlf

	mov	si,offset ext_msg2
	call	stdout_string
	mov	ax,bx
	mov	cx,1024
	mul	cx
	call	dword_to_dec_stdout
	call	stdout_crlf
	
	ret
;---------------------------------------------------------------------------

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
