        name    driver
        page    55,132
        title   'DRIVER --- installable driver template'

;
; This is a "template" for a MS-DOS installable device driver.
; The actual driver subroutines are stubs only and have
; no effect but to return a non-error "done" status.
; 
; Ray Duncan
; Laboratory Microsystems Inc.
; April 1985

code    segment public 'CODE'

driver  proc    far

        assume  cs:code,ds:code,es:code

        org     0


Max_Cmd equ     15              ; MS-DOS command code maximum
                                ; this is 15 for MS-DOS 3.x
                                ; and 12 for MS-DOS 2.x 


cr      equ     0dh             ; ASCII carriage return
lf      equ     0ah             ; ASCII line feed
eom     equ     '$'             ; end of message signal


        page
;
; Device Driver Header
;
Header  dd      -1              ;link to next device,-1= end of list

        dw      8000h           ;attribute word
                                ;bit 15=1 for character devices

        dw      Strat           ;device "Strategy" entry point

        dw      Intr            ;device "Interrupt" entry point

        db      'DRIVER  '      ;char device name, 8 char, or
                                ;if block device, no. of units
                                ;in first byte followed by 
                                ;7 don't care bytes     



; Interpretation of Attribute word:
; 
; Bit           Significance
;
; 15            =1 for character drivers
; 14            =1 if driver can handle IOCTL
; 13            =1 if block device & non-IBM format
; 12            0
; 11            open/close/RM supported (DOS 3.x)
; 10            0
;  9            0
;  8            0
;  7            0
;  6            0
;  5            0
;  4            0
;  3            =1 if CLOCK device
;  2            =1 if NUL device
;  1            =1 if Standard Output
;  0            =1 if Standard Input

        page
;
; local variables for use by driver
;
RH_Ptr  dd      ?               ; pointer to request header
                                ; passed to Strat by BDOS

Ident   db      cr,lf,lf
        db      'LMI Example Device Driver 1.0'
        db      cr,lf
        db      'Copyright (c) 1985 '
        db      'Laboratory Microsystems Inc.' 
        db      cr,lf,lf,eom
;
; MS-DOS Command Codes dispatch table.
; The "Interrupt" routine uses this table and the 
; Command Code supplied in the Request Header to 
; transfer to the appropriate driver subroutine.

Dispatch:
        dw      Init            ;  0 = init driver into system
        dw      Media_Chk       ;  1 = media check on blk dev
        dw      Build_Bpb       ;  2 = build BIOS param block
        dw      Ioctl_Inp       ;  3 = I/O ctrl read from dev
        dw      Input           ;  4 = normal destructive read
        dw      Nd_Input        ;  5 = non-destructive read,no wait
        dw      Inp_Stat        ;  6 = return current input status
        dw      Inp_Flush       ;  7 = flush device input buffers
        dw      Output          ;  8 = normal output to device
        dw      Outp_Vfy        ;  9 = output with verify
        dw      Outp_Stat       ; 10 = return current output status
        dw      Outp_Flush      ; 11 = flush output buffers
        dw      Ioctl_Outp      ; 12 = I/O control output
        dw      Dev_Open        ; 13 = device open      (MS-DOS 3.x)
        dw      Dev_Close       ; 14 = device close     (MS-DOS 3.x)
        dw      Rem_Media       ; 15 = removeable media (MS-DOS 3.x)
        page
; 
; MS-DOS Request Header structure definition
;
; The first 13 bytes of all Request Headers are the same
; and are referred to as the "Static" part of the Header.
; The number and meaning of the following bytes varies.
; In this "Struc" definition we show the Request Header
; contents for Read and Write calls.
;
Request struc                   ; request header template structure
        
                                ; beginning of "Static" portion
Rlength db      ?               ; length of request header
Unit    db      ?               ; unit number for this request
Command db      ?               ; request header's command code
Status  dw      ?               ; driver's return status word
Reserve db      8 dup (?)       ; reserved area
                                ; end of "Static" portion       

