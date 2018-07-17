        .386
        locals
        include pmc.inc

; Mode X (320x240, 256 colors) rectangle 4x4 pattern fill routine.
; Upper left corner of pattern is always aligned to a multiple-of-4
; row and column. Works on all VGAs. Uses approach of copying the
; pattern to off-screen display memory, then loading the latches with
; the pattern for each scan line and filling each scan line four
; pixels at a time. Fills up to but not including the column at EndX
; and the row at EndY. No clipping is performed. All ASM code tested
; with TASM 2. C near-callable as:
;    void FillPatternedX(int StartX, int StartY, int EndX, int EndY,
;       unsigned int PageBase, char* Pattern);

SC_INDEX equ    03c4h   ;Sequence Controller Index register port
MAP_MASK equ    02h     ;index in SC of Map Mask register
GC_INDEX equ    03ceh   ;Graphics Controller Index register port
BIT_MASK equ    08h     ;index in GC of Bit Mask register
PATTERN_BUFFER equ 0fffch ;offset in screen memory of the buffer used
                        ; to store each pattern during drawing
parms   struc
        dd      2 dup (?) ;pushed BP and return address
StartX  dd      ?       ;X coordinate of upper left corner of rect
StartY  dd      ?       ;Y coordinate of upper left corner of rect
EndX    dd      ?       ;X coordinate of lower right corner of rect
                        ; (the row at EndX is not filled)
EndY    dd      ?       ;Y coordinate of lower right corner of rect
                        ; (the column at EndY is not filled)
PageBase dd     ?       ;base offset in display memory of page in
                        ; which to fill rectangle
Pattern dd      ?       ;4x4 pattern with which to fill rectangle
parms   ends

NextScanOffset equ -4   ;local storage for distance from end of one
                        ; scan line to start of next
RectAddrWidth equ -8    ;local storage for address width of rectangle
Height   equ     -12    ;local storage for height of rectangle
WrapCheck equ   -16     ;local for pattern wrap
STACK_FRAME_SIZE equ 16

        @dseg

        extrn   SCREEN_SEG:dword
        extrn   SCREEN_WIDTH:dword
        extrn   LeftClipPlaneMask:byte
        extrn   RightClipPlaneMask:byte

        ends

        @cseg

        public  _FillPatternX
_FillPatternX proc    near
        push    ebp      ;preserve caller's stack frame
        mov     ebp,esp   ;point to local stack frame
        sub     esp,STACK_FRAME_SIZE ;allocate space for local vars
        push    esi      ;preserve caller's register variables
        push    edi
        push    ebx

        cld
                                ;copy pattern to display memory buffer
        mov     esi,[ebp+Pattern] ;point to pattern to fill with
        mov     edi,PATTERN_BUFFER ;point EDI to pattern buffer
        add     edi,[SCREEN_SEG]   ;    on screen
        mov     dx,SC_INDEX     ;point Sequence Controller Index to
        mov     al,MAP_MASK     ; Map Mask
        out     dx,al
        inc     dx              ;point to SC Data register
        mov     ecx,4            ;4 pixel quadruplets in pattern
