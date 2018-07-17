;----------------------
; Toby Opferman
;   Random Number
;    Generator
; _Secret
; http://www.opferman.com
; toby@opferman.com
;----------------------
.MODEL TINY
.386

.DATA

 Seed1 dw ?
 Seed2 dw ?
 Seed3 dw ?
 Seed4 dw ?
 String db "      ",13, 10, "$"

.CODE
 ORG 0100h
START:
 CALL Seed                      ; Seed Random Number

 RANDP:
 CALL RAND                      ; Get a Random Number in AX

 MOV DX, AX                     ; DX == Value To Convert To String
                                
 MOV DI, OFFSET String          ; Get OffSet Of Data String

 PUSH DI                        ; Save
 CALL NUMBA                     ; Convert Register To Ascii
 POP DX                         ; Restore Address in DX

 MOV AH, 9h                     ; Fun 9h Of DOS, Print String
 INT 21h                        ; Terminated By a $

 MOV AH, 1                      ; Is Key Waiting In Buffer?
 INT 16h
 JZ RANDP                       ; No, Then Continue

 RET                            ; Exit

;--------------------------------
; Converts a Number to a String
; Number is in DX
; String in ES:DI
;--------------------------------

; 48 = 0
NUMBA PROC
     PUSH DX            ; Save Number
     MOV BX, 10000      ; Start At 10000's Place (Max Int Base 10)
     PUSH BX            ; Save The Number Place

     MOV CX, 5          ; Loop 5 Number Places (10000)

     LOOPER:            ; Loop All 5 Number Places
     POP BX             ; Restore Number Place
     POP AX             ; Restore Number

     PUSH CX            ; Save Current Loop Number

     XOR DX, DX         ; Clear DX For DIVISION
     MOV CX, AX         ; Save Number and Divide By Number Places

     DIV BX             ; Divide To Get Only The TOP Digit
                        ; (i.e. 2330/1000 = 2)

     POP DX             ; Get Current Loop Number 
     PUSH AX            ; Save Integer Part Of Number/1xxxxx

     ADD AL, 48         ; Add 48 Onto The Low Part (To Make Into Ascii Number)
     MOV ES:[DI], AL    ; Put Ascii In String

     INC DI             ; Inc To Next Position in String

     POP AX             ; Restore Digit
     PUSH DX            ; Save Current Loop Number

     XOR DX, DX         ; Clear DX For Multiplication
     MUL BX             ; MULTIPLY By 1xxxx*SingleDigit
                        ; (i.e. 100*3 = 300)
     SUB CX, AX         ; Now, Subtract High End Off
                        ; (i.e. 300 - 324 = 24)
     MOV AX, CX

     POP CX             ; Get Current Loop Number
     PUSH AX            ; Save New Number

     XOR DX, DX         ; Clear DX For Division
     MOV AX, BX         ; Get 1xxxx Number

     MOV BX, 10         ; Divide it By 10 (To Go Down Next Level)
     DIV BX             ; (i.e. 1000/10 = 100)        

     PUSH AX            ; Save 1xxxx Number
     LOOP LOOPER        ; If CX != 0, Loop Again

     POP AX             ; Clear Stack (Bogus)
     POP AX             ; & Unused
     RET
ENDP NUMBA



;-------------------
; Returns a Random
; Number In AX
;-------------------

RAND PROC
  MOV AX, [Seed1]               ; Restore Seed Numbers
  MOV BX, [Seed2]
  MOV CX, [Seed3]
  MOV DX, [Seed4]

  ADD AX, BX                    ; Perform Weird
  XCHG CL, CH                   ; Operations                
  SBB DX, AX                    ; To Insure

  ADC CL, AL
  ADC AH, BL
  ADC AX, DX

  ROR DX, CL                    ; A Good Pseudo
  ROL AX, CL
  ADC AX, CX                    ; Number

  XCHG DL, CH
  XCHG DX, BX
  XCHG CH, AL
  XCHG BL, DH

  SBB AX, CX
  ADC AX, BX

  MOV [Seed1], AX               ; Save Seed Numbers
  MOV [Seed2], BX
  MOV [Seed3], CX
  MOV [Seed4], DX

  RET                           ; Return
ENDP RAND


;----------------
; Seed Random Numbers
;    Number
; Call Once Before Using RAND
;
;----------------
Seed PROC 

 MOV AH, 02h
 INT 01Ah               ; Get Clock Timer Settings

 MOV AX, DX
 MOV BX, CX

 MOV [Seed1], AX        ; Seed 1

 XCHG AL, AH            ; Perform Some Wacky Operations
 SBB AH, AL
 ADC AX, AX
 ROR BX, CL

 MOV [Seed2], AX        ; Seed 2

 ROR AX, CL

 MOV [Seed3], AX        ; Seed 3

 MOV CX, DS             ; Get Data Segment

 ADC CX, BX             ; More Wacky Operations
 ADC AX, BX
 XCHG AH, BL
 XCHG AL, AH
 ADC AL, AH

 MOV [Seed4], AX        ; Seed 4
 RET
ENDP Seed

END START
