;*****************************  LOAN.ASM   **********************************
PAGE  70,132
comment 
                             LOAN Payments
                             -------------

     Purpose:
     --------

     LOAN is a sample program to show how floating point math can
     be performed.  It will calculate a 12 month table showing
     what portions of payments go to principal and interest.

     Using LOAN
     ----------

     To calculate the loan parameters, type "LOAN"<Enter> and
     enter the loan amount, principal, and interest.  The
     program will do the rest.

     Floating Point Overview
     -----------------------

     LOAN operates by first allocating 8 floating variables.  Then,
     three of the variables are set to the payment amount, principal,
     and interest respectivly.  Each of the 8 allocated variables
     are referenced by a number or token.  The first variable is #1,
     the second #2 etc.  This makes it vary easy to add two variables
     by just saying add #1 to #2.  When, the calculations are done,
     they are extracted by calling "text_out" to convert from 
     floating point format to a printable ascii text string.

     Compiling
     ---------

     The commands needed to build LOAN.EXE using MASM are:
		masm loan;
		link loan,loan,,alib.lib;

     
	include	mac.inc
	include	common.inc
;-----------------------------------------------------------------------------
	extrn	library_setup:far
;;	extrn	lib_error_handler:far
	extrn	clear_screen:far
	extrn	display_string:far
	extrn	library_terminate:far	
	extrn	qget_string:far
	extrn	key_or_mouse:far
	extrn	binary_in:far
	extrn	binary_out:far
	extrn	f_divide:far
	extrn	f_multiply:far
	extrn	f_subtract:far
	extrn	f_addition:far
	extrn	text_in:far
	extrn	text_out:far
	extrn	fmove:far
	extrn	round:far	
;------------------------------------------------------------------------------
code		segment para public 'CODE'
		assume	cs:code, ds:code
;-----------------------------------------------------------------------------
;
color		db	1bh
 
pspseg		dw	0
lib_info_ptr	dw	0
lib_info_seg	dw	0

copyright_msg	db	'----------------- LOAN PAYMENT table ------------- ',0

interest_msg	db	'What is the interest rate (xx.xx)% ',0
interest_buf	db	8 dup (0)
amount_msg	db	'What is principle remaining ',0
amount_buf	db	20 dup (0)
payment_msg	db	'What is amount of payments ',0
payment_buf	db	12 dup (0)
header_msg	db	'PAYMENT    INT-PAID    PRIN-PAID   PRIN-REMAINING',0
term_dash_msg	db	'-------    --------    ----------- --------------',0
any_key_msg	db	'Press any key to continue',0

int_paid_text	db	15 dup (0)
prin_paid_text	db	15 dup (0)
prin_remain_text db	15 dup (0)

total_prin_paid	db	15 dup (0)
total_int_paid	db	15 dup (0)

display_row	db	8
month_count	db	0

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
	mov	lib_info_ptr,si		;save ptr to library info block
	mov	lib_info_seg,es         ; see COMMON.INC or LIBRARY_SETUP
	cmp	ax,128
	jae	got_enough_mem		;jmp if 128k of memory avail
;;	mov	al,7
;;	mov	ah,fatal_return
;;	call	lib_error_handler
	jmp	exitx
	
got_enough_mem:
;
; clear the screen and display signon
;
	mov	ah,color		;select color
	mov	al,' '
	call	clear_screen
;
; display copyright message
;
	mov	si,offset copyright_msg
	mov	ah,color
	mov	dx,0100h		;display row
	call	display_string	
	
	
; prevent an unintended program crash; trap Ctrl+Break, Ctrl+C and
; Ctrl+Alt+Del key combinations

;	call	BREAK_KEY_INTERCEPT
;
; --- --- --- --- ---
; load floating point variables as follows: token 0 = interest rate
;                                                 1 = prin
;                                                 2 = payment
;                                                 3 = interest paid
;                                                 4 = prin paid
;                                                 5 = temp (x)
;                                                 6 = total int. paid
;                                                 7 = total prin paid
; get varialbes & zero rest
; int = int/1200
; int paid = int * prin
; prin paid = payment - int paid
; x = prin - prin paid
; if x is positive
;   prin = x
;   total int = total int + int paid
;   total prin= total prin + prin paid
;
;
; get beginning loan amount (prin)
;
	mov	ax,cs
	mov	ds,ax
	mov	es,ax
	
	mov	si,offset amount_msg
	mov	dx,0201h			;display location
	mov	ah,color
	call	display_string
	mov	cl,10				;max length of input string
	mov	dx,0222h			;display location
	mov	di,offset amount_buf
	call	qget_string
	mov	ax,1				;token #
	call	text_in				;es:di point at text, ax=token
