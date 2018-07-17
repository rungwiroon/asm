;**************************** DISKINFO.ASM **********************************
PAGE  70,132

;Purpose:  Display information about DOS and BIOS fixed disk setup
;Usage:  DISKINFO <seg>
;        where: <seg> is optional memory area to dump
        
	include	mac.inc
	include	common.inc
;-----------------------------------------------------------------------------
	extrn	library_setup:far
	extrn	clear_screen:far
	extrn	library_terminate:far
	extrn	byte_to_hex_str:far
	extrn	word_to_hex_str:far

;------------------------------- STRUCTURES -----------------------------------

lists struc
dpb_ptr	dd	?		;ptr to dpb for A:
       	dd	?		;ptr to system file table
	dd	?		;ptr to clock dev
	dd	?		;ptr to CON device
bps_	dw	?		;max bytes per sector
	dd	?		;ptr to disk buffer rec
	dd	?		;ptr to array of current dir struc's
	dd	?		;ptr to system FCB tables
	dw	?		;number of FCB's
	db	?		;number of block devices
nulld	db	?		;start of null device header
lists	ends

; location 40:75 has number of fixed disks
; location 0:4c  (int 13) disk bios entry
; location 0:100 (int 40) grabber by fixed disk
; location 0:104 (int 41) has fixed disk 0 parameters
; location 0:118 (int 46) has fixed disk 1 parameters
;

fparm	struc
f_num_cyl	dw	?		;number of cyl
f_num_hd	db	?		;number of heads
f_writec	dw	?		;write current
f_precom	dw	?		;write precomp
f_burst 	db	?		;burst
f_ctrl		db	?		;ctrl
	db	?
	db	?
	db	?
f_landing	dw	?		;landing cyl
f_sec_trk	db	?		;sect/track
fparm	ends
	
	
;------------------------------------------------------------------------------
code		segment para public 'CODE'
		assume	cs:code, ds:code
;-----------------------------------------------------------------------------
; 
pspseg		dw	0
lib_info_ptr	dw	0
lib_info_seg	dw	0


file_asciiz		db	40 dup (0)

stacksize	equ	1024
	db	stacksize dup (0)
stack_	label	word
;
signon_msg	label	byte
 db 'diskinfo execution started --------------------------',0dh,0ah,0

app_text_color		db	07h,'background color',0

 
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
	jmp	exitx
	
got_enough_mem:
;
; display signon message
;
	mov	si,offset signon_msg
	call	display
	call	crlf

	call	show_vectors

	call	show_bios_data

	call	show_devices

	call	show_dpb

	call	show_memory

	
exit:

; normal program exit

exitx:	mov	ax,1
	call	library_terminate
	mov	ax,4C00h
	int	21h


;------------------------------------------------------------------------

probe_msg1	label	byte
 db 'int13 reset returns       '
stuff_0	db '   (drive 0)       '
stuff_1 db '   (drive 1)',0

probe_msg2	label	byte
 db ' vectors  int13 [0000:004c] = '
stuff_a1 db '    :         int40 [0000:0100] = '
stuff_a2 db '    :     ',0

probe_msg3	label	byte
 db ' BIOS fixed disk count [0000:0075] = '
stuff_c db '    ',0

;--------------------------------------- 
show_vectors:
;
; issue reset to both possible fixed disks
;
	mov	ah,0dh
	mov	dl,80h
	int	13h
	jc	sv_ok1
	mov	ah,0
sv_ok1:	mov	al,ah
	mov	si,offset stuff_0
	call	byte_to_hex_str
;
	mov	ah,0dh
	mov	dl,81h
	int	13h
	jc	sv_ok2
	mov	ah,0
sv_ok2:	mov	al,ah
	mov	si,offset stuff_1
	call	byte_to_hex_str
;
	mov	si,offset probe_msg1
	call	display
;
; display int13 vector
;
	sub	ax,ax
	mov	es,ax
	mov	ax,es:4ch
	mov	dx,es:4eh
	push	ds
	pop	es
	mov	si,offset stuff_a1
	call	store_address
