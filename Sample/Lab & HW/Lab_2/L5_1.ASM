CSreg segment
        assume cs:CSreg,ds:CSreg
        org     100h

;===================================;
;    macro  bell sound              ; in your book 283 page !!!
bell        macro                   ;
            push    dx              ;
            push    ax              ;
            mov     dl,07           ; bell code
            mov     ah,02
            int     21h
            pop     ax              ;
            pop     dx              ;
     endm                           ;
;===================================;
;    macro  wait key pressed        ; 
waitkey     macro                   ;
                mov     ah,08       ; wait keypressed no display key
                int     21h         ;
     endm                           ;
                                    ;
;===================================;
;
;
;
main    proc    near            ;<---------- MAIN PROGRAM !!!
        jmp     start
msg1    db  'exit pressed q$'
;
start:
        bell                    ;macro bell sound easy!
        call    clearD          ;clear screen display
        lea     dx,msg1
        mov     ah,09
        int     21h
        ;
        bell
        waitkey                 ;wait keypressed return 'AL'
        bell

exit1:  int     20h

main    endp
;
;
;.......................................;
;--- subprogram1       clear display ---;
;input = none                           ;
;output= none                           ;
;                                       ;
clearD     proc    near                 ;
                mov     ah,06           ;
                mov     al,00           ;
                mov     bh,07           ;
                mov     cx,0            ;
                mov     dx,184Fh        ;
                int     10h             ;
                ret                     ;
clearD          endp                    ;
;                                       ;
;.......................................;

CSreg   ends
end     main
        
