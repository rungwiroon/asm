;****************************************************************************
 close_window   macro
                local close
                mov handle1,0
                mov handle2,200
                mov x,0
                mov y,320
 close:         linew 0,handle1,320,0
                linew 0,handle2,320,0
                lineh x,0,200,0
                lineh y,0,200,0
                delay 2
                inc handle1
                dec handle2
                inc x
                dec y
                cmp y,160
                jge close
 endm
;****************************************************************************
 delay          macro n
                local delay1,delay2
                push_reg
                mov dx,n
 delay1:        mov cx,0ffffh
 delay2:        loop delay2
                dec dx
                jnz delay1
                pop_reg
 endm
;****************************************************************************
 disp_line      macro
                local next1
                linew 35,060,285,15
                linew 35,135,285,15
                mov ah,0ch
                mov al,0
                mov cx,lcol[0]
                mov dx,60
                int 10h
                inc cx
                int 10h
                inc cx
                int 10h
                mov cx,lcol[2]
                int 10h
                inc cx
                int 10h
                inc cx
                int 10h
                mov cx,lcol[0]
                mov dx,135
                int 10h
                inc cx
                int 10h
                inc cx
                int 10h
                mov cx,lcol[2]
                int 10h
                inc cx
                int 10h
                inc cx
                int 10h
                dec lcol[0]
                inc lcol[2]
                cmp lcol[2],285
                jle next1
                mov lcol[2],160
                mov lcol[0],160
 next1:         delay 10      
 endm
;****************************************************************************
 disp_level     macro
                local chk_mouse,chk_xchg,click,select1,select2,select3,select_botton
                screen_level
                select
 chk_mouse:     mov ax,1
                int 33h                 ;show mouse
                mov ax,3
                int 33h                 ;check status mouse
                cmp bx,1
                je  click    
                cmp cx,x
                jne chk_xchg            ;no slide
                cmp dx,y
                je  chk_mouse  
 chk_xchg:      mov ax,2
                int 33h                 ;hide mouse
                chk_level_all
                jmp chk_mouse
 click:         mov point,0
                chk_level_all
                cmp point,0             ;no click choice
                je  chk_mouse
                mov ax,2
                int 33h                 ;hide mouse
                cmp point,1
                je  select1             ;select easy
                cmp point,2
                je  select2             ;select normal
                cmp point,3
                je  select3             ;select hard
                jmp main_menu
 select1:       mov level,30
                jmp select_botton
 select2:       mov level,20
                jmp select_botton
 select3:       mov level,10
 select_botton: select
                jmp chk_mouse
 endm
;****************************************************************************
 select         macro
                local botton_easy,botton_norm,botton_ok
                botton_level                    ;clear botton
                cmp level,30
                je  botton_easy
                cmp level,20
                je  botton_norm
                writepic picbotton2,145,123,16,7        ;botton hard
                jmp botton_ok
 botton_easy:   writepic picbotton2,145,063,16,7        ;botton normal
                jmp botton_ok
 botton_norm:   writepic picbotton2,145,093,16,7        ;botton easy
 botton_ok:
 endm
;****************************************************************************
 chk_level_all  macro
                chk_level 122h,140h,03fh,045h,1
                chk_level 122h,140h,05dh,063h,2
                chk_level 122h,140h,07bh,081h,3
                chk_level 08ah,0e8h,077h,082h,4
 endm
;****************************************************************************
 chk_level      macro tl,tr,ul,ur,ptr
                local no_clr,xchg_ok
                push_reg                
                cmp cx,tl               ;column left        
                jl  no_clr
                cmp cx,tr               ;column right
                jg  no_clr
                cmp dx,ul               ;row top
                jl  no_clr
                cmp dx,ur               ;row bottom
                jg  no_clr
                chk_ch_level 1,ptr
                mov point,ptr           ;select choice
                jmp xchg_ok
 no_clr:        chk_ch_level 0,ptr
 xchg_ok:       pop_reg
                mov x,cx
                mov y,dx                ;new position cursor
 endm
