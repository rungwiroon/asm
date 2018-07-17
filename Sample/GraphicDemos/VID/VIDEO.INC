; These are EQUates / global declaractions for the VIDEO.ASM module.

; Author: David Bennett - Version 1.0 - Date: 11/9/88
;
; Please see the file VIDEO.DOC for more info.  VIDDEMO.ASM has examples
; of how to use this include file in your programs.
;

; ---------------------
; Various video equates
; ---------------------

; Memory areas

MonoSeg         EQU     0B000h          ; Mono screen segment
CGASeg          EQU     0B800h          ; CGA screen segment

; Video Modes

BW40            EQU     0               ; 40x25 B/W on Color Adapter
CO40            EQU     1               ; 40x25 Color on Color Adapter
BW80            EQU     2               ; 80x25 B/W on Color Adapter
CO80            EQU     3               ; 80x25 Color on Color Adapter
Mono            EQU     7               ; 80x25 on Monochrome Adapter

; Foreground / Background color constants

Black           EQU     0
Blue            EQU     1
Green           EQU     2
Cyan            EQU     3
Red             EQU     4
Magenta         EQU     5
Brown           EQU     6
LightGray       EQU     7

; Foreground color constants

DarkGray        EQU     8
LightBlue       EQU     9
LightGreen      EQU     10
LightCyan       EQU     11
LightRed        EQU     12
LightMagenta    EQU     13
Yellow          EQU     14
White           EQU     15

; Add this for blink

Blink           EQU     10000000b       ; Blink Bit
UnderLine       EQU     00000001b       ; Underline Bit (Mono Only)

; Some commonly used attributes

Normal          EQU     7       ; Gray on Black (Low Intensity)
Reverse         EQU     112     ; Black on Gray
HighInt         EQU     15      ; White on Black (High Intensity)

; ------------------------
; Global data in VIDEO.ASM
; ------------------------

GLOBAL BaseOfScreen:WORD
GLOBAL SnowCheck:BYTE
GLOBAL VideoMode:BYTE

; -------------------------------------------
; Global procedure declarations for VIDEO.ASM
; -------------------------------------------

GLOBAL  EGAInstalled:PROC
GLOBAL  GetVideoMode:PROC
GLOBAL  DWriteCH:PROC
GLOBAL  DWriteCHNA:PROC
GLOBAL  DWriteStr:PROC
GLOBAL  DWriteStrNA:PROC
GLOBAL  DFillCH:PROC
GLOBAL  DFillCHNA:PROC
GLOBAL  DFillAttr:PROC
GLOBAL  StoreToMem:PROC
GLOBAL  StoreToScr:PROC
GLOBAL  CursorOff:PROC
GLOBAL  CursorOn:PROC
