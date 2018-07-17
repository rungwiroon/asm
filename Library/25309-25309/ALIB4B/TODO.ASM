;***************************** TODO.ASM   **********************************
PAGE  70,132
COMMENT 
                              TODO (todo list organizer)
                              Version 1.0
                              --------------------


     Purpose
     -------


     


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
	extrn	dec_str2_to_word:far
	extrn	WORD_TO_DEC_CRT:far
	extrn	get_setup:far
	extrn	save_window:far
	extrn	restore_window:far
	extrn	window_string:far
	extrn	flush_keyboard:far
	extrn	set_lib_colors:far
	extrn	window_cstring:far
	extrn	strlen3:far
	extrn	to_upper:far
	extrn	yes_or_no:far
	extrn	file_exist:far
	extrn	word_to_dec_str:far
	extrn	word_to_dec_strl:far
	extrn	get_date:far
	extrn	stdout_char:far
	extrn	sbyte_to_dec_str:far
	extrn	key_read:far
	extrn	display_text:far
	extrn	get_menu_cursor:far
	extrn	set_menu_cursor:far
	extrn	cursor_:far
	extrn	month_days:far
	extrn	get_day:far
	extrn	merge_sort_file:far
	extrn	fd_init:far
	extrn	fd_close:far
	extrn	fd_read:far
	extrn	fd_read_prev:far
	extrn	fd_read_next:far
	extrn	fd_replace:far
	extrn	fd_remove:far
	extrn	fd_close:far
	extrn	fd_append:far
	extrn	asc2_to_bin:far
	extrn	bin_date_to_asc2:far
	extrn	asc2_to_date:far
	extrn	date_to_asc2:far
	extrn	day_to_ascii:far
	
;------------------------------------------------------------------------------
code		segment para public 'CODE'
		assume	cs:code, ds:code
;-----------------------------------------------------------------------------
; 
pspseg		dw	0
lib_info_ptr	dw	0
lib_info_seg	dw	0
data_seg	dw	0

msg_size	equ	66
rec_struc	struc
 year		db	'yyyy'
 		db	'/'
 month		db	'mm'
 		db	'/'
 day		db	'dd'
 		db	' '
 resched	db	'  '
 		db	' '
 msg		db	msg_size dup (' ')
 		db	0dh,0ah
rec_struc	ends

record_size	equ	size rec_struc	;database record size

today_bin_year	dw	0	;year 1980 - 2099
today_bin_month	db	0	;month 1-12
today_bin_day	db	0	;day of month
today_bin_wday	db	0	;day of week (0-6) 0=sunday

today_asc_year	db	'xxxx','/'
today_asc_month	db	'xx','/'
today_asc_day	db	'xx','/'

top_display_rec	dw	0	;top record of current display (-1=none)
selected_rec	dw	0	;current highlighted record (-1=none)

page_size	equ	24
crt_start_adr	equ	0100h	;used by show_rec
crt_end_adr	equ	0100h+page_size*100h	;final display location

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

	call	read_setup			;get config file
	call	ck_for_datafile			;asciiz -> ds:dx
	jc	cant_create
;
; ds:dx = pointer to asciiz file name
;    ax = record size in bytes
;
	mov	ax,record_size
	call	fd_init				;initialize database
	jc	cant_init
	mov	cs:data_seg,bx
;
; ax = 0 if fd_init found data, use to initialize display ptrs
;
	mov	top_display_rec,ax
	mov	selected_rec,ax
	cmp	ax,0
	je	store_date
	mov	top_display_rec,-1
	mov	selected_rec,-1
	jmp	store_date
cant_create:
cant_init:
	mov	al,6
	mov	ah,fatal_return
	call	lib_error_handler1
	jmp	exit2
store_date:
	call	get_date		;dx=year ah=month al=mday cl=wday
	mov	today_bin_year,dx
	mov	today_bin_month,ah
	mov	today_bin_day,al
	mov	today_bin_wday,cl

	mov	ax,today_bin_year
	mov	si,offset today_asc_year
	call	word_to_dec_strl

	mov	al,today_bin_month
	mov	si,offset today_asc_month
	call	sbyte_to_dec_str

	mov	al,today_bin_day
	mov	si,offset today_asc_day
	call	sbyte_to_dec_str

	call	put_date_in_menu
;
	call	init_for_edit

display_todo:
;
; clear the screen
;
	mov	ah,app_text_color
	mov	al,' '
	call	clear_screen

	call	show_summary
		

;
; show menu bar and wait for selection
;
menu1:	mov	bx,offset menu1_def
	mov	ah,08h+20h		;restore bar & return unknown keys
	call	MENU_SYSTEM
	mov	es,data_seg		;point ES at database
	cmp	cl,1			;check if process key
	jne	menu1_d2		;jmp if not process hit
	jmp	ax
	jmp	menu1			;go do it again
menu1_d2:
	cmp	cl,4			;check if abort key
	je	exit_todo
	cmp	cl,3
	je	mouse			;jmp if mouse
	cmp	al,51h
	je	pgdn
	cmp	al,49h
	je	pgup
	jmp	menu1
	
;---------------------------------------------------------------------------
; top level menu executables
;---------------------------------------------------------------------------

pgup:
	call	pageup
	jmp	display_todo
pgdn:
	call	pagedown
	jmp	display_todo
add_todo:
	call	addtodo
	jmp	display_todo
modify_todo:
	call	modifytodo
	jmp	display_todo
setup_todo:
	call	setuptodo
	jmp	display_todo
ascii_char:
	call	asciichar
	jmp	display_todo
mouse:	call	mouse_process
	jmp	display_todo
;
; close database
;
exit_todo:
	mov	es,data_seg		;make sure ES points at data
	call	fd_close
	call	restore_path
	jnc	exit2			;jmp if no error
	mov	al,6
	mov	ah,fatal_return
	call	lib_error_handler1
exit2:	

exitx:	mov	ax,0
	call	library_terminate
	mov	ax,4C00h
	int	21h
;---------------------------------------------------------------------------
pageup:	mov	bx,top_display_rec
	call	fd_read			;set carry if error or end of data
	call	fd_read_prev
	jc	pu_done			;jmp if no previous data
	mov	cx,page_size -1
pu_loop:call	fd_read_prev
	jc	pu_set
	loop	pu_loop
pu_set:	mov	top_display_rec,bx
	mov	selected_rec,bx
pu_done:	
	ret
	
pagedown:
	mov	bx,top_display_rec
	call	fd_read			;set carry if error or end of data
	call	fd_read_next
	jc	pd_done			;jmp if no more data
	mov	cx,page_size -1
pd_loop:call	fd_read_next
	jc	pd_done
	loop	pd_loop
pd_set:	mov	top_display_rec,bx
	mov	selected_rec,bx
