; code segment definition for ASM32 library functions

IFDEF	NEARMODEL
_NEAR	segment dword public 'near' use32
	assume cs:_NEAR, ds:_NEAR
CGROUP	EQU	_NEAR
ELSE
.code
CGROUP	EQU	_TEXT
ENDIF

StackEAX	equ	[esp+7*4]
StackECX	equ	[esp+6*4]
StackEDX	equ	[esp+5*4]
StackEBX	equ	[esp+4*4]
StackESP	equ	[esp+3*4]
StackEBP	equ	[esp+2*4]
StackESI	equ	[esp+1*4]
StackEDI	equ	[esp+0*4]

IFDEF	FLATMODEL
zs	equ	ds
ELSE
zs	equ	es
ENDIF