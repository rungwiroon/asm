;***************************** EDREC.ASM   **********************************
PAGE  70,132
COMMENT 
                              EDREC (Edit Records)
                              Version 1.0
                              --------------------


     Purpose
     -------

     EDREC is both a sample program and ALIB utility program.  Files
     created by EDREC use ALIB database format which is also used by
     hyper message and error displays.  This greatly simplifies the
     process of creating a file of error messages or help screens.

     Using EDREC
     -----------

     EDREC can be started by typing EDREC or by typing EDREC followed
     with a file name.  If the file exists, EDREC will display the first
     record and wait for input.  If the file does not exist the record
     window will be blank.

     The data entered using EDREC is probably going to be displayed in
     a window someday, so the window size should be selected to make
     data entry easier.  The record window size is set by the "Config"
     menu option.

     After setting the window size, select "Edit" to add or modify
     records.
     
     Database Format
     ---------------

     EDREC creates records in a window which can be configured to any size.
     Each record is variable length and terminated by a null (hex 00 char).

     Compiling
     ---------

     The MASM & LINK commands needed to build EDREC.EXE are:
		masm edrec;
		link edrec,edrec,,alib.lib;

     


	include	mac.inc
	include	common.inc
;-----------------------------------------------------------------------------
	extrn	library_setup:far
	extrn	lib_error_handler1:far
	extrn	error_handler1:far
	extrn	clear_screen:far
	extrn	display_string:far
	extrn	display_string_fill:far
	extrn	put_crt_blk:far
	extrn	repeat_put_crt:far
	extrn	BREAK_KEY_INTERCEPT:far
	extrn	change_path:far
	extrn	MENU_SYSTEM:far
	extrn	change_setup:far
	extrn	restore_path:far
	extrn	find_home_path:far
	extrn	library_terminate:far
	extrn	BREAK_KEY_RESTORE:far
	extrn	parse_first:far
	extrn	expand_filename:far
	extrn	get_string:far
	extrn	qget_string:far
	extrn	DEC_STR_TO_WORD:far
	extrn	WORD_TO_DEC_CRT:far
	extrn	get_setup:far
	extrn	save_window:far
	extrn	restore_window:far
	extrn	draw_box:far
	extrn	box_shrink:far
	extrn	window_string:far
	extrn	yes_or_no:far
	extrn	flush_keyboard:far
	extrn	set_lib_colors:far
	extrn	dbase_init:far
	extrn	DBASE_READ:far
	extrn	dbase_read_next:far
	extrn	dbase_read_prev:far
	extrn	dbase_append:far
	extrn	dbase_replace:far
	extrn	dbase_insert:far
	extrn	DBASE_REMOVE:far
	extrn	dbase_close:far	
	extrn	window_edit:far
	extrn	window_cstring:far
	extrn	strlen3:far
	extrn	to_upper:far
	extrn	message:far
;------------------------------------------------------------------------------
code		segment para public 'CODE'
		assume	cs:code, ds:code
;-----------------------------------------------------------------------------
; 
edit1_msg	db	' Current Record #',0
edit3_msg	db	'(alt-H) for help ',0
append_msg	db	'append',0 
insert_msg	db	'insert',0
modify_msg	db	'modify',0
exit_msg	db	'EDREC exiting, do you wish to save the changes in memory? (Y/n)',0
pspseg		dw	0
lib_info_ptr	dw	0
lib_info_seg	dw	0

current_operation	db	0	;0=none 1=append 2=insert 3=replace
current_record		dw	1
current_record_ptr	dw	0
current_Record_len	dw	0
null_file_flag		db	0	;0=file empty

file_asciiz		db	40 dup (0)

box_size		label	word
box_cols		db	50	;columns
box_rows		db	5	;rows

box_location		label	word
			db	14	;column
			db	5	;row

dirty_flag		db	0	;1=changes have been made
saved_flag		db	0	;1=file has been saved

buffer_size	equ	1000		;largest record size
buffer			db	buffer_size dup (0)
buffer_ptr		dw	buffer
cursor_position		dw	0

file_create_flag	db	0	;1=create is needed
string1			db	3 dup (0)
string2			db	3 dup (0)

help_asciiz		db	'EDREC.HLP',0

null_file_msg		db	'The database does not contain any records'
			db	' select the EDIT and APPEND options to add'
			db	' records, or CONFIG option to change setup.'
			db	0dh,0ah,0dh,0ah,'Press any key to continue',0