;****************************************************************************
 chk_ch_level   macro color,ptr
                local choice_1,choice_2,choice_3,choice_4,ch1_n,ch2_n,ch3_n,ch4_n,choice_ok
                mov al,ptr
                mov bl,color
                cmp al,1
                je  choice_1
                cmp al,2
                je  choice_2
                cmp al,3
                je  choice_3
                cmp al,4
                je  choice_4
 choice_1:      cmp bl,1
                je  ch1_n
                pic_color piceasy,181,63,34,11,4
                jmp choice_ok
    ch1_n:      pic_color piceasy,180,62,34,11,40       ;display normal
                jmp choice_ok
 choice_2:      cmp bl,1
                je  ch2_n
                pic_color picmedium,181,093,63,8,4    
                jmp choice_ok
    ch2_n:      pic_color picmedium,180,092,63,8,40     ;display normal
                jmp choice_ok
 choice_3:      cmp bl,1
                je  ch3_n
                pic_color pichard,181,123,38,8,4 
                jmp choice_ok
    ch3_n:      pic_color pichard,180,122,38,8,40       ;display normal
                jmp choice_ok
 choice_4:      cmp bl,1
                je  ch4_n
                botton_border 69,119,31,26
                jmp choice_ok
    ch4_n:      botton_border 69,119,26,31
 choice_ok:  
 endm
;****************************************************************************
 screen_level   macro
                level_border
                pic_color piclevel,63,60,57,11,54
                pic_color piclevel,64,61,57,11,32       ;display 'Level'
                pic_color piceasy,180,62,34,11,40
                pic_color piceasy,181,63,34,11,4        ;display 'Easy'
                pic_color picmedium,180,092,63,8,40
                pic_color picmedium,181,093,63,8,4      ;display 'Medium'
                pic_color pichard,180,122,38,8,40
                pic_color pichard,181,123,38,8,4        ;display 'Hard'
                writepic picdone,69,119,48,12
                botton_level
 endm
;****************************************************************************
 level_border   macro
                clrscr
                mov ax,0600h
                mov bh,3
                mov cx,0504h
                mov dx,1222h
                int 10h
                linew 032,039,279,15
                lineh 032,039,151,15
                linew 033,151,279,27
                lineh 279,040,151,27
 endm
;****************************************************************************
 botton_level   macro
                writepic picbotton1,145,063,16,7
                writepic picbotton1,145,093,16,7
                writepic picbotton1,145,123,16,7
 endm
;****************************************************************************
 disp_about     macro
                local chk_mouse,click,chk_xchg
                screen_about
                mov x,140h
                mov y,64h               ;set start cursor
 chk_mouse:     mov ax,1
                int 33h                 ;show mouse
                disp_line
                mov ax,3
                int 33h                 ;check status mouse
                cmp bx,1
                je  click               ;left click
                cmp cx,x
                jne chk_xchg            ;no slide
                cmp dx,y
                je  chk_mouse  
                jmp chk_xchg 
 chk_xchg:      mov ax,2
                int 33h                 ;hide mouse
                chk_about
                jmp chk_mouse
 click:         mov point,0
                chk_about
                cmp point,1
                jne chk_mouse
                mov ax,2
                int 33h                 ;hide mouse
                jmp main_menu
 endm
;****************************************************************************
 chk_about      macro
                local no_xchg,xchg_ok
                push_reg
                cmp cx,10ah             ;column left        
                jl  no_xchg    
                cmp cx,168h             ;column right
                jg  no_xchg    
                cmp dx,094h             ;row top
                jl  no_xchg    
                cmp dx,09fh             ;row bottom
                jg  no_xchg
                botton_border 133,148,26,31
                mov point,1
                jmp xchg_ok
 no_xchg:       botton_border 133,148,31,26
 xchg_ok:       pop_reg
                mov x,cx
                mov y,dx
 endm
;****************************************************************************
 screen_about   macro
                clrscr
                pic_color picabout,122,32,66,11,54
                pic_color picabout,123,33,66,11,32
                writepic picdone,133,148,48,12
                disp_line
                delay 500
                disp_char license,0905h,30,39
                delay 500
                disp_char author,0c05h,30,39
                delay 500
                disp_char iden,0f05h,30,39
 endm