pd_done:
	ret
	
	
addtodo:
	mov	al,0			;indicate append
	call	edit_record
	ret
	
modifytodo:
	mov	bx,selected_rec		;get record# to be modified
	mov	al,1			;indicate modify
	call	edit_record
	ret
	
setuptodo:
	push	es
	push	ds
	pop	es
	call	change_setup
	call	read_setup
	pop	es
	ret
	
asciichar:
	mov	si,offset a_msg
	mov	ah,app_text_color
	mov	dx,0308h		;display row 03 column xx
	call	display_string
	ret
a_msg	db	'ascii char',0dh,0ah,0

mouse_process:				;mouse posn is in -ax-
	mov	di,offset rec_table
	mov	cx,crt_start_adr
mp_loop:
	cmp	word ptr [di],-1	;valad record here
	je	mp_done			;exit if end of display
	cmp	ah,ch			;match
	je	mp_match		;jmp if record found
	add	di,2			;move to next record
	add	cx,0100h		;move down a line
	jmp	mp_loop
mp_match:
	mov	ax,word ptr [di]	;get record
	cmp	ax,selected_rec		;check if double click
	jne	mp_set
	call	resched_and_sort
	jmp	mp_done
mp_set:	mov	selected_rec,ax
mp_done:
	ret	
;---------------------------------------------------------------------------
; general subroutines
;---------------------------------------------------------------------------
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
;---------------------------------------------------------------------------
; ck_for_datafile - get file with todo list
;   inputs: 	none
;   outputs:    carry = aborting, problems
;            no carry = done
;
ck_for_datafile:
	mov	ax,cs
	mov	es,ax
aq_test_file:
	mov	si,offset file_asciiz
	call	expand_filename
	jc	aq_exit		;jmp if file error
;
; open the file	
;
	mov	dx,offset file_asciiz
	call	file_exist	;ds:dx = asciiz file ptr
	jnc	aq_exit		;jmp if file exists
;
; create file
;
	mov	ah,3ch		;file create
	mov	cx,0		;normal read/write file
	int	21h		;ds:dx = file asciiz
aq_exit:
	ret

;-------------------------------------------------------------------------
; resched_and_sort - todo was completed, process it
;  inputs: ax = record # completed
;  ouptut: ax = next record
;  processing 1. modify record
;             2. write/close file
;             3. sort file
;             4. re-open file and initialize
;             5. set top_display_rec
;             6. select next sequential record for selected_rec
;           
resched_and_sort:
	mov	bx,ax		;get record #
	call	fd_read		;returns es:si ptr to record
	mov	ax,word ptr es:[si.resched]
	xchg	ah,al
	mov	di,offset resched_table
rs_lp:	cmp	word ptr [di],0
	je	rs_exit
	cmp	ax,word ptr [di]
	je	rs_process
	add	di,4
	jmp	rs_lp
rs_process:
	mov	ax,word ptr [di+2]
	call	ax
	mov	bx,selected_rec
	call	fd_replace
	call	sort
rs_exit:	
	ret

resched_table:
	dw	'D0',rs_once
	dw	'D1',rs_daily
	dw	'W1',rs_weekly
	dw	'W2',rs_weekly2
	dw	'W3',rs_weekly3
	dw	'W4',rs_weekly4
	dw	'M1',rs_monthly1
	dw	'M2',rs_monthly2
	dw	'M3',rs_monthly3
	dw	'M4',rs_monthly4
	dw	'M5',rs_monthly5
	dw	'M6',rs_monthly6
	dw	'M7',rs_monthly7
	dw	'M8',rs_monthly8
	dw	'M9',rs_monthly9
	dw	'MA',rs_monyhlya
	dw	'MB',rs_monyhlyb
	dw	'ME',rs_monthlye
        dw	'Y1',rs_yearly
        
        dw	'11',rs_11
        dw	'12',rs_12
        dw	'13',rs_13
        dw	'14',rs_14
        dw	'15',rs_15
        dw	'16',rs_16
        dw	'17',rs_17
        
        dw	'21',rs_21
        dw	'22',rs_22
        dw	'23',rs_23
        dw	'24',rs_24
        dw	'25',rs_25
        dw	'26',rs_26
        dw	'27',rs_27
        
        dw	'31',rs_31
        dw	'32',rs_32
        dw	'33',rs_33
        dw	'34',rs_34
        dw	'35',rs_35
        dw	'36',rs_36
        dw	'37',rs_37
        
        dw	'41',rs_41
        dw	'42',rs_42
        dw	'43',rs_43
        dw	'44',rs_44
        dw	'45',rs_45
        dw	'46',rs_46
        dw	'47',rs_47
        
	dw	0,0		;end of table


rs_once:
	mov	bx,selected_rec
	call	fd_remove
	ret
rs_daily:
	mov	di,si			;get ptr to record in -di-
	call	asc2_to_bin
	inc	ax
	call	bin_date_to_asc2
	ret

temp	dw	0
rs_weekly:
	mov	cs:temp,7
	jmp	rs_week
rs_weekly2:
	mov	cs:temp,2*7
	jmp	rs_week
rs_weekly3:
	mov	cs:temp,3*7
	jmp	rs_week
	ret
rs_weekly4:
	mov	cs:temp,4*7
rs_week:
	mov	di,si			;get ptr to record in -di-
	call	asc2_to_bin
	add	ax,cs:temp
	call	bin_date_to_asc2
	ret

month_temp	db	0
rs_monthly1:
	mov	month_temp,1
	jmp	rs_month
rs_monthly2:
	mov	month_temp,2
	jmp	rs_month
rs_monthly3:
	mov	month_temp,3
	jmp	rs_month
rs_monthly4:
	mov	month_temp,4
	jmp	rs_month
rs_monthly5:
	mov	month_temp,5
	jmp	rs_month
rs_monthly6:
	mov	month_temp,6
	jmp	rs_month
rs_monthly7:
	mov	month_temp,7
	jmp	rs_month
rs_monthly8:
	mov	month_temp,8
	jmp	rs_month
rs_monthly9:
	mov	month_temp,9
	jmp	rs_month
rs_monyhlya:
	mov	month_temp,10
	jmp	rs_month
rs_monyhlyb:
	mov	month_temp,11

rs_month:
	mov	di,si			;get ptr to record in -di-
	call	asc2_to_date		;set dx=year ah=month al=day
	add	ah,cs:month_temp
	cmp	ah,12
	jbe	rs_month_x
	sub	ah,12			;take mod function on month
	inc	dx			;bump year
rs_month_x:
	push	ax
	mov	bl,ah
	mov	bh,0
	mov	ax,dx
	call	month_days		;set bx=days in month
	pop	ax
	cmp	bl,al			;check if date falls in new month
	jae	rs_month_y		;jmp if date ok
	mov	al,bl
