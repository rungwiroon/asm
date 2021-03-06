;PIANO--Uses Timer2 to run speaker
;  number keys play notes of the scale
;
portB         equ      61h             ;I/O Port B
keybd2        equ      7h              ;keybd input, no echo
doscall       equ      21h             ;DOS interrupt number
cont_c        equ      03h             ;ctrl-C ASCII code
;********************************************************************
prognam       segment                  ;define code segment
;
;--------------------------------------------------------------------
main          proc      far            ;main part of program
;
              assume    cs:prognam
;
              org       100h           ;first address
;
;
start:                                 ;starting execution address
;
read_key:
              mov  ah,keybd2           ;keybd function, no echo
              int  doscall             ;call DOS
              cmp  al,cont_c           ;is it Ctrl C ?
              jz   exit                ;  yes, so exit
              sub  al,31h              ;change ASCII to digit
              and  al,00000111b        ;mask off upper five bits
              shl  al,1                ;* by 2 (2 bytes/word)
              cbw                      ;byte --> word in AX
              mov  bx,ax               ;put in BX (for table)
              mov  ax,0                ;numerator (low word)
              mov  dx,12h              ;  (high word)
              div  [13Eh  + bx]        ;divisor from table
              mov  bx,ax               ;save quotient in BX
;
;set 1/pitch into timer, then turn on tone
              mov  al,10110110b        ;put magic number
              out 43h,al               ;   into timer2
              mov  ax,bx               ;move 1/pitch into AX
              out 42h,al               ;LSB into timer2
              mov  al,ah               ;MSB to AL, then
              out 42h,al               ;   to timer2
              in  al,portB             ;read port B into AL
              or  al,3                 ;turn on bits 0, 1
              out portB,al             ;to turn speaker on/off
;
;sound note for a while, then turn in off
              mov  cx,0ffffh           ;set up for delay
wait:         loop wait                ;delay
              in   al,portB            ;read port B into AL1
              and  al,11111100b        ;mask off lower 2 bits
              out  portB,al            ;to turn off speaker
              jmp  read_key            ;go get another digit
;
;
;control-C typed so exit
exit:
              int  20h                 ;return to DOS
;
;frequencies of notes
              dw   262d                ;C
              dw   294d                ;D
              dw   330d                ;E
              dw   347d                ;F
              dw   392d                ;G
              dw   440d                ;A
              dw   494d                ;B
              dw   524d                ;C
;
main          endp                     ;end main part of program
;--------------------------------------------------------------------
prognam       ends                     ;end code segment
;********************************************************************
              end  start               ;end of assembly
;====================================================================
main          endp                     ;end main part of program
;--------------------------------------------------------------------
;
prognam       ends                    ;end of code segment
;********************************************************************
;
              end       start         ;end assembly
;====================================================================
                                                          