;
; get payment amount
;
	mov	si,offset payment_msg
	mov	dx,0301h			;display location
	mov	ah,color
	call	display_string
	mov	cl,07				;max length of input string
	mov	dx,0322h			;display location
	mov	di,offset payment_buf
	call	qget_string
	mov	ax,2				;token #
	call	text_in				;es:di point at text, ax=token
;
; get interest rate
;
	mov	si,offset interest_msg
	mov	dx,0401h			;display location
	mov	ah,color
	call	display_string
	mov	cl,05				;max length of input string
	mov	dx,0422h			;display location
	mov	di,offset interest_buf
	call	qget_string
	mov	ax,0				;token #
	call	text_in				;es:di point at text, ax=token
;
; zero all remaining variables
;
	mov	ax,0
	mov	dx,0				;set value of zero
	mov	bx,3				;start with token 3
	call	binary_in
	mov	bx,4
	call	binary_in
	mov	bx,5
	call	binary_in
	mov	bx,6
	call	binary_in
	mov	bx,7
	call	binary_in
;
; display header line
;
	mov	si,offset header_msg
	mov	dx,0601h			;display location
	mov	ah,color
	call	display_string
	
; compute int = int/1200

	mov	bx,5
	mov	ax,1200
	mov	dx,0
	call	binary_in			;token 5 = 1200

	mov	ax,0
	mov	bx,5
	mov	cx,0
	call	f_divide				;int/1200 -> int
	
; compute int paid = int * prin

month_loop:
	mov	ax,0				;interest
	mov	bx,1				;prin
	mov	cx,3				;int paid
	call	f_multiply

	mov	ax,3				;int paid
	call	round

; compute prin paid = payment - int paid

	mov	ax,2				;payment
	mov	bx,3				;int paid
	mov	cx,4				;prin paid
	call	f_subtract

	mov	ax,4
	call	round

; compute x = prin - prin paid

	mov	ax,1				;prin
	mov	bx,4				;prin paid
	mov	cx,5				;temp (x) prin remain
	call	f_subtract
	
; if x is positive
;   prin = x
	mov	bx,5
	call	binary_out
	test	dh,80h				;check if negative
	jz	loan_cont			; continue if numbers valid
	jmp	view_wait			; jmp if negative
loan_cont:	
	mov	ax,5
	mov	bx,1
	call	fmove	
	
;   compute total int = total int + int paid

	mov	ax,6				;total int paid
	mov	bx,3				;int paid
	mov	cx,6				;total int paid
	call	f_addition

;   total prin= total prin + prin paid

	mov	ax,7				;total prin paid
	mov	bx,4				;prin paid
	mov	cx,7
	call	f_addition
;
; convert floating values to text
;
	mov	ax,3				;int paid
	mov	di,offset int_paid_text
	mov	cx,0208h			;buffer sizes
	call	text_out

	mov	ax,4				;prin paid
	mov	di,offset prin_paid_text
	mov	cx,0209h			;buffer sizes
	call	text_out

	mov	ax,1				;prin remaining
	mov	di,offset prin_remain_text
	mov	cx,020bh			;buffer sizes
	call	text_out
	
; print results for this month

	mov	dh,display_row
	mov	dl,1
	mov	si,offset payment_buf
	mov	ah,color
	call	display_string	

	mov	dh,display_row
	mov	dl,10
	mov	si,offset int_paid_text
	mov	ah,color
	call	display_string	

	mov	dh,display_row
	mov	dl,20
	mov	si,offset prin_paid_text
	mov	ah,color
	call	display_string	

	mov	dh,display_row
	mov	dl,30
	mov	si,offset prin_remain_text
	mov	ah,color
	call	display_string	

; check if 12 months printed, month_count = 12

	inc	display_row
	inc	month_count
	cmp	month_count,12
	je	show_totals
	jmp	month_loop
;
; now show totals
;
show_totals:
	mov	si,offset term_dash_msg
	mov	dh,display_row
	mov	dl,0
	mov	ah,color
	call	display_string	

	mov	ax,7				;total prin paid
	mov	di,offset total_prin_paid
	mov	cx,0209h			;buffer sizes
	call	text_out

	mov	ax,6				;total intrest paid
	mov	di,offset total_int_paid
	mov	cx,020bh			;buffer sizes
	call	text_out

	mov	dh,display_row
	add	dh,1
	mov	dl,7
	mov	si,offset total_int_paid
	mov	ah,color
	call	display_string	

	mov	dh,display_row
	add	dh,1
	mov	dl,21
	mov	si,offset total_prin_paid
	mov	ah,color
	call	display_string	

; let user view the screen

view_wait:
	mov	si,offset any_key_msg
	mov	dh,display_row
	add	dh,3
	mov	dl,10
	mov	ah,color
	call	display_string	
	call	key_or_mouse	
	
;
; de-activate the Ctrl+Break trap
;	call	BREAK_KEY_RESTORE

; normal program exit

exitx:	mov	ax,0
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