Media   db      ?               ; media descriptor byte
Address dd      ?               ; memory address for transfer
Count   dw      ?               ; byte/sector count value
Sector  dw      ?               ; starting sector value

Request ends                    ; end of request header template

;
; Status word is interpreted as follows:
;
;  Bit(s)   Significance
;   15       Error
;   10-14    Reserved
;   9        Busy
;   8        Done
;   0-7      Error code if bit 15=1

; Predefined BDOS error codes are:
; 
;   0       Write protect violation
;   1       Unknown unit
;   2       Drive not ready
;   3       Unknown command
;   4       CRC error
;   5       Bad drive request structure length
;   6       Seek error
;   7       Unknown media
;   8       Sector not found
;   9       Printer out of paper
;   10      Write fault
;   11      Read fault
;   12      General failure     
;   13-14   Reserved
;   15      Invalid disk change  (MS-DOS 3.x)

        page

; Device Driver "Strategy Routine"

; Each time a request is made for this device, the BDOS
; first calls "Strategy routine",  then immediately calls
; the "Interrupt routine".  

; The Strategy routine is passed the address of the
; Request Header in ES:BX, which it saves in a local
; variable and then returns to the BDOS.

Strat   proc    far     
                                ; save address of Request Header
        mov     word ptr cs:[RH_Ptr],bx
        mov     word ptr cs:[RH_Ptr+2],es

        ret                     ; back to BDOS

Strat   endp

        page


; Device Driver "Interrupt Routine"

; This entry point is called by the BDOS immediately after 
; the call to the "Strategy Routine", which saved the long
; address of the Request Header in the local variable "RH_Ptr".

; The "Interrupt Routine" uses the Command Code passed in
; the Request Header to transfer to the appropriate device
; handling routine.  Each command code routine is responsible
; for any necessary return information into the Request Header,
; then transfers to Error or Exit to set the Return Status code.

Intr    proc  far

        push    ax              ; save general registers 
        push    bx
        push    cx
        push    dx
        push    ds
        push    es
        push    di
        push    si
        push    bp

        push    cs              ; make local data addressable
        pop     ds

        les     di,[RH_Ptr]     ; ES:DI = Request Header

                                ; get BX = Command Code
        mov     bl,es:[di.Command]
        xor     bh,bh
        cmp     bx,Max_Cmd      ; make sure its legal
        jg      Unk_Command     ; too big, exit with error code
        shl     bx,1            ; form index to Dispatch table
                                ; and branch to driver routine
        jmp     word ptr [bx+Dispatch]

        page


; General collection of exit points for the driver routines.


Unk_Command:                    ; Come here if Command Code too big.
        mov     al,3            ; Sets "Unknown Command" error 
                                ; code and "Done" bit.

Error:                          ; Transfer here with AL = error code.
        mov     ah,81h          ; Sets "Error" and "Done" bits.
        jmp     Exit

Done:   mov     ah,1            ; Come here if I/O complete and
                                ; no error, sets "Done" bit only.


Exit:                           ; General purpose exit point.
                                ; Transfer here with AX = 
                                ; Return Status word to be
                                ; placed into Request Header.

        lds     bx,cs:[RH_Ptr]          ; set status
        mov     ds:[bx.Status],ax

        pop     bp              ;restore general registers
        pop     si
        pop     di
        pop     es
        pop     ds
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        ret                     ; back to BDOS

        page


; Function 1  Media Check

; Block devices only.  Should be a NOP for character devices.
;
; This routine is called first by BDOS for a block device transfer,
; passing current media descriptor byte at Request Header + 
;
; Media Check routine sets status word and in addition passes back 
; return byte at Request Header + 14  as follows:

;    -1  Media has been changed
;     0  Don't know if media changed
;     1  Media has not been changed
;
; If driver can return 1 or -1, performance is improved because
; MS-DOS does not need to reread the FAT for each directory access.


Media_Chk:

        jmp     Done

        page

