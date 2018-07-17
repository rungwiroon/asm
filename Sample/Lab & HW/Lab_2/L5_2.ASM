CSreg segment
        assume cs:CSreg,ds:CSreg
        org     100h

;===================================;
;    macro  bell sound              ; in your book 283 page !!!
bell        macro                   ;
            mov     dl,07           ; bell code
            call    disp1           ;
     endm                           ;
;===================================;
;    macro  wait key pressed        ; 
waitkey     macro                   ;
                mov     ah,08       ; wait keypressed no display key
                int     21h         ;
     endm                           ;
                                    ;
;===================================;
;    macro  set cursor  row,col     ; in your book 283 page !!!
gotoxy      macro   row,col         ;    
            mov     dh,row          ;
            mov     dl,col          ;
            call    move_cur        ;
     endm                           ;
;===================================;

;
;
;
main    proc    near            ;<---------- MAIN PROGRAM !!!

start:
        call    clearD          ;clear screen display
key1:
        gotoxy  12,39           ;MACRO !!
        waitkey                 ;wait keypressed return 'AL'
        cmp     al,'q'
        jz      exit1
        mov     dl,al
        call    disp1
        bell                    ;MACRO !!
        jmp     key1
exit1:  int     20h

main    endp
;
;
;
;
;--- subprogram1 display 1 character ---;
;input = dl                             ;
;output= none                           ;
;                                       ;
disp1     proc    near                  ;
                mov     ah,02           ;
                int     21h             ;
                ret                     ;
disp1           endp                    ;
;.......................................;
;--- subprogram2        move cursor  ---;
;input = dl,dh                          ;
;output= none                           ;
;                                       ;
move_cur   proc near                    ;
                mov     ah,02           ;
                mov     bh,0            ;
                int     10h             ;
                ret                     ;
move_cur        endp                    ;
;.......................................;
;--- subprogram3       clear display ---;
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
        
