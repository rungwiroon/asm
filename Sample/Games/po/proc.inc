;****************************************************************************
 border         proc
                linew 05,008,295,09
                linew 06,009,294,09
                linew 07,010,293,09
                linew 08,011,292,09             ;top border
                linew 05,175,295,09 
                linew 06,174,294,09
                linew 07,173,293,09
                linew 08,172,292,09             ;bottom border
                lineh 05,008,175,54
                lineh 06,009,174,54
                lineh 07,010,173,54
                lineh 08,011,172,54
                lineh 09,012,171,54             ;left border
                lineh 295,08,175,54
                lineh 294,09,174,54
                lineh 293,10,173,54
                lineh 292,11,172,54
                lineh 291,12,171,54             ;right border
                lineh 319,008,175,54
                linew 296,008,319,54
                linew 296,175,319,54
                linew 296,009,319,54
                linew 296,174,319,54            ;life border
                linew 241,180,318,09
                linew 242,181,317,09            ;top of time
                linew 241,194,318,09
                linew 242,193,317,09            ;bottom of time
                lineh 240,180,194,54
                lineh 241,181,193,54
                lineh 242,182,192,54            ;left of time
                lineh 319,180,194,54
                lineh 318,181,193,54
                lineh 317,182,192,54            ;right of time
                linew 062,180,174,09
                linew 063,181,173,09            ;top of player
                linew 062,194,174,09
                linew 063,193,173,09            ;bottom of player
                lineh 061,180,194,54
                lineh 062,181,193,54
                lineh 063,182,192,54            ;left of player
                lineh 175,180,194,54
                lineh 174,181,193,54
                lineh 173,182,192,54            ;right of player
                ret
 border         endp
;****************************************************************************
 dead_pic       proc
                mov bx,0
                mov cx,130
                add cx,slide
                mov dx,138
                add dx,over
                mov di,40
                mov si,00
 printd:        mov ah,0ch
                mov al,picd[si]
                cmp al,1
                je db_color 
                cmp cdead,1
                je  d_normal
                mov al,0
 d_normal:      int 10h
 db_color:      inc si
                inc cx
                cmp si,di
                jbe printd   
                mov cx,130
                add cx,slide
                inc dx
                add di,41
                cmp di,860
                jbe printd
                ret
 dead_pic       endp
;****************************************************************************
 fruit          proc
                mov color,1
                writefruit pica,025,47,23,17,color  ;apple 1
                writefruit pica,109,50,23,17,color  ;apple 2
                writefruit pica,194,47,23,17,color  ;apple 3
                writefruit pico,055,50,19,17,color  ;orange 1
                writefruit pico,139,50,19,17,color  ;orange 2
                writefruit pico,223,49,19,17,color  ;orange 3
                writefruit picr,082,50,20,17,color  ;rose 1
                writefruit picr,167,50,20,17,color  ;rose 2
                writefruit picr,251,47,20,17,color  ;rose 3
                mov bx,2
 set_stat:      mov stat[bx],1
                add bx,4
                cmp bx,34
                jle set_stat
                ret
 fruit          endp
;****************************************************************************
 bat            proc
                writebat pbat1,013,73,61,27,cbat
                neg fly
                writebat pbat2,227,73,61,27,cbat
                neg fly
                ret
 bat            endp
;*******************************************************************
 life_start     proc
                mov cx,5
                mov dh,3
                mov dl,38
 l1:            mov ah,2
                int 10h
                mov ah,0eh
                mov al,1
                mov bh,0
                mov bl,14
                int 10h
                add dh,4
                loop l1
                ret
 life_start     endp
;*******************************************************************
 background     proc
                clrscr
                mov ax,0600h
                mov bh,0
                mov cx,0101h            ;0402h
                mov dx,1524h            
                int 10h                 ;set background color
                pic_color picplayer,4,182,45,12,40
                pic_color picplayer,5,183,45,12,4
                pic_color pictimer,187,182,44,8,40
                pic_color pictimer,188,183,44,8,4
                ret
 background     endp
;****************************************************************************
 branch         proc
                mov ah,0ch
                mov al,6
                mov bx,0
 bprint:        mov cx,branch_c[bx]
                mov dx,branch_r[bx]
                int 10h
                add bx,2
                cmp branch_r[bx],0
                jne bprint
                ret
 branch         endp
;****************************************************************************
 convert        proc
                mov ah,0
                mov dl,10
                div dl
                or  ax,3030h            ;convert to char
                ret
 convert        endp
;****************************************************************************
 backup_time    proc
                mov ah,2ch
                int 21h                 ;read time
                mov hh,ch
                mov mm,cl
                mov sec,dh
                mov ms,dl               ;backup real time
                ret
 backup_time    endp
;****************************************************************************
 set_time       proc
                mov ah,2ch
                int 21h                 ;read time
                cmp dl,ms
                jge do_ms
                add dl,100
                sub dh,1
 do_ms:         sub dl,ms               ;compute millisecond
                cmp dh,sec
                jge do_sec
                add dh,60
                sub cl,1
 do_sec:        sub dh,sec              ;compute second
                cmp cl,mm
                jge do_hh
                add cl,60
                sub ch,1
 do_hh:         sub cl,mm               ;compute minute
                sub ch,hh               ;compute hour
 do_ok:         push dx
                lea bx,str_time         ;offset of time string
                mov al,cl
                call convert            ;call sub program
                mov [bx],ax             ;mov minute to time string
                mov al,dh
                call convert            ;call sub program
                mov [bx+3],ax           ;mov second to time string
                pop ax
                call convert            ;call sub program
                mov [bx+6],ax           ;mov millisecond to time string
                ret
 set_time       endp
;****************************************************************************
 clear_time     proc
                mov str_time[0],'0'
                mov str_time[1],'0'
                mov str_time[3],'0'
                mov str_time[4],'0'
                mov str_time[6],'0'
                mov str_time[7],'0'
                mov ah,2
                xor bh,bh
                mov dx,171fh            ;set cursor position
                int 10h
                mov ah,09
                lea dx,str_time
                int 21h
                ret
 clear_time     endp
;*******************************************************************