rs_month_y:
	call	date_to_asc2
	ret	

rs_monthlye:				;month ends
	mov	di,si			;get ptr to record in -di-
	call	asc2_to_date		;set dx=year ah=month al=day
	add	ah,1
	cmp	ah,12
	jbe	rs_month_z
	sub	ah,12			;take mod function on month
	inc	dx			;bump year
rs_month_z:
	push	ax
	mov	bl,ah
	mov	bh,0
	mov	ax,dx
	call	month_days		;set bx=days in month
	pop	ax
	mov	al,bl
	call	date_to_asc2
	ret	
	
rs_yearly:
	push	ds
	mov	bx,es
	mov	ds,bx
	mov	cx,4
	push	si
	call	dec_str2_to_word	;year is returned in -bx-
	inc	bx			;move to next year
	mov	ax,bx
	pop	si			;
	call	word_to_dec_strl	;-ax- to ds:si
	pop	ds

	mov	bx,selected_rec
	call	fd_replace
	call	sort
	ret

;
; the followng rs_temp is not used at present, nor is all these values
; jumps necessary.
;
rs_temp	db	0
rs_11:
	mov	rs_temp,1
	jmp	rs_90
rs_12:
	mov	rs_temp,2
	jmp	rs_90
rs_13:
	mov	rs_temp,3
	jmp	rs_90
rs_14:
	mov	rs_temp,4
	jmp	rs_90
rs_15:
	mov	rs_temp,5
	jmp	rs_90
rs_16:
	mov	rs_temp,6
	jmp	rs_90
rs_17:
	mov	rs_temp,7
	jmp	rs_90

rs_21:
	mov	rs_temp,8
	jmp	rs_90
rs_22:
	mov	rs_temp,9
	jmp	rs_90
rs_23:
	mov	rs_temp,10
	jmp	rs_90
rs_24:
	mov	rs_temp,12
	jmp	rs_90
rs_25:
	mov	rs_temp,13
	jmp	rs_90
rs_26:
	mov	rs_temp,14
	jmp	rs_90
rs_27:
	mov	rs_temp,15
	jmp	rs_90

rs_31:
	mov	rs_temp,16
	jmp	rs_90
rs_32:
	mov	rs_temp,17
	jmp	rs_90
rs_33:
	mov	rs_temp,18
	jmp	rs_90
rs_34:
	mov	rs_temp,19
	jmp	rs_90
rs_35:
	mov	rs_temp,20
	jmp	rs_90
rs_36:
	mov	rs_temp,21
	jmp	rs_90
rs_37:
	mov	rs_temp,22
	jmp	rs_90

rs_41:
	mov	rs_temp,22
	jmp	rs_90
rs_42:
	mov	rs_temp,23
	jmp	rs_90
rs_43:
	mov	rs_temp,24
	jmp	rs_90
rs_44:
	mov	rs_temp,25
	jmp	rs_90
rs_45:
	mov	rs_temp,26
	jmp	rs_90
rs_46:
	mov	rs_temp,27
	jmp	rs_90
rs_47:
	mov	rs_temp,28

rs_90:	mov	di,si			;get ptr to record in -di-
	push	bx
	call	asc2_to_date		;set dx=year ah=month al=day
	inc	ah
	cmp	ah,12
	jbe	rs_month_v
	sub	ah,12			;take mod function on month
	inc	dx			;bump year
rs_month_v:
	mov	bx,word ptr es:[si.resched]
	and	bx,0f0fh		;strip off ascii
	
	mov	al,0
rs_md:	inc	al
	call	get_day			;cl = day of week
	inc	cl			;convert to 1-7
	cmp	cl,bl			;day match?
	jne	rs_md			;loop till day mataches

rs_mdl:	cmp	bh,1
	je	rs_md2
	add	al,7
	dec	bh
	jmp	rs_mdl
rs_md2:	
	call	date_to_asc2
	pop	bx
	ret	
;---------------------------------------------------------------------
; sort - close, sort, and re-open
;
sort:					;warning -- entry point
	call	fd_close		;close the file

	push	ds
	pop	es
	mov	di,offset file_asciiz
	mov	bx,record_size	;
	mov	al,0			;fixed lenght record
	mov	dx,0			;starting_column
	mov	ah,10			;field_length
	call	merge_sort_file	

	mov	dx,cs
	mov	ds,dx
	mov	dx,offset file_asciiz
	mov	ax,record_size
	call	fd_init
	mov	cs:data_seg,bx
	mov	es,bx
	ret
;---------------------------------------------------------------------------
; init_for_edit - setup for edit
;  inputs: 
;  outputs:
;
init_for_edit:
	mov	si,offset yr_stuff2
	mov	cx,6
year_loop:
	mov	ax,today_bin_year
	call	word_to_dec_strl	;store year in message
	mov	si,','			;repair message
	inc	si
	inc	ax			;move to next year
	loop	year_loop
	ret
;---------------------------------------------------------------------------
; show_summary - display screen of todo's
;
;  inputs: 
;  outputs:
;
nxt_display_rec	dw	0
nxt_display_loc	dw	0

rt_struc	struc
 ss_rec		dw	?
rt_struc	ends

rec_table_ptr	dw	0
rec_table	rt_struc	page_size+1	dup (<-1>)

show_summary:
	mov	ax,offset rec_table
	mov	rec_table_ptr,ax
	
	mov	es,data_seg
	mov	bx,top_display_rec
	cmp	bx,-1			;check for null file
	je	ss_exit			; jmp if no data
	mov	nxt_display_rec,bx
	mov	nxt_display_loc,crt_start_adr 	;set display location
	call	fd_read			;set es:si to next rec
	jc	ss_exit			;jmp if no data
ss_loop:
	mov	di,rec_table_ptr
	mov	word ptr [di],bx	;save this record #
	add	rec_table_ptr,size rt_struc
	
	call	show_line
	add	dx,0100h		;move to next line
	cmp	dx,crt_end_adr		;check if done
	je	ss_exit			;exit if end of display
	mov	nxt_display_loc,dx
	call	fd_read_next
	jc	ss_exit
	mov	nxt_display_rec,bx
	jmp	ss_loop	
ss_exit:
	mov	di,rec_table_ptr
	mov	word ptr [di],-1	;terminate rec table
	ret	
;-------------------------------------------------------------------------
; put_date_in_menu  -  move date to menu line
;  inputs:  see data definitions
;  outputs: none
;
put_date_in_menu:
	mov	ax,today_bin_year
	mov	si,offset mstuff_year
	call	word_to_dec_strl

	mov	al,today_bin_month
	mov	si,offset mstuff_month
	call	sbyte_to_dec_str

	mov	al,today_bin_day
	mov	si,offset mstuff_day
	call	sbyte_to_dec_str

	mov	ch,0
	mov	cl,today_bin_wday
	inc	cl
	call	day_to_ascii
	mov	si,offset main_opt8_text