;
; Function 2  Build BIOS Parameter Block
; 
; Block devices only.  Should be a NOP for character devices.
;
; This routine is called by MS-DOS when Media-Changed code is
; returned by Media Check routine, or if Not Sure code is returned
; and there are no dirty buffers.
; 
; Build BPB call receives pointer to one-sector buffer in Address
; Field of Request Header (offset 14).  If "Non-IBM-Format" bit 
; in attribute word is zero, the buffer contains the first sector
; of the FAT including the media identification byte and should not 
; be altered by the driver.   If the "Non-IBM-Format" bit is set, 
; the buffer may be used as scratch space.
;
; The Build BPB routine sets status and returns a DWORD pointer to 
; the new Bios Parameter Block at Request Header + 18.
;

Build_Bpb:

        jmp     Done

        page

;
; Function 3  I/O Control Read 
; 
; Only called if IOCTL bit set in Device Header Attribute word.
;
; Called with:
;
; Request Header + 13  BYTE   Media descriptor byte from DPB
; Request Header + 14  DWORD  Transfer address
; Request Header + 18  WORD   byte/sector count
; Request Header + 20  WORD   starting sector no. (block dev.)
;
; Returns the Return Status word set appropriately, and
; Request Header + 18  WORD   actual bytes or sectors transferred
; 
; No error check is performed on IOCTL I/O calls.

Ioctl_Inp:

        jmp     Done

        page

;
; Function 4  Read from Device
;
; Called with
;
; Request Header + 13  BYTE   Media descriptor byte from DPB
; Request Header + 14  DWORD  Transfer address
; Request Header + 18  WORD   byte/sector count
; Request Header + 20  WORD   starting sector no. (block dev.)
;
; Returns the Return Status word set appropriately, and
; Request Header + 18  WORD   actual bytes or sectors transferred

Input: 

        jmp     Done

        page

;
; Function 5  Non-destructive Read from Device
; 
; Character devices only.
;
; If Input Status request returns Busy bit=0 (characters 
; waiting), ; the next character that would be read is returned 
; at Request Header + 13.  This character is not removed from
; the Input Buffer.  This basically provides the capability to 
; "look-ahead" by one character.
 
Nd_Input:

        jmp     Done

        page

;
; Function 6  Input Status
; 
; Character devices only.
;
; Sets the Returned Status word:
; Done bit = 1
; Busy bit = 1 read request would go to physical device
;          = 0 characters already in device buffer, read request
;              would return quickly.
;
; MS-DOS assumes all character devices have type-ahead buffer.
; If device does not have type-ahead buffer, should always
; return Busy bit=0 so MS-DOS will not hang.

Inp_Stat:

        jmp     Done

        page

;
; Function 7  Flush Input Buffers
; 
; Character devices only.
;
; Terminate all pending requests, i.e. the Input buffer is
; emptied.

Inp_Flush:

        jmp     Done

        page

;
; Function 8  Write to Device
; 
; Called with
;
; Request Header + 13  BYTE   Media descriptor byte from DPB
; Request Header + 14  DWORD  Transfer address
; Request Header + 18  WORD   byte/sector count
; Request Header + 20  WORD   starting sector no. (block dev.)
;
; Returns the Return Status word set appropriately, and
; Request Header + 18  WORD   actual bytes or sectors transferred

Output: 

        jmp     Done

        page

;
; Function 9  Write with Verify to Device
; 
; Called with
;
; Request Header + 13  BYTE   Media descriptor byte from DPB
; Request Header + 14  DWORD  Transfer address
; Request Header + 18  WORD   byte/sector count
; Request Header + 20  WORD   starting sector no. (block dev.)
;
; Returns the Return Status word set appropriately, and
; Request Header + 18  WORD   actual bytes or sectors transferred

Outp_Vfy: 

        jmp     Done

        page

;
; Function 10  Output Status
;
; Character devices only.
;
; Sets the Returned Status word:
; Done bit = 1
; Busy bit = 1 write request would wait for completion of
;              current request
;          = 0 device idle, write request would start immediately.
;

