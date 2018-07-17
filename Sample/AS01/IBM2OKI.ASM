;*****************************************************************************;
;*	This program traps the printer output interrupt (17H), and	     *;
;*	translates outgoing IBM-style line drawing characters to codes	     *;
;*	compatible with the Okidata 84p.				     *;
;*									     *;
;*	Since the 84p doesn't fully implement all double-line characters,    *;
;*	we translate everything into single-line graphics.  Other graphics   *;
;*	characters (hearts, happy faces, etc.) are not supported in this     *;
;*	program.							     *;
;*									     *;
;*	The utility should be disabled prior to running any program (such as *;
;*	Lotus 1-2-3) that depends on the okidata graphics character set or   *;
;*	uses the Okigraph graphics printing facility.			     *;
;*									     *;
;*	USE:	Giving the command "IBM2OKI" for the first time will install *;
;*	the conversion utility and produce the report "IBM2OKI installed and *;
;*	running."  Thereafter, giving the "IBM2OKI" command will toggle the  *;
;*	translation feature off and on, reporting "IBM2OKI temporarily       *;
;*	deactivated." or "IBM2OKI reactivated."                              *;
;*									     *;
;*	Copyright (C) 1983 Jeffrey P. Garbers.		All rights reserved  *;
;*****************************************************************************;

cseg		segment para public 'CODE'
	assume	cs:cseg, ds:cseg

;	The printer interrupt number is defined by the PC to be 17H.

printer_interrupt	equ	17h

;	The signature word is an arbitrary 16-bit number that we'll use in
;	checking to see if the utility has already been installed.

signature		equ	0944h

;	DOS has a handy macro that calls DOS for service.  Its first argument
;	is a function code number.  The second one (if it's there) is assumed
;	to be an offset that needs to be loaded into DX

DOS	macro	fcn_code, location_arg












































































































































































































































































