pdl:	mov	al,byte ptr es:[di]
	mov	byte ptr ds:[si],al
	inc	di
	inc	si
	loop	pdl
	
	ret


;--------------------------------------------------------------------------
; show_line - display one line to screen
;  inputs:
;  output:
;
show_line:
	mov	ah,app_text_color
	cmp	bx,selected_rec
	jne	sl_01			;jmp if not selected
	mov	ah,entry_text_color
	jmp	sl_02
;
; check if date past due
;
sl_01:	push	si
	mov	di,offset today_asc_year
	xchg	si,di
	mov	cx,10
	rep	cmpsb
	pop	si
	jb	sl_02			;jmp if future date
	mov	ah,past_due_color
	
sl_02:	mov	dx,nxt_display_loc
	mov	cx,record_size
	sub	cx,2
	push	ds
	mov	ds,data_seg
	call	display_text
	pop	ds
	ret
;---------------------------------------------------------------------------
; local database
;---------------------------------------------------------------------------
stacksize	equ	1024
	db	stacksize dup (0)
stack_	label	word
;
file_asciiz	db	'todo.dat',0,'work area to expand file path, save!!!'
		db      'leave this text here'
file_create_flag db	0

menu1_def	label	byte
	db	0			;m_flag
	db	0			;top row
	db	0			;left column
	db	1			;total rows
	db	80			;total columns
	db	8			;menu options
	dw	0			;main selection
	dw	0			;sub selection
; main option #0 -ADD-
	db	0			;e_count
	db	0 			;e_sub_length
	db	30			;e_hot_key (alt-a)
	db	3			;e_length
	dw	main_opt0_text		;e_text_ptr
	dw	add_todo		;e_process
	db	1			;e_column
	db	0			;e_row
; main option #1 -MODIFY-
	db	0			;e_count
	db	0 			;e_sub_length
	db	50			;e_hot_key (alt-m)
	db	6			;e_length
	dw	main_opt1_text		;e_text_ptr
	dw	modify_todo		;e_process
	db	6			;e_column
	db	0			;e_row
; main option #2 -SETUP-
	db	0			;e_count
	db	0 			;e_sub_length
	db	31			;e_hot_key (alt-s)
	db	5			;e_length
	dw	main_opt2_text		;e_text_ptr
	dw	setup_todo    		;e_process
	db	13			;e_column
	db	0			;e_row
; main option #5 -EXIT-
	db	0			;e_count
	db	0			;e_sub_length
	db	18			;e_hot_key (alt-e)
	db	4			;e_length
	dw	main_opt5_text		;e_text_ptr
  	dw	exit_todo      		;e_process
	db	19			;e_column
	db	0			;e_row
; main option #6 -PGUP-
	db	0			;e_count
	db	0 			;e_sub_length
	db	49H			;e_hot_key (pgup)
	db	5			;e_length
	dw	main_opt6_text		;e_text_ptr
	dw	pgup      		;e_process
	db	24			;e_column
	db	0			;e_row
; main option #7 -PGDN-
	db	0			;e_count
	db	0 			;e_sub_length
	db	51H			;e_hot_key (pgdn)
	db	5			;e_length
	dw	main_opt7_text		;e_text_ptr
	dw	pgdn       		;e_process
	db	30			;e_column
	db	0			;e_row
; main option #8 -DATE-
	db	0			;e_count
	db	0 			;e_sub_length
	db	51H			;e_hot_key (pgdn)
	db	20			;e_length
	dw	main_opt8_text		;e_text_ptr
	dw	pgdn       		;e_process
	db	60			;e_column
	db	0			;e_row

main_opt0_text     db 'Add',0
main_opt1_text     db 'Modify',0
main_opt2_text     db 'Setup',0
main_opt5_text     db 'Exit',0
main_opt6_text     db ' PGUP',0
main_opt7_text     db ' PGDN',0
main_opt8_text	   db 'Today-    '
mstuff_month	   db '08-'
mstuff_day	   db 'xx-'
mstuff_year	   db '1998',0

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
     db	     70h       ;entry text color
     db      07h       ;past due color
          
color_defaults	label	byte
     Db      5fh       ;bar text color
     db      5eh       ;bar select color
     db      5eh       ;bar hotkey color
     db      1eh       ;submenu text color
     db      70h       ;submenu select color
     db      07h       ;msg text color
     db      70h       ;msg hyper color
     db      0fh       ;pick color
     db      70h       ;pick select color

     db      7eh       ;applicaton color
     db	     7ch       ;entry text color
     db      71h       ;past due color
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
app_text_color		db	7eh,'background color',0

			db	4		;data type = 4 (color)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	0ffh		;maximum value
entry_text_color	db	7ch,'data entry field',0

			db	4		;data type = 4 (color)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	0ffh		;maximum value
past_due_color		db	71h,'overdue entry',0

;------------------
; setup strings
;
        db      '<<MISC program settings>>',0

			db	1		;data type = 1 (boolean flag)
			db	1		;data length = 1 byte
			db	0		;minimum value
			db	1		;maximum value
sounds			db	1		;current setting (on)
			db	'Error sounds (ON or OFF)',0
        db      '<<end>>',0
;


;---------------------------------------------------------------------------
; edit_record - edit or append a record
;  inputs:  al = 0 append
;                1 edit record# in -bx-
;           bx = record number to modify
;
er_opcode	db	?
er_record	dw	?
er_ptr		dw	?
er_append	rec_struc <>

er_dirty	db	0		;set to one if rec. modified

edit_record:
	mov	er_opcode,al
	mov	er_record,bx
	cmp	al,0
	je	er_01			;jmp if append
	call	fd_read			;get ptr to record
	jc	er_err
	mov	er_ptr,si		;save ptr to record
	jmp	er_03
	
er_01:
	
	mov	si,offset er_append
	call	fd_append
	mov	er_ptr,bx		;save allocated append ptr
	mov	er_record,bx		;save append record#
;
; put defaults date (today) in record
;
er_02:	mov	di,bx			;point di at record
	mov	si,offset today_asc_year
	mov	cx,4
	cld
	rep	movsb			;move year
	inc	si
	inc	di
	mov	cx,2
	rep	movsb			;move month number
	inc	si
	inc	di
	mov	cx,2
	rep	movsb			;move day of month
	inc	si
	inc	di
	mov	ax,'1Y'
	stosw
	inc	di
	mov	al,' '
	mov	cx,msg_size
	rep	stosb			;clear the message