bad_rec_msg		db	'This record does not exist in the database'
			db	'.  The APPEND function must be used to add'
			db	' records.',0dh,0ah,0dh,0ah
			db	'Press any key to continue',0
not_yet_msg		db	'This feature not implemented at present.  '
			db	' Press any key to continue',0
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
	mov	bx,0			;number of floating point variables
	call	library_setup
	mov	lib_info_ptr,si		;save ptr to library info block
	mov	lib_info_seg,es         ; see COMMON.INC or LIBRARY_SETUP
	cmp	ax,128
	jae	got_enough_mem		;jmp if 128k of memory avail
	mov	al,7
	mov	ah,fatal_return
	call	lib_error_handler1
	jmp	exitx
	
got_enough_mem:
;
; clear the screen and display signon
;
	mov	ah,app_text_color
	mov	al,' '
	call	clear_screen
;
; display copyright message
;
	mov	si,offset copyright_msg
	mov	ah,app_text_color
	mov	dx,1008h		;display row 16 column xx
	call	display_string	
	
	
; prevent an unintended program crash; trap Ctrl+Break, Ctrl+C and
; Ctrl+Alt+Del key combinations

;	call	BREAK_KEY_INTERCEPT

;
; switch to home directory
;
	push	es
	call	find_home_path
	mov	bx,di
	call	change_path
	pop	es
	jnc	path_changed
	mov	al,6
	mov	ah,fatal_return
	call	lib_error_handler1
	jmp	exit2
path_changed:
	call	read_setup
	call	establish_defaults	;set colors & see if config file avail
	call	ck_for_filename
;
; read the file (initialize the database)
;
init_database:
	mov	dx,offset file_asciiz
	call	dbase_init
	mov	es,bx			;move selector to es:
;
; if file does not exist, then ask if create ok
;
	cmp	al,1			;check if file opened ok
	jbe	clear_and_display
	jmp	exit			;jmp if error opening file
;
; clear the screen and display the box
;
clear_and_display:
	mov	ah,_msg_text_color
	mov	al,' '
	call	clear_screen
	mov	dx,box_location
	mov	bx,box_size
	mov	ah,_msg_text_color
	mov	al,0			;single line frame
	call	draw_box
;
; fill box with record info.
;
	mov	dx,current_record
	call	DBASE_READ
	cmp	al,0
	je	show_rec		;jmp if record found
	cmp	dx,1			;check if this is record 1
	jne	show_rec		;jmp if database has records
;
; current database is empty
;
null_file:
	mov	si,offset null_file_msg
bad_rec_number:	
	apush	ds,es
	mov	ax,cs
	mov	ds,ax
	mov	es,ax
	mov	ah,cs:_msg_text_color
	mov	al,0
	mov	bx,0840h
	mov	dx,0808h
	mov	cx,1
	mov	bp,msg_save_win+msg_restore_win+msg_anykey+msg_disp+msg_ram
	call	message
	apop	es,ds		
	jmp	menu1			;jmp if empty database
;
; this record is not present in the data base, ask for instructions
;

;
; fill the box with current record contents
;   es:si point at data for display
;      cx = record length
;
show_rec:
	mov	null_file_flag,1	;specify database has data
	call	move_to_buffer
;
; setup to display buffer
;
display_buffer:		
	mov	bx,box_size
	mov	dx,box_location
	call	box_shrink
	mov	ah,_msg_text_color	
	mov	si,offset buffer
	push	di
	mov	di,0
	call	window_cstring
	pop	di
;
; display status line with record#
;
	call	show_rec_status
;
; show menu bar and wait for selection
;
menu1:	mov	bx,offset menu1_def
	mov	ah,08h+20h		;restore bar & return unknown keys
	call	MENU_SYSTEM
	cmp	cl,1			;check if process key
	jne	menu1_d2		;jmp if not process hit
	jmp	ax
	jmp	menu1			;go do it again
menu1_d2:
	cmp	cl,4			;check if abort key
	je	quit_j
	cmp	cl,2
	jne	menu1			;jmp if unknown mouse or no key press
	cmp	al,51h
	je	pgdn_j
	cmp	al,49h
	je	pgup_j
	jmp	menu1
	
