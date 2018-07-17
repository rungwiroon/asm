.model small
 include macro.inc
.stack 100h
.data
 include picture.inc
 include variable.inc
.code
 main           proc                    ;main program
                mov ax,@data
                mov ds,ax               ;set data segment
                mov ax,13h
                int 10h                 ;set vga 256 colors
                mov level,20
                mov ax,0
                int 33h
 main_menu:     close_window
                menu
 show_level:    close_window
                disp_level
                jmp main_menu
 show_score:    close_window
                disp_score
                jmp main_menu
 show_about:    close_window
                disp_about
                jmp main_menu
 new_game:      mov ax,2
                int 33h                 ;hide mouse
                close_window
                mov position,18
                mov direction,0
                mov dead,0
                mov life,5
                mov slide,0
                mov cmonk,1
                mov cbat,1
                mov pstb1,1
                mov pstb2,31
                mov over,0
                mov pre,10
                mov fly,0
                mov al,0bh
                call background         ;display background
                call picachu_pic        ;display picachu
                writepic bpic,30,30,240,20   ;display tree
                call fruit                   ;display all fruit
                call branch
                call clear_time
                call life_start
                call border
                mov al,82
                call bat_pic
                call key_player
                call backup_time        ;backup real time
                mov slide,0
                mov over,0
                mov al,0bh              ;color of picachu
 slide_key:     call picachu_pic        ;display picachu
                mov ah,1
                int 16h                 ;check keyboard buffer
                jz  no_key              ;no key in buffer
                mov ah,0                ;accept key from user
                int 16h
                cmp al,27
                je  main_menu           ;escape key
                cmp ah,3bh
                je  new_game            ;f1 = new game
                cmp al,' '
                je  jumping_u           ;space bar for jump
                cmp ah,77
                je  right               ;right arrow
                cmp ah,75
                je  left                ;left arrow
                mov al,0bh
                jmp slide_key
 jumping_u:     mov dead,0
                mov cdead,1
                call picachu_pic        ;clear for dead
                mov cdead,0
                mov aloop,7
                mov nloop,7             ;jump 7 times
 ujump:         mov ah,2ch
                int 21h                 ;read time start
                mov nms,dl              ;backup millisecond
 jump_u:        push_reg
                call picachu_pic        ;display picachu
                pop_reg
                mov ah,2ch
                int 21h                 ;read time now
                cmp dl,nms
                jge chkmsu
                add dl,100
 chkmsu:        sub dl,nms
                cmp dl,1
                jle jump_u
                mov cmonk,0             ;set black color
                call picachu_pic        ;display picachu
                mov cmonk,1             ;set picachu color
                add over,-9             ;move picachu over
                call picachu_pic        ;display picachu
                cmp nloop,4
                jne no_chk_j
                call chk_jump
                cmp dead,1
                je  jump_dead
 no_chk_j:      dec nloop
                jnz ujump
                call chk_fruit
                jmp jumping_d
 jump_dead:     sub aloop,3
                dec life
 clr_dead:      mov ax,0600h
                mov bh,0
                mov cx,0902h            
                mov dx,0f23h            
                int 10h                 ;clear for position of bat
                call chk_life
                cmp life,0
                je  play_again
 jumping_d:     mov bl,aloop
                mov nloop,bl            ;down 7 times
 djump:         mov ah,2ch
                int 21h                 ;read time start
                mov nms,dl
 jump_d:        push_reg
                call picachu_pic        ;display picachu
                pop_reg
                mov ah,2ch
                int 21h                 ;read time now
                cmp dl,nms
                jge chkssd
                add dl,100
 chkssd:        sub dl,nms
                cmp dl,1
                jle jump_d
                mov cmonk,0
                mov cdead,0
                call picachu_pic        ;clear old picachu
                mov cmonk,1             ;set picachu color
                mov cdead,1
                add over,9
                call picachu_pic        ;display picachu
                dec nloop
                jnz djump
                cmp dead,0
                je  slide_key
                mov rec,150
 delay_dead:    call picachu_pic
                inc bcount
                dec rec
                jnz delay_dead
                mov dead,0
                jmp slide_key
 right:         cmp position,35         ;amount 1 - 35 shifts
                je  slide_key
                inc position
                mov cmonk,0
                call picachu_pic        ;clear old position picture
                mov cmonk,1
                add slide,7             ;slide right
                jmp slide_key
 left:          cmp position,1
                je  slide_key
                dec position
                mov cmonk,0
                call picachu_pic        ;clear old position picture
                mov cmonk,1
                add slide,-7            ;slide left
                jmp slide_key
 no_key:        mov al,0bh              ;set color
                jmp slide_key
 quit:          close_window
                mov ax,3
                int 10h                 ;return normal mode
                mov ah,4ch
                int 21h                 ;exit program
 main           endp
;****************************************************************************
 picachu_pic    proc
                disp_time               ;display timer
                inc bcount
                mov bl,level
                cmp bcount,bl
                jle start_pica          ;bat not fly
                mov bcount,0
                inc pstb1
                dec pstb2
                mov cbat,0
                call bat_pic            ;clear old bat
                add fly,7
                mov cbat,1              ;color of bat
                call bat_pic            ;display bat
 start_pica:    cmp dead,0
                je  pica_normal
                call dead_pic
                jmp pica_ok
 pica_normal:   cmp cdead,0
                je no_clear
                mov cdead,0
                call dead_pic
 no_clear:      picachu
 pica_ok:       ret                     ;end procedure
 picachu_pic    endp