;
; move the mouse to text input field
;
	mov	ax,04h
	mov	cx,0dh*8
	mov	dx,2*8
	int	33h
;
; processing here:  1. clear screen
;                   2. display record
;                   3. add menu at top
;                   4. wait for input
er_03:
	call	fix_days_per_month
;
; clear the screen
;
	mov	ah,app_text_color
	mov	al,' '
	call	clear_screen
;
; display entry template
;
	mov	si,offset edit_rec_screen
	mov	ah,app_text_color
	mov	dx,0201h		;row 01 column 01
	call	display_string
;
; display the data for this record on the screen
;
	mov	si,er_ptr		;get record ptr
	add	si,offset msg
	mov	ah,entry_text_color
	mov	dx,es
	mov	ds,dx
	mov	dx,020dh		;get display location
	mov	cx,msg_size
	call	display_text		;display todo text
	
	mov	si,cs:er_ptr
	mov	dx,040dh
	mov	cx,4
	call	display_text		;display year in record

	mov	si,cs:er_ptr
	add	si,offset month
	mov	dx,050fh
	mov	cx,2
	call	display_text		;display month

	mov	si,cs:er_ptr
	add	si,offset day
	mov	dx,070fh
	mov	cx,2
	call	display_text		;display day

	mov	si,cs:er_ptr
	add	si,offset resched
	mov	dx,0b0bh
	mov	cx,2
	call	display_text		;display resched code

	mov	ax,cs
	mov	ds,ax			;restore ds
;
er_menu1:
	mov	bx,offset er_menu_def
	mov	ah,08h+20h		;restore bar & return unknown keys
	call	MENU_SYSTEM
	cmp	cl,1			;check if process key
	jne	er_menu1_d2		;jmp if not process hit
	jmp	ax
	jmp	er_menu1		;go do it again
er_menu1_d2:
	cmp	cl,4			;check if abort key
	je	er_exit
	cmp	cl,2
	jne	er_decodem		;jmp if mouse
	cmp	ah,1
	jne	er_decodek
	cmp	al,51h
	je	er_next			;jmp if pgup
	cmp	al,49h
	je	er_prev			;jmp if pgdn
	jmp	er_decodek		;go decode key
;
; table routines
;
er_next:
	call	verify_ok		;delete record if blank
	mov	bx,er_record
	call	fd_read_next
	jc	er_add2			;jmp if no next record
	mov	er_record,bx
	mov	er_ptr,si
	jmp	er_03
	
er_prev:
	call	verify_ok		;delete record if blank
	mov	bx,er_record
	call	fd_read_prev
	jnc	er_prev1		;jmp if record found
	mov	bx,er_record
	jmp	showit
er_prev1:
	mov	er_record,bx
	mov	er_ptr,si
	jmp	er_03
	
er_add:
	call	verify_ok
er_add2:jmp	er_01
	
er_delete:
	mov	bx,er_record
	call	fd_remove
	call	fd_read_next
	jnc	showit
	call	fd_read_prev
	jnc	showit
	jmp	er_exit
showit:	mov	al,1			;switch to edit mode
	jmp	edit_record		;restart edit
	
er_help:
er_exit:
	cmp	er_opcode,0		;check if append
	jne	er_exit1		;jmp if modify
	test	top_display_rec,8000h
	jz	er_exitx
	mov	top_display_rec,0
	mov	selected_rec,0
;
; we are appending, check if blank record
;
er_exitx:
	call	verify_ok
	jmp	er_exit2
;
; we are modifying, write it back
;	
er_exit1:
	mov	bx,er_record
	call	fd_replace
er_exit2:
	call	sort
	ret

er_err:	
	ret

;
; decode mouse action using table (mouse_decode_table)
;	   cl=3   ax=click row/column (unknown mouse click)
;
er_decodem:
	mov	si,offset mouse_decode_table
er_lpm:	cmp	ah,[si.mrow]
	jne	er_mnext		;jmp if row mismatch
	cmp	al,[si.mcol1]
	jb	er_mnext		;jmp if out of field
	cmp	al,[si.mcol2]
	jbe	er_ck_m			;jmp if within field
er_mnext:
	add	si,size mouse_struc
	cmp	[si.mrow],0
	jne	er_lpm			;loop till done with table
	jmp	er_03
;
; process mouse match
;
er_ck_m:
	mov	ax,[si.mact]
	jmp	ax	

;
; decode key press by checking if within legal field
;	   cl=2   ax=key (unknown key press)
er_decodek:
	call	get_menu_cursor		;dx = display loc
	mov	si,offset ktable
er_dklp:
	cmp	[si.frow],dh		;check if valid row
	jne	er_dnext		;jmp if row does not match
	cmp	dl,[si.fcol1]		;check column
	jb	er_dnext		;jmp if column does not match
	cmp	dl,[si.fcol2]		;check column end
	jbe	er_ck_key
er_dnext:
	add	si,size fields
	cmp	[si.frow],0
	jne	er_dklp			;loop till end of table
	jmp	er_03			;exit if not inside legal field
;
; we are inside a legal field (si) has field limits
; check if key press is legal.  dh = cursor row
;                               dl = cursor column
;                               al = key code   ah = key
;
er_ck_key:	
	mov	bl,byte ptr [si.recstrt]	;get field start
	mov	bh,dl
	sub	bh,[si.fcol1]			;compute increment into
	add	bl,bh
	sub	bh,bh
	mov	di,er_ptr
	cmp	ah,1
	je	control_key			;jmp if extended key
	cmp	al,8
	je	backspace			;jmp if rubout
	mov	es:[di][bx],al			;store key code in record
	jmp	cursor_right			;done		

control_key:
	cmp	al,53h
	je	del_key
noway:	jmp	er_03				;ignore this key
	
backspace:
	cmp	dl,[si.fcol1]
	je	noway
	call	left
del_key:add	di,bx
	mov	bl,dl				;get current column
	add	bl,2				;adjust bl
dk_lp:	cmp	bl,[si.fcol2]
	jae	noway				;exit if done
	mov	bh,es:[di+1]
	mov	es:[di],bh
	inc	di
	inc	bl
	jmp	dk_lp
;
; table defining fields which can be edited
;
fields	struc
 frow	db	?
 fcol1	db	?
 fcol2	db	?
 recstrt db	?		;index into record
fields	ends

ktable	fields <02,0dh,0dh+msg_size,offset msg>	;text field
	fields <04,0dh,0dh+4,offset year>		;year
	fields <05,0fh,0fh+2,offset month>		;month
	fields <07,0fh,0fh+2,offset day>		;day of month
	fields <0bh,0bh,0bh+2,offset resched>	;reschedule code
	db	0			;end of table