quit_j:	jmp	quit	
pgdn_j:	jmp	pgdn
pgup_j:	jmp	pgup	
;---------------------------------------------------------------------------
; top level menu executables
;---------------------------------------------------------------------------
edit_append:
	mov	current_record,0
	mov	current_operation,1		;set append flag
	call	clear_buffer
	call	show_rec_status			;show new append state
	call	buffer_edit
	push	ax
	call	append_record
	mov	current_operation,0
	pop	ax
	jc	edrec_errorj
	mov	null_file_flag,1
	jmp	display_buffer
;----------------------------
edrec_errorj:
	jmp	edrec_error
;----------------------------		
edit_insert:
	cmp	null_file_flag,0
	je	null_filek			;jmp if database empty
	call	clear_buffer
	mov	current_operation,2		;set insert code
	call	show_rec_status
	call	buffer_edit
	push	ax
	call	insert_record
	mov	current_operation,0
	pop	ax
	jc	clear_and_displayj
	jmp	display_buffer

clear_and_displayj:
	jmp	clear_and_display
	
get_rec_msg	db	'What record# do you want to view/edit?',0
new_rec		dw	0
	
edit_selected:
	cmp	null_file_flag,0
	je	null_filek			;jmp if database empty
	call	get_rec
	jc	es_abort	
	mov	current_operation,3			
	mov	dx,new_rec
	call	fill_buffer
	jnc	es_cont
es_bad:	mov	si,offset bad_rec_msg
	jmp	bad_rec_number
es_cont:call	show_rec_status
	call	buffer_edit
	push	ax
	call	replace_record
	mov	current_operation,0
	pop	ax
	jmp	ed_common
es_abort:	
	jmp	display_buffer
;--------------------------
null_filek:
	jmp	null_file
edrec_error:
	jmp	exit
;--------------------------	
edit_displayed:
	cmp	null_file_flag,0
	je	null_filek			;jmp if database empty
	mov	current_operation,3
	call	show_rec_status
	call	buffer_edit
	push	ax
	call	replace_record
	mov	current_operation,0
	pop	ax
	
ed_common:
	jc	edrec_error
	cmp	ax,0151h			;check for pgdn
	je	ed_pgdn
	cmp	ax,0149h
	jne	ed_exit
ed_pgup:
	mov	di,offset buffer
	call	dbase_read_prev
	jmp	ed_c
;-
ed_pgdn:
	mov	di,offset buffer
	call	dbase_read_next
ed_c:	cmp	al,0
	jne	edit_displayed
ed_d:	call	move_to_buffer
	jmp	edit_displayed
ed_exit:
	jmp	display_buffer
;--------------------------
find_record:
	cmp	null_file_flag,0
	je	null_filej			;jmp if database empty
	call	get_rec
	jc	fr_abort	
	mov	current_operation,0			
	mov	dx,new_rec
	call	fill_buffer
	jnc	fr_abort
	jmp	es_bad				;jmp if record not found
fr_abort:	
	jmp	display_buffer
;-----------
find_next:
	jmp	pgdn
find_prev:
	jmp	pgup
find_text:
	call	not_yet
	jmp	menu1
;--------------------------
delete_record:
	cmp	null_file_flag,0
	je	null_filej			;jmp if database empty
	call	get_rec
	jc	ed_exit				;jmp if no record# entered
	mov	dx,new_rec
	jmp	delete_cont
;--------------------------------
delete_displayed:
	cmp	null_file_flag,0
	je	null_filej			;jmp if database empty
	mov	dx,current_record
delete_cont:
	call	DBASE_REMOVE
	mov	cs:dirty_flag,1
	mov	dx,current_record
	call	dbase_read
	jnc	delete_cont2			;jmp if record found
;
; check if deleted record was at end of the database and no records follow
;
	dec	dx
	call	dbase_read
	jnc	delete_cont2			;jmp if record found
	mov	null_file_flag,1
	jmp	clear_and_display
delete_cont2:
	call	fill_buffer
	jmp	display_buffer

null_filej:
	jmp	null_file		
;--------------------------
move_record:
	call	not_yet
	jmp	menu1
;--------------------------
help:	apush	ax,bx,cx,dx,si,di,bp,ds,es
	mov	ax,cs
	mov	ds,ax
	mov	es,ax
	mov	ah,cs:_msg_text_color
	mov	al,0
	mov	bx,1040h
	mov	dx,0404h
	mov	cx,1
	mov	si,offset help_asciiz
	mov	bp,msg_save_win+msg_restore_win+msg_hyper+msg_close+msg_open+msg_disp
	call	message
	apop	es,ds,bp,di,si,dx,cx,bx,ax
	jmp	menu1
