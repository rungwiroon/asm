        .386p
        locals
        include pmc.inc

; Mode X (320x240, 256 colors) read pixel routine. Works on all VGAs.
; No clipping is performed.
; C near-callable as:
;    unsigned int ReadPixelX(int X, int Y, unsigned int PageBase);
;
; Modified Aug 30, 1994 (ykumanan)
; ) Made code 32 bit pm (not fully optimized)
;

GC_INDEX equ    03ceh   ;Graphics Controller Index
READ_MAP equ    04h     ;index in GC of the Read Map register
parms   struc
        dd      2 dup (?) ;pushed EBP and return address
X       dd      ?       ;X coordinate of pixel to read
Y       dd      ?       ;Y coordinate of pixel to read
PageBase dd     ?       ;base offset in display memory of page from
                        ; which to read pixel
parms   ends

        @dseg

        extrn   SCREEN_SEG:dword
        extrn   SCREEN_WIDTH:dword       ;width of screen in bytes from
                                         ; one scan line to the next

        ends

        @cseg
        public  _ReadPixelX
_ReadPixelX     proc    near
        push    ebp      ;preserve caller's stack frame
        mov     ebp,esp   ;point to local stack frame

        mov     eax, [SCREEN_WIDTH]
        mul     [ebp+Y]  ;offset of pixel's scan line in page
        mov     ebx,[ebp+X]
        shr     ebx,2    ;X/4 = offset of pixel in scan line
        add     ebx,eax   ;offset of pixel in page
        add     ebx,[ebp+PageBase] ;offset of pixel in display memory
        add     ebx,[SCREEN_SEG]

        mov     ah,byte ptr [ebp+X]
        and     ah,011b ;AH = pixel's plane
        mov     al,READ_MAP ;AL = index in GC of the Read Map reg
        mov     dx,GC_INDEX ;set the Read Map to read the pixel's
        out     dx,ax       ; plane

        mov     al,[ebx] ;read the pixel's color
        sub     ah,ah   ;convert it to an unsigned int

        pop     ebp      ;restore caller's stack frame
        ret
_ReadPixelX     endp
        ends
        end