;****************************************************************************
 menu           macro
                local chk_mouse,click,chk_xchg
                clrscr
                choice
                mov ax,1
                int 33h                 ;show mouse
                mov x,140h
                mov y,64h               ;set start cursor
 chk_mouse:     mov ax,1
                int 33h                 ;show cursor
                mov ax,03
                int 33h                 ;check status cursor
                cmp bx,1
                je  click               ;left click
                cmp cx,x
                jne chk_xchg            ;no slide
                cmp dx,y
                je  chk_mouse
 chk_xchg:      mov ax,2
                int 33h                 ;hide mouse
                chk_cursor_all
                jmp chk_mouse
 click:         mov point,0
                chk_cursor_all
                mov ax,2
                int 33h                 ;hide mouse
                cmp point,1             ;click start game
                je  new_game
                cmp point,2             ;click level
                je  show_level
                cmp point,3             ;click high score
                je  show_score
                cmp point,4             ;click about
                je  show_about
                cmp point,5             ;click exit
                je  quit
                jmp chk_mouse
 endm
;****************************************************************************
 chk_cursor_all macro
                chk_cursor  0f0h,1f0h,02ah,034h,1
                chk_cursor  136h,1a8h,048h,052h,2
                chk_cursor  0fah,1eah,066h,070h,3
                chk_cursor  12ch,1aeh,084h,08eh,4
                chk_cursor  104h,1e0h,0a2h,0ach,5
 endm
;****************************************************************************
 chk_choice     macro color,ptr
                local choice_1,choice_2,choice_3,choice_4,choice_5,ch1_n,ch2_n,ch3_n,ch4_n,ch5_n,choice_ok
                mov al,ptr
                mov bl,color
                cmp al,1
                je  choice_1
                cmp al,2
                je  choice_2
                cmp al,3
                je  choice_3
                cmp al,4
                je  choice_4
                cmp al,5
                je  choice_5
 choice_1:      cmp bl,1
                je  ch1_n
                pic_color picstart,121,43,128,11,4
                jmp choice_ok
    ch1_n:      pic_color picstart,120,42,128,11,1
                jmp choice_ok
 choice_2:      cmp bl,1
                je  ch2_n
                pic_color piclevel,156,73,57,11,4
                jmp choice_ok
    ch2_n:      pic_color piclevel,155,72,57,11,1
                jmp choice_ok
 choice_3:      cmp bl,1
                je  ch3_n
                pic_color pichigh,126,103,121,15,4
                jmp choice_ok
    ch3_n:      pic_color pichigh,125,102,121,15,1
                jmp choice_ok
 choice_4:      cmp bl,1
                je  ch4_n
                pic_color picabout,151,133,66,11,4
                jmp choice_ok
    ch4_n:      pic_color picabout,150,132,66,11,1
                jmp choice_ok
 choice_5:      cmp bl,1
                je  ch5_n
                pic_color picexit,132,163,110,11,4
                jmp choice_ok
    ch5_n:      pic_color picexit,131,162,110,11,1
 choice_ok:  
 endm
;****************************************************************************
 chk_cursor     macro tl,tr,ul,ur,ptr
                local no_clr,xchg_ok
                push_reg                
                cmp cx,tl               ;column left        
                jl  no_clr
                cmp cx,tr               ;column right
                jg  no_clr
                cmp dx,ul               ;row top
                jl  no_clr
                cmp dx,ur               ;row bottom
                jg  no_clr
                chk_choice 1,ptr
                mov point,ptr           ;select choice
                jmp xchg_ok
 no_clr:        chk_choice 0,ptr
 xchg_ok:       pop_reg
                mov x,cx
                mov y,dx                ;new position cursor
 endm
;****************************************************************************
 choice         macro
                pic_color picmenu,52,43,40,130,9
                pic_color picmenu,50,45,40,130,1
                pic_color picstart,120,42,128,11,1
                pic_color picstart,121,43,128,11,4
                pic_color piclevel,155,72,57,11,1
                pic_color piclevel,156,73,57,11,4
                pic_color pichigh,125,102,121,15,1
                pic_color pichigh,126,103,121,15,4
                pic_color picabout,150,132,66,11,1
                pic_color picabout,151,133,66,11,4
                pic_color picexit,131,162,110,11,1      
                pic_color picexit,132,163,110,11,4      ;display choice
 endm
