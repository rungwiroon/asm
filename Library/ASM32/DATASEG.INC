; data segment definition for ASM32 library functions

IFDEF	NEARMODEL
_NEAR	segment dword public 'near' use32
	assume cs:_NEAR, ds:_NEAR
ELSE
.data
ENDIF