DownloadPatternLoop:
        mov     al,1            ;
        out     dx,al           ;select plane 0 for writes
        movsb                   ;copy over next plane 0 pattern pixel
        dec     edi             ;stay at same address for next plane
        mov     al,2            ;
        out     dx,al           ;select plane 1 for writes
        movsb                   ;copy over next plane 1 pattern pixel
        dec     edi             ;stay at same address for next plane
        mov     al,4            ;
        out     dx,al           ;select plane 2 for writes
        movsb                   ;copy over next plane 2 pattern pixel
        dec     edi             ;stay at same address for next plane
        mov     al,8            ;
        out     dx,al           ;select plane 3 for writes
        movsb                   ;copy over next plane 3 pattern pixel
                                ; and advance address
        loop    DownloadPatternLoop

        mov     dx,GC_INDEX     ;set the bit mask to select all bits
        mov     ax,00000h+BIT_MASK ; from the latches and none from
        out     dx,ax           ; the CPU, so that we can write the
                                ; latch contents directly to memory
        mov     eax,[ebp+StartY]  ;top rectangle scan line
        mov     esi,eax
        and     esi,011b         ;top rect scan line modulo 4
        add     esi,PATTERN_BUFFER ;point to pattern scan line that
                                ; maps to top line of rect to draw
        mov     edx,[SCREEN_WIDTH]
        mul     edx      ;offset in page of top rectangle scan line
        mov     edi,[ebp+StartX]
        mov     ebx,edi
        shr     edi,2    ;X/4 = offset of first rectangle pixel in scan line
        add     edi,eax   ;offset of first rectangle pixel in page
        add     edi,[ebp+PageBase] ;offset of first rectangle pixel in
                        ; display memory
        and     ebx,0003h                 ;look up left edge plane mask
        mov     ah,LeftClipPlaneMask[ebx] ; to clip
        mov     ebx,[ebp+EndX]
        and     ebx,0003h                  ;look up right edge plane
        mov     al,RightClipPlaneMask[ebx] ; mask to clip
        mov     ebx,eax                   ;put the masks in BX
        
        mov     ecx,[ebp+EndX]    ;calculate # of addresses across rect
        mov     eax,[ebp+StartX]
        cmp     ecx,eax
        jle     FillDone        ;skip if 0 or negative width
        dec     ecx
        and     eax,not 011b
        sub     ecx,eax
        shr     ecx,2    ;# of addresses across rectangle to fill - 1
        jnz     MasksSet ;there's more than one pixel to draw
        and     bh,bl   ;there's only one pixel, so combine the left
                        ; and right edge clip masks
MasksSet:
        mov     eax,[ebp+EndY]
        sub     eax,[ebp+StartY]  ;EAX = height of rectangle
        jle     FillDone        ;skip if 0 or negative height
        mov     [ebp+Height],eax
        mov     eax,SCREEN_WIDTH
        sub     eax,ecx   ;distance from end of one scan line to start
        dec     eax      ; of next
        mov     [ebp+NextScanOffset],eax
        mov     [ebp+RectAddrWidth],ecx ;remember width in addresses - 1
        mov     dx,SC_INDEX+1 ;point to Sequence Controller Data reg
                                ; (SC Index still points to Map Mask)
        mov     ecx, [SCREEN_SEG]
        add     edi, ecx
        add     esi, ecx
        mov     [ebp+WrapCheck], esi
        add     dword ptr [ebp+WrapCheck], 4
FillRowsLoop:
        mov     ecx,[ebp+RectAddrWidth] ;width across - 1
        mov     al,[esi] ;read display memory to latch this scan
                         ; line's pattern
        inc     esi      ;point to the next pattern scan line, wrapping

        cmp     esi, [ebp+WrapCheck]
        jl      NoWrap   ; back to the start of the pattern if
        sub     esi,4    ; we've run off the end
NoWrap:
        mov     al,bh   ;put left-edge clip mask in AL
        out     dx,al   ;set the left-edge plane (clip) mask
        stosb           ;draw the left edge (pixels come from latches;
                        ; value written by CPU doesn't matter)
        dec     ecx      ;count off left edge address
        js      FillLoopBottom ;that's the only address
        jz      DoRightEdge ;there are only two addresses
        mov     al,00fh ;middle addresses are drawn 4 pixels at a pop
        out     dx,al   ;set the middle pixel mask to no clip
        rep     stosb   ;draw the middle addresses four pixels apiece
                        ; (from latches; value written doesn't matter)
DoRightEdge:
        mov     al,bl   ;put right-edge clip mask in AL
        out     dx,al   ;set the right-edge plane (clip) mask
        stosb           ;draw the right edge (from latches; value
                        ; written doesn't matter)
FillLoopBottom:
        add     edi,[ebp+NextScanOffset] ;point to the start of the next scan
                                        ; line of the rectangle
        dec     dword ptr [ebp+Height] ;count down scan lines
        jnz     FillRowsLoop
FillDone:
        mov     dx,GC_INDEX+1 ;restore the bit mask to its default,
        mov     al,0ffh       ; which selects all bits from the CPU
        out     dx,al         ; and none from the latches (the GC
                              ; Index still points to Bit Mask)
        pop     ebx
        pop     edi      ;restore caller's register variables
        pop     esi
        mov     esp,ebp   ;discard storage for local variables
        pop     ebp      ;restore caller's stack frame
        ret
_FillPatternX endp
        ends
        end


