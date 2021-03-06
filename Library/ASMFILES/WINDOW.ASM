;WINDOW--Demonstrates video window function
;  Uses ROM routines
;
;keyboard writes into window 20 chars wide
;  and 9 chars high in middle of screen
;
;***************************************************************
;
prognam       segment             ;define code segment
;
              assume    cs:prognam
;
;clear screen, using scroll up function
;
              mov  ah,6
              mov  al,0
              mov  ch,0
              mov  cl,0
              mov  dh,24
              mov  dl,79
              mov  bh,7
              int  10h
;
;position cursor at bottom of window
pos_cursor:
;
              mov  ah,2
              mov  dh,16
              mov  dl,30
              mov  bh,0
              int  10h
;
;get characters from keyboard
;
              mov  cx,20d
;
get_char:
              mov  ah,1
              int  21h
              cmp  al,3
              jz   exit
              loop get_char
;
;scroll up
              mov  ah,6
              mov  al,1
              mov  ch,8
              mov  cl,30
              mov  dh,16
              mov  dl,50
              mov  bh,7
              int  10h
;
              jmp  pos_cursor
;
exit:         int  20h
;
prognam       ends
;
              end
                                                                                                                             