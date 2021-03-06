;NOISE--Make a sound with the speaker
;can`t be stopped execpt by reset
;
;********************************************************************
prognam       segment                  ;define code segment
;
;-------------------------------------------------------------------
main          proc      far            ;main part of program
;
              assume    cs:prognam
;
              org       100h           ;start of program
;
start:                                 ;starting execution address
              mov  dx,140h             ;initial value of wait
              in   al,61h              ;get port 61
              and  al,11111100b        ;and off bits 0, 1
sound:        xor  al,2                ;toggle bit #1 in AL
              out  61h,al              ;output to port 61
              add  dx,9248h            ;add random pattern
              mov  cl,3                ;set to rotate 3 bits
              ror  dx,cl               ;rotate it
;
              mov  cx,dx               ;put in CX
              and  cx,1ffh             ;mask off upper 7 bits
              or   cx,10               ;ensure not to long
;
wait:         loop wait                ;wait
              jmp  sound               ;keep on toggling
;
main          endp                     ;end of main part of program
;--------------------------------------------------------------------
prognam       ends                     ;end of code segment
;********************************************************************
              end                      ;end assembly
                                                                   