testLAB  segment
        assume  cs:testLAB,ds:testLAB
        org 100h
;
main  proc near
;-------------
        jmp     start
msg1:   db      'please wait...keypressed!$'
msg2:   db      '<---- it your keypressed $'
msg3:   db      'don t wory!...I hope you pass sure!! $'

;-------------
start:       
        mov     al,0            ;mode 0 monitor set are 40*25
        call	setm
        ;----------;
        mov     dl,8           ;column at 8
        mov     dh,12           ;row at 12
        call	cursor
        ;----------;
        lea     dx,msg1
        call    dispT
        ;----------;
        mov     dl,18           ; 18,18
        mov     dh,18
        call	cursor
        ;----------;
        mov     ah,01           ;key bord 1 pressed function
        int     21h
        ;                       ; key value save in 'al'
   push    ax      ;========/
        ;----------;
        mov     dl,al           ;ascii in 'al' copy to 'dl'
        mov     ah,2            ;display 1 character function
        int     21h
        ;-------------;
        call    bell1           ;short sound
        ;-------------
        mov     dl,6           ; 6,20
        mov     dh,20
        call	cursor
        ;----------;
   pop     ax      ;=======\
        mov     ah,09           ; display 1 char + attribute function
        mov     bh,0
        mov     bl,5AH          ;green+blue,,,green  coler
        mov     cx,2
        int     10h
        ;----------;
        lea     dx,msg2
        call    dispT
        ;----------;
        call    keyp
        ;-------------;
        mov     al,3            ;mode 0 monitor set are 40*25
        call	setm
        ;------------;
        lea     dx,msg3
        call    dispT
        ;------------;
        int     20h
main    endp
;========================;
;...sub program 1...     ;              ;-------- 1
;========================;
bell1   proc     near    ;
        mov     al,10    ; ; You must! find bell code 00-255=...?
        mov     ah,02    ;
        int     21h      ;
        ret              ;
;                        ;
bell1   endp             ;
;========================;
;...sub program 2...     ;
;========================;             ;-------- 2
dispT   proc     near   ;
        mov     ah,09    ;
        int     21h      ;
        ret              ;
;                        ;
dispT   endp             ;
;=======================;
;...sub program 3...    ;
;=======================;              ;-------- 3
keyp    proc     near   ;
                        ;
        mov     ah,1    ;
        int     21h     ;
        ret             ;
;                       ;
keyp    endp            ;
;=======================;
cursor    proc     near  
        mov     ah,2            ;move cursor function
        mov     bh,0            ;uses page 0
        int     10h
	ret
keyp    endp 
;---------------------------------
setm    proc     near   ;
        mov     ah,1    ;
        int     10h     ;
        ret             ;
;                       ;
setm   endp            ;
;====================
testLAB ends
end     main
