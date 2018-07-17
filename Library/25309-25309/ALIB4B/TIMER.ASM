;**************************** TIMER.ASM *********************************
PAGE  70,132
comment 
                             TIMER
                             -----

     Purpose:
     --------

     TIMER is a sample program to show how the timer funcitons can
     be used.  The unmodified program will time the execution of
     programs, but it can be modified to time code segments.

     Using TIMER
     ----------

     To time a program, type "TIMER <program name>"<Enter>
     TIMER will execute the program and display the elapsed
     time when the program exits.

     Compiling
     ---------

     The commands needed to build TIMER.EXE using MASM are:
		masm TIMER;
		link TIMER,TIMER,,alib.lib;


;----------------------------------------------------------------------------
.xlist
	include  mac.inc
	include  common.inc
	extrn	library_setup:far
	extrn	library_terminate:far	
	extrn	spawn_dos:far	
;	extrn	calibrate_timer:far
;	extrn	start_timer:far
;	extrn	read_timer:far
;	extrn	convert_timer:far
;	extrn	display_timer:far
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
; check if enough memory free to run program
;
	mov	ax,pspseg		;pass psp segment to setup
	mov	bx,0			;number of floating point variables
	call	library_setup
;
; We want to call SPAWN_DOS which is not compatable with the memory
; manager, so we will remove it from memory.  We needed to call
; library setup origionally, to setup the library data area.
;
	mov	ax,1
	call	library_terminate

	call	calibrate_timer
	call	start_timer
;
; note: for code timing it will be necessary to comment out the "jcxz"
;       instruction above, then place code below.
;
; **** place code to be timed here ****	

;		mov	cx,100
;loopx:
;		mov	al,0ffh
;		mov	si,offset temp
;
;    push   ax
;    aam                      ;convert byte to bcd
;    push   ax
;    mov    ah,al
;    aam
;    or     ax,3030h          ;add in ascii
;    mov    byte ptr [si],ah
;    mov    byte ptr [si+1],al
;    pop    ax
;    or     al,30h
;    mov    byte ptr [si+2],al
;    pop    ax
;	loop	loopx
;	jmp	continue

; SI buff addr, 
;
; The following code can be used if timing a program.  Example:
;                             Timer program.exe
; It should be removed if doing code timing and a look used as
; is shown above.
;
	mov	ax,cs:pspseg
	mov	ds,ax
	mov	es,ax
	mov	si,81h
	call	spawn_dos		;execute program to be timed

continue:
; **** end of code to be timed ****

	call	read_timer
	call	convert_timer
	call	display_timer		

exit2:	mov	ax,4C00h
	int	21h
;---------------------------
			
code		ends
	
;-------------------------------------------------------------------------
;
; This segment definition is needed so linker will put the LIBSEG here
; before the ZSEG.  We want ZSEG to be last so memory allocation will
; work correctly.
;
LIBSEG           segment byte public 'LIB'
LIBSEG	ENDS
	PAGE	66,132
;******************************** TIME7.ASM  *********************************
LIBSEG           segment byte public "LIB"
		assume cs:LIBSEG , ds:LIBSEG
;----------------------------------------------------------------------------
	include	mac.inc
	extrn	word_to_dec_stdout:far
	extrn	dword_to_dec_stdout:far
	extrn	stdout_string:far
	extrn	quad_multiply1:far
	extrn	quad_divide:far
;
; General information.  This collection of timer functions use the
; 8243 timer.  The 8253 has three timers, and timer 0 is used to
; keep the system clock (attached to interrupt 8) current.  We will
; also use timer 0.  The timer 0 is accessed at port 43h (commands) and
; port 40h (data).  One timer tick is roughly 840 nano secods.
; 			
timer_low	equ	046ch
timer_mode	equ	43h
timer0		equ	40h

