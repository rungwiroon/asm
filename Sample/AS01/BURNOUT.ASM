COMMENT *
 
  Demo (and semi-useful) program to read/set burnout device parameters.
 
  Usage: burnout [ticks] [C+-] [V+-] [H+-]
 
  Parameters can be separated by almost anything.
  With no parameters, program simply returns current status.
 
  Examples:
    burnout 5000                (sets time to 5000 ticks)
    burnout 5000H+              (time=5000, use hardware blanking)
    burnout 5000,h+             (ditto, separators don't matter)
    burnout c+h-v+              (continuous clear, software, monitor video)
    burnout /C+ /H- /V+         (ditto)
    burnout                     (return status only)
 
  Assembly/link:
    masm burnout;
    link burnout;  (ignore NO STACK warning message)
    exe2bin burnout burnout.com
 
  By CJDunford  20-Mar-1985
     Compuserve 76703,2002
 
======================================================================
*
 
stdout equ 1                            ; DOS output files
stderr equ 2
 
; ----- General equates
DOS         equ 21H                     ; DOS interrupt
TERMINATE   equ 20H                     ; Exit to DOS
 
PRINT       equ 09H                     ; DOS "print" string to stdout
FOPEN       equ 3D02H                   ; DOS file open, read/write
FREAD       equ 3FH                     ; DOS file read
FWRITE      equ 40H                     ; DOS file write
 
CR          equ 13                      ; ASCII carriage return
LF          equ 10                      ; ASCII line fine
 
code segment
assume cs:code,ds:code
 
org 80H                                 ; Parm storage area in PSP
ParmLength label byte                   ; Length of parms
org 81H
Parameters label byte                   ; Start of parms
 
org 100H                                ; Org for .COM
main proc far
        jmp start                       ; Hate to execute data
 
DevName         db 'BRNDEV',0           ; Burnout device name
handle          dw ?                    ; Storage for handle
Flush           db '@'                  ; Char to flush device I/O
Execute         db '#'                  ; Char to execute device commands
 
NotInstalled    db 'Burnout device is not installed',13,10
NotInstalledL   equ $ - NotInstalled
 
Status          db 'Current status: '   ; Status message
StatInsert      db 40 dup (?)           ; brndev will store status here
 
; ----- Open the device
start:
        mov dx,offset DevName           ; DS:DX => device name
        mov ax,FOPEN
        int DOS
        jnc A1                          ; Continue if no error
        mov bx,stderr                   ; Message to stderr
        mov cx,NotInstalledL
        mov dx,offset NotInstalled
        mov ah,FWRITE
        int DOS
        jmp exit
 
; ----- Flush any pending I/O to/from the device
A1:
        mov handle,ax                   ; Save device handle
        mov dx,offset Flush             ; Point to the "@"
        mov cx,1                        ; Writing one byte
        mov bx,handle                   ; Device handle
        mov ah,FWRITE                   ; Write "@" to device
        int DOS
 
; ----- Send and execute parameters if present
        mov cl,ParmLength               ; Parm length to CL
        or cl,cl                        ; Any parms present?
        jz A2                           ; Skip if not
        xor ch,ch                       ; CX = parm length
        mov dx,offset Parameters        ; DS:DX => parms
        mov bx,handle                   ; BX = device handle
        mov ah,FWRITE                   ; Write parms to device
        int DOS
 
        mov dx,offset Execute           ; Execute the parms
        mov cx,1                        ; Writing one byte
        mov bx,handle                   ; Device handle
        mov ah,FWRITE                   ; Write "#" to device
        int DOS
 
; ----- Get and display device status
A2:
        mov dx,offset StatInsert        ; DS:DX => where to put status
        mov cx,0FFH                     ; Ask for lots of data; DOS will ...
                                        ; ... fetch only until CR found.
        mov bx,handle                   ; Device handle
        mov ah,FREAD                    ; Read device info
        int DOS
 
        mov cx,ax                       ; CX = actual # bytes read
        mov di,offset StatInsert        ; Where the stat data is stored
        add di,cx                       ; Add length of input read
        mov al,CR                       ; Store a CR/LF/'$' at end
        cld
        stosb
        mov al,LF
        stosb
        mov al,'$'
        stosb
        mov dx,offset Status            ; Write status to stdout
        mov ah,PRINT
        int DOS
 
exit:
        int TERMINATE                   ; Exit to DOS
main endp
code ends
end main
