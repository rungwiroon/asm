        .386p
        locals
        include pmc.inc

; Mode X (320x240, 256 colors) rectangle fill routine. Works on all
; VGAs. Uses fast approach that fans data out to up to four planes at
; once to draw up to four pixels at once. Fills up to but not
; including the column at EndX and the row at EndY. No clipping is
; performed.
; C near-callable as:
;    void FillRectangleX(int StartX, int StartY, int EndX, int EndY,
;       unsigned int PageBase, int Color);
;
; Modified Aug 30, 1994 (ykumanan)
; ) Made code 32 bit pm (not fully optimized)
;

SC_INDEX equ    03c4h   ;Sequence Controller Index
MAP_MASK equ    02h     ;index in SC of Map Mask register

parms   struc
        dd      2 dup (?) ;pushed EBP and return address
StartX  dd      ?       ;X coordinate of upper left corner of rect
StartY  dd      ?       ;Y coordinate of upper left corner of rect
EndX    dd      ?       ;X coordinate of lower right corner of rect
                        ; (the row at EndX is not filled)
EndY    dd      ?       ;Y coordinate of lower right corner of rect
                        ; (the column at EndY is not filled)
PageBase dd     ?       ;base offset in display memory of page in
                        ; which to fill rectangle
Color   dd      ?       ;color in which to draw pixel
parms   ends

        @dseg

        extrn   SCREEN_SEG:dword
        extrn   SCREEN_WIDTH:dword      ;width of screen in bytes from
                                        ; one scan line to the next
        extrn   LeftClipPlaneMask:byte
        extrn   RightClipPlaneMask:byte

        ends
        @cseg

        public  _FillRectangleX
_FillRectangleX proc    near
        push    ebp     ;preserve caller's stack frame
        mov     ebp,esp ;point to local stack frame
        push    esi     ;preserve caller's register variables
        push    edi
        push    ebx

        cld
        mov     eax, [SCREEN_WIDTH]
        imul    eax, [ebp+StartY] ;offset in page of top rectangle scan line
        mov     edi, [ebp+StartX]
        shr     edi,2    ;X/4 = offset of first rectangle pixel in scan line
        add     edi,eax   ;offset of first rectangle pixel in page
        add     edi,[ebp+PageBase] ;offset of first rectangle pixel in
                        ; display memory
        add     edi, [SCREEN_SEG]       ; point es:edi to 1st rect
        mov     dx,SC_INDEX ;set the Sequence Controller Index to
        mov     al,MAP_MASK ; point to the Map Mask register
        out     dx,al
        inc     dx      ;point DX to the SC Data register
        mov     esi,[ebp+StartX]        ; make hi(esi) zero
        and     esi,0003h                 ;look up left edge plane mask
        mov     bh,LeftClipPlaneMask[esi] ; to clip & put in BH
        mov     esi,[ebp+EndX]
        and     esi,0003h                  ;look up right edge plane
        mov     bl,RightClipPlaneMask[esi] ; mask to clip & put in BL
        
        mov     ecx,[ebp+EndX]    ;calculate # of addresses across rect
                                  ; make hi(ecx) zero
        mov     esi,[ebp+StartX]
        cmp     ecx,esi
        jle     FillDone        ;skip if 0 or negative width
        dec     ecx
        and     esi,not 011b
        sub     ecx,esi
        shr     ecx,2    ;# of addresses across rectangle to fill - 1
        jnz     MasksSet ;there's more than one byte to draw
        and     bh,bl   ;there's only one byte, so combine the left
                        ; and right edge clip masks
MasksSet:
        mov     esi,[ebp+EndY]
        sub     esi,[ebp+StartY]  ;BX = height of rectangle
        jle     FillDone        ;skip if 0 or negative height
        mov     ah,byte ptr [ebp+Color] ;color with which to fill
        mov     ebp, [SCREEN_WIDTH] ;stack frame isn't needed any more
        sub     ebp,ecx   ;distance from end of one scan line to start
        dec     ebp      ; of next
FillRowsLoop:
        push    ecx      ;remember width in addresses - 1
        mov     al,bh   ;put left-edge clip mask in AL
        out     dx,al   ;set the left-edge plane (clip) mask
        mov     al,ah   ;put color in AL
        stosb           ;draw the left edge
        dec     ecx      ;count off left edge byte
        js      FillLoopBottom ;that's the only byte
        jz      DoRightEdge ;there are only two bytes
        mov     al,00fh ;middle addresses are drawn 4 pixels at a pop
        out     dx,al   ;set the middle pixel mask to no clip
        mov     al,ah   ;put color in AL
        rep     stosb   ;draw the middle addresses four pixels apiece
DoRightEdge:
        mov     al,bl   ;put right-edge clip mask in AL
        out     dx,al   ;set the right-edge plane (clip) mask
        mov     al,ah   ;put color in AL
        stosb           ;draw the right edge
FillLoopBottom:
        add     edi,ebp ;point to the start of the next scan line of
                        ; the rectangle
        pop     ecx      ;retrieve width in addresses - 1
        dec     esi      ;count down scan lines
        jnz     FillRowsLoop
FillDone:
        pop     ebx
        pop     edi     ;restore caller's register variables
        pop     esi
        pop     ebp     ;restore caller's stack frame
        ret
_FillRectangleX endp
        ends
        end