;--------------------------
pgup:
	cmp	null_file_flag,0
	je	null_filej			;jmp if database empty
	mov	di,offset buffer
	call	dbase_read_prev
	cmp	al,0
	jne	menu1_j
	call	move_to_buffer
	jmp	display_buffer
;--------------------------
pgdn:
	cmp	null_file_flag,0
	je	null_filej			;jmp if database empty
	mov	di,offset buffer
	call	dbase_read_next
	cmp	al,0
	jne	menu1_j
	call	move_to_buffer
	jmp	display_buffer

menu1_j:jmp	menu1
;--------------------------

; setup - main menu entry to change the program configuration
;
SETUP:	push	es
	push	ds
	pop	es
	call	change_setup
	call	establish_defaults
	pop	es
	jmp	clear_and_display
;--------------------------
quit:	cmp	cs:dirty_flag,0		;check if any changes make
	je	exit			; jmp if no changes make
;
; ask user if edits are to be saved or discarded
;	
	mov	bh,4			;rows in message
	mov	bl,40			;columns in message
	mov	dx,0814h		;message window location
	mov	si,offset exit_msg	;message text
	mov	bp,msg_yesno+msg_disp+msg_ram
	call	message			;display message & wait for yes/no
	cmp	al,'N'
	je	exit			;jmp if discarding changes
	call	dbase_close
	
exit:
	call	restore_path
	jnc	exit2			;jmp if no error
	mov	al,6
	mov	ah,fatal_return
	call	lib_error_handler1
exit2:	
;
; de-activate the Ctrl+Break trap
;	call	BREAK_KEY_RESTORE

; normal program exit

exitx:	mov	ax,0
	call	library_terminate
	mov	ax,4C00h
	int	21h
;
;---------------------------------------------------------------------------
;----------------------- local subroutines ---------------------------------
;---------------------------------------------------------------------------
; get_rec - ask user for record #
;   inputs: none
;   output: carry set if error
;
get_rec:	
	call	clear_string1
	mov	si,offset get_rec_msg
	mov	dx,1801h
	mov	ah,_pick_color
	mov	cx,79
	call	display_string_fill
	mov	dx,1830h
	mov	cl,5
	mov	di,offset string1
	push	es
	push	ds
	pop	es
	call	qget_string
	pop	es
	cmp	cx,-1
	je	gr_abort			;jmp if no string entered
	jcxz	gr_abort
	mov	si,offset string1
	call	DEC_STR_TO_WORD
	mov	new_rec,ax
	jmp	gr_exit
gr_abort:
	stc
gr_exit:		
	ret
	
; show_rec_status - display status for displayed record
;   inputs: none
;   outputs: none
;
show_rec_status:
	mov	si,offset edit1_msg
	mov	dx,1800h		;row 24 column 1
	mov	ah,_bar_text_color
	mov	cx,80			;max display rows
	call	display_string_fill

	mov	di,2*17+24*160			;display offset
	mov	ch,_bar_text_color
	mov	ax,current_record
	cmp	current_operation,1
	je	srs_append			;jmp if this is an append
	cmp	current_operation,2
	je	srs_insert
	call	WORD_TO_DEC_CRT
	jmp	srs_cont1

srs_append:
	mov	dx,1811h
	mov	si,offset append_msg
	mov	ah,ch
	call	display_string
	jmp	srs_cont1
srs_insert:		
	mov	dx,1811h
	mov	si,offset insert_msg
	mov	ah,ch
	call	display_string
srs_cont1:
;
; clear the top line
;
	mov	al,' '				;char to clear with
	mov	dx,0				;display address
	mov	cx,80				;display width
	call	repeat_put_crt
	ret
;---------------------------------------------------------------------------
; clear_buffer - clear the buffer for editing
;   inputs: none
;   output: none
;
clear_buffer:
	push	es
	mov	ax,ds
	mov	es,ax
	mov	buffer_ptr,offset buffer
	mov	current_record_len,0
	mov	cx,buffer_size
	mov	di,offset buffer
	cld
	mov	al,0
	rep	stosb
	pop	es
	ret
;---------------------------------------------------------------------------
; fill_buffer - move the record in dx,ah to buffer
;   inputs:  dx = record #
;  output:  dx = record#
;           cx = record length
;
fill_buffer:
;
; this record is not the current record, call database
;
fb_read:	call	DBASE_READ
		jnc	move_to_buffer		;jmp if read successful
		mov	dx,current_record
		jmp	fb_exit
