;SHIFT STAUTS TEST PROGRAM
;  displays shift status continuously
;
sh_stat              equ 2h
key_rom              equ 16h
display              equ 2h
doscall              equ 21h
return               equ 0dh
;
;***************************************************************
;
pro_nam segment                         ;start of segmnet
;
;---------------------------------------------------------------
main                 proc   far
;
                     assume cs:pro_nam
;
again:               mov  ah,sh_stat
                     int  key_rom
                     mov  bx,ax
                     call binihex
                     mov  dl,return
                     mov  ah,display
                     int  doscall
                     jmp  again
;
main                 endp
;---------------------------------------------------------------
binihex              proc  near
;
;SUBROUTINE TO CONVERT BINARY NUMBER IN BX
;  TO HEX ON CONSOLE SCREEN
;
                     mov ch,4           ;number of digits
rotate:              mov cl,4           ;set count to 4 bits
                     rol bx,cl          ;left digit to right
                     mov al,bl          ;move to AL
                     and al,0fh         ;mask off left digit
                     add al,30h         ;convert hex to ASCII
                     cmp al,3ah         ;is it > 9?
                     jl  printit        ;jump if digit = 0 to 9
                     add al,7h          ;digit is A to F
printit:
                     mov dl,al          ;put ASCII char in DL
                     mov ah,display     ;Display Output function
                     int doscall        ;call DOS
                     dec ch             ;done 4 digits?
                     jnz rotate         ;not yet
                     ret                ;done subroutine
;
binihex              endp
;---------------------------------------------------------------
pro_nam              ends
;***************************************************************
                     end                ;end of program
                                                