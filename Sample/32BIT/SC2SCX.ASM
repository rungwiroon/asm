        .386p
        locals
        include pmc.inc

; Mode X (320x240, 256 colors) display memory to display memory masked copy 
; routine. Works on all VGAs. Uses approach of reading 4 pixels at a time from 
; source into latches, then writing latches to destination, using Map Mask 
; register to perform masking. Copies up to but not including column at 
; SourceEndX and row at SourceEndY. No clipping is performed. Results are not 
; guaranteed if source and destination overlap. C near-callable as:
;    void CopyScreenToScreenMaskedX(int SourceStartX,
;       int SourceStartY, int SourceEndX, int SourceEndY,
;       int DestStartX, int DestStartY, MaskedImage * Source,
;       unsigned int DestPageBase, int DestBitmapWidth);

SC_INDEX equ    03c4h   ;Sequence Controller Index register port
MAP_MASK equ    02h     ;index in SC of Map Mask register
GC_INDEX equ    03ceh   ;Graphics Controller Index register port
BIT_MASK equ    08h     ;index in GC of Bit Mask register

parms   struc
        dd      2 dup (?) ;pushed BP and return address
SourceStartX dd ?       ;X coordinate of upper left corner of source
SourceStartY dd ?       ;Y coordinate of upper left corner of source
SourceEndX   dd ?       ;X coordinate of lower right corner of source
                        ; (the column at SourceEndX is not copied)
SourceEndY   dd ?       ;Y coordinate of lower right corner of source
                        ; (the row at SourceEndY is not copied)
DestStartX   dd ?       ;X coordinate of upper left corner of dest
DestStartY   dd ?       ;Y coordinate of upper left corner of dest
Source       dd ?       ;pointer to MaskedImage struct for source
                        ; which source resides
DestPageBase dd ?       ;base offset in display memory of page in
                        ; which dest resides
DestBitmapWidth   dd ?  ;# of pixels across dest bitmap (must be multiple of 4)
parms   ends

SourceNextScanOffset equ -4   ;local storage for distance from end of
                              ; one source scan line to start of next
DestNextScanOffset equ -8    ;local storage for distance from end of
                              ; one dest scan line to start of next
RectAddrWidth equ -12   ;local storage for address width of rectangle
RectHeight    equ -16   ;local storage for height of rectangle
SourceBitmapWidth equ -20 ;local storage for width of source bitmap
                        ; (in addresses)
STACK_FRAME_SIZE equ 20

MaskedImage     struc
 Alignments     dd  4 dup(?) ;pointers to AlignedMaskedImages for the
                             ; 4 possible destination image alignments
MaskedImage     ends

AlignedMaskedImage      struc
 ImageWidth     dd      ? ;image width in addresses (also mask width in bytes)
 ImagePtr       dd      ? ;offset of image bitmap in display memory
 MaskPtr        dd      ? ;pointer to mask bitmap in DS
AlignedMaskedImage      ends

        @dseg

        extrn   SCREEN_SEG:dword

        ends

        @cseg

        public  _CopyScreenToScreenMaskedX
_CopyScreenToScreenMaskedX proc    near
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
        mov     eax, [ebp+DestBitmapWidth]
        shr     eax,2            ;convert to width in addresses
        mul     [ebp+DestStartY] ;top dest rect scan line
        mov     edi, [ebp+DestStartX]
        mov     esi,edi
        shr     edi,2    ;X/4 = offset of first dest rect pixel in scan line
        add     edi,eax   ;offset of first dest rect pixel in page
        add     edi,[ebp+DestPageBase] ;offset of first dest rect pixel
                        ; in display memory. now look up the image that's 
                        ; aligned to match left-edge alignment of destination
        and     esi,3   ;DestStartX modulo 4
        mov     ecx,esi ;set aside alignment for later
        shl     esi,2    ;prepare for dword look-up
        mov     ebx,[ebp+Source] ;point to source MaskedImage structure
        mov     ebx,[ebx+Alignments+esi] ;point to AlignedMaskedImage
                        ; struc for current left edge alignment
        mov     eax,[ebx+ImageWidth] ;image width in addresses
        mov     [ebp+SourceBitmapWidth],eax ;remember image width in
                                          ; addresses
        mul     [ebp+SourceStartY] ;top source rect scan line
        mov     esi,[ebp+SourceStartX]
        shr     esi,2    ;X/4 = address of first source rect pixel in scan line
        add     esi,eax   ;offset of first source rect pixel in image
        mov     eax,esi
        add     esi,[ebx+MaskPtr] ;point to mask offset of first mask pixel in DS
        mov     ebx,[ebx+ImagePtr] ;offset of first source rect pixel
        add     ebx,eax            ; in display memory

        mov     eax,[ebp+SourceStartX] ;calculate # of addresses across
        add     eax,ecx                ; rect, shifting if necessary to
        add     ecx,[ebp+SourceEndX]   ; account for alignment
        cmp     ecx,eax
        jle     CopyDone        ;skip if 0 or negative width
        add     ecx,3
        and     eax,not 011b
        sub     ecx,eax
        shr     ecx,2    ;# of addresses across rectangle to copy
        mov     eax,[ebp+SourceEndY]
        sub     eax,[ebp+SourceStartY]  ;EAX = height of rectangle
        jle     CopyDone        ;skip if 0 or negative height
        mov     [ebp+RectHeight],eax
        mov     eax,[ebp+DestBitmapWidth]
        shr     eax,2            ;convert to width in addresses
        sub     eax,ecx ;distance from end of one dest scan line to start of next
        mov     [ebp+DestNextScanOffset],eax
        mov     eax,[ebp+SourceBitmapWidth] ;width in addresses
        sub     eax,ecx ;distance from end of source scan line to start of next
        mov     [ebp+SourceNextScanOffset],eax
        mov     [ebp+RectAddrWidth],ecx ;remember width in addresses

        mov     dx,SC_INDEX
        mov     al,MAP_MASK
        out     dx,al           ;point SC Index register to Map Mask
        inc     dx              ;point to SC Data register

        mov     ecx, [SCREEN_SEG]
        add     edi, ecx        ;edi & ebx point to video memory
        add     ebx, ecx
CopyRowsLoop:
        mov     ecx,[ebp+RectAddrWidth] ;width across
CopyScanLineLoop:
        lodsb                   ;get the mask for this four-pixel set
                                ; and advance the mask pointer
        out     dx,al           ;set the mask
        mov     al,[ebx]        ;load the latches with 4-pixel set from source
        mov     [edi],al        ;copy the four-pixel set to the dest
        inc     ebx             ;advance the source pointer
        inc     edi             ;advance the destination pointer
        dec     ecx             ;count off four-pixel sets
        jnz     CopyScanLineLoop

        mov     eax,[ebp+SourceNextScanOffset]
        add     esi,eax                      ;point to the start of
        add     ebx,eax                      ; the next source, mask,
        add     edi,[ebp+DestNextScanOffset] ; and dest lines
        dec     dword ptr [ebp+RectHeight] ;count down scan lines
        jnz     CopyRowsLoop
CopyDone:
        mov     dx,GC_INDEX+1   ;restore the bit mask to its default,
        mov     al,0ffh         ; which selects all bits from the CPU
        out     dx,al           ; and none from the latches (the GC
                                ; Index still points to Bit Mask)
        pop     ebx
        pop     edi      ;restore caller's register variables
        pop     esi
        mov     esp,ebp  ;discard storage for local variables
        pop     ebp      ;restore caller's stack frame
        ret
_CopyScreenToScreenMaskedX endp
        ends
        end

