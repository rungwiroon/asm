; MODEL.INC for ASM32/DPMI source code

.386

.model small

DPMI	equ	1

;Structure of parameter table for real mode interrupt and procedure calling.
;
;NOTE:- For interrupts, CS:IP,SS:SP & Flags are filled in by the extender.
;       For far calls, SS:SP & Flags are filled in by the extender.
;
RealRegsStruc struc
Real_EDI	dd ?	;EDI
Real_ESI	dd ?	;ESI
Real_EBP	dd ?	;EBP
		dd ?	;Reserved.
Real_EBX	dd ?	;EBX
Real_EDX	dd ?	;EDX
Real_ECX	dd ?	;ECX
Real_EAX	dd ?	;EAX
Real_Flags	dw ?	;FLAGS
Real_ES	dw ?	;ES
Real_DS	dw ?	;DS
Real_FS	dw ?	;FS
Real_GS	dw ?	;GS
Real_IP	dw ?	;IP
Real_CS	dw ?	;CS
Real_SP	dw ?	;SP
Real_SS	dw ?	;SS
RealRegsStruc ends


Sys	macro p1
;
;Call a system function. Operand supplied is the function number. Use
;of this macro is not obligatory, use your own version if you want.
;
	mov	ax,p1
	int	31h
	endm

; Function 000Ah - Create Alias Descriptor:
;-----------------------------------------------
;
;Creates a new data descriptor that has the same base and limit as the
;specified descriptor.
;
;In:
;  AX     = 000ah
;  BX     = selector
;
;Out:
;  if successful:
;  AX     = data selector (alias)
;
;  if failed:
;  AX     = error code:
;           8011h - descriptor unavailable
;           8022h - invalid selector
;
;Notes:
;) The selector supplied to the function may be either a data descriptor or
;  a code descriptor. The alias descriptor created is always an expand-up
;  writeable data segment.
;
;) The descriptor alias returned by this function will not track changes to the
;  original descriptor.

AliasSel	equ	000Ah


; Function 0100h - Allocate DOS Memory Block:
;--------------------------------------------
;
; Allocate a block of DOS memory, returning AX real-mode segment and
; BX selector for allocated block
;
; In:  BX = paragraphs to allocate
; Out: [CF=0] AX = real-mode segment base address
;             BX = selector for allocated block
;      [CF=1] AX = error code
;             BX = size of larges available block in paragraphs
;

GetMemDOS	equ	0100h


; Function 0101h - Free DOS Memory Block:
;----------------------------------------
;
; Release a block of DOS (conventional) memory previously allocated with
; GetMemDOS.
;
; In:  DX = Selector of block to free
; Out: [CF=0] no error
;      [CF=1] AX = DOS error code
;
;Notes:
;
;) All descriptors allocated for the memory block are automatically freed
;  and therefore should not be accessed once the block is freed by this
;  function.

RelMemDOS	equ	0101h


; Function 0102h - Resize DOS Memory Block:
;------------------------------------------
;
; Resize a block of DOS (conventional) memory previously allocated with
; GetMemDOS.
;
; In:  BX = New block size in paragraphs
;      DX = Selector of block to modify
; Out: [CF=0] no error
;      [CF=1] AX = DOS error code:
;             BX = Maximum block size possible in paragraphs
;
;Notes:
;
;) Growing a memory block is often likely to fail since other DOS block
;  allocations will prevent increasing the size of the block. Also, if the
;  size of a block grows past a 64K boundary then the allocation will fail
;  if the next descriptor in the LDT is  not free.
;
ResMemDOS	equ	0102h