;****************************************************************************
 rank           macro
                local rank1
                mov cx,0406h
                mov si,'1'
                mov bl,54
 rank1:         mov ax,si
                mov ah,2
                mov dx,cx
                int 10h                 ;set cursor
                mov ax,si
                mov ah,0eh
                int 10h                 ;display rank
                mov al,'.'
                int 10h                 ;display '.'
                add ch,2                ;next row
                inc si                  ;next rank
                cmp si,'9'
                jle rank1
 endm
;****************************************************************************
 disp_score     macro
                local read_score,write_char,write_ok,disp_ok
                mov ax,2
                int 33h                 ;hide mouse
                clrscr
                mov rec,1  
                mov ah,3dh
                lea dx,filename1
                mov al,2
                int 21h                 ;open file score
                jc  disp_ok
                mov handle1,ax
                mov ah,2                ;function set cursor
                mov bh,0
                mov dh,4
                mov dl,9
                int 10h                 ;set cursor
 read_score:    mov ah,3fh
                mov bx,handle1
                mov cx,80
                lea dx,buffer
                int 21h                 ;read file score
                cmp ax,0
                je  disp_ok             ;eof
                push_reg                ;push all register
                mov cx,ax
                mov si,0
 write_char:    mov ah,0eh
                mov al,buffer[si]
                mov bh,0
                mov bl,12
                int 10h                 ;display 1 char and foreground
                inc si
                loop write_char         ;next char
                pop_reg
                jmp read_score
 disp_ok:       mov ah,3eh
                mov bx,handle1
                int 21h                 ;close file
                score_border
 endm
;****************************************************************************
 score_border   macro
                local key_score,chk_mouse,chk_xchg,click,score_ok,clear_player
                rank                    ;display rank 1 - 9
                pic_color pichigh 90,08,121,15,54
                pic_color pichigh 91,09,121,15,32
                writepic picclear1,75,181,48,12
                writepic picdone,181,181,48,12
                mov ax,1                
                int 33h                 ;show cursor
                mov x,140h
                mov y,64h               ;set start cursor
 chk_mouse:     mov ax,1
                int 33h                 ;show cursor
                mov ax,03
                int 33h                 ;check status cursor
                cmp bx,1
                je  click               ;left click
                cmp cx,x
                jne chk_xchg            ;no slide
                cmp dx,y
                je  chk_mouse
 chk_xchg:      mov ax,2
                int 33h                 ;hide mouse
                chk_xchg_clr            ;check for clear
                chk_xchg_ok             ;check for ok
                jmp chk_mouse
 click:         mov point,0
                chk_xchg_clr
                chk_xchg_ok
                cmp point,1             ;click clear
                je  clear_player
                cmp point,2             ;click ok                   
                jne chk_mouse
                jmp score_ok
 clear_player:  mov ax,2
                int 33h
                mov ax,0600h
                mov bh,0
                mov cx,0409h
                mov dx,141fh
                int 10h                 ;clear screen of player
                mov ah,41h
                lea dx,filename1
                int 21h                 ;delete score file
                jmp chk_mouse
 score_ok:      mov ax,2
                int 33h
                jmp main_menu
 endm
;****************************************************************************
 chk_xchg_clr   macro
                local no_xchg_clr,xchg_clr_ok
                push_reg                
                cmp cx,096h              ;column left        
                jl  no_xchg_clr
                cmp cx,0f4h              ;column right
                jg  no_xchg_clr
                cmp dx,0b5h              ;row top
                jl  no_xchg_clr
                cmp dx,0c0h              ;row bottom
                jg  no_xchg_clr
                botton_border 75,181,26,31
                mov point,1
                jmp xchg_clr_ok
 no_xchg_clr:   botton_border 75,181,31,26
 xchg_clr_ok:   pop_reg
                mov x,cx
                mov y,dx                ;new position cursor
 endm
;****************************************************************************
 chk_xchg_ok    macro
                local no_xchg_ok,xchg_ok_ok
                push_reg
                cmp cx,168h              ;column left
                jl  no_xchg_ok
                cmp cx,1c8h              ;column right
                jg  no_xchg_ok
                cmp dx,0b5h              ;row top
                jl  no_xchg_ok
                cmp dx,0c0h              ;row bottom
                jg  no_xchg_ok
                botton_border 181,181,26,31
                mov point,2
                jmp xchg_ok_ok
 no_xchg_ok:    botton_border 181,181,31,26
 xchg_ok_ok:    pop_reg
                mov x,cx
                mov y,dx                ;new position cursor
 endm