;
; display int40 vector
;
	sub	ax,ax
	mov	es,ax
	mov	ax,es:100h
	mov	dx,es:102h
	push	ds
	pop	es
	mov	si,offset stuff_a2
	call	store_address

	mov	si,offset probe_msg2
	call	display
;
; display BIOS fixed disk count
;
	sub	ax,ax
	mov	es,ax
	mov	al,es:[475h]
	push	ds
	pop	es
	mov	si,offset stuff_c
	call	byte_to_hex_str

	mov	si,offset probe_msg3
	call	display
	call	crlf		
		
	ret
;------------------------------------------------------------------------
sb_msg1 db 'BIOS fixed disk vector at int41 [0000:0104] points to '
stuff_b1 db '    :    ',0
sb_msg2 db 'BIOS fixed disk vector at int46 [0000:0118] points to '
stuff_b2 db '    :    ',0
;----------------------------------
show_bios_data:
	push	es
	mov	ax,0
	mov	es,ax
	les	di,es:[104h]

	mov	ax,di
	mov	dx,es
	mov	si,offset stuff_b1
	call	store_address
	
	mov	si,offset sb_msg1
	call	display
	call	show_bios_sub
	call	crlf
;
; show drive 1
;
	mov	ax,0
	mov	es,ax
	les	di,es:[118h]

	mov	ax,di
	mov	dx,es
	mov	si,offset stuff_b2
	call	store_address
	
	mov	si,offset sb_msg2
	call	display
	call	show_bios_sub
	call	crlf
	
	pop	es	
	ret
;-----------------------------------
; inputs:  es:di = ptr to block
;
show_bios_sub:

	mov	ax,es:[di.f_num_cyl]
	mov	si,offset stuff_s1
	call	word_to_hex_str
	mov	si,offset sbd_msg1
	call	display
	
	mov	al,es:[di.f_num_hd]
	mov	si,offset stuff_s2
	call	byte_to_hex_str
	mov	si,offset sbd_msg2
	call	display
	
	mov	ax,es:[di.f_writec]
	mov	si,offset stuff_s3
	call	word_to_hex_str
	mov	si,offset sbd_msg3
	call	display
	
	mov	ax,es:[di.f_precom]
	mov	si,offset stuff_s4
	call	word_to_hex_str
	mov	si,offset sbd_msg4
	call	display
	
	mov	al,es:[di.f_burst]
	mov	si,offset stuff_s5
	call	byte_to_hex_str
	mov	si,offset sbd_msg5
	call	display
	
	mov	ax,es:[di.f_landing]
	mov	si,offset stuff_s6
	call	word_to_hex_str
	mov	si,offset sbd_msg6
	call	display
	ret	

sbd_msg1 db '  number of cylinders = '
stuff_s1 db '    ',0
sbd_msg2 db '  number of heads = '
stuff_s2 db '    ',0
sbd_msg3 db '  write current = '
stuff_s3 db '    ',0
sbd_msg4 db '  pre compensation = '
stuff_s4 db '    ',0
sbd_msg5 db '  burst rate = '
stuff_s5 db '    ',0
sbd_msg6 db '  landing cylinder = '
stuff_s6 db '    ',0	
;------------------------------------------------------------------------
; displayl device chain
;

ddhead	struc
next_dd		dd	0	;
attrib		dw	0	;
strat_ptr	dw	0	;
int_ptr		dw	0	;
dev_name	db	8 dup (0);
ddhead	ends



show_devices:
	push	es
;
	mov	ah,52h		;get dos variables
	int	21h
				;es:bx -> vars
	add	bx,22h		;get to nul device

	call	crlf
	mov	dx,offset head0
	call	string_out

loop1:
	call	prt_dd		;print device driver info
	cmp	word ptr es:[bx],0FFFFh	;check if last driver in chain
	je	done		;yes - so exit
	les	bx,es:[bx]	;get address of next driver
	jmp	short loop1		

done:	pop	es
	ret
;-----------------------------