;****************************************************************************
 bat_pic        proc
                cmp pstb1,31
                jge no_bat
                mov bx,0
                call bat
                jmp quit_bat
 no_bat:        mov pstb1,1
                mov pstb2,31
                mov fly,0               ;clear fly of bat
                mov ax,0600h
                mov bh,0
                mov cx,0902h            
                mov dx,0c23h            
                int 10h                 ;clear for position of bat
 quit_bat:      ret                     ;end procedure
 bat_pic        endp
;****************************************************************************
 chk_fruit      proc
                xor bh,bh
                mov bl,position
                cmp stat[bx],1
                jne chk_ok
                mov stat[bx],0          ;fruit is sill
                mov color,0
                cmp position,2          ;position of apple1
                je  clr_apple1
                cmp position,6          ;position of orange1
                je  clr_orange1
                cmp position,10         ;position of rose1
                je  clr_rose1  
                cmp position,14         ;position of apple2
                je  clr_apple2
                cmp position,18         ;position of orange2
                je  clr_orange2
                cmp position,22         ;position of rose2
                je  clr_rose2 
                cmp position,26         ;position of apple3
                je  clr_apple3 
                cmp position,30         ;position of orange3
                je  clr_orange3
                writefruit picr,251,47,20,17,color ;clear rose3
                jmp chk_ok
 clr_apple1:    writefruit pica,025,47,23,17,color ;clear apple1
                jmp chk_ok
 clr_apple2:    writefruit pica,109,50,23,17,color ;clear apple2
                jmp chk_ok
 clr_apple3:    writefruit pica,194,47,23,17,color ;clear apple3
                jmp chk_ok
 clr_orange1:   writefruit pico,055,50,19,17,color ;clear orange1
                jmp chk_ok
 clr_orange2:   writefruit pico,139,50,19,17,color ;clear orange2
                jmp chk_ok
 clr_orange3:   writefruit pico,223,49,19,17,color ;clear orange3
                jmp chk_ok
 clr_rose1:     writefruit picr,082,50,20,17,color ;clear rose1
                jmp chk_ok
 clr_rose2:     writefruit picr,167,50,20,17,color ;clear rose2
 chk_ok:        mov color,1
                call chk_game           ;check for finish game
                ret
 chk_fruit      endp
;****************************************************************************
 chk_game       proc
                mov bx,2
 loop_chk:      cmp stat[bx],0          ;check the fruit are kept all
                jne not_game
                add bx,4                ;next fruit
                cmp bx,35
                jle loop_chk
                save_score
 play_again:    mov ax,0600h
                mov bh,0
                mov cx,0905h            
                mov dx,0c1fh            
                int 10h                 ;clear for position of bat
                mov fly,0
                call bat_pic            ;clear bat picture old
                mov cmonk,0
                call picachu_pic        ;clear picachu picture old
                mov direction,0
                mov pstb1,1
                mov pstb2,31
                mov fly,0               ;clear everything for bat
                mov position,13
                mov slide,0
                mov over,0              ;clear everything for picachu
                mov cmonk,1
                mov dead,0
                cmp life,0
                jne winner
                mov cdead,1
                call dead_pic           ;display dead picachu
                writepic picl,112,100,71,9  ;"you lost"
                jmp finish_game         
 winner:        call picachu_pic        ;display picachu at standard
                writepic picw,116,100,65,9  ;"you win"
 finish_game:   mov al,82
                call bat_pic            ;display bat at standard
 getch:         mov ah,0
                int 16h
                close_window
                disp_score
                jmp quit
 not_game:      ret
 chk_game       endp
;****************************************************************************
 chk_jump       proc
                mov cl,position         ;left of bat
                mov al,position         ;right of bat
                add cl,4
                sub al,8
 chk_b1:        cmp pstb1,cl
                jg  chk_b2
                cmp pstb1,al
                jl  chk_b2
                mov dead,1              ;picachu dead for bat1
                jmp chk_b_ok
 chk_b2:        cmp pstb2,cl
                jg  chk_b_ok
                cmp pstb2,al
                jl  chk_b_ok
                mov dead,1              ;picachu dead for bat2
 chk_b_ok:      ret
 chk_jump       endp
;****************************************************************************
 chk_life       proc
                mov ah,2
                mov bh,0
                mov cl,3
                mov ch,6
 next_chk:      dec ch
                cmp ch,life
                jle life_ok
                mov dh,cl
                mov dl,38
                int 10h                 ;shift cursor
                mov dl,' '
                int 21h                 ;clear life picture
                add cl,4
                jmp next_chk
 life_ok:       ret
 chk_life       endp
;****************************************************************************
 key_player     proc
                call clear_pname
                mov ah,2
                xor bh,bh
                mov dx,1709h            ;set cursor position
                int 10h
                mov si,0                ;offset of name
 cont:          mov ah,0
                int 16h                 ;accept key
                cmp al,13
                je  key_ok
                cmp al,27               ;key escape for exit
                je  main_menu
                cmp al,65
                jl  cont
                cmp al,122
                jg  cont                ;next character
                mov ah,0eh
                xor bh,bh
                mov bl,99
                int 10h                 ;display key
                mov pname[si],al        ;keep key
                inc si
                cmp si,12
                jl  cont
 key_ok:        cmp si,0
                je  cont
                ret
 key_player     endp
;****************************************************************************
 clear_pname    proc
                mov cx,15
                mov si,0
 clr:           mov pname[si],' '
                inc si
                loop clr
                ret
 clear_pname    endp
;****************************************************************************
 include proc.inc
                end main