;----------------
; current cursor position.      dh = cursor row
;                               dl = cursor column
;                            ds:si = fields struc
cursor_right:
	cmp	dl,[si.fcol2]		;check if at end
	jne	go_right
	jmp	er_03			;can't move right, exit
go_right:
	inc	dl
	call	set_menu_cursor
	jmp	er_03			;go display results

cursor_left:
	call	left
	jmp	er_03

;----------------------
left:	cmp	dl,[si.fcol1]
	je	left_out		;exit if can't go left
	dec	dl
	call	set_menu_cursor
left_out:
	ret	
	
;-----------------------------------------------------------------------
; mouse processing

mouse_struc	struc
 mrow	db	?		;set to zero if end of table
 mcol1	db	?
 mcol2	db	?
 mact	dw	?
mouse_struc	ends

mouse_decode_table	label	byte
 mouse_struc	<04,17h,1ah,year1>
 mouse_struc	<04,1ch,1fh,year2>
 mouse_struc	<04,21h,24h,year3>
 mouse_struc	<04,26h,29h,year4>
 mouse_struc	<04,2bh,2eh,year5>
 mouse_struc	<04,30h,33h,year6>
 mouse_struc	<05,17h,1fh,m_jan>
 mouse_struc	<05,20h,2ah,m_feb>
 mouse_struc	<05,2bh,31h,m_mar>
 mouse_struc	<05,32h,38h,m_apr>
 mouse_struc	<05,39h,3dh,m_may>
 mouse_struc	<05,3eh,41h,m_jun>
 mouse_struc	<06,17h,1ch,m_jul>
 mouse_struc	<06,1dh,24h,m_aug>
 mouse_struc	<06,25h,2fh,m_sep>
 mouse_struc	<06,30h,38h,m_oct>
 mouse_struc	<06,39h,42h,m_nov>
 mouse_struc	<06,43h,4fh,m_dec>
 
 mouse_struc	<0bh,12h,1ah,s_once>
 mouse_struc	<0bh,1bh,21h,s_daily>
 
 mouse_struc	<0ch,12h,24h,s_week1>
 mouse_struc	<0ch,26h,2eh,s_week2>
 mouse_struc	<0ch,2fh,37h,s_week3>
 mouse_struc	<0ch,38h,40h,s_week4>
 mouse_struc	<0dh,12h,25h,s_month1>
 mouse_struc	<0dh,27h,2fh,s_month2>
 mouse_struc	<0dh,30h,37h,s_month3>
 mouse_struc	<0dh,38h,40h,s_month4>
 mouse_struc	<0dh,41h,48h,s_month5>
 
 mouse_struc	<0eh,15h,1dh,s_month6>
 mouse_struc	<0eh,1eh,26h,s_month7>
 mouse_struc	<0eh,27h,2fh,s_month8>
 mouse_struc	<0eh,30h,38h,s_month9>
 mouse_struc	<0eh,39h,42h,s_montha>
 mouse_struc	<0eh,43h,4bh,s_monthb>
 
 mouse_struc	<0fh,12h,1dh,s_year1>
 mouse_struc	<0fh,34h,47h,s_monthe>
 
 mouse_struc	<11h,12h,19h,s_11>
 mouse_struc	<11h,1ah,22h,s_21>
 mouse_struc	<11h,23h,2bh,s_31>
 mouse_struc	<11h,2ch,33h,s_41>
 mouse_struc	<11h,34h,3bh,s_51>
 mouse_struc	<11h,3ch,43h,s_61>
 mouse_struc	<11h,44h,4bh,s_71>
 
 mouse_struc	<12h,12h,19h,s_12>
 mouse_struc	<12h,1ah,22h,s_22>
 mouse_struc	<12h,23h,2bh,s_32>
 mouse_struc	<12h,2ch,33h,s_42>
 mouse_struc	<12h,34h,3bh,s_52>
 mouse_struc	<12h,3ch,43h,s_62>
 mouse_struc	<12h,44h,4bh,s_72>
 
 mouse_struc	<13h,12h,19h,s_13>
 mouse_struc	<13h,1ah,22h,s_23>
 mouse_struc	<13h,23h,2bh,s_33>
 mouse_struc	<13h,2ch,33h,s_43>
 mouse_struc	<13h,34h,3bh,s_53>
 mouse_struc	<13h,3ch,43h,s_63>
 mouse_struc	<13h,44h,4bh,s_73>
 
 mouse_struc	<14h,12h,19h,s_14>
 mouse_struc	<14h,1ah,22h,s_24>
 mouse_struc	<14h,23h,2bh,s_34>
 mouse_struc	<14h,2ch,33h,s_44>
 mouse_struc	<14h,34h,3bh,s_54>
 mouse_struc	<14h,3ch,43h,s_64>
 mouse_struc	<14h,44h,4bh,s_74>

; the days have to be near the end because they are adjusted for each month

 mouse_struc	<07,17h,19h,day01>
 mouse_struc	<07,1bh,1dh,day02>
 mouse_struc	<07,1fh,21h,day03>
 mouse_struc	<07,23h,26h,day04>
 mouse_struc	<07,27h,29h,day05>
 mouse_struc	<07,2bh,2eh,day06>
 mouse_struc	<07,2fh,32h,day07>
 mouse_struc	<07,33h,36h,day08>
 mouse_struc	<07,37h,39h,day09>
 mouse_struc	<07,3bh,3dh,day10>
 mouse_struc	<07,3fh,41h,day11>
 mouse_struc	<08,17h,19h,day12>
 mouse_struc	<08,1bh,1dh,day13>
 mouse_struc	<08,1fh,22h,day14>
 mouse_struc	<08,23h,26h,day15>
 mouse_struc	<08,27h,29h,day16>
 mouse_struc	<08,2bh,2eh,day17>
 mouse_struc	<08,2fh,32h,day18>
 mouse_struc	<08,33h,36h,day19>
 mouse_struc	<08,37h,39h,day20>
 mouse_struc	<08,3bh,3dh,day21>
 mouse_struc	<08,3fh,41h,day22>
 mouse_struc	<09,17h,19h,day23>
 mouse_struc	<09,1bh,1dh,day24>
 mouse_struc	<09,1fh,22h,day25>
 mouse_struc	<09,23h,26h,day26>
 mouse_struc	<09,27h,29h,day27>
 mouse_struc	<09,2bh,2dh,day28>
mod1:
 mouse_struc	<09,2fh,32h,day29>
mod2:
 mouse_struc	<09,33h,36h,day30>
mod3:
 mouse_struc	<09,37h,39h,day31>

 db	0				;end of table
; 
; set first year in table
;
year1:	mov	si,offset yr_stuff2
	jmp	stuff_year
year2:	mov	si,offset yr_stuff2 +5
	jmp	stuff_year
