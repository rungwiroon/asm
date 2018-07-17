; DPMI32.ASM for ASM32/DPMI - Copyright (C) 1995 Douglas Herr
;  all rights reserved

include	model.inc

IFNDEF	DPMI
DPMI	equ	1
ENDIF

public	GetMemNear, RelMemNear, ResMemNear, GetSelDet32
public	GetMemLinear32, RelMemLinear32, ResMemLinear32
public	Linear2Near, Near2Linear

include	dataseg.inc
extrn	zero_sel:word
@curseg	ends

include	codeseg.inc

; GetMemNear
;
; In:  EBX = bytes
; Out: ESI = near address of block

GetMemNear:
	push	ecx
	mov	ecx,ebx			; bytes
	call	GetMemLinear32		; ret: ESI = linear address
	jc	short GetMemNearExit
	call	Linear2Near		; ret: ESI = near address

GetMemNearExit:
	pop	ecx
	ret



; RelMemNear
;
; release memory allocated by GetMemNear
; ESI = near memory address

RelMemNear:
	pushad

	call	Near2Linear
	jc	short RelMemNearExit
	call	RelMemLinear32

RelMemNearExit:
	popad
	ret



; ResMemNear
;
; In:  ESI = existing near base address
;      ECX = new size requested
; Out: ESI = new base address

ResMemNear:
	call	Near2Linear		; convert to linear address
	jc	short ResMemNearExit
	call	ResMemLinear32		; resize
	jc	short ResMemNearExit
	call	Linear2Near		; convert to near address
ResMemNearExit:
	ret


; ResMemLinear32
;
; In:  ESI = linear address of memory block
;      ECX = new block size
; Out: [CF=0] ESI = new block address
;      [CF=1] AX = error code

ResMemLinear32:
	push	ebx
	push	ecx
	push	edx
	push	edi
	push	es

	mov	es,zero_sel
	mov	esi,es:[esi-4]		; get handle
	movzx	edi,si
	shr	esi,16			; SI:DI = block handle

	add	ecx,4			; allow space for handle storage
	mov	ebx,ecx
	movzx	ecx,cx
	shr	ebx,16			; BX:CX = bytes

	mov	ax,0503h		; resize linear memory
	int	31h
	jc	short ResMemLinear32Exit

	shl	esi,16
	mov	si,di			; ESI = handle

	shl	ebx,16
	mov	bx,cx			; EBX = new address of block
	mov	es:[ebx],esi
	add	ebx,4
	mov	esi,ebx			; new block address
	clc				; no error

ResMemLinear32Exit:
	pop	es
	pop	edi
	pop	edx
	pop	ecx
	pop	ebx
	ret



; Linear2Near
;
; In:  ESI = linear address
; Out: ESI = near address

Linear2Near:
	pushad

	mov	bx,ds
	call	GetSelDet32		; ret: EDX = selector base address
	jc	short Linear2NearExit

	mov	ebx,esi			; linear address
	sub	ebx,edx
	jc	short Linear2NearExit
	mov	esi,ebx

Linear2NearExit:
	mov	StackESI,esi
	popad
	ret


; Near2Linear
;
; In:  ESI = near address
; Out: ESI = linear address

Near2Linear:
	pushad

	mov	bx,ds
	call	GetSelDet32		; ret: EDX = selector base address
	jc	short Near2LinearExit
	add	esi,edx			; add base to near -> linear

Near2LinearExit:
	mov	StackESI,esi
	popad
	ret


; GetMemLinear
;
; In:  ECX = bytes
; Out: ESI = linear address

GetMemLinear32:
	pushad
	push	es

	add	ecx,4		; allow space for handle storage
	mov	ebx,ecx
	shr	ebx,16		; BX:CX = bytes
	mov	ax,0501h
	int	31h
	jc	short GetMemLinear32Exit

	shl	ebx,16
	mov	bx,cx		; EBX = linear address

	shl	esi,16
	mov	si,di		; ESI = handle

	mov	es,zero_sel
	mov	es:[ebx],esi

	add	ebx,4
	mov	esi,ebx		; user address

GetMemLinear32Exit:
	pop	es
	mov	StackESI,esi
	popad
	ret


; RelMemLinear32
;
; In:  ESI = linear address of memory block

RelMemLinear32:
	pushad
	push	es

	mov	es,zero_sel
	mov	esi,es:[esi-4]	; get handle
	movzx	edi,si
	shr	esi,16		; SI:DI = handle
	mov	ax,0502h
	int	31h

	pop	es	
	popad
	ret



; GetSelDet32
;
; In:  BX = selector
; Out: EDX = linear base address
;      ECX = selector byte limit

.386p

GetSelDet32:
	push	eax
	push	ebx
	mov	eax,0006h
	int	31h
	jc	short exitDet32
	movzx	edx,dx
	shl	ecx,16
	or	edx,ecx		; EDX = linear base address
	movzx	ebx,bx
	lsl	ecx,ebx		; ECX = byte limit
	clc

exitDet32:
	pop	ebx
	pop	eax
	ret

@curseg	ends
	end
