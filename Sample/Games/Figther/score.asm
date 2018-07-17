
getname proc
	pushx	<ax,bx,cx,dx,di,si>
	mov	ax,@data
	mov	es,ax
	gotoxy	6,19
	mov	ah,9
	lea	dx,msgname
	int	21h
        xor     bx,bx

        mov     ah,1
getnamelp_:
        int     21h
        cmp     al,0dh
        je      endgetname_
        mov     [nameplay+bx],al
        inc     bx
        jmp     getnamelp_
endgetname_:
        openfile
        cld
        lea     di,filebuffer1
        mov     numsave,0
nextsave3_:
        mov     ah,3fh
        mov     bx,filehandle
        mov     cx,18
        lea     dx,namebuffer
        int     21h

        mov     ah,3fh
        mov     bx,filehandle
        mov     cx,2
        lea     dx,scorebuffer
        int     21h

        mov     ax,scorebuffer
        cmp     score,ax
        jge     nextsave1_

        inc     numsave
        lea     si,namebuffer
        mov     cx,18
        rep     movsb
        mov     ax,scorebuffer
        stosw
        cmp     numsave,10
        jne     nextsave3_
        jmp     endsave_
nextsave1_:
        inc     numsave
        lea     si,nameplay
        mov     cx,18
        rep     movsb
        mov     ax,score
        stosw

        cmp     numsave,10
        jne     nextsave2_
        jmp     endsave_
nextsave2_:
        inc     numsave
        lea     si,namebuffer
        mov     cx,18
        rep     movsb
        mov     ax,scorebuffer
        stosw

        cmp     numsave,10
        je      endsave_

nextsave4_:
        mov     ah,3fh
        mov     bx,filehandle
        mov     cx,18
        lea     dx,namebuffer
        int     21h

        mov     ah,3fh
        mov     bx,filehandle
        mov     cx,2
        lea     dx,scorebuffer
        int     21h

        inc     numsave
        lea     si,namebuffer
        mov     cx,18
        rep     movsb
        mov     ax,scorebuffer
        stosw

        cmp     numsave,10
        je      endsave_
        jmp     nextsave4_

endsave_:
        mov     ah,42h
        mov     al,0
        mov     bx,filehandle
        xor     cx,cx
        xor     dx,dx
        int     21h

        mov     ah,40h
        mov     bx,filehandle
        mov     cx,200
        lea     dx,filebuffer1
        int     21h
        closefile
        popx	<si,di,dx,cx,bx,ax>
        ret
getname endp

showhiscore     proc
	pushx	<ax,bx,cx,dx,di,si>
        openfile

        mov     numshowscore,30h
        mov     count,10
        mov     line,9
hiscoreloop_:
        inc     numshowscore
        mov     ah,3fh
        mov     bx,filehandle
        mov     cx,18
        lea     dx,namebuffer
        int     21h

        mov     ah,2h
        mov     bh,0
        mov     dh,line
        mov     dl,8
        int     10h

        cmp     numshowscore,3ah
        jne     is1_9
        mov     ah,2h
        mov     bh,0
        mov     dh,line
        mov     dl,8
        int     10h
        mov     ah,2
        mov     dl,'1'
        int     21h
        mov     dl,'0'
        int     21h
        mov     dl,'.'
        int     21h
        mov     dl,' '
        int     21h
        jmp     showname_
is1_9:
        mov     ah,2
        mov     dl,numshowscore
        int     21h
        mov     dl,'.'
        int     21h
        mov     dl,' '
        int     21h

showname_:
        mov     ah,2h
        mov     bh,0
        mov     dh,line
        mov     dl,11
        int     10h

        mov     ah,9
        lea     dx,namebuffer
        int     21h

        mov     ah,3fh
        mov     bx,filehandle
        mov     cx,2
        lea     dx,score
        int     21h

        mov     ah,2h
        mov     bh,0
        mov     dh,line
        mov     dl,30
        int     10h

        mov     ax,score
        call    outdec

        inc     line

        dec     count
        jz      endhiscore_
        jmp     hiscoreloop_
endhiscore_:
        mov     ah,1
        int     21h
        closefile
        popx	<si,di,dx,cx,bx,ax>
        ret
showhiscore     endp