year3:	mov	si,offset yr_stuff2 +10
	jmp	stuff_year
year4:	mov	si,offset yr_stuff2 +15
	jmp	stuff_year
year5:	mov	si,offset yr_stuff2 +20
	jmp	stuff_year
year6:	mov	si,offset yr_stuff2 +25
stuff_year:
	mov	di,er_ptr
	cld
	mov	cx,4
	rep	movsb
	jmp	er_03

m_jan:	mov	ax,'01'
	jmp	month_stuff
m_feb:	mov	ax,'02'
	jmp	month_stuff
m_mar:	mov	ax,'03'
	jmp	month_stuff
m_apr:	mov	ax,'04'
	jmp	month_stuff
m_may:	mov	ax,'05'
	jmp	month_stuff
m_jun:  mov	ax,'06'
	jmp	month_stuff
m_jul:	mov	ax,'07'
	jmp	month_stuff
m_aug:	mov	ax,'08'
	jmp	month_stuff
m_sep:	mov	ax,'09'
	jmp	month_stuff
m_oct:	mov	ax,'10'
	jmp	month_stuff
m_nov:	mov	ax,'11'
	jmp	month_stuff
m_dec:	mov	ax,'12'
month_stuff:
	mov	di,er_ptr
	xchg	ah,al
	mov	word ptr es:[di.month],ax
	jmp	er_03

day01:	mov	ax,'01'
	jmp	day_stuff
day02:	mov	ax,'02'
	jmp	day_stuff
day03:	mov	ax,'03'
	jmp	day_stuff
day04:	mov	ax,'04'
	jmp	day_stuff
day05:	mov	ax,'05'
	jmp	day_stuff
day06:	mov	ax,'06'
	jmp	day_stuff
day07:	mov	ax,'07'
	jmp	day_stuff
day08:	mov	ax,'08'
	jmp	day_stuff
day09:	mov	ax,'09'
	jmp	day_stuff
day10:	mov	ax,'10'
	jmp	day_stuff
day11:	mov	ax,'11'
	jmp	day_stuff
day12:	mov	ax,'12'
	jmp	day_stuff
day13:	mov	ax,'13'
	jmp	day_stuff
day14:	mov	ax,'14'
	jmp	day_stuff
day15:	mov	ax,'15'
	jmp	day_stuff
day16:	mov	ax,'16'
	jmp	day_stuff
day17:	mov	ax,'17'
	jmp	day_stuff
day18:	mov	ax,'18'
	jmp	day_stuff
day19:	mov	ax,'19'
	jmp	day_stuff
day20:	mov	ax,'20'
	jmp	day_stuff
day21:	mov	ax,'21'
	jmp	day_stuff
day22:	mov	ax,'22'
	jmp	day_stuff
day23:	mov	ax,'23'
	jmp	day_stuff
day24:	mov	ax,'24'
	jmp	day_stuff
day25:	mov	ax,'25'
	jmp	day_stuff
day26:	mov	ax,'26'
	jmp	day_stuff
day27:	mov	ax,'27'
	jmp	day_stuff
day28:	mov	ax,'28'
	jmp	day_stuff
day29:	mov	ax,'29'
	jmp	day_stuff
day30:	mov	ax,'30'
	jmp	day_stuff
day31:	mov	ax,'31'
day_stuff:
	mov	di,er_ptr
	xchg	ah,al
	mov	word ptr es:[di.day],ax
	jmp	er_03

s_once:	mov	ax,'D0'
	jmp	resched_stuff
s_daily:mov	ax,'D1'
	jmp	resched_stuff
s_week1:mov	ax,'W1'
	jmp	resched_stuff
s_week2:mov	ax,'W2'
	jmp	resched_stuff
s_week3:mov	ax,'W3'
	jmp	resched_stuff
s_week4:mov	ax,'W4'
	jmp	resched_stuff
s_month1:mov	ax,'M1'
	jmp	resched_stuff
s_month2:mov	ax,'M2'
	jmp	resched_stuff
s_month3:mov	ax,'M3'
	jmp	resched_stuff
s_month4:mov	ax,'M4'
	jmp	resched_stuff
s_month5:mov	ax,'M5'
	jmp	resched_stuff
s_month6:mov	ax,'M6'
	jmp	resched_stuff
s_month7:mov	ax,'M7'
	jmp	resched_stuff
s_month8:mov	ax,'M8'
	jmp	resched_stuff
s_month9:mov	ax,'M9'
	jmp	resched_stuff
s_montha:mov	ax,'MA'
	jmp	resched_stuff
s_monthb:mov	ax,'MB'
	jmp	resched_stuff
s_monthe:mov	ax,'ME'
	jmp	resched_stuff
s_year1:mov	ax,'Y1'
	jmp	resched_stuff
s_11:	mov	ax,'11'
	jmp	resched_stuff
s_12:	mov	ax,'12'
	jmp	resched_stuff
s_13:	mov	ax,'13'
	jmp	resched_stuff
s_14:	mov	ax,'14'
	jmp	resched_stuff

s_21:	mov	ax,'21'
	jmp	resched_stuff
s_22:	mov	ax,'22'
	jmp	resched_stuff
s_23:	mov	ax,'23'
	jmp	resched_stuff
s_24:	mov	ax,'24'
	jmp	resched_stuff

s_31:	mov	ax,'31'
	jmp	resched_stuff
s_32:	mov	ax,'32'
	jmp	resched_stuff
s_33:	mov	ax,'33'
	jmp	resched_stuff
s_34:	mov	ax,'34'
	jmp	resched_stuff

s_41:	mov	ax,'41'
	jmp	resched_stuff
s_42:	mov	ax,'42'
	jmp	resched_stuff
s_43:	mov	ax,'43'
	jmp	resched_stuff
s_44:	mov	ax,'44'
	jmp	resched_stuff

s_51:	mov	ax,'51'
	jmp	resched_stuff
s_52:	mov	ax,'52'
	jmp	resched_stuff
s_53:	mov	ax,'53'
	jmp	resched_stuff
s_54:	mov	ax,'54'
	jmp	resched_stuff

s_61:	mov	ax,'61'
	jmp	resched_stuff
s_62:	mov	ax,'62'
	jmp	resched_stuff
s_63:	mov	ax,'63'
	jmp	resched_stuff
s_64:	mov	ax,'64'
	jmp	resched_stuff

s_71:	mov	ax,'71'
	jmp	resched_stuff
s_72:	mov	ax,'72'
	jmp	resched_stuff
s_73:	mov	ax,'73'
	jmp	resched_stuff
s_74:	mov	ax,'74'
	jmp	resched_stuff


	
resched_stuff:
	mov	di,er_ptr
	xchg	ah,al
	mov	word ptr es:[di.resched],ax
	jmp	er_03
