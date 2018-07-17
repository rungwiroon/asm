        .386p
        locals
        include pmc.inc

; Mode X (320x240, 256 colors) display memory to display memory copy
; routine. Left edge of source rectangle modulo 4 must equal left edge
; of destination rectangle modulo 4. Works on all VGAs. Uses approach
; of reading 4 pixels at a time from the source into the latches, then
; writing the latches to the destination. Copies up to but not
; including the column at SourceEndX and the row at SourceEndY. No
; clipping is performed. Results are not guaranteed if the source and
; destination overlap. C near-callable as:
;    void CopyScreenToScreenX(int SourceStartX, int SourceStartY,
;       int SourceEndX, int SourceEndY, int DestStartX,
;       int DestStartY, unsigned int SourcePageBase,
;       unsigned int DestPageBase, int SourceBitmapWidth,
;       int DestBitmapWidth);

SC_INDEX equ    03c4h   ;Sequence Controller Index register port
MAP_MASK equ    02h     ;index in SC of Map Mask register
GC_INDEX equ    03ceh   ;Graphics Controller Index register port
BIT_MASK equ    08h     ;index in GC of Bit Mask register

parms   struc
        dd      2 dup (?) ;pushed BP and return address
SourceStartX dd ?       ;X coordinate of upper left corner of source
SourceStartY dd ?       ;Y coordinate of upper left corner of source
SourceEndX   dd ?       ;X coordinate of lower right corner of source
                        ; (the row at SourceEndX is not copied)
SourceEndY   dd ?       ;Y coordinate of lower right corner of source
                        ; (the column at SourceEndY is not copied)
DestStartX   dd ?       ;X coordinate of upper left corner of dest
DestStartY   dd ?       ;Y coordinate of upper left corner of dest
SourcePageBase dd ?     ;base offset in display memory of page in
                        ; which source resides
DestPageBase dd ?       ;base offset in display memory of page in
                        ; which dest resides
SourceBitmapWidth dd ?  ;# of pixels across source bitmap
                        ; (must be a multiple of 4)
DestBitmapWidth   dd ?  ;# of pixels across dest bitmap
                        ; (must be a multiple of 4)
parms   ends

SourceNextScanOffset equ -4   ;local storage for distance from end of
                              ; one source scan line to start of next
DestNextScanOffset equ -8    ;local storage for distance from end of
                              ; one dest scan line to start of next
RectAddrWidth equ -12   ;local storage for address width of rectangle
Height   equ     -16    ;local storage for height of rectangle
STACK_FRAME_SIZE equ 16

        @dseg

        extrn SCREEN_SEG:dword
        extrn   LeftClipPlaneMask:byte
        extrn   RightClipPlaneMask:byte

        ends
        @cseg

        public  _CopyScreenToScreenX
_CopyScreenToScreenX proc    near
        push    ebp      ;preserve caller's stack frame
        mov     ebp,esp  ;point to local stack frame
        sub     esp,STACK_FRAME_SIZE ;allocate space for local vars
        push    esi      ;preserve caller's register variables
        push    edi
        push    ebx

        cld
        mov     dx,GC_INDEX     ;set the bit mask to select all bits
        mov     ax,00000h+BIT_MASK ; from the latches and none from
        out     dx,ax           ; the CPU, so that we can write the
                                ; latch contents directly to memory
        mov     eax,[ebp+DestBitmapWidth]
        shr     eax,2            ;convert to width in addresses
        mul     [ebp+DestStartY] ;top dest rect scan line
        mov     edi, [ebp+DestStartX]
        shr     edi,2    ;X/4 = offset of first dest rect pixel in scan line
        add     edi,eax   ;offset of first dest rect pixel in page
        add     edi,[ebp+DestPageBase] ;offset of first dest rect pixel
                        ; in display memory
        mov     eax,[ebp+SourceBitmapWidth]
        shr     eax,2            ;convert to width in addresses
        mul     [ebp+SourceStartY] ;top source rect scan line
        mov     esi, [ebp+SourceStartX]
        mov     ebx,esi
        shr     esi,2    ;X/4 = offset of first source rect pixel in scan line
        add     esi,eax   ;offset of first source rect pixel in page
        add     esi,[ebp+SourcePageBase] ;offset of first source rect
                        ; pixel in display memory
        and     bx,0003h                 ;look up left edge plane mask
        mov     ah,LeftClipPlaneMask[bx] ; to clip
        mov     ebx,[ebp+SourceEndX]
        and     bx,0003h                  ;look up right edge plane
        mov     al,RightClipPlaneMask[bx] ; mask to clip
        mov     bx,ax                   ;put the masks in BX
        
        mov     ecx,[ebp+SourceEndX]   ;calculate # of addresses across
        mov     eax,[ebp+SourceStartX] ; rect
        cmp     ecx,eax
        jle     CopyDone        ;skip if 0 or negative width
        dec     ecx
        and     eax,not 011b
        sub     ecx,eax
        shr     ecx,2    ;# of addresses across rectangle to copy - 1
        jnz     MasksSet ;there's more than one address to draw
        and     bh,bl   ;there's only one address, so combine the left
                        ; and right edge clip masks
