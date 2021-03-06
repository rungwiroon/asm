;SPACEWARS--Uses Timer2 to run speaker
;  produces weird rising bubble
;
;********************************************************************
prognam       segment                  ;define code segment
;
;--------------------------------------------------------------------
main          proc      far            ;main part of program
;
              assume    cs:prognam
;
;REM          org       100h           ;first address
;
;
start:                                 ;starting execution address
;
;initial value of 1/pitch
              mov  bx,200h             ;set 1/pitch in BX
;
;
;sound the tone
sounder:
              mov al,10110110b         ;magic number
              out 43h,al                ;to timer2
tone:         mov ax,bx                ;move 1/pitch into AX
              out 42h,al               ;LSB into timer2
              mov al,ah                ;MSB to AL, then
              out 42h,al               ;   to timer2
              in al,61h                ;read port B into AL
              or al,3                  ;turn on bits 0 and 1
              out 61h,al               ;to turn speaker on
;
;increase the pitch and wait a bit
              dec bx                   ;increase the pitch
              jz  start                ;when BX=0, reset it
;
              mov cx,800d              ;setup wait loop
wait:         loop wait                ;wait
;
;check if keyboard character typed
              mov ah,0bh               ;get keyboard status
              int 21h                  ;call DOS
              inc al                   ;if AL not FF, then
              jnz sounder              ;  no key pressed
;key pressed, return to DOS
              int 20h                  ;return to DOS
;
main          endp                     ;end main part of program
;--------------------------------------------------------------------
prognam       ends                     ;end code segment
;********************************************************************
              end                      ;end of assembly
;====================================================================
main          endp                     ;end main part of program
;--------------------------------------------------------------------
;
prognam       ends                    ;end of code segment
;********************************************************************
;
              end       start         ;end assembly
;====================================================================
                                                                                                                      