;
;----------------------------------------------------------------------
; check if blank record and delete it if blank.
;
verify_ok:
	mov	di,er_ptr
	add	di,offset msg
	mov	cx,size msg
er_exit_lp:
	cmp	byte ptr es:[di],' '
	jne	er_out1			;exit if non-space
	inc	di
	dec	cx
	jnz	er_exit_lp
	mov	bx,er_record		;blank record (todo)
	call	fd_remove		;  delete it
	jmp	er_out2
er_out1:
	mov	bx,er_record
	call	fd_replace
er_out2:
	ret
;---------------------------------------------------------------------
; fix_days_per_month - adjust display of days to match current month
;
fix_days_per_month:
	mov	si,er_ptr	;get current record
	push	ds
	mov	ax,es
	mov	ds,ax
	
	mov	cx,4
	call	dec_str2_to_word ;set bx=year
	push	bx
	inc	si
	mov	cx,2
	call	dec_str2_to_word ;set bx=month
	pop	ax		;get year in ax
	call	month_days	;set bx=days per month

	pop	ds
;
; bx = days per month
;
	mov	byte ptr mod1,9
	mov	byte ptr mod2,9
	mov	byte ptr mod3,9
	mov	word ptr day29_stuff,'92'		;stuff 29
	mov	word ptr day30_stuff,'03'
	mov	word ptr day31_stuff,'13'
	cmp	bx,28
	ja	fdp_2		;jmp if not 28 days
	mov	byte ptr mod1,0
	mov	word ptr day29_stuff,'  '
fdp_2:	cmp	bx,29
	ja	fdp_4
	mov	byte ptr mod2,0
	mov	word ptr day30_stuff,'  '
fdp_4:	cmp	bx,30
	ja	fdp_6
	mov	byte ptr mod3,0
	mov	word ptr day31_stuff,'  '
fdp_6:	ret
;
; edit record menu
;
er_menu_def	label	byte
	db	0			;m_flag
	db	0			;top row
	db	0			;left column
	db	1			;total rows
	db	80			;total columns
	db	6			;menu options
	dw	0			;main selection
	dw	0			;sub selection
; main option #0 -NEXT-
	db	0			;e_count
	db	0 			;e_sub_length
	db	51			;e_hot_key
	db	10			;e_length
	dw	er_opt0_text		;e_text_ptr
	dw	er_next			;e_process
	db	1			;e_column
	db	0			;e_row
; main option #1 -PREV-
	db	0			;e_count
	db	0 			;e_sub_length
	db	57			;e_hot_key
	db	10			;e_length
	dw	er_opt1_text		;e_text_ptr
	dw	er_prev      		;e_process
	db	13			;e_column
	db	0			;e_row
; main option #2 -DELETE-
	db	0			;e_count
	db	0 			;e_sub_length
	db	32			;e_hot_key (alt-d)
	db	16			;e_length
	dw	er_opt2_text		;e_text_ptr
	dw	er_delete    		;e_process
	db	24			;e_column
	db	0			;e_row
; main option #3 -ADD-NEW-
	db	0			;e_count
	db	0			;e_sub_length
	db	30			;e_hot_key (alt-a)
	db	12			;e_length
	dw	er_opt3_text		;e_text_ptr
  	dw	er_add      		;e_process
	db	42			;e_column
	db	0			;e_row
; main option #4 -HELP-
	db	0			;e_count
	db	0			;e_sub_length
	db	35			;e_hot_key (alt-h)
	db	4			;e_length
	dw	er_opt4_text		;e_text_ptr
  	dw	er_help   		;e_process
	db	56			;e_column
	db	0			;e_row
; main option #5 -EXIT-
	db	0			;e_count
	db	0			;e_sub_length
	db	18			;e_hot_key (alt-e)
	db	4			;e_length
	dw	er_opt5_text		;e_text_ptr
  	dw	er_exit      		;e_process
	db	62			;e_column
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

er_opt0_text     db 'Next(PGDN)',0
er_opt1_text     db 'Prev(PGUP)',0
er_opt2_text     db 'Delete-this-todo',0
er_opt3_text     db 'Add-new-todo',0
er_opt4_text     db 'Help',0
er_opt5_text     db 'Done-Editing',0



edit_rec_screen	label	byte
 db ' Todo text  012345678901234567890123456789012345678901234567890123456789',0dh,0ah
 db 0dh,0ah
;;year_stuff1	equ	$ + 14
yr_stuff2	=	$ + 22
 db ' Todo year  xxxx ÄÄÄÄÄ1997,1998,1999,2000,2001,2002',0dh,0ah
;;month_stuff	equ	$ + 15
 db ' Todo Month   xx ÄÄÄÂÄJanuary, Februrary, March, April, May, June',0dh,0ah
 db '                    ÀÄJuly, August, September, October, November, December',0dh,0ah
 db ' Todo Day     xx ÄÄÄÂÄ01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11',0dh,0ah
 db '                    ÃÄ12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22',0dh,0ah
day29_stuff	=	$ + 46
day30_stuff	=	$ + 50
day31_stuff	=	$ + 54
 db '                    ÀÄ23, 24, 25, 26, 27, 28, 29, 30, 31',0dh,0ah
 db 0dh,0ah
 db ' Schedule xx ÄÄÂÄonce(D0) daily(D1)',0dh,0ah
 db '               ÃÄweekly(W1) or every 2nd(W2), 3rd(W3), 4th(W4) week',0dh,0ah
 db '               ÃÄmonthly(M1) or every 2nd(M2), 3rd(M3, 4th(M4), 5th(M5),',0dh,0ah
 db '               ³    6th(M6), 7th(M7), 8th(M8), 9th(M9), 10th(MA), 11th(MB)',0dh,0ah
 db '               ÃÄyearly(Y1)                        end of each month(ME) ',0dh,0ah
 db '               ÃÄsunday  monday  tuesday   wed     thurs   friday  saturday',0dh,0ah
 db '               ³ 1st-11  1st-21   1st-31   1st-41  1st-51  1st-61  1st-71',0dh,0ah
 db '               ³ 2st-12  2st-22   2st-32   2st-42  2st-52  2st-62  2st-72',0dh,0ah
 db '               ³ 3st-13  3st-23   3st-33   3st-43  3st-53  3st-63  3st-73',0dh,0ah
 db '               ³ 4th-14  4th-24   4th-34   4th-44  4th-54  4th-64  4th-74',0dh,0ah
 db '               ÀÄ',0dh,0ah
 db 0		;end of screen
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
;
;------------------------

;------------------------
;-------------------------------------------------------------------------
; zseg must be at the end of the program for memory allocation from
; DOS.
;
zseg	segment	para public 'ZZ'

zseg	ends

		end	start