;
; entry point follows, called as subroutine following calls to DBASE_READ,
;  dbase_read_prev, dbase_read_next
;
move_to_buffer:
		mov	current_record,dx
		mov	current_record_len,cx
		mov	current_record_ptr,si
fb_fill:	apush	ds,es
		apop	ds,es
		mov	di,offset buffer
		rep	movsb			;move record to buffer
		mov	byte ptr es:[di],0	;put zero at end
		apush	ds,es
		apop	ds,es
fb_exit:
		mov	cx,current_record_len
		ret
;---------------------------------------------------------------------------
; buffer_edit - edit the current buffer contents
;   inputs: buffer and database
;   output: ax=last key press
;
edit_flag	db	0

buffer_edit:
	mov	cs:edit_flag,0			;not changes to this record yet
	mov	si,offset buffer
	mov	di,buffer_ptr
	mov	bx,box_size
	mov	dx,box_location
	mov	cx,buffer_size
	call	window_edit
	jnc	be_exit
	mov	cs:dirty_flag,1			;the file was changed
	mov	cs:edit_flag,1			;the buffer was changed.
be_exit:		
	ret
;---------------------------------------------------------------------------
; append_record  -  append record to database
;
append_record:
	mov	bx,offset buffer
	call	strlen3
	mov	di,offset buffer
	call	dbase_append
	mov	current_record,dx
	ret
;---------------------------------------------------------------------------
; replace_record  -  replace current record in database
;   inputs:  none
;   output:
;            dx = record #
;
replace_record:
	cmp	cs:edit_flag,0
	je	rr_exit  			;jump if no changes make
	mov	bx,offset buffer
	call	strlen3
	mov	di,offset buffer
	mov	dx,current_record
	call	dbase_replace
	mov	current_record,dx
rr_exit:ret
;---------------------------------------------------------------------------
; insert_record  -  insert before current record in database
;
insert_record:
	mov	bx,offset buffer
	call	strlen3
	mov	di,offset buffer
	mov	dx,current_record
	call	dbase_insert
	mov	current_record,dx
	ret
;---------------------------------------------------------------------------
; clear_string1 - clear input buffer
;  inputs: none
;  oputput: none
;
clear_string1:
	apush	ax,cx,di,es
	mov	ax,ds
	mov	es,ax
	mov	di,offset string1
	cld
	mov	al,0
	mov	cx,8
	rep	stosb
	apop	es,di,cx,ax
	ret
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
	je	aq_no_file 		;jmp if file not found
aq_test_file:
	mov	si,offset file_asciiz
	call	expand_filename
	jnc	aq_exit		;jmp if file ok
	jmp	aq_ask_create
;
; the filename was not specified on the command line, ask user for it
;
aq_no_file:
	mov	si,offset aq_msg2
	mov	dx,0408h		;row 4 column 8
	mov	ah,_pick_color
	call	display_string
	call	flush_keyboard		;clear out any keys
	mov	dx,0432h
	mov	cl,12
	mov	di,offset file_asciiz
	call	qget_string
	jmp	aq_test_file
;
; specified file was not found, create or abort?
;
aq_ask_create:
	mov	si,offset aq_msg1
	mov	dx,0308h		;row 3 column 8
	mov	ah,_pick_color
	call	display_string		;say file was not found
	call	yes_or_no		;ask if file create
	cmp	al,'Y'
	je	aq_create		;jmp if file create
	stc
	jmp	aq_exit			;abort	
;
; create a new file
;
aq_create:
	mov	file_create_flag,1
aq_exit:
	ret
;---------------------------------------------------------------------------
aq_msg1	db 'The specified file was not found, do you want to create file? (Y/N)',0
aq_msg2	db 'Enter edit file name ',0
;--------------------------------------------------------------------------
; read_setup - read setup block from disk if avail.

read_setup:
	les	bx,dword ptr lib_info_ptr	;get library info structure
	cmp	es:[bx.mono_flag],0		;check if mono display
	jne	mono_setup
;
; set color attributes as default
;
	mov	si,offset color_defaults
	jmp	move_colors
mono_setup:
	mov	si,offset mono_defaults
move_colors:
	lodsb
	mov	_bar_text_color,al
	lodsb
	mov	_bar_select_color,al
	lodsb
	mov	_bar_hotkey_color,al
	lodsb
	mov	_submenu_text_color,al
	lodsb
	mov	_submenu_select_color,al
	lodsb
	mov	_msg_text_color,al			
	lodsb
	mov	_msg_hyper_color,al
	lodsb
	mov	_pick_color,al
	lodsb
	mov	_pick_select_color,al
