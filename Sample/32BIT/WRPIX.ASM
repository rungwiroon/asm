        .386p
        locals
        include pmc.inc

; Mode X (320x240, 256 colors) write pixel routine. Works on all VGAs.
; No clipping is performed.
; C near-callable as:
;    void WritePixelX(int X, int Y, unsigned int PageBase, int Color);
;
; Modified Aug 30, 1994 (ykumanan)
; ) Made code 32 bit pm (not fully optimized)
;

SC_INDEX equ    03c4h   ;Sequence Controller Index
MAP_MASK equ    02h     ;index in SC of Map Mask register

parms   struc
        dd      2 dup (?) ;pushed EBP and return address
X       dd      ?       ;X coordinate of pixel to draw
Y       dd      ?       ;Y coordinate of pixel to draw
PageBase dd     ?       ;base offset in display memory of page in
                        ; which to draw pixel
Color   dd      ?       ;color in which to draw pixel
parms   ends

        @dseg

        extrn   SCREEN_SEG:dword
        extrn   SCREEN_WIDTH:dword       ;width of screen in bytes from
                                         ; one scan line to the next

        ends

        @cseg
        public  _WritePixelX
_WritePixelX    proc    near
        push    ebp      ;preserve caller's stack frame
        mov     ebp,esp   ;point to local stack frame

        mov     eax,[SCREEN_WIDTH]
        mul     [ebp+Y]  ;offset of pixel's scan line in page
        mov     ebx,[ebp+X]
        shr     ebx,2    ;X/4 = offset of pixel in scan line
        add     ebx,eax   ;offset of pixel in page
        add     ebx,[ebp+PageBase] ;offset of pixel in display memory
        add     ebx, [SCREEN_SEG]

        mov     cl,byte ptr [ebp+X]
        and     cl,011b ;CL = pixel's plane
        mov     ax,0100h + MAP_MASK ;AL = index in SC of Map Mask reg
        shl     ah,cl   ;set only the bit for the pixel's plane to 1
        mov     dx,SC_INDEX ;set the Map Mask to enable only the
        out     dx,ax       ; pixel's plane

        mov     al,byte ptr [ebp+Color]
        mov     [ebx],al ;draw the pixel in the desired color

        pop     ebp      ;restore caller's stack frame
        ret
_WritePixelX    endp
        ends
        end