prt_dd	proc	near		
;Print pertinent field of device driver header
;Input: ES:BX points to device driver header
;Output: None

	push	ax		;save registers
	push	bx
	push	cx
	push	dx
	push	si

	mov	dx,es		;segment of device driver
	call	hex_to_ascii
	mov	al,':'
	call	char_out

	mov	dx,bx		;offset of device driver
	call	hex_to_ascii
	mov	al,' '
	call	char_out
	mov	al,' '
	call	char_out

	mov	dx,es:[bx.attrib]	;attribute
	call	hex_to_ascii
	mov	al,' '
	call	char_out
	mov	al,' '
	call	char_out

	mov	dx,es		;Print SEG:OFS of Strategy
	call	hex_to_ascii
	mov	al,':'
	call	char_out
	mov	dx,es:[bx.strat_ptr]
	call	hex_to_ascii
	mov	al,' '
	call	char_out

	mov	dx,es		;Print SEG:OFS of Interrupt
	call	hex_to_ascii
	mov	al,':'
	call	char_out
	mov	dx,es:[bx.int_ptr]
	call	hex_to_ascii

	mov	al,' '
	call	char_out
	mov	al,' '
	call	char_out

	mov	ax,es:[bx.attrib];Print BLOCK or CHAR
	and	ax,0f000h
	test	ax,8000h
	jnz	is_char		;Has Character Attribute

	mov	dx,offset block	;Print Out Block Info
	call	string_out	
	mov	al,' '
	call	char_out

	mov	al,es:[bx+10]
	add	al,48
	call	char_out
	jmp	prt_dd1

is_char:mov	dx,offset char	;Print Out Character Info
	call	string_out
	mov	al,' '
	call	char_out
	mov	si,bx
	add	si,10
	mov	cx,8

is_char_loop:			;Print Out Character Device Name
	mov	al,es:[si]
	inc	si	
	call	char_out
	loopnz	is_char_loop

prt_dd1:
	call	crlf

	pop	si		;restore registers
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret	
prt_dd	endp
;-----------------------------------
char_out proc near  ;output character in al
	push	dx
	mov	dl,al
	mov	ah,2
	int	21h
	pop	dx
	ret
char_out	endp


hex_to_ascii	proc	near	;output hex word in dx 
	push	cx
	push	ax
	mov	cx,4
hex1:
	push	cx
	mov	cl,4
	rol	dx,cl
	mov	al,dl
	and	al,0fh
	daa
	add	al,0f0h
	adc	al,040h
	call	char_out
	pop	cx
	loop	hex1
	
	pop	ax
	pop	cx	
	ret
hex_to_ascii	endp

string_out	proc	near	;print a string pointed to by DS:DX
				;first byte of string is length

	push	ax
	push	bx
	push	cx
	push	dx
	mov	ah,40h
	mov	bx,dx
	inc	dx	;point to string
	mov	cl,[bx]	;get length
	mov	ch,0
	mov	bx,1	;standard output
	int	21h
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret
string_out	endp

;
;data
;

head0	db	162,'     D E V I C E    D R I V E R    C H A I N      ',13,10
    	db	    'Drv Addrs  Atrb  Strategy  Interrupt  Type  Name/Unit',13,10
	db	    '---------  ----  --------- ---------  ----- ---------',13,10
block	db	5,'Block'
char	db	5,'Char '
;


	ret
;------------------------------------------------------------------------
	
dpb	struc
dpb_dr	db	?		;drive number 0=a:
dpb_u	db	?		;unit
dpb_bs	dw	?		;bytes per sector
dpb_sc	db	?		;sectors/cluster
	db	?
dpb_r	dw	?		;reserved sectors at start
dpb_f	db	?		;number of fats
dpb_rn	dw	?		;max entries in root
dpb_d1	dw	?		;first data sector
dpb_cl	dw	?		;clusters
dpb_sf	dw	?		;sectors per fat
dpb_dir	dw	?		;first dir sector
dpb_dev	dd	?		;ptr to device drvr
dpb_m	db	?		;media byte
dpb_a	db	?		;disk accessed yet, ff=no
dpb_nex	dd	?		;ptr to next dpb
dpb	ends


show_dpb:
	call	crlf
	
	push	es
	push	ds
	mov	ah,32h
	mov	dl,03		;get DPB for drive c:
	int	21h
	mov	di,bx		;offset to -di-
	mov	bx,ds
	mov	es,bx		;set to -es-
	pop	ds