;
; get setup block from disk if present, if not then write defaults to disk
;	
	mov	si,offset setup_block
	call	get_setup
	cmp	al,0			;check if setup ok
	je	setup_ok
	
	mov	al,2
	mov	ah,fatal_return
	call	lib_error_handler1

setup_ok:		

	ret
;--------------------------------------------------------------------------
; establish_defaults - compute setup info.
;
establish_defaults:
	push	cs
	pop	ds
;
; set the display box size
;
	mov	al,xbox_l
	mov	cs:box_rows,al

	mov	al,xbox_w
	mov	cs:box_cols,al
;
; center the box on the screen
;
	push	es
	les	si,dword ptr ds:lib_info_ptr
	
	sub	ax,ax
	mov	al,es:[si].crt_rows
	sub	al,byte ptr ds:box_size+1	;compute free rows
	shr	al,1
	mov	byte ptr ds:box_location+1,al	;store starting row

	mov	al,es:[si].crt_columns
	sub	al,byte ptr ds:box_size		;compute free rows
	shr	al,1
	mov	byte ptr ds:box_location,al
	pop	es
		
	ret

;---------------------------------------------------------------------------
; not_yet - display feature not available message
;
not_yet:
     	apush	ax,bx,cx,dx,si,di,bp,ds,es
	mov	ax,cs
	mov	ds,ax
	mov	es,ax
	mov	ah,cs:_msg_text_color
	mov	al,0
	mov	bx,0840h
	mov	dx,0808h
	mov	si,offset not_yet_msg
	mov	bp,msg_save_win+msg_restore_win+msg_anykey+msg_ram+msg_disp
	call	message
	apop	es,ds,bp,di,si,dx,cx,bx,ax

	ret
;---------------------------------------------------------------------------

stacksize	equ	1024
	db	stacksize dup (0)
stack_	label	word
;
copyright_msg	label	byte
 db 'Edit      Record',0dh,0ah
 db 'ллллллл   лллллм     лллллллл   лллллллл   лллллллл',0dh,0ah
 db 'лл        лл   плл   лл    лл   лл         лл      ',0dh,0ah
 db 'лл        лл    лл   лл    лл   лл         лл      ',0dh,0ah
 db 'ллллллл   лл    лл   лллллллл   лллллллл   лл      ',0dh,0ah
 db 'лл        лл    лл   лллл       лл         лл      ',0dh,0ah
 db 'лл        лл   млл   лл ллл     лл         лл      ',0dh,0ah
 db 'ллллллл   лллллп     лл   ллл   лллллллл   лллллллл',0dh,0ah
 db 'Copyright 1994 Owens Consulting',0dh,0ah
 db 0


menu1_def	label	byte
	db	0			;m_flag
	db	0			;top row
	db	0			;left column
	db	1			;total rows
	db	80			;total columns
	db	7			;menu options
	dw	0			;main selection
	dw	0			;sub selection
; main option #0 -EDIT-
	db	4			;e_count
	db	16			;e_sub_length
	db	18			;e_hot_key (alt-e)
	db	4			;e_length
	dw	main_opt0_text		;e_text_ptr
	dw	sub0_struc		;e_process
	db	1			;e_column
	db	0			;e_row
; main option #1 -FIND-
	db	4			;e_count
	db	12			;e_sub_length
	db	33			;e_hot_key (alt-f)
	db	4			;e_length
	dw	main_opt1_text		;e_text_ptr
	dw	sub1_struc		;e_process
	db	7			;e_column
	db	0			;e_row
; main option #2 -DELETE-
	db	2			;e_count
	db	15			;e_sub_length
	db	32			;e_hot_key (alt-d)
	db	6			;e_length
	dw	main_opt2_text		;e_text_ptr
	dw	sub2_struc   		;e_process
	db	13			;e_column
	db	0			;e_row
; main option #3 -MOVE-
	db	0			;e_count
	db	0			;e_sub_length
	db	50			;e_hot_key (alt-m)
	db	4			;e_length
	dw	main_opt3_text		;e_text_ptr
	dw	MOVE_RECORD		;e_process
	db	21			;e_column
	db	0			;e_row
