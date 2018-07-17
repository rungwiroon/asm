        title   Control-Break handler for Lattice C programs
        name    break
        include dos.mac

;
; Control-Break Interrupt Handler for Lattice C programs 
; running on IBM PCs (and ROM BIOS compatibles)
; 
; Ray Duncan, May 1985
;
; This module allows C programs running on the IBM PC
; to retain control when the user enters a Control-Break
; or Control-C.  This is accomplished by taking over the
; Int 23H (MS-DOS Control-Break) and Int 1BH (IBM PC 
; ROM BIOS Keyboard Driver Control-Break) interrupt 
; vectors.  The interrupt handler sets an internal
; flag (which must be declared STATIC INT) to TRUE within
; the C program; the C program can poll or ignore this 
; flag as it wishes.
; 
; The module follows the Lattice C parameter passing
; conventions, and also relies on the Lattice file DOS.MAC
; for the definition of certain constants and macros.
;
; The Int 23H Control-Break handler is a function of MS-DOS
; and is present on all MS-DOS machines, however, the Int 1BH
; handler is a function of the IBM PC ROM BIOS and will not
; necessarily be present on other machines. 
; 
        if      lprog
args    equ     6               ;offset of arguments, Large models
        else
args    equ     4               ;offset of arguments, Small models
        endif

cr      equ     0dh             ;ASCII carriage return
lf      equ     0ah             ;ASCII line feed

        pseg

        public  capture,release ;function names for C


;
; The function CAPTURE is called by the C program to
; take over the MS-DOS and keyboard driver Control-
; Break interrupts (1BH and 23H).  It is passed the
; address of a flag within the C program which is set
; to TRUE whenever a Control-Break or Control-C
; is detected.  The function is used in the form:
; 
;               static int flag;
;               capture(&flag)
;

capture proc    near            ;take over Control-Break 

        push    bp              ;interrupt vectors
        mov     bp,sp
        push    ds

        mov     ax,word ptr [bp+args]
        mov     cs:flag,ax      ;save address of integer
        mov     cs:flag+2,ds    ;flag variable in C program

                                ;pick up original vector contents
        mov     ax,3523h        ;for interrupt 23H (MS-DOS
        int     21h             ;Control-Break handler)
        mov     cs:int23,bx
        mov     cs:int23+2,es

        mov     ax,351bh        ;and interrupt 1BH 
        int     21h             ;(IBM PC ROM BIOS keyboard driver
        mov     cs:int1b,bx     ;Control-Break interrupt handler)
        mov     cs:int1b+2,es

        push    cs              ;set address of new handler     
        pop     ds
        mov     dx,offset ctrlbrk
        mov     ax,02523H       ;for interrupt 23H
        int     21h
        mov     ax,0251bH       ;and interrupt 1BH
        int     21h

        pop     ds              ;restore registers and
        pop     bp              ;return to C program
        ret

capture endp


;
; The function RELEASE is called by the C program to
; return the MS-DOS and keyboard driver Control-Break
; interrupt vectors to their original state.  Int 23h is
; also automatically restored by MS-DOS upon the termination
; of a process, however, calling RELEASE allows the C
; program to restore the default action of a Control-C
; without terminating.  The function is used in the form:
;
;               release()
;

release proc    near            ;restore Control-Break interrupt
                                ;vectors to their original state        
        push    bp
        mov     bp,sp
        push    ds

        mov     dx,cs:int1b     ;set interrupt 1BH
        mov     ds,cs:int1b+2   ;(MS-DOS Control-Break 
        mov     ax,251bh        ;interrupt handler)     
        int     21h

        mov     dx,cs:int23     ;set interrupt 23H
        mov     ds,cs:int23+2   ;(IBM PC ROM BIOS keyboard driver 
        mov     ax,2523h        ;Control-Break interrupt handler)
        int     21h

        pop     ds              ;restore registers and
        pop     bp              ;return to C program
        ret

release endp


;
; This is the actual interrupt handler which is called by
; the ROM BIOS keyboard driver or by MS-DOS when a Control-C
; or Control-Break is detected.  Since the interrupt handler
; may be called asynchronously by the keyboard driver, it
; is severely restricted in what it may do without crashing
; the system (e.g. no calls on DOS allowed).  In this
; version, it simply sets a flag within the C program to
; TRUE to indicate that a Control-C or Control-Break has
; been detected; the address of this flag was passed
; by the C program during the call to the CAPTURE function.
;

ctrlbrk proc    far             ;Control-Break interrupt handler

        push    bx              ;save affected registers
        push    ds

        mov     bx,cs:flag      ;set flag within C program
        mov     ds,cs:flag+2    ;to "True"
        mov     word ptr ds:[bx],-1
        
        pop     ds              ;restore registers and exit
        pop     bx

        iret

ctrlbrk endp


flag    dw      0,0             ;long address of C program's
                                ;Control-Break detected flag

int23   dw      0,0             ;original contents of MS-DOS
                                ;Control-Break Interrupt 23H
                                ;vector
        
int1b   dw      0,0             ;original contents of ROM BIOS
                                ;keyboard driver Control-Break
                                ;Interrupt 1BH vector


        endps

        end