sh_loop:
	mov	ax,es
	cmp	ax,-1
	je	sh_done		;jmp if last dpb
	call	show_dpb_sub
	les	di,dword ptr es:[di.dpb_nex]
	jmp	sh_loop	
sh_done:
	pop	es
	ret

dpb_msg1 db 'DPB (Disk paramter block) for fixed disk, stored at ['
stuff_dp1 db '    :    ]',0
;---------------------------
; inputs:  es:di point at DPB
;
show_dpb_sub:
	mov	ax,di
	mov	dx,es
	mov	si,offset stuff_dp1
	call	store_address
	mov	si,offset dpb_msg1
	call	display
;
; drive number
;
	mov	al,es:[di.dpb_dr]
	mov	si,offset stuff_dr
	call	byte_to_hex_str
	mov	si,offset dpb_dr_msg
	call	display
			
;
; unit number
;
	mov	al,es:[di.dpb_u]
	mov	si,offset stuff_u
	call	byte_to_hex_str
	mov	si,offset dpb_u_msg
	call	display
;
; bytes per sector
;
	mov	ax,es:[di.dpb_bs]
	mov	si,offset stuff_bs
	call	word_to_hex_str
	mov	si,offset dpb_bs_msg
	call	display
;
; sectors per cluster
;
	mov	al,es:[di.dpb_sc]
	mov	si,offset stuff_sc
	call	byte_to_hex_str
	mov	si,offset dpb_sc_msg
	call	display
;
; reserved sectors
;
	mov	ax,es:[di.dpb_r]
	mov	si,offset stuff_r
	call	word_to_hex_str
	mov	si,offset dpb_r_msg
	call	display
;
; number of fats
;
	mov	al,es:[di.dpb_f]
	mov	si,offset stuff_f
	call	byte_to_hex_str
	mov	si,offset dpb_f_msg
	call	display
;
; skip forward
; device driver
;
	mov	ax,word ptr es:[di.dpb_dev]
	mov	dx,word ptr es:[di.dpb_dev+2]
	mov	si,offset stuff_dev
	call	store_address
	mov	si,offset dpb_dev_msg
	call	display
;
; accessed yet flag
;
	mov	al,es:[di.dpb_a]
	mov	si,offset stuff_a
	call	byte_to_hex_str
	mov	si,offset dpb_a_msg
	call	display
			
	ret
	
dpb_dr_msg	db '  drive# (0=A:) '
stuff_dr	db '  ',0
dpb_u_msg	db '  unit# '
stuff_u		db '  ',0
dpb_bs_msg	db '  bytes per sector = '
stuff_bs	db '    ',0
dpb_sc_msg	db '  sectors per cluster = '
stuff_sc	db '  ',0	
dpb_r_msg	db '  reserved sectors = '
stuff_r		db '    ',0
dpb_f_msg	db '  number of fats = '
stuff_f		db '    ',0
dpb_dev_msg	db '  device driver at '
stuff_dev	db '    :    ',0
dpb_a_msg	db '  disk accessed yet, ff=no - '
stuff_a		db '  ',0
;------------------------------------------------------------------------
show_memory:
	ret
;------------------------------------------------------------------------

;------------------------------------------------------------------------
;------------------------------------------------------------------------
; display - display one line to stdout
;  inputs:  ds:si = msg
;
display:
	lodsb
	or	al,al
	jz	crlf
	mov	dl,al
	mov	ah,2
	int	21h
	jmp	display
;------------------------------------------------------------------------
crlf:	mov	dl,0dh
	mov	ah,02h
	int	21h
	mov	dl,0ah
	mov	ah,02h
	int	21h
	ret
;------------------------------------------------------------------------
; store_address - display segment:offset
;  ax = offset
;  dx = segment
;  ds:si = storage point
;
store_address:
	apush	ax,dx,di,si
	xchg	ax,dx
	call	word_to_hex_str
	mov	byte ptr ds:[si],':'
	inc	si
	xchg	ax,dx
	call	word_to_hex_str
	apop	si,di,dx,ax
	ret
;------------------------------------------------------------------------

	
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
