        .386p
        locals
        include pmc.inc

; Mode X (320x240, 256 colors) system memory to display memory copy
; routine. Uses approach of changing the plane for each pixel copied;
; this is slower than copying all pixels in one plane, then all pixels
; in the next plane, and so on, but it is simpler; besides, images for
; which performance is critical should be stored in off-screen memory
; and copied to the screen via the latches. Copies up to but not
; including the column at SourceEndX and the row at SourceEndY. No
; clipping is performed. C near-callable as:
;    void CopySystemToScreenX(int SourceStartX, int SourceStartY,
;       int SourceEndX, int SourceEndY, int DestStartX,
;       int DestStartY, char* SourcePtr, unsigned int DestPageBase,
;       int SourceBitmapWidth, int DestBitmapWidth);

SC_INDEX equ    03c4h   ;Sequence Controller Index register port
MAP_MASK equ    02h     ;index in SC of Map Mask register

parms   struc
        dd      2 dup (?) ;pushed BP and return address
SourceStartX dd ?       ;X coordinate of upper left corner of source
SourceStartY dd ?       ;Y coordinate of upper left corner of source
SourceEndX   dd ?       ;X coordinate of lower right corner of source
                        ; (the row at EndX is not copied)
SourceEndY   dd ?       ;Y coordinate of lower right corner of source
                        ; (the column at EndY is not copied)
DestStartX   dd ?       ;X coordinate of upper left corner of dest
DestStartY   dd ?       ;Y coordinate of upper left corner of dest
SourcePtr    dd ?       ;pointer in DS to start of bitmap in which
                        ; source resides
DestPageBase dd ?       ;base offset in display memory of page in
                        ; which dest resides
SourceBitmapWidth dd ?  ;# of pixels across source bitmap
DestBitmapWidth   dd ?  ;# of pixels across dest bitmap
                        ; (must be a multiple of 4)
parms   ends

RectWidth equ   -4      ;local storage for width of rectangle
LeftMask equ    -6      ;local storage for left rect edge plane mask
STACK_FRAME_SIZE equ 6

        @dseg

        extrn   SCREEN_SEG:dword

        ends

        @cseg

        public  _CopySystemToScreenX
_CopySystemToScreenX proc    near
        push    ebp      ;preserve caller's stack frame
        mov     ebp,esp   ;point to local stack frame
        sub     esp,STACK_FRAME_SIZE ;allocate space for local vars
        push    esi      ;preserve caller's register variables
        push    edi
        push    ebx

        cld
        mov     eax,[ebp+SourceBitmapWidth]
        mul     [ebp+SourceStartY] ;top source rect scan line
        add     eax,[ebp+SourceStartX]
        add     eax,[ebp+SourcePtr] ;offset of first source rect pixel
        mov     esi,eax             ; in DS:ESI
        
        mov     eax, [ebp+DestBitmapWidth]
        shr     eax,2            ;convert to width in addresses
        mov     [ebp+DestBitmapWidth],eax ;remember address width
        mul     [ebp+DestStartY] ;top dest rect scan line
        mov     edi, [ebp+DestStartX]    ; clear hi(edi)
        mov     ecx,edi
        shr     edi,2    ;X/4 = offset of first dest rect pixel in scan line
        add     edi,eax   ;offset of first dest rect pixel in page
        add     edi,[ebp+DestPageBase] ;offset of first dest rect pixel
                        ; in display memory
        add     edi,[SCREEN_SEG]  ;make mem ptr now

        and     cl,011b ;CL = first dest pixel's plane
        mov     al,11h  ;upper nibble comes into play when plane wraps
                        ; from 3 back to 0
        shl     al,cl   ;set the bit for the first dest pixel's plane
        mov     [ebp+LeftMask],al ; in each nibble to 1

        mov     ecx,[ebp+SourceEndX]   ;calculate # of pixels across
        sub     ecx,[ebp+SourceStartX] ; rect
        jle     CopyDone        ;skip if 0 or negative width
        mov     [ebp+RectWidth],ecx
        mov     ebx,[ebp+SourceEndY]
        sub     ebx,[ebp+SourceStartY]  ;BX = height of rectangle
        jle     CopyDone        ;skip if 0 or negative height
        mov     dx,SC_INDEX     ;point to SC Index register
        mov     al,MAP_MASK
        out     dx,al           ;point SC Index reg to the Map Mask
        inc     dx              ;point DX to SC Data reg
CopyRowsLoop:
        mov     ax,[ebp+LeftMask]
        mov     ecx,[ebp+RectWidth]
        push    esi      ;remember the start offset in the source
        push    edi      ;remember the start offset in the dest
CopyScanLineLoop:
        out     dx,al           ;set the plane for this pixel
        movsb                   ;copy the pixel to the screen
        rol     al,1            ;set mask for next pixel's plane
        cmc                     ;advance destination address only when
        sbb     di,0            ; wrapping from plane 3 to plane 0
                                ; (else undo INC DI done by MOVSB)
        loop    CopyScanLineLoop
        pop     edi      ;retrieve the dest start offset
        add     edi,[ebp+DestBitmapWidth] ;point to the start of the
                                        ; next scan line of the dest
        pop     esi      ;retrieve the source start offset
        add     esi,[ebp+SourceBitmapWidth] ;point to the start of the
                                        ; next scan line of the source
        dec     ebx      ;count down scan lines
        jnz     CopyRowsLoop
CopyDone:
        pop     ebx
        pop     edi      ;restore caller's register variables
        pop     esi
        mov     esp,ebp   ;discard storage for local variables
        pop     ebp      ;restore caller's stack frame
        ret
_CopySystemToScreenX endp
        ends
        end
