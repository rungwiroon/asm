; STARTCW.ASM for ASM32CW - Copyright (C) 1994, 1995 Douglas Herr
;  all rights reserved

include	model.inc

IFNDEF	NEARMODEL
;
; define stack for all models except NEAR
;
IFNDEF	STACKSIZE
STACKSIZE	equ	2048
ENDIF

.stack	STACKSIZE
ENDIF

;
; tell WL32 which library to use
;
IFDEF	NEARMODEL
includelib	asm32cw
ENDIF
IFDEF	SMALLMODEL
includelib	asm32cws
ENDIF
IFDEF	FLATMODEL
includelib	asm32cwf
ENDIF

;
; public symbols
;
public	$pspsel, $xferseg
public	zero_sel
IFDEF	SMALLMODEL
public	alias_code_sel
ENDIF

extrn	main32:near

include	dataseg.inc

zero_sel	dw ?		; 4G selector for linear address 0000:0000
psp_sel		dw ?		; 100h selector for PSP segment
xfer_buffer	dd ?		; size of transfer buffer (always < 64k)
xfer_seg	dw ?		; real-mode segment address of transfer buffer
xfer_sel	dw ?		; selector of transfer buffer
xfer_offset	dd ?		; offset of transfer buffer
system_flags	dd ?		; CW extender flags
IFDEF	SMALLMODEL
alias_code_sel	dw ?
ENDIF
@curseg	ends

include	codeseg.inc

start:
;
; set up selectors except SS, CS
;
IFDEF	NEARMODEL
	mov	ax,_NEAR
ELSE
	mov	ax,@data
ENDIF
	mov	ds,ax
	mov	es,ax
	mov	fs,ax
	mov	gs,ax

	call	get_system_data		; initialize ZERO_SEL, PSP_SEL, etc
	call	main32

	mov	ax,4C00h
	int	21h

;
; get CW-ASM system data using CW API
;

$pspsel:
	mov	ax,psp_sel
	ret

$xferseg:
	mov	bx,xfer_seg	; real-mode segment address of buffer
	mov	eax,xfer_offset
	mov	ecx,xfer_buffer	; size of transfer buffer
	ret

get_system_data:
	pushad
	push	es

	sys	info		; API function to get CW extender data
	mov	zero_sel,ax
	mov	psp_sel,bx
	mov	xfer_buffer,ecx
	mov	xfer_seg,dx
	mov	xfer_offset,esi
	mov	xfer_sel,es
	mov	system_flags,edi
IFDEF	SMALLMODEL
	mov	bx,cs
	sys	AliasSel
	mov	alias_code_sel,ax
ENDIF
	pop	es
	popad
exit:
	ret

@curseg	ends
	end	start