; Function 0300h - Simulate Real Mode Interrupt:
;-----------------------------------------------------
;
;Simulates an interrupt in real mode. The function transfers control to the
;address specified by the real mode interrupt vector. The real mode handler
;must return by executing an IRET.
;
;In:
;  AX     = 0300h
;  BL     = interrupt number
;  BH     = must be 0
;  CX     = number of words to copy from the protected mode stack to the real
;           mode stack
;  ES:EDI = selector:offset of real mode register data structure in the
;           following format:
;
;           Offset  Length  Contents
;           00h     4       EDI
;           04h     4       ESI
;           08h     4       EBP
;           0ch     4       reserved, ignored
;           10h     4       EBX
;           14h     4       EDX
;           18h     4       ECX
;           1ch     4       EAX
;           20h     2       CPU status flags
;           22h     2       ES
;           24h     2       DS
;           26h     2       FS
;           28h     2       GS
;           2ah     2       IP (reserved, ignored)
;           2ch     2       CS (reserved, ignored)
;           2eh     2       SP
;           30h     2       SS
;
;Out:
;  if successful:
;  ES:EDI = selector offset of modified real mode register data structure
;
;  if failed:
;  AX     = error code:
;           8012h - linear memory unavailable (stack)
;           8013h - physical memory unavailable (stack) (DPMI 1.0 only)
;           8014h - backing store unavailable (stack) (DPMI 1.0 only)
;           8021h - invalid value (CX too large) (DPMI 1.0 only)
;
;Notes:
;) The CS:IP in the real mode register data structure is ignored by this
;  function. The appropriate interrupt handler will be called based on the
;  value passed in BL.
;
;) If the SS:SP fields in the real mode register data structure are zero, a
;  real mode stack will be provided by the host. Otherwise the real mode SS:SP
;  will be set to the specified values before the interrupt handler is called.
;
;) The flags specified in the real mode register data structure will be put on
;  the real mode interrupt handler's IRET frame. The interrupt handler will be
;  called with the interrupt and trace flags clear.
;
;) Values placed in the segment register positions of the data structure must
;  be valid for real mode. That is, the values must be paragraph addresses, not
;  protected mode selectors.
;
;) The target real mode handler must return with the stack in the same state
;  as when it was called. This means that the real mode code may switch stacks
;  while it is running, but must return on the same stack that it was called
;  on and must return with an IRET.
;
;) When this function returns, the real mode register data structure will
;  contain the values that were returned by the real mode interrupt handler.
;  The CS:IP and SS:SP values will be unmodified in the data structure.
;
;) It is the caller's responsibility to remove any parameters that were pushed
;  on the protected mode stack.

IntXX		equ	0300h


; Function 0501h - Allocate Memory Block:
;----------------------------------------------
;
;Allocates a block of extended memory.
;
;In:
;  AX     = 0501h
;  BX:CX  = size of block in bytes (must be non-zero)
;
;Out:
;  if successful:
;  BX:CX  = linear address of allocated memory block
;  SI:DI  = memory block handle (used to resize and free block)
;
;  if failed:
;  AX     = error code:
;           8010h - internal resource unavailable (stack) (XMS only)
;           8012h - linear memory unavailable (DPMI 1.0/VCPI only)
;           8013h - physical memory unavailable
;           8014h - backing store unavailable (DPMI 1.0 only)
;           8016h - handle unavailable (DPMI 1.0/XMS only)
;           8021h - invalid value (BX:CX = 0)
;
;Notes:
;) The allocated block is guaranteed to have at least paragraph alignment.
;
;) This function does not allocate any descriptors for the memory block. It is
;  the responsibility of the client to allocate and initialize any descriptors
;  needed to access the memory with additional function calls.
;
;) The allocations by this function could be paragraph, kilobyte, or page
;  aligned. That is, the value you request could be rounded up to the next
;  paragraph, kilobyte, or page value.

GetMem		equ	0501h


; Function 0502h - Free Memory Block:
;------------------------------------------
;
;Frees a memory block previously allocated with the Allocate Memory Block
;function (0501h).
;
;In:
;  AX     = 0502h
;  SI:DI  = memory block handle
;
;Out:
;  if failed:
;  AX     = error code:
;           8010h - internal resource unavailable (stack) (XMS only)
;           8023h - invalid handle
;
;Notes:
;) No descriptors are freed by this call. It is the client's responsibility to
;  free any descriptors that it previously allocated to map the memory block.
;  Descriptors should be freed before memory blocks.

RelMem		equ	0502h


; Function 0503h - Resize Memory Block:
;--------------------------------------------
;
;Changes the size of a memory block previously allocated with the Allocate
;Memory Block function (0501h).
;
;In:
;  AX     = 0503h
;  BX:CX  = new size of block in bytes (must be non-zero)
;  SI:DI  = memory block handle
;
;Out:
;  BX:CX  = new linear address of memory block
;  SI:DI  = new memory block handle
;
;  if failed:
;  AX     = error code:
;           8010h - internal resource unavailable (stack) (XMS only)
;           8012h - linear memory unavailable (DPMI 1.0/VCPI only)
;           8013h - physical memory unavailable
;           8014h - backing store unavailable (DPMI 1.0 only)
;           8016h - handle unavailable (DPMI 1.0/XMS only)
;           8021h - invalid value (BX:CX = 0)
;           8023h - invalid handle
;
;Notes:
;) After this function returns successfully, the previous handle for the memory
;  block is invalid and should not be used anymore.
;
;) It is the client's responsibility to update any descriptors that map the
;  memory block with the new linear address after resizing the block.

ResMem		equ	0503h
