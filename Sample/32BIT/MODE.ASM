        .386p
        locals
        include pmc.inc

; Mode X (320x240, 256 colors) mode set routine. Works on all VGAs.
; C near-callable as:
;       void Set320x240Mode(unsigned scrwidth);
; Tested with TASM 2.0.
; Modified from public-domain mode set code by John Bridges.
;
; Modified Aug 30, 1994 (ykumanan)
; ) Made code 32 bit pm (not fully optimized)
;

SC_INDEX equ    03c4h   ;Sequence Controller Index
CRTC_INDEX equ  03d4h   ;CRT Controller Index
MISC_OUTPUT equ 03c2h   ;Miscellaneous Output register
CSCREEN_SEG equ 0a000h  ;segment of display memory in mode X
CRTC_OFFS equ 13h       ;offset

parms   struc
        dd      2 dup (?) ;pushed EBP and return address
ScrWid  dd      ?         ;reqstd width for scan line
parms   ends

        @dseg

        public  SCREEN_SEG, SCREEN_WIDTH

; Selector for the video segment
SCREEN_SEG      dd      0
SCREEN_WIDTH    dd      080h

; Index/data pairs for CRT Controller registers that differ between
; mode 13h and mode X.
CRTParms label  word
        dw      00d06h  ;vertical total
        dw      03e07h  ;overflow (bit 8 of vertical counts)
        dw      04109h  ;cell height (2 to double-scan)
        dw      0ea10h  ;v sync start
        dw      0ac11h  ;v sync end and protect cr0-cr7
        dw      0df12h  ;vertical displayed
        dw      00014h  ;turn off dword mode
        dw      0e715h  ;v blank start
        dw      00616h  ;v blank end
        dw      0e317h  ;turn on byte mode
CRT_PARM_LENGTH equ     (($-CRTParms)/2)

        ends

        @cseg

        public  _Set320x240Mode

_Set320x240Mode proc
        push    ebp      ;preserve caller's stack frame
        mov     ebp, esp
        push    esi      ;preserve C register vars
        push    edi      ; (don't count on BIOS preserving anything)
        push    ebx

        ;; make SCREEN_SEG first
        segoff2ptr      eax, CSCREEN_SEG, 0
        mov     SCREEN_SEG, eax
        ;; done

        mov     ax,13h  ;let the BIOS set standard 256-color
        int     10h     ; mode (320x200 linear)

        mov     dx,SC_INDEX
        mov     ax,0604h
        out     dx,ax   ;disable chain4 mode
        mov     ax,0100h
        out     dx,ax   ;synchronous reset while switching clocks

        mov     dx,MISC_OUTPUT
        mov     al,0e3h
        out     dx,al   ;select 28 MHz dot clock & 60 Hz scanning rate

        mov     dx,SC_INDEX
        mov     ax,0300h
        out     dx,ax   ;undo reset (restart sequencer)

        mov     dx,CRTC_INDEX ;reprogram the CRT Controller
        mov     al,11h  ;VSync End reg contains register write
        out     dx,al   ; protect bit
        inc     dx      ;CRT Controller Data register
        in      al,dx   ;get current VSync End register setting
        and     al,7fh  ;remove write protect on various
        out     dx,al   ; CRTC registers
        dec     dx      ;CRT Controller Index
        cld
        mov     esi,offset CRTParms ;point to CRT parameter table
        mov     ecx,CRT_PARM_LENGTH ;# of table entries
SetCRTParmsLoop:
        lodsw           ;get the next CRT Index/Data pair
        out     dx,ax   ;set the next CRT Index/Data pair
        loop    SetCRTParmsLoop

        mov     dx,SC_INDEX
        mov     ax,0f02h
        out     dx,ax   ;enable writes to all four planes
        mov     edi, [SCREEN_SEG] ; point es:edi to disp mem
        sub     ax,ax   ;clear to zero-value pixels
        mov     ecx,8000h ;# of words in display memory
        rep     stosw   ;clear all of display memory

        ;; set screen width to allow for horizontal panning
        mov     dx, CRTC_INDEX
        mov     al, CRTC_OFFS
        out     dx, al
        inc     dx

        mov     eax, [ebp+ScrWid]
        cmp     eax, 320                ; is it >= screen width?
        jge     @@valid
        mov     eax, 320
@@valid:
        shr     eax, 3                  ; div by 8 to make it work
        out     dx, al                  ; set it

        shl     eax, 1
        mov     [SCREEN_WIDTH], eax     ; # of bytes, not words
@@bye:
        pop     ebx
        pop     edi     ;restore C register vars
        pop     esi
        pop     ebp      ;restore caller's stack frame
        ret
_Set320x240Mode endp

        public  _ResetModeX
_ResetModeX     proc
        push    ebp

        mov     ax, 3
        int     10h                     ; text mode

        pop     ebp
        ret
_ResetModeX     endp

        ends
        end