; main option #4 -CONFIG-
	db	0			;e_count
	db	0			;e_sub_length
	db	46			;e_hot_key (alt-c)
	db	6			;e_length
	dw	main_opt4_text		;e_text_ptr
	dw	SETUP      		;e_process
	db	27			;e_column
	db	0			;e_row
; main option #5 -HELP-
	db	0			;e_count
	db	0			;e_sub_length
	db	35			;e_hot_key (alt-h)
	db	4			;e_length
	dw	main_opt5_text		;e_text_ptr
	dw	HELP       		;e_process
	db	35			;e_column
	db	0			;e_row
; main option #6 -QUIT-
	db	0			;e_count
	db	0			;e_sub_length
	db	16			;e_hot_key (alt-q)
	db	4			;e_length
	dw	main_opt6_text		;e_text_ptr
	dw	quit       		;e_process
	db	41			;e_column
	db	0			;e_row
; main option #7 -PGUP-
	db	0			;e_count
	db	0 			;e_sub_length
	db	49H			;e_hot_key (pgup)
	db	5			;e_length
	dw	main_opt7_text		;e_text_ptr
	dw	pgup      		;e_process
	db	46			;e_column
	db	0			;e_row
; main option #8 -PGDN-
	db	0			;e_count
	db	0 			;e_sub_length
	db	51H			;e_hot_key (pgdn)
	db	5			;e_length
	dw	main_opt8_text		;e_text_ptr
	dw	pgdn       		;e_process
	db	52			;e_column
	db	0			;e_row
; main option end, dummy option
	db	0			;e_count
	db	0			;e_sub_length
	db	00			;e_hot_key (none)
	db	0			;e_length
	dw	0             		;e_text_ptr
	dw	0			;e_process
	db	0			;e_column
	db	0			;e_row

main_opt0_text     db 'Edit',0
main_opt1_text     db 'Find',0
main_opt2_text     db 'Delete',0
main_opt3_text     db 'Move',0
main_opt4_text     db 'Config',0
main_opt5_text     db 'Help',0
main_opt6_text     db 'Quit',0
main_opt7_text     db ' PGUP',0
main_opt8_text     db ' PGDN',0

sub0_struc	label	byte
;				-EDIT DISPLAYED-
	db	0			;e_count
	db	0			;e_sub_length
	db	00h			;e_hot_key (none)
	db	13			;e_length
	dw	sub0_text4		;e_text_ptr
	dw	edit_displayed		;e_process
	db	2			;e_column
	db	2			;e_row
;				-NEW APPEND-
	db	0			;e_count
	db	0			;e_sub_length
	db	00h			;e_hot_key (none)
	db	10			;e_length
	dw	sub0_text1		;e_text_ptr
	dw	edit_append		;e_process
	db	2			;e_column
	db	3			;e_row
;				-NEW INSERT-
	db	0			;e_count
	db	0			;e_sub_length
	db	00h			;e_hot_key (none)
	db	10			;e_length
	dw	sub0_text2		;e_text_ptr
	dw	edit_insert		;e_process
	db	2			;e_column
	db	4			;e_row
;				-SELECT RECORD#-
	db	0			;e_count
	db	0			;e_sub_length
	db	00h			;e_hot_key (none)
	db	14			;e_length
	dw	sub0_text3		;e_text_ptr
	dw	edit_selected		;e_process
	db	2			;e_column
	db	5			;e_row

sub0_text1      db      'Edit for append',0
sub0_text2      db      'Edit for insert',0
sub0_text3      db      'Select record',0
sub0_text4	db	'Edit displayed',0
;------
sub1_struc	label	byte
;				-RECORD #-
	db	0			;e_count
	db	0			;e_sub_length
	db	00h			;e_hot_key (none)
	db	8 			;e_length
	dw	sub1_text1		;e_text_ptr
	dw	find_record		;e_process
	db	8			;e_column
	db	2			;e_row
;				-NEXT (PGDN)-
	db	0			;e_count
	db	0			;e_sub_length
	db	00h			;e_hot_key (none)
	db	11			;e_length
	dw	sub1_text2		;e_text_ptr
	dw	find_next		;e_process
	db	8			;e_column
	db	3			;e_row
;				-PREV (PGUP)-
	db	0			;e_count
	db	0			;e_sub_length
	db	00h			;e_hot_key (none)
	db	11			;e_length
	dw	sub1_text3		;e_text_ptr
	dw	find_prev    		;e_process
	db	8			;e_column
	db	4			;e_row