;****************************************************************************
 save_score     macro
                local read_,eof,loop1,no_file,change_file
                mov paste,0
                mov rec,1
                mov si,15               ;array of pname
                mov bx,0
 loop1:         mov dl,str_time[bx]
                mov pname[si],dl
                inc bx
                inc si
                cmp bx,8                ;digit of time = 8
                jl  loop1
                mov ah,3ch              ;function of open new file
                mov cl,0
                lea dx,filename2
                int 21h                 ;open backup
                mov handle2,ax          ;backup handle of backup
                mov ah,3dh              ;function of open existing file
                mov al,0
                lea dx,filename1
                int 21h                 ;open score file
                jc  no_file
                mov handle1,ax          ;backup of handle of existing
 read_:         mov cx,80               ;write to file 80 column
                mov ah,3fh              ;function for read file
                mov bx,handle1
                lea dx,buffer
                int 21h                 ;read file from main score
                cmp ax,0                ;check for eof
                je  eof
                push_reg
                cmp paste,1
                je  next_rec
                mov di,15               ;position of array
                mov cx,8
 chk_digit:     mov al,buffer[di]
                cmp pname[di],al
                jl  new_position
                cmp pname[di],al
                jg  next_rec
                inc di                  ;next digit of time
                loop chk_digit
                jmp next_rec
 new_position:  new_player              ;write player for right position
                mov paste,1
                inc rec
                cmp rec,9
                jg  paste_ok
 next_rec:      pop_reg
                cmp buffer[0],' '       
                je  read_
                mov cx,ax               ;amount of char to read past
                mov ah,40h
                mov bx,handle2
                lea dx,buffer
                int 21h                 ;write to file
                inc rec
                cmp rec,9
                jg  paste_ok
                jmp read_
 no_file:       new_player              ;write to file for no file
                mov paste,1
 eof:           cmp paste,0             
                jne paste_ok
                new_player              ;write player for last position
 paste_ok:      mov ah,3eh
                mov bx,handle1
                int 21h                 ;close file score
                mov ah,3eh
                mov bx,handle2
                int 21h                 ;close file backup
 change_file:   mov ah,41h
                lea dx,filename1
                int 21h                 ;delete old score
                mov ax,@data
                mov es,ax               ;set extra segment
                mov ah,56h
                lea dx,filename2
                lea di,filename1
                int 21h                 ;rename to new score
 endm
;****************************************************************************
 new_player     macro
                push_reg
                mov ah,40h
                mov bx,handle2
                mov cx,80
                lea dx,pname
                int 21h                 ;write last player to file
                pop_reg
 endm
;****************************************************************************
 disp_time      macro
                push_reg
                mov ah,2
                xor bh,bh
                mov dx,171fh            ;set cursor position
                int 10h
                call set_time           ;get timer
                mov ah,09h
                lea dx,str_time
                int 21h                 ;display time
                pop_reg
 endm
;****************************************************************************
 clrscr         macro
                mov ax,0600h
                mov bh,0
                mov cx,0
                mov dx,184fh
                int 10h
 endm
;****************************************************************************
 push_reg       macro
                push ax
                push bx
                push cx
                push dx
 endm
;****************************************************************************
 pop_reg        macro
                pop dx
                pop cx
                pop bx
                pop ax
 endm
;****************************************************************************
 botton_border  macro c,r,c1,c2
                mov row,r
                dec row
                mov col,c
                dec col
                mov si,col
                add si,48
                linew c,r,si,c1         ;top border
                mov di,row
                add di,12
                lineh c,r,di,c1         ;left border
                mov ax,c
                inc ax
                mov si,col
                add si,48
                linew ax,di,si,c2       ;bottom border
                mov bx,r
                inc bx
                lineh si,bx,di,c2       ;right border
 endm
;****************************************************************************
 disp_char      macro pic,col,wi,color          ;string,row-col,width,color
                local key_char 
                mov cx,col  
                mov si,0
                mov bl,color            ;set color
 key_char:      mov ah,2
                mov bh,0
                mov dx,cx
                int 10h                 ;set cursor
                mov ah,0eh
                mov al,pic[si]
                mov bh,0
                int 10h                 ;display character of string
                inc cl
                inc si
                cmp si,wi
                jl  key_char 
 endm