Outp_Stat:

        jmp     Done

        page

;
; Function 11  Flush Output Buffers
; 
; Character devices only.
;
; Terminate pending requests.  The output buffer, if any,
; is emptied.

Outp_Flush:

        jmp     Done

        page

;
; Function 12  I/O Control Write 
; 
; Only called if IOCTL bit in Device Header Attribute word is set.
;
; Called with
;
; Request Header + 13  BYTE   Media descriptor byte from DPB
; Request Header + 14  DWORD  Transfer address
; Request Header + 18  WORD   byte/sector count
; Request Header + 20  WORD   starting sector no. (block dev.)
;
; Returns the Return Status word set appropriately, and
; Request Header + 18  WORD   actual bytes or sectors transferred
;
; No error check is performed on IOCTL calls.

Ioctl_Outp:

        jmp     Done

        page

;
; Function 13  Device Open
;
; MS-DOS version 3.0 and above only.
; Only called if OPEN/CLOSE/RM bit set in Attribute word.
; May be used to manage local buffering.  Reference count
; is incremented keeping track of number of open files on
; the device.  On character devices can be used to send
; device initialization string, which can be set by IOCTL 
; Write.  Note that CON AUX and PRN devices are always open.
;
; Returns the Return Status word set to "Done".
;
Dev_Open:

        jmp     Done

        page

;
; Function 14  Device Close
;
; MS-DOS version 3.0 and above only.
; Only called if OPEN/CLOSE/RM bit set in Attribute word.
; May be used to manage local buffering.  Reference count
; is decremented keeping track of number of open files on
; the device; when count reaches zero all files have been closed 
; and the driver should flush buffers as user may change disks.
; On character devices can be used to send device post-I/O
; string such as a form feed, which can be set by IOCTL 
; Write.  Note that CON AUX and PRN devices are never closed.
;
; Returns the Return Status word set to "Done".
;
Dev_Close:

        jmp     Done

        page

;
; Function 15  Removeable Media
;
; MS-DOS version 3.0 and above only.
; Only called if OPEN/CLOSE/RM bit set in Attribute word
;    and device type is block.
;
; Returns the Return Status word set to "Done" and 
; Busy bit = 1 if media is non-removable.  
;          = 0 if media is removable.
;
Rem_Media:

        jmp     Done


        page

; This Initialization code for the driver is called only
; once when the driver is loaded.  It is responsible for
; initializing the hardware, setting up any necessary 
; interrupt vectors, and it must return the address
; of the first free memory after the driver to the BDOS.
; If it is a block device driver, Init must also return the 
; address of the Bios Parameter Block pointer array; if all 
; units are the same, all pointers can point to the same BPB.
; Only MS-DOS services 01-0CH and 30H can be called by the 
; Initialization function. 
;
; In this example, Init returns its own address to the DOS as 
; the start of free memory after the driver, so that the memory 
; occupied by INIT will be reclaimed after it is finished 
; with its work.  
;
; Called with:
;
; Request Header + 18  DWORD pointer to the character after the "="
;                            on the CONFIG.SYS line that loaded 
;                            driver; this information is read only.
;                  22  BYTE  drive letter for first unit of a 
;                            block driver (0=A 1=B etc)
;                            (MS-DOS 3.x only)   
;
; Returns:
; 
; Request Header + 13  BYTE  Number of units (block devices only)
;                + 14  DWORD address of first free memory above driver
;                + 18  DWORD BPB pointer array (block devices only)     
;

Init:                           ; Function 0
                                ; initialize device driver

        push    es              ; push Request Header addr
        push    di

        mov     ah,9            ; print sign-on message
        mov     dx,offset Ident
        int     21h

        pop     di              ; restore Request Header addr
        pop     es

                                ; set first usable memory addr.
        mov     word ptr es:[di.Address],offset Init
        mov     word ptr es:[di.Address+2],cs

        jmp     Done


Intr    endp


Driver  endp

code    ends
        
        end     
