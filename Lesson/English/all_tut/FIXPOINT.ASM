comment !
2 macros for 16.16 bit fixed point multiplication and division
including test values and routines. After the macro the result is
always located in EAX. Addition and subtraction can be done as with
normal 32 bit integers.
a 32 bit value is composed from a 16 bit part and a 16 bit fraction.
e.g. 2.5 is 00028000h
                |  |
The (not negative) fractional part is computed in this way:

                   -1
                DDDDDDDD
                \               i
FRACTION =       \      bit  * 2
                 /         i
                /
                DDDDDDDD
                 i=-16

note: in the fraction word the lsb is bit
                                         -16

in this way 1/3 is 00005555h

  1     1     1     1     1     1     1     1     1
 --- + --- + --- + --- + --- + --- + --- + --- + ---  = 0.333328247
   1     2     4     6     8     10    12    14    16
  2     2     2     2     2     2     2     2     2

if you need negative values use the 2-complement as show in the samples

this stuff and the code examples are done by the counselor/chalice in 1994

.MODEL TINY
!
; 000000000000000000000000000000000000000000000000000000000000000000000000
FIXIMUL MACRO   R0
        IMUL    R0                        ;IMUL EAX,R0
        SHRD    EAX,EDX,16                ;SHIFT WHOLE PART LEFT AND
        ENDM                              ;FRACTION INTO LOWER BITS

FIXIDIV MACRO   R0
        CDQ                               ;SIGN EXTEND INTO EDX
        SHLD    EDX,EAX,16                ;SHIFT WHOLE PART INTO EDX AND
        SHL     EAX,16                    ;FRACTION INTO HIGHER BITS
        IDIV    R0                        ;IDIV EDX:EAX,R0
        ENDM
; 000000000000000000000000000000000000000000000000000000000000000000000000
comment !
.DATA
ALIGN 2
FIXPOINT1       DD     000010000H         ;1.0
FIXPOINT2       DD     000020000H         ;2.0
FIXPOINT3       DD     000028000H         ;2.5
FIXPOINT4       DD     (NOT 000024000H)+1 ;-2.25
FIXPOINT5       DD     (NOT 000028000H)+1 ;-2.5
FIXPOINT6       DD     (NOT 000020000H)+1 ;-2.0
FIXPOINT7       DD     000030000H         ;3.0
.CODE
.386
MAIN:
        mov     ax,@data
        mov     ds,ax
        MOV     EAX,FIXPOINT1           ;1.0
        MOV     EBX,FIXPOINT2           ;2.0
        FIXIMUL EBX                     ;=2.0

        MOV     EBX,FIXPOINT3           ;2.5
        FIXIMUL EBX                     ;=5.0

        MOV     EBX,FIXPOINT4           ;-2.25
        FIXIMUL EBX                     ;=-11.25

        MOV     EAX,FIXPOINT6           ;-2
        MOV     EBX,FIXPOINT6           ;-2
        FIXIMUL EBX                     ;=4

        MOV     EAX,FIXPOINT1           ;1.0
        MOV     EBX,FIXPOINT2           ;2.0
        FIXIDIV EBX                     ;=0.5

        MOV     EAX,FIXPOINT5           ;-2.5
        MOV     EBX,FIXPOINT2           ;2.0
        FIXIDIV EBX                     ;=-1.25

        MOV     EAX,FIXPOINT6           ;-2
        MOV     EBX,FIXPOINT2           ; 2
        FIXIMUL EBX                     ;=-4
        MOV     EBX,FIXPOINT6           ;-2
        FIXIDIV EBX                     ;=2

        MOV     EAX,FIXPOINT1           ;1
        MOV     EBX,FIXPOINT7           ;3
        FIXIDIV EBX                     ;=1/3

        MOV     AX,4C00H
        INT     21H
        END     MAIN