MasksSet:
        mov     eax,[ebp+SourceEndY]
        sub     eax,[ebp+SourceStartY]  ;AX = height of rectangle
        jle     CopyDone        ;skip if 0 or negative height
        mov     [ebp+Height],eax
        mov     eax,[ebp+DestBitmapWidth]
        shr     eax,2            ;convert to width in addresses
        sub     eax,ecx   ;distance from end of one dest scan line to
        dec     eax      ; start of next
        mov     [ebp+DestNextScanOffset],eax
        mov     eax,[ebp+SourceBitmapWidth]
        shr     eax,2            ;convert to width in addresses
        sub     eax,ecx   ;distance from end of one source scan line to
        dec     eax      ; start of next
        mov     [ebp+SourceNextScanOffset],eax
        mov     [ebp+RectAddrWidth],ecx ;remember width in addresses - 1

        mov     dx,SC_INDEX
        mov     al,MAP_MASK
        out     dx,al           ;point SC Index reg to Map Mask
        inc     dx              ;point to SC Data reg

        mov     eax, [SCREEN_SEG]
        add     edi, eax
        add     esi, eax
CopyRowsLoop:
        mov     ecx,[ebp+RectAddrWidth] ;width across - 1
        mov     al,bh   ;put left-edge clip mask in AL
        out     dx,al   ;set the left-edge plane (clip) mask
        movsb           ;copy the left edge (pixels go through
                        ; latches)
        dec     ecx      ;count off left edge address
        js      CopyLoopBottom ;that's the only address
        jz      DoRightEdge ;there are only two addresses
        mov     al,00fh ;middle addresses are drawn 4 pixels at a pop
        out     dx,al   ;set the middle pixel mask to no clip
        rep     movsb   ;draw the middle addresses four pixels apiece
                        ; (pixels copied through latches)
DoRightEdge:
        mov     al,bl   ;put right-edge clip mask in AL
        out     dx,al   ;set the right-edge plane (clip) mask
        movsb           ;draw the right edge (pixels copied through
                        ; latches)
CopyLoopBottom:
        add     esi,[ebp+SourceNextScanOffset] ;point to the start of
        add     edi,[ebp+DestNextScanOffset]  ; next source & dest lines
        dec     dword ptr [ebp+Height] ;count down scan lines
        jnz     CopyRowsLoop
CopyDone:
        mov     dx,GC_INDEX+1 ;restore the bit mask to its default,
        mov     al,0ffh         ; which selects all bits from the CPU
        out     dx,al           ; and none from the latches (the GC
                                ; Index still points to Bit Mask)
        pop     ebx
        pop     edi      ;restore caller's register variables
        pop     esi
        mov     esp,ebp  ;discard storage for local variables
        pop     ebp      ;restore caller's stack frame
        ret
_CopyScreenToScreenX endp
        ends
        end