comment 
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -(  MISC   )
;START_TIMER - start high resolution timer
;  inputs:  none
;  output:  none
; 
; note:  the maximum time which can be measured is one hour.  code
;        fragments can be timed accuratly up to 55ms.  Programs
;        can be timed for longer periods, but interrupts have to
;        be enabled.  It is usually best to disable interrupts
;        while timing short code fragments.  For program timing
;        the reported time will include the time required to
;        service interrupts.
;
; note:  The timer functions are usually called in the following order
;           call  calibrate_timer
;           call  start_timer
;           (timed program or code here)
;           call  read_timer
;           call  convert_timer
;           call  display_timer
;
; note:  See sample program TIMER.ASM for usage hints.
;* * * * * * * * * * * * * *

	public	start_timer
start_timer	proc	far
	apush	ax,dx,ds
	pushf
	cli
;
; initialize the 8253 to count down max count of 65536 by setting zero
;
	mov	al,00110100b		;select mode
	out	timer_mode,al		;request mode
	call	delay
	sub	ax,ax			;starting count
	out	timer0,al
	call	delay
	out	timer0,al
;
; wait for timer tick before starting
;
	sti
	call	delay
	in	al,timer0
	mov	ah,al
twait:	call	delay
	in	al,timer0
	cmp	al,ah
	je	twait
	call	delay
;
;wait for interrupt
;
	sub	dx,dx
	mov	ds,dx			;point at seg 0
	mov	dx,word ptr ds:[timer_low]
ilop:	mov	ax,word ptr ds:[timer_low]
	cmp	ax,dx
	je	ilop
;
; restart the timer back at count of zero again.
;
	mov	al,00110100b		;select mode
	out	timer_mode,al		;request mode
	call	delay
	sub	ax,ax			;starting count
	out	timer0,al
	call	delay
	out	timer0,al
;
; get the current bios time of day
;
	mov	ax,word ptr ds:[timer_low]
	mov	cs:interrupt_count,ax
	popf
	apop	ds,dx,ax
	retf
start_timer	endp

delay:	jmp	d1
d1:	jmp	d2
d2:	jmp	d3
d3:	jmp	d4
d4:	nop
	push	ax
	pop	ax
	jmp	d5
d5:	push	ax
	pop	ax
	jmp	d6
d6:	push	ax
	pop	ax
   	ret

comment 
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -(  MISC   )
;read_timer - read high resolution timer
;  inputs:  none
;  output:  dx,ax = total 8253 timer ticks at rate of 1,193,182 per second
;           
;* * * * * * * * * * * * * *

	public	read_timer
read_timer	proc	far
	apush	ds,es
	pushf
	cli
	mov	ax,cs
	mov	ds,ax
	xor	ax,ax
	mov	es,ax
;
; stop timer by setting mode to zero
;
	out	timer_mode,al	;timer interrupts off
	call	delay
	in	al,timer0
	call	delay
	mov	ah,al
	in	al,timer0
	xchg	ah,al
	neg	ax
	mov	timer_count,ax	;ax now has 16 bit timer count
;
; read interrupt count from bios
;
	mov	ax,es:[timer_low]
	sub	ax,interrupt_count
	mov	interrupt_count,ax
;
; restart the timer by resetting default value of control word
;
	mov	al,00110110b	;binary,mode 3,timer 0
	out	timer_mode,al
	mov	al,0
	call	delay
	out	timer0,al
	call	delay
	out	timer0,al
;
; return values to caller
;
	mov	ax,timer_count
	mov	dx,interrupt_count

	sub	ax,calibrate
	sbb	dx,0			;calibrate timer value
	popf
exit:	apop	es,ds
	retf
read_timer	endp

comment 
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -(  MISC   )
;CONVERT_TIMER - convert timer ticks to seconds and microseconds
;  inputs:  dx,ax = total 8253 timer ticks at rate of 1,193,182 per second
;  output:  ax = seconds
;           cx,bx = microseconds
;
;* * * * * * * * * * * * * *

	public	CONVERT_TIMER