;				-TEXT-
	db	0			;e_count
	db	0			;e_sub_length
	db	00h			;e_hot_key (none)
	db	04			;e_length
	dw	sub1_text4		;e_text_ptr
	dw	find_text		;e_process
	db	8			;e_column
	db	5			;e_row

sub1_text1      db      'Record #',0
sub1_text2      db      'Next (pgdn)',0
sub1_text3      db      'Prev (pgup)',0
sub1_text4	db	'text',0
;------
sub2_struc	label	byte
;				-DISPLAYED-
	db	0			;e_count
	db	0			;e_sub_length
	db	00h			;e_hot_key (none)
	db	09			;e_length
	dw	sub2_text2		;e_text_ptr
	dw	delete_displayed	;e_process
	db	14			;e_column
	db	2			;e_row
;				-RECORD #-
	db	0			;e_count
	db	0			;e_sub_length
	db	00h			;e_hot_key (none)
	db	8 			;e_length
	dw	sub2_text1		;e_text_ptr
	dw	delete_record		;e_process
	db	14			;e_column
	db	3			;e_row

sub2_text1      db      'Record #',0
sub2_text2      db      'Displayed',0
;------

;
; default colors for mono display
;
mono_defaults	label	byte
     Db      07h       ;bar text color
     db      70h       ;bar select color
     db      0fh       ;bar hotkey color
     db      0fh       ;submenu text color
     db      07h       ;submenu select color
     db      07h       ;msg text color
     db      70h       ;msg hyper color
     db      0fh       ;pick color
     db      70h       ;pick select color

     db      07h       ;appication color
          
color_defaults	label	byte
     Db      1fh       ;bar text color
     db      3eh       ;bar select color
     db      3ch       ;bar hotkey color
     db      1eh       ;submenu text color
     db      70h       ;submenu select color
     db      07h       ;msg text color
     db      70h       ;msg hyper color
     db      0fh       ;pick color
     db      70h       ;pick select color

     db      07h       ;applicaton color
;--------------------------------------------------------------------------
;
; Note: This data has a disk image which can be modified by the user
;
setup_block	label	byte
;-----------------
; colors - The first 9 colors which follow are used by library display
;	   routines and can not be removed or the order changed.  This
;	   program can utilize these colors or add additional colors at
;	   end.
;
;-----------------
        db      '<<COLORS - use right/left arrow to change>>',0
;
			db	4		;data type = 4 (color)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	0ffh		;maximum value
_bar_text_color		Db	07,'menu text color',0
;
			db	4		;data type = 4 (color)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	0ffh		;maximum value
_bar_select_color	db	70h,'menu select color',0
;
			db	4		;data type = 4 (color)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	0ffh		;maximum value
_bar_hotkey_color	db	0fh,'hotkey color',0
;
			db	4		;data type = 4 (color)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	0ffh		;maximum value
_submenu_text_color	db	0fh,'submenu color',0
;
			db	4		;data type = 4 (color)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	0ffh		;maximum value
_submenu_select_color	db	70h,'submenu select color',0
;
			db	4		;data type = 4 (color)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	0ffh		;maximum value
_msg_text_color		db	07h,'message window text color',0
;
			db	4		;data type = 4 (color)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	0ffh		;maximum value
_msg_hyper_color	db	70h,'message window hyper key color',0
;
			db	4		;data type = 4 (color)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	0ffh		;maximum value
_pick_color		db	07h,'pick from list, window color',0
;
			db	4		;data type = 4 (color)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	0ffh		;maximum value
_pick_select_color	db	70h,'pick from list, window select color',0

; the following color has been defined by EDREC and is not used by
; library functions.

			db	4		;data type = 4 (color)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	0ffh		;maximum value
app_text_color		db	07h,'background color',0


;------------------
; setup strings
;------------------
        db      '<<MISC program settings>>',0
;
			db	3		;data type = 3 (decimal value)
			db	1		;data length = 1 byte
			db	5		;minimum value
			db	78		;maximum value
xbox_w			db	60		;current setting (default)
			db	'displayed record, box width ',0
	
;
			db	3		;data type = 3 (decimal value)
			db	1		;data length = 1 byte
			db	3		;minimum value
			db	21		;maximum value
xbox_l			db	8		;current setting (default)
			db	'displayed record, box lenght',0
;
			db	1		;data type = 1 (boolean flag)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	1		;maximum value
sounds			db	1		;current setting (on)
			db	'Error sounds (ON or OFF)',0
        db      '<<end>>',0
;
	
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
