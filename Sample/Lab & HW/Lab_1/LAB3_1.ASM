
  lab3 segment
        assume cs:lab3,ds:lab3
        org     100h
  main1 proc near
  ;===========================================
        jmp     start
 msgi  db      '[..........hello!lab3(5555).....]$'
 start:
        mov     ah,09h
        lea     dx,msgi
;.............................................
 	
        int     21h
	call    display1
;...............................................
	int       20h
;===========================================
main1   endp

;////////////////////////////////////////////////////////////////////////////////////////////////////////
        ;sub program"display1"
;////////////////////////////////////////////////////////////////////////////////////////////////////////
display1      proc near
char    db      'A'
        push    ax
        push    cx
        push    dx
        mov     cl,0
;========================================
disp1:
        mov     ah,02h
        mov     dl,char
        add     dl,cl
        int     21h
        inc     cl
        cmp     cl,26
        jnz     disp1
        pop     dx
        pop     cx
        pop     ax
        ret
display1 endp
lab3    ends
end     main1