CONVERT_TIMER	proc	far
	apush	si,ds
	mov	si,cs
	mov	ds,si

	mov	cx,word ptr timer_convert+2
	mov	bx,word ptr timer_convert
	call	quad_multiply1		;result to dx,cx,bx,ax
	mov	si,word ptr hundred_thousand+2
	mov	di,word ptr hundred_thousand
	call	quad_divide		;result dx,ax  remainder cx,bx

;
; dx,ax now contains the total number of micro seconds, cx,bx = remainder
;
	cmp	cx,1
	je	round_up
	cmp	bx,0c350h		;(100000/2)
	jb	compute_seconds
round_up:
	add	ax,1
	adc	dx,0			;round up 1

compute_seconds:
	mov	bx,dx
	xor	dx,dx
	xor	cx,cx
	mov	si,word ptr million+2
	mov	di,word ptr million
	call	quad_divide		;compute seconds & microseconds
;
; dx,ax = seconds   cx,bx = microseconds
;
	apop	ds,si
	retf		

CONVERT_TIMER	endp

comment 
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -(  MISC   )
;DISPLAY_TIMER - display timer values to stdout
;  inputs:   ax = seconds
;          cx,bx = microseconds
;  output:  none
;           
;* * * * * * * * * * * * * *

	public	display_timer
DISPLAY_TIMER	proc	far
	apush	si,ds

	mov	si,cs
	mov	ds,si
	mov	seconds,ax
	mov	word ptr microseconds+2,cx
	mov	word ptr microseconds,bx

	mov	si,offset msg1
	call	stdout_string			;display 'Elapsed time ="
	
	mov	ax,seconds
	call	word_to_dec_stdout		;seconds
	mov	si,offset message_sec
	call	stdout_string
	
	mov	ax,word ptr microseconds
	mov	dx,word ptr microseconds+2
	call	dword_to_dec_stdout
	mov	si,offset message_micro
	call	stdout_string
	apop	ds,si
	retf
DISPLAY_TIMER	endp
comment 
;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -(  MISC   )
;CALIBRATE_TIMER - calibrate timer
;  inputs:  none
;  output:  none
; 
; note:  This function computes the overhead needed to call
;        START_TIMER and read_timer on current computer and
;        calibrates the time calculation so that it will
;        compute zero if nothing is being timed.           
;
; note:  This function only needs to be called once.  It saves
;        a calibration factor which is used by read_timer as
;        long as read_timer is in memory.
;* * * * * * * * * * * * * *


	public	calibrate_timer
calibrate_timer	proc	far
	apush	ax,bx,cx,dx
	mov	cs:calibrate,0
	mov	cs:seconds,0
	mov	cx,8
ct_lp1:	push	cx
       	call	start_timer
	call	read_timer
	add	cs:seconds,ax
	pop	cx
	loop	ct_lp1

	mov	ax,cs:seconds
	mov	cl,3
	shr	ax,cl
	mov	cs:calibrate,ax
	
	mov	cx,5000
ct_lp:	call	delay
	loop	ct_lp
	apop	dx,cx,bx,ax
	retf
calibrate_timer	endp
;--------------------------------------------------------------------------

timer_count	dw	0	;read from 8253
interrupt_count	dw	0	;read from BIOS

microseconds	dd	0	;total microseconds
seconds		dw	0	;total seconds

calibrate	dw	0	;calibration factor from read_timer

timer_convert	dd	83809	;838.096 nsec per tick
hundred_thousand dd	100000
million		dd	1000000

msg1		db	0dh,0ah,0dh,0ah,'Elapsed time = ',0
message_sec	db	' (seconds)   ',0
message_micro	db	' (Micro seconds)',0dh,0ah,0


LIBSEG	ENDS
;;	end

;-------------------------------------------------------------------------
; zseg must be at the end of the program for memory allocation from
; DOS.
;
zseg	segment	para public 'ZZ'
zseg	ends
		end	start
