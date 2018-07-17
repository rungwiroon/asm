.model small
.stack 100h
.386
include j_macro.asm
;----------------------------------------
;----------------------------------------
load_redsnow macro
	mov ax,r_snowx
	mov startx,ax
	add ax,40
	mov stopx,ax
	mov ax,r_snowy
	mov starty,ax
	add ax,32
	mov stopy,ax
endm
;----------------------------------------
;----------------------------------------
clear_redsnow macro
	save_register <ax,cx,dx>
	mov ax,r_snowx
	mov ganx,ax
	add ax,40
	mov maxc,ax
	mov ax,r_snowy
	mov gany,ax
	add ax,32
	mov maxr,ax
	mov r_snowx,250
	mov r_snowy,85
	pixel ganx,gany,maxc,maxr,15
	load_register <dx,cx,ax>
endm
;----------------------------------------
;----------------------------------------
show_snow1 macro
	local s1,s2
	save_register <ax,cx,dx>
	mov ax,s1y
	inc ax
	mov s1y,ax
	mov ax,s1x
	mov ganx,ax
	add ax,16
	mov maxc,ax
	mov ax,s1y
	mov gany,ax
	add ax,16
	mov maxr,ax
	showpic ganx,gany,maxc,maxr,0,snow
	load_register <dx,cx,ax>
endm
;----------------------------------------
;----------------------------------------
clear_snow1 macro
	save_register <ax,cx,dx>
	mov ax,snowx
	mov ganx,ax
	add ax,14
	mov maxc,ax
	mov ax,snowy
	mov gany,ax
	add ax,12
	mov maxr,ax
	mov snowx,0
	mov snowy,0
	mov dl,0	
	pixel ganx,gany,maxc,maxr,15
	load_register <dx,cx,ax>
endm
;----------------------------------------
;----------------------------------------
load_greensnow macro
	local s1,s2
	save_register <ax,cx,dx>
	mov ax,g1_snowy
	inc ax
	mov g1_snowy,ax
	mov ax,g1_snowx
	mov ganx,ax
	add ax,40
	mov maxc,ax
	mov ax,g1_snowy
	mov gany,ax
	add ax,32
	mov maxr,ax
	mov d1,2
	div dl
	cmp ah,1
	jne s1
	showpic ganx,gany,maxc,maxr,0,green1
	jmp s2
s1:
	showpic ganx,gany,maxc,maxr,0,green3
s2:
	load_register <dx,cx,ax>
endm
;----------------------------------------
;----------------------------------------
load_heart macro heart
	local h1
	save_register <ax,bx,cx,dx>
	cmp heart,1
	jb h1
	showgame 170,181,186,194,0,heart
	cmp heart,2
	jb h1
	showgame 184,181,200,194,0,heart
	cmp heart,3
	jb h1
	showgame 198,181,214,194,0,heart
h1:	
	load_register <dx,cx,bx,ax>
endm
;----------------------------------------
;----------------------------------------
help_screen macro
	local h1,h2
	save_register <ax,bx,cx,dx,si>    
	pixel 50,25,275,175,0,0
	square 50,25,276,176,78,78	; border
	square 51,26,276,176,78,78
	square 50,25,275,176,78,78
	square 51,26,276,176,78,78
	square 50,44,275,175,78,78
	square 51,45,276,176,78,78
	showmessage 17,4,mesg1		; message
	showmessage 10,8,mesg2
	showmessage 10,10,mesg3
	showmessage 10,12,mesg4
	showmessage 10,14,mesg5
	showmessage 10,16,mesg6
	showmessage 10,18,mesg7
	showmessage 10,20,mesg8
	;showmessage 10,23,mesg9
h1:
	keyplay
	cmp key,1
	je h2
	delay 100
	jmp h1
h2:
	load_register <si,dx,cx,bx,ax>
endm
;----------------------------------------
;----------------------------------------
season_screen macro
	local title
	save_register <cx>
	xor cx,cx
	mov cx,10h
	pixel 0,0,320,200,15,15
	showpicture 90,70,160,32,season
