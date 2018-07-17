.model small
.stack 100h
.386
include j_macro.asm
;----------------------------------------
title_screen macro
	local title
	save_register <cx>
	xor cx,cx
	mov cx,10h
	pixel 0,0,320,200,15,15
	square 1,1,318,198,88,88
	square 3,3,316,196,92,92
	square 5,5,314,194,88,88
	showpicture 50,25,100,38,snowname
	showpicture 170,25,100,39,craftname
	showpicture 120,70,100,77,view
title:
	showpicture 45,50,20,26,lavef
	showpicture 268,45,20,26,lavef
	delay 1000
	showpicture 45,50,20,27,lavef1
	showpicture 268,45,20,27,lavef1
	delay 1000
	dec cx
	cmp cx,0
	jnz title
	load_register <cx>
endm
;----------------------------------------
jew macro
	pixel 0,0,320,200,0,0
	showpicture 90,60,40,66,j
	delay 10000
	showpicture 140,65,44,60,e
	delay 10000
	showpicture 190,60,72,63,w
	delay 10000
	showpicture 40,150,232,25,computer
	delay 30000
endm
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

	showpicture 70,30,40,32,greenwin
	showpicture 250,45,40,32,greenwin3
	showpicture 70,30,40,32,greenwin2
	delay 500
	showpicture 200,120,40,32,greenwin
	showpicture 250,45,40,32,greenwin2
	showpicture 70,30,40,32,greenwin3
	delay 500
	showpicture 250,45,40,32,greenwin
	showpicture 200,120,40,32,greenwin2
	showpicture 30,50,40,32,greenwin3
	delay 500
	showpicture 30,50,40,32,greenwin
	showpicture 30,50,40,32,greenwin2
	showpicture 200,120,40,32,greenwin3
	delay 500
	
	dec cx			
	cmp cx,0		
	jnz title		
	load_register <cx>	
endm
;----------------------------------------
.data 
include def_var.asm
include picture.asm
.code
main proc
	
	mov ax,@data
	mov ds,ax
	opengraphic

	title_screen	
	jew
	season_screen

	closegraphic
	mov ah,4ch
	int 21h
main endp
include outdec.asm
end main
	







	