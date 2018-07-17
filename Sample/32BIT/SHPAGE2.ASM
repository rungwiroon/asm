        .386p
        locals
        include pmc.inc

; Shows the page at the specified offset in the bitmap. Page is displayed when 
; this routine returns. This code first appeared in PC Techniques.
;
; C near-callable as: void ShowPage(unsigned x, y);
;
; Modified Aug 30, 1994 (ykumanan)
; ) Made code 32 bit pm (not fully optimized)
; ) Added pel panning code for smooth horizontal scrolling
; ) Converted to coordinate scrolling for easier mapping
;

INPUT_STATUS_1  equ     03dah   ;Input Status 1 register
CRTC_INDEX      equ     03d4h   ;CRT Controller Index reg
START_ADDRESS_HIGH equ  0ch     ;bitmap start address high byte
START_ADDRESS_LOW equ   0dh     ;bitmap start address low byte
AC_INDEX        equ  03c0h   ;Attribute controller index register
PEL_PANNING     equ    13h   ; Pel panning register index in AC

ShowPageParms   struc
        dd      2 dup (?) ;pushed EBP and return address
X       dd      ?
Y       dd      ?       ; location in bitmap to display
ShowPageParms   ends

        @dseg

        extrn   SCREEN_WIDTH:dword

        ends
        @cseg

        public  _ShowPage
_ShowPage       proc    near
        push    ebp      ;preserve caller's stack frame
        mov     ebp,esp   ;point to local stack frame
        push    esi
        push    ebx

; Wait for display enable to be active (status is active low), to be
; sure both halves of the start address will take in the same frame.
        mov     esi, [ebp+X]
        mov     eax, [SCREEN_WIDTH]
        mov     ecx, [ebp+Y]
        mul     ecx                     ; row offset
        mov     ecx, esi
        shr     ecx, 2
        add     eax, ecx                ; make full offset

        and     esi, 03h                ; select pel pan register value
        shl     esi, 9                  ; * 2 to make pel pan index
                                        ; and move to high byte
        or      esi, PEL_PANNING+20h    ; put pel info in low byte

        mov     bl,START_ADDRESS_LOW        ;preload for fastest
        mov     bh, al                      ; flipping once display
        mov     cl,START_ADDRESS_HIGH       ; enable is detected
        mov     ch, ah
        mov     dx,INPUT_STATUS_1
WaitDE:
        in      al,dx
        test    al,01h
        jnz     WaitDE  ;display enable is active low (0 = active)
; Set the start offset in display memory of the page to display.
        mov     dx,CRTC_INDEX
        mov     ax,bx
        out     dx,ax   ;start address low
        mov     ax,cx
        out     dx,ax   ;start address high
; Now wait for vertical sync, so the other page will be invisible when
; we start drawing to it.
        mov     dx,INPUT_STATUS_1
WaitVS:
        in      al,dx
        test    al,08h
        jz      WaitVS  ;vertical sync is active high (1 = active)

        mov     dx, AC_INDEX
        mov     ax,si             ; Point the attribute controller to pel pan
	cli
        out     dx,al             ; reg. Bit 5 also set to prevent blanking
        mov     al,ah
        out     dx,al             ; load new Pel Pan setting.
	sti

        pop     ebx
        pop     esi
        pop     ebp      ;restore caller's stack frame
        ret
_ShowPage       endp
        ends
        end