title:
	square 1,1,318,198,88,88
	square 3,3,316,196,92,92
	square 5,5,314,194,88,88
	showpicture 30,50,40,32,greenwin
	showpicture 30,50,40,32,greenwin2
	showpicture 200,120,40,32,greenwin3
	delay 500
	showpicture 70,30,40,32,greenwin
	showpicture 70,30,40,32,greenwin2
	showpicture 250,45,40,32,greenwin3
	delay 500
	showpicture 200,120,40,32,greenwin
	showpicture 250,45,40,32,greenwin2
	showpicture 70,30,40,32,greenwin3
	delay 500
	showpicture 250,45,40,32,greenwin
	showpicture 200,120,40,32,greenwin2
	showpicture 30,50,40,32,greenwin3
	delay 500
	dec cx
	cmp cx,0
	jnz title
	load_register <cx>
endm
;----------------------------------------
;----------------------------------------
load_screen macro
	save_register <ax,bx,cx,dx>
	pixel 0,0,320,200,15,15
	pixel 5,180,315,195,0,0
	square 1,1,318,198,88,88  ; border out
	square 3,3,316,196,92,92
	square 5,5,314,194,88,88
	square 5,5,314,179,88,88  ; border in
	showmessage 1,23,mesg12	  ; player 	
	showmessage 15,23,mesg11  ; lift 
	showmessage 69,23,mesg10  ; score
	showpicture 70,80,40,25,snow3
	showpicture 190,90,40,25,snow4

	mov heart,3
	load_heart heart	
	mov score,0
	mov check,0
	mov countk,0
	mov countloop,0
	mov time,100
	mov s1x,0
	mov s1y,0
	mov d1,0
	
	mov r_snowx,250	          ;display snow_red position
	mov r_snowy,85
	load_redsnow
	pixel startx,starty,stopx,stopy,15
	showgame startx,starty,stopx,stopy,05,red1 
	load_register <dx,cx,bx,ax>
endm

;----------------------------------------
;----------------------------------------
play_screen macro
	local p1,p11,left,right,up,down,help,pause,newgame,exitplay,shoot
	season_screen
	load_screen
p1:
	load_redsnow
	showgame startx,starty,stopx,stopy,15,red1
	check_snow
	keyplay	
	cmp key,57	; space bar
	je shoot
	cmp key,59	; f1
	je help
	cmp key,68	; f10
	je pause
	cmp key,60	; f2
	je newgame
	cmp key,75	; left
	je left
	cmp key,77	; right
	je right
	cmp key,72	; up
	je up
	cmp key,80	; down
	je down
	cmp key,1
	je exitplay
	delay time
	jmp p1
left:
	;load_redsnow
	pixel startx,starty,stopx,stopy,15
	cmp r_snowx,230
	je p1
	sub r_snowx,1
	jmp p1
right:
	;load_redsnow
	pixel startx,starty,stopx,stopy,15
	cmp r_snowx,274
	je p1
	add r_snowx,1
	jmp p1
up:
	;load_redsnow
	pixel startx,starty,stopx,stopy,15
	cmp r_snowy,6
	je p1
	sub r_snowy,1
	jmp p1
down:
	;load_redsnow
	pixel startx,starty,stopx,stopy,15
	cmp r_snowy,147
	je p1
	add r_snowy,1
	jmp p1
pause:
help:
	help_screen
	jmp p1
shoot:
	
	showpicture 250,85,40,32,red1
	delay 2000
	showpicture 250,85,40,32,red3
	delay 2000
	showpicture 250,85,40,32,red4
	delay 2000
	clear_redsnow
	jmp p1
newgame:
exitplay:
endm
;----------------------------------------
;----------------------------------------
.data 
include def_var.asm
include picture.asm
.code
main proc
	
	mov ax,@data
	mov ds,ax
	opengraphic
	play_screen
	closegraphic
	mov ah,4ch
	int 21h
main endp
include outdec.asm
end main
	







	