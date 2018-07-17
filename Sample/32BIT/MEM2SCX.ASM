        .386p
        locals
        include pmc.inc

; Mode X (320x240, 256 colors) system memory-to-display memory masked copy 
; routine. Not particularly fast; images for which performance is critical 
; should be stored in off-screen memory and copied to screen via latches. Works
; on all VGAs. Copies up to but not including column at SourceEndX and row at 
; SourceEndY. No clipping is performed. Mask and source image are both byte-
; per-pixel, and must be of same widths and reside at same coordinates in their
; respective bitmaps. Assembly code tested with TASM 2.0. C near-callable as:
;    void CopySystemToScreenMaskedX(int SourceStartX,
;       int SourceStartY, int SourceEndX, int SourceEndY,
;       int DestStartX, int DestStartY, char * SourcePtr,
;       unsigned int DestPageBase, int SourceBitmapWidth,
;       int DestBitmapWidth, char * MaskPtr);

SC_INDEX equ    03c4h   ;Sequence Controller Index register port
MAP_MASK equ    02h     ;index in SC of Map Mask register

parms   struc
        dd      2 dup (?) ;pushed BP and return address
SourceStartX dd ?       ;X coordinate of upper left corner of source
                        ; (source is in system memory)
SourceStartY dd ?       ;Y coordinate of upper left corner of source
SourceEndX   dd ?       ;X coordinate of lower right corner of source
                        ; (the column at EndX is not copied)
SourceEndY   dd ?       ;Y coordinate of lower right corner of source
                        ; (the row at EndY is not copied)
DestStartX   dd ?       ;X coordinate of upper left corner of dest
                        ; (destination is in display memory)
DestStartY   dd ?       ;Y coordinate of upper left corner of dest
SourcePtr    dd ?       ;pointer in DS to start of bitmap which source resides
DestPageBase dd ?       ;base offset in display memory of page in
                        ; which dest resides
SourceBitmapWidth dd ?  ;# of pixels across source bitmap (also must
                        ; be width across the mask)
DestBitmapWidth   dd ?  ;# of pixels across dest bitmap (must be multiple of 4)
MaskPtr      dd ?       ;pointer in DS to start of bitmap in which mask
                        ; resides (byte-per-pixel format, just like the source 
                        ; image; 0-bytes mean don't copy corresponding source 
                        ; pixel, 1-bytes mean do copy)
parms   ends

RectWidth equ   -4      ;local storage for width of rectangle
RectHeight equ  -8      ;local storage for height of rectangle
LeftMask equ    -10     ;local storage for left rect edge plane mask
STACK_FRAME_SIZE equ 10

        @dseg

        extrn   SCREEN_SEG:dword

        ends

        @cseg

        public  _CopySystemToScreenMaskedX
_CopySystemToScreenMaskedX proc    near
        push    ebp      ;preserve caller's stack frame
        mov     ebp,esp  ;point to local stack frame
        sub     esp,STACK_FRAME_SIZE ;allocate space for local vars
        push    esi      ;preserve caller's register variables
        push    edi
        push    ebx

        mov     eax, [ebp+SourceBitmapWidth]
        mul     [ebp+SourceStartY] ;top source rect scan line
        add     eax,[ebp+SourceStartX]
        mov     ebx,eax
        add     eax,[ebp+SourcePtr] ;offset of first source rect pixel
        mov     esi,eax             ; in DS
        add     ebx,[ebp+MaskPtr] ;offset of first mask pixel in DS
        
        mov     eax, [ebp+DestBitmapWidth]
        shr     eax,2            ;convert to width in addresses
        mov     [ebp+DestBitmapWidth],eax ;remember address width
        mul     [ebp+DestStartY] ;top dest rect scan line
        mov     edi, [ebp+DestStartX]
        mov     ecx,edi
        shr     edi,2    ;X/4 = offset of first dest rect pixel in scan line
        add     edi,eax   ;offset of first dest rect pixel in page
        add     edi,[ebp+DestPageBase] ;offset of first dest rect pixel
                        ; in display memory
        and     cl,011b ;CL = first dest pixel's plane
        mov     al,11h  ;upper nibble comes into play when plane wraps
                        ; from 3 back to 0
        shl     al,cl   ;set the bit for the first dest pixel's plane
        mov     [ebp+LeftMask],al ; in each nibble to 1

        mov     eax,[ebp+SourceEndX]   ;calculate # of pixels across
        sub     eax,[ebp+SourceStartX] ; rect
        jle     CopyDone        ;skip if 0 or negative width
        mov     [ebp+RectWidth],eax
        sub     [ebp+SourceBitmapWidth],eax
                    ;distance from end of one source scan line to start of next
        mov     eax,[ebp+SourceEndY]
        sub     eax,[ebp+SourceStartY] ;height of rectangle
        jle     CopyDone        ;skip if 0 or negative height
        mov     [ebp+RectHeight],eax
        mov     dx,SC_INDEX     ;point to SC Index register
        mov     al,MAP_MASK
        out     dx,al           ;point SC Index reg to the Map Mask
        inc     dx              ;point DX to SC Data reg

        add     edi, [SCREEN_SEG] ; point edi to video
CopyRowsLoop:
        mov     al,[ebp+LeftMask]
        mov     ecx,[ebp+RectWidth]
        push    edi      ;remember the start offset in the dest
CopyScanLineLoop:
        cmp     byte ptr [ebx],0 ;is this pixel mask-enabled?
        jz      MaskOff         ;no, so don't draw it
                                ;yes, draw the pixel
        out     dx,al           ;set the plane for this pixel
        mov     ah,[esi]        ;get the pixel from the source
        mov     [edi],ah        ;copy the pixel to the screen
MaskOff:
        inc     ebx              ;advance the mask pointer
        inc     esi              ;advance the source pointer
        rol     al,1            ;set mask for next pixel's plane
        adc     di,0            ;advance destination address only when
                                ; wrapping from plane 3 to plane 0
        loop    CopyScanLineLoop
        pop     edi              ;retrieve the dest start offset
        add     edi,[ebp+DestBitmapWidth] ;point to the start of the
                                        ; next scan line of the dest
        add     esi,[ebp+SourceBitmapWidth] ;point to the start of the
                                        ; next scan line of the source
        add     ebx,[ebp+SourceBitmapWidth] ;point to the start of the
                                        ; next scan line of the mask
        dec     dword ptr [ebp+RectHeight] ;count down scan lines
        jnz     CopyRowsLoop
CopyDone:
        pop     ebx
        pop     edi      ;restore caller's register variables
        pop     esi
        mov     esp,ebp  ;discard storage for local variables
        pop     ebp      ;restore caller's stack frame
        ret
_CopySystemToScreenMaskedX endp
        ends
        end