;****************************************************************************
 picachu        macro
                local mprint,mnormal,mb_color
                mov bx,0
                mov cx,130
                mov dx,130
                add cx,slide
                add dx,over
                mov di,34
                mov bx,00
 mprint:        mov ah,0ch
                mov al,picp[bx]
                cmp al,0
                je  mb_color
                cmp cmonk,1
                je  mnormal
                mov al,0
 mnormal:       int 10h
 mb_color:      inc bx
                inc cx
                cmp bx,di
                jbe mprint
                mov cx,130
                add cx,slide
                add dx,1
                add di,35
                cmp di,1014
                jbe mprint
 endm
;*******************************************************************
 writebat       macro pic,col,row,wi,hi,cbat
                local print_bat,bback1,bback2
                mov cx,col
                add cx,fly
                mov dx,row
                mov di,wi
                dec di
                mov bx,0
 print_bat:     mov ah,0ch
                mov al,pic[bx]
                cmp al,0
                je  bback2
                cmp cbat,1
                je  bback1
                mov al,0
 bback1:        int 10h
 bback2:        inc bx
                inc cx
                cmp bx,di
                jbe print_bat
                mov cx,col
                add cx,fly
                inc dx
                add di,wi
                mov si,row
                add si,hi
                cmp dx,si
                jb  print_bat
 endm
;*******************************************************************
 writefruit     macro pic,col,row,wi,hi,color
                local print_fruit,fcolor
                mov cx,col
                mov dx,row
                mov di,wi
                dec di
                mov bx,0
 print_fruit:   mov ah,0ch
                mov al,pic[bx]
                cmp color,1
                je  fcolor
                mov al,0
 fcolor:        int 10h
                inc bx
                inc cx
                cmp bx,di
                jbe print_fruit
                mov cx,col
                inc dx
                add di,wi
                mov si,row
                add si,hi
                dec si
                cmp dx,si
                jbe print_fruit
 endm
;*******************************************************************
 linew          macro col,row,last,color
                local w1
                push_reg
                mov cx,col
                mov dx,row
                mov si,last
                mov al,color
                mov ah,0ch
 w1:            int 10h
                inc cx
                cmp cx,si
                jle w1
                pop_reg
 endm
;****************************************************************************
 lineh          macro col,row,last,color
                local h1
                push_reg
                mov cx,col
                mov dx,row
                mov si,last
                mov al,color
                mov ah,0ch
 h1:            int 10h
                inc dx
                cmp dx,si
                jle h1
                pop_reg
 endm
;****************************************************************************
 writepic       macro pic,col,row,wi,hi
                local print_pic,cback
                mov cx,col
                mov dx,row              ;set column and row
                mov di,wi               
                dec di
                mov bx,0
 print_pic:     mov ah,0ch              ;function for write pixel
                mov al,pic[bx]
                cmp al,0                ;color of background
                je  cback
                int 10h
 cback:         inc bx                  ;next color
                inc cx
                cmp bx,di
                jbe print_pic
                mov cx,col              ;set start column
                inc dx
                add di,wi
                mov si,row
                add si,hi
                dec si
                cmp dx,si               ;check for last pixel
                jbe print_pic
 endm
;****************************************************************************
 pic_color      macro pic,col,row,wi,hi,color
                local print_pic,cback,normal
                push_reg
                mov cx,col
                mov dx,row              ;set column and row
                mov di,wi
                dec di
                mov bx,0
 print_pic:     mov ah,0ch              ;function for write pixel
                mov al,pic[bx]
                cmp al,0
                je  cback
                mov si,color            ;check color normal or pointer
                cmp si,1
                je  normal
                mov al,color
 normal:        int 10h                 ;write pixel
 cback:         inc bx
                inc cx                  ;next column
                cmp bx,di
                jbe print_pic
                mov cx,col              ;set start column
                inc dx
                add di,wi
                mov si,row
                add si,hi
                dec si
                cmp dx,si
                jbe print_pic           ;check for last pixel
                pop_reg
 endm
;****************************************************************************
