;****************************************************************************
 show_xy        macro
                push_reg
                mov ah,2
                mov bh,0
                mov dx,0
                int 10h                 ;set cursor
                mov ax,03h
                int 33h                 ;check position of mouse
                push_reg
                mov ah,2
                mov dl,'X'
                int 21h
                mov dl,'='
                int 21h
                pop_reg
                mov bx,cx
                cv_xy
                push_reg
                mov ah,2
                mov dl,' '
                int 21h
                mov dl,'Y'
                int 21h
                mov dl,'='
                int 21h
                pop_reg
                mov bx,dx
                cv_xy
                pop_reg
 endm
;****************************************************************************
 cv_xy          macro
                local p1,p2,p3
                push_reg
                mov cx,4
 p1:            mov si,4
 p2:            shl bx,1
                rcl dl,1
                dec si
                jnz p2
                and dl,0fh
                or dl,30h
                cmp dl,3ah
                jb p3
                add dl,07h
 p3:            mov ah,02h
                int 21h
                loop p1
                pop_reg
 endm
;****************************************************************************
