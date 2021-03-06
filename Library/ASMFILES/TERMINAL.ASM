;------------ EXAMPLE OF A SIMPLE 1200 BAUD TERMINAL PROGRAM -----------
;
;
stack         segment para stack 'stack'
              db        256       dup(0)     ; 256 bytes of stack
stack         ends
;
code          segment para public 'code'
start         proc      far
;
;------------------- STANDARD PROGRAM PROLOGUE ------------------------
;
              assume    cs:code
              push      ds        ; SAVE PSP SEGMENT ADDRESS
              mov       ax,0
              push      ax        ; SAVE RETURN ADDRESS OFFSET (PSP+0)
;
;-----------------------------------------------------------------------
;
;------------ PART 1: INITIALIZE THE 8250 UART FOR: -------------------
;------------               7 DATA BITS             -------------------
;------------               1 STOP BIT              -------------------
;------------               ODD PARITY              -------------------
;------------               1200 BAUD               -------------------
;----------------- SET UP FOR LOOPBACK FEATURE ------------------------
;
              mov       dx,3fbh   ;ADDRESS OF LINE CONTROL REGISTER
              mov       al,80h
              out       dx,al     ;TO ADDRESS BAUD RATE DIVISOR REGISTER
              mov       dx,3f8h   ;ADDRESS OF BAUD RATE DIVISOR LSB
              mov       al,60h    ;LSB VALUE FOR 1200 BAUD
              out       dx,al
              mov       dx,3f9h   ;ADDRESS OF BAUD RATE DIVISOR MSB
              mov       al,0      ;MSB VALUE FOR 1200 BAUD
              out       dx,al
;-------------- THE BAUD RATE HAS NOW BEEN INITIALIZED ----------------
;
;-------------- NOW INITIALIZE THE LINE CONTROL REGISTER --------------
;
              mov       dx,3fbh   ;ADDRESS OF LINE CONTROL REGISTER
              mov       al,0ah    ;ODD PARITY 1 STOP BIT 7 DATA BITS
              out       dx,al
;
;---------- NOW INITIALIZE THE MODEM CONTROL REGISTER FOR: ------------
;--------- REQUEST TO SEND AND DATA TERMINAL READY SIGNALS ------------
;---------------- AND SET THE LOOPBACK FEATURE ------------------------
;
              mov       dx,3fch   ;ADDRESS OF MODEM CONTROL REGISTER
              mov       al,03h    ;SET LOOPBACK AND MODEM CTRL SIGNALS
              out       dx,al
;
;------------- NOW DISABLE ALL FOUR CLASSES OF INTERRUPTS --------------
;
              mov       dx,3f9h   ;ADDRESS OF INTERRUPT ENABLE REGISTER
              mov       al,0
              out       dx,al
;
;----------- THE INITIALIZATION OF THE 8250 IS NOW COMPLETE ------------
;
;
;----------- PART2:   DISPLAY WHAT IS RECEIVED FROM THE 8250 -----------
;------------ AND TRANSMIT WHAT IS INPUT FROM THE KEYBOARD -------------
;
forever:      mov       dx,3fdh   ;ADDRESS OF LINE STATUS REGISTER
              in        al,dx     ;LINE STATUS REGISTER IN AL
              test      al,1eh    ;TEST FOR A RECEPTION ERROR
              jnz       error     ;RECEIVE ERROR HANDLING
              test      al,01h    ;TEST FOR RECEIVED DATA READY
              jnz       receive   ;RECEIVED CHARACTOR HANDLING
              test      al,20h    ;TEST FOR TRANSMITTER HOLDING
;                                       REGISTER EMPTY
              jz        forever   ;IF THE 8250 IS NOT READY FOR ANOTHER
;                                  CHARACTER TO TRANSMIT THE LOOP
;
;IF FALL THROUGH TO HERE THEN THE 8250 IS READY FOR ANOTHER CHARACTER
;TO TRANSMIT.
;
;IF THE KEYBOARD BUFFER HAS ANOTHER CHARACTER THEN GET IT AND OUTPUT
;IT TO THE 8250.
;
              mov       ah,1      ;CHECK KEYBOARD BUFFER CODE
              int       16h       ;BIOS CALL
              jz        forever   ;IF NO KEYBOARD CHARACTER THEN NOTHING
;                                  TO TRANSMIT.
;
;IF FALL THROUGH TO HERE THEN THERE IS A KEYBOARD CHARACTER TO TRANSMIT
;
              mov       ah,0      ;GET KEYBOARD INPUT CODE
              int       16h       ;BIOS CALL
;
;AL HAS THE KEYBOARD CHARACTOR FOR TRANSMISSION
;
              mov       dx,3f8h   ;ADDRESS OF TRANSMITTER HOLDING REG
              out       dx,al     ;TRANSMIT THE CHARACTER
              jmp       forever
;
;
;THIS POINT IS REACHED IF A CHARACTER WAS RECEIVED BY THE 8250 WITH NO
;ERRORS.
;
receive:      mov       dx,3f8h   ;ADDRESS OF THE RECEIVER DATA REGISTER
              in        al,dx     ;AL HAS THE RECEIVED CHARACTER
              and       al,7fh    ;BECAUSE THERE ARE ONLY 7 BITS OF DATA
;                                  THE HIGH ORDER BIT IS NOT VALID
              push      ax        ;SAVE THE RECEIVED CHARACTER
;
;PREPARE TO DISPLAY THE CHARACTER
;
              mov       bx,0
              mov       ah,14     ;DISPLAY FUNCTION CODE
              int       10h       ;BIOS CALL
              pop       ax        ;RESTORE THE CHARACTER
              cmp       al,0dh    ;WAS IT A CARRIAGE RETURN ?
              jnz       forever   ;NO, SO START OVER AGAIN
;
;IF IT WAS A CARRIAGE RETURN THE A LINEFEED MUST ALSO BE DISPLAYED
;
              mov       al,0ah    ;LINEFEED
              mov       bx,0
              mov       ah,14
              int       10h       ;BIOS CALL
              jmp       forever
;
;IF THIS POINT IS REACHED THEN THERE WAS AN ERROR IN THE RECEIVED
;CHARACTER. CLEAR THE RECEIVER DATA REGISTER AND DISPLAY A ?.
;
error:        mov       dx,3f8h   ;ADDRESS OF THE RECEIVER DATA REGISTER
              in        al,dx     ;AL HAS THE INCORRECT CHARACTER
              mov       al,'?'    ;DISPLAY A ? INSTEAD
              mov       bx,0
              mov       ah,14
              int       10h       ;BIOS CALL
              jmp       forever
;
start         endp
code          ends
              end       start
                                                                                    