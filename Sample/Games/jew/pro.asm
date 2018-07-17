.model small
.stack 100h
.386
include macro.asm
GETNAME MACRO
	LOCAL GETS_LOOP,GETS_NORM,GETS_RETURN
	SAVE_REGISTER <DI,AX,BX,DX>
	GOTOXY 25,9
	XOR BL,BL		;FOR COUNT INPUT
	LEA DI,NAMEPLAY[2]
	CLD
     GETS_LOOP:
	INC BL
	CMP BL,10
	JE  GETS_RETURN
	MOV AH,01H              ;READ CHAR
	INT 21H
	CMP AL,0DH              ;IS AL = ENTER
	JZ  GETS_RETURN         ;YES RETURN
	CMP AL,08H              ;IS AL = BACKSPACE
	JNZ GETS_NORM           ;NO GOTO NORMAL GETS

	MOV BYTE PTR[DI],' '
	DEC DI
	MOV AH,02H
	MOV DL,' '
	INT 21H
	MOV DL,08H
	INT 21H
	DEC BL
	JMP GETS_LOOP
     GETS_NORM:
	STOSB
	JMP GETS_LOOP
     GETS_RETURN:
	MOV BYTE PTR [DI],'$'
	LOAD_REGISTER <DX,BX,AX,DI>
ENDM
INPUTNAME MACRO
     SAVE_REGISTER <DI>
     PIXEL 50,60,275,90,016
     SQUARE 50,60,275,90,4,4
     SHOWMESSAGE 7,9,MES0
     GETNAME
     PIXEL 50,60,276,91,016
     LOAD_REGISTER <DI>
ENDM
STORAGESCORE MACRO
	LOCAL READING,READING_,NOT_FULL,NOT_FULL1,READING1,WRITING_FIRST_TIME
	LOCAL MAIN_WRITE_FILE,MAIN_WRITE_FILE1,CLOSE_FILE_ALL,OPEN_ERROR,EXIT,REPLACE
	mov ax,score
	mov word ptr nameplay,ax
	;closegraphic
	LEA DX,FILENAME1
	MOV AL,02H
	OPEN_OLD_FILE
	JNC READING			;IF CAN OPEN
	OPEN_NEW_FILE
	JNC WRITING_FIRST_TIME
	JC OPEN_ERROR
READING:
	MOV HANDLE1,AX     ;STORE HANDLE NAME
  ;MOVE FILE POINTER TO THE FIRST OF THE FILE
	MOV AH,42H
	MOV AL,0H
	XOR CX,CX
	XOR DX,DX
	MOV BX,HANDLE1
	INT 21H
   ;READING FLE
	MOV BX,HANDLE1
	MOV CX,121D
	LEA DX,COUNT
	READ_FILE

	CMP COUNT,10D   ;COUNT = 10
	JNE NOT_FULL    ;NO: NOT FULL

	LEA SI,HSCORE    ;YES: FULL
	MOV CX,09H
READING_:
	ADD SI,12D
	LOOP  READING_

	MOV AX,WORD PTR [SI]

	CMP AX,WORD PTR NAMEPLAY
	JL REPLACE

	JMP MAIN_WRITE_FILE
NOT_FULL:
	LEA SI,HSCORE
	XOR CH,CH
	MOV CL,COUNT
	DEC CL
NOT_FULL1:
	ADD SI,12D
	LOOP NOT_FULL1
	JMP REPLACE

READING1:
	LEA SI,HSCORE
	XOR BH,BH
	MOV BL,COUNT
	SELECTSTRING

	JMP MAIN_WRITE_FILE

WRITING_FIRST_TIME:
	MOV HANDLE1,AX
	MOV COUNT,1D
   ;MOVE NAME AND SCORE TO SCORE
	LEA SI,NAMEPLAY
	LEA DI,HSCORE
	MOV BX,12D
	MOVSTRING

MAIN_WRITE_FILE:
  ;MOVE FILE POINTER TO BEGINING OF THE FILE
	MOV AH,42H
	MOV AL,0H
	XOR CX,CX
	XOR DX,DX
	MOV BX,HANDLE1
	INT 21H

	CMP COUNT,10D
	JE MAIN_WRITE_FILE1
	INC COUNT
MAIN_WRITE_FILE1:
   ;WRITE TO SCORE.dat
	MOV BX,HANDLE1
	MOV CX,121D
	LEA DX,COUNT
	WRITE_FILE
CLOSE_FILE_ALL:
   ;CLOSE FILE SCORE.dat
	MOV BX,HANDLE1
	CLOSE_FILE
	XOR BH,BH
	MOV BL,COUNT
	SHOWSCORENAME
	JMP EXIT
REPLACE:
	MOV DI,SI
	LEA SI,NAMEPLAY
	MOV BX,12D
	MOVSTRING
	JMP READING1
OPEN_ERROR:
	Printf "Open file error....."
EXIT:
ENDM

OPEN_NEW_FILE MACRO
	MOV AH,3CH
	MOV CL,20H      ;ATTRIB OF A FILE
	INT 21H
ENDM
OPEN_OLD_FILE MACRO
	MOV AH,3DH
	INT 21H
ENDM
READ_FILE MACRO
        mov ah,3fh
        int 21h       
ENDM
WRITE_FILE MACRO
	MOV AH,40H
        INT 21H
ENDM
CLOSE_FILE MACRO
        MOV AH,3EH
        INT 21H      
ENDM
SELECTSTRING MACRO
        LOCAL SORT_LOOP,FILE_LITLE,NEXT,END_SORT
        SAVE_REGISTER <BX,CX,DX,SI>
        DEC BX
        JE END_SORT
        MOV DX,SI
    SORT_LOOP:
        MOV SI,DX
        MOV CX,BX
        MOV DI,SI
        MOV AX,WORD PTR[DI]
    FIND_LITLE:
        ADD SI,12D
        CMP WORD PTR[SI],AX
        JNL NEXT
        MOV DI,SI
        MOV AX,WORD PTR[DI]
    NEXT:
        LOOP FIND_LITLE
	SWAP
        DEC BX
        JNE SORT_LOOP
    END_SORT:        
    LOAD_REGISTER <SI,DX,CX,BX>	
ENDM
SWAP MACRO     
        LOCAL SWAP_LOOP
        SAVE_REGISTER <AX,SI,DI,BX,CX>
        MOV CX,12D
    SWAP_LOOP:
        MOV AL,[SI]
        XCHG AL,[DI]
	MOV [SI],AL
        INC SI
        INC DI
        LOOP SWAP_LOOP
	LOAD_REGISTER <CX,BX,DI,SI,AX>    
ENDM
MOVSTRING MACRO
        CLD
        MOV CX,BX
        REP MOVSB       
ENDM
SHOWSCORENAME MACRO	
        LOCAL L1,L2,L3,L4
	SAVE_REGISTER <ax,bx,cx,dx>
        ;PIXEL 50,25,275,165,016
        SQUARE 50,25,270,165,94,120    
	GOTOXY 11,5	
	PRINTF "    HIGH SCORE     "        
	gotoxy 9,18
	printf "Press F2 to continue..."
        LEA SI,HSCORE
        MOV TEMP,1D
        MOV CX,10D
	MOV Y,7
     l2:
        GOTOXY 10,Y
	MOV AX,TEMP
        CALL OUTDEC
        INC TEMP

	gotoxy 13,y

        MOV AX,WORD PTR[SI]
        CALL OUTDEC

        gotoxy 20,y

        ADD SI,2D
        MOV AH,09H
	MOV DX,SI
        INT 21H

;MAKE NEW LINE
        INC Y
        ADD SI,10D
        DEC CX
        CMP CX,0
        JE l3
        JMP l2
      l3:
        KEYPLAY
	CMP KEY,60
	JE l4
	DELAY 300
	;SHOWGAME 90,37,114,47,016,SNICH1
	;SHOWGAME 207,37,231,47,016,SNICH1
	DELAY 300
	;SHOWGAME 90,37,114,47,016,SNICH2
	;SHOWGAME 207,37,231,47,016,SNICH2
	JMP l3
      l4:
      load_register <dx,cx,bx,ax>
ENDM
showmessage macro x,y,string
   save_register <ax,dx>
   mov ah,02h
   mov dl,x
   mov dh,y
   int 10h
   lea dx,string
   mov ah,09h
   int 21h
   load_register <dx,ax>
endm
gotoxy macro x,y
   save_register <ax,dx>
   mov ah,02h
   mov dl,x
   mov dh,y
   int 10h
   load_register <dx,ax>
endm
Printf macro string
	local start,msg
   save_register <ax,dx,ds>
	jmp start
   msg db string,'$'
   start:
	mov ax,cs
	mov ds,ax
	mov ah,09h
	lea dx,msg
        int 21h
   load_register <ds,dx,ax>
endm

;----------------------------------------
;----------------------------------------
load_redsnow macro	;start position
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
load_greensnow macro
	mov ax,g_snowx
	mov startx,ax
	add ax,40
	mov stopx,ax
	mov ax,g_snowy
	mov starty,ax
	add ax,32
	mov stopy,ax
endm
;----------------------------------------
load_heart macro
	local h1
	save_register <ax,bx,cx,dx>
	pixel 155,181,199,194,0
	cmp life,1
	jb h1
	showpicture 155,181,14,13,heart
	cmp life,2
	jb h1
	showpicture 170,181,14,13,heart
	cmp life,3
	jb h1
	showpicture 185,181,14,13,heart
h1:	
	load_register <dx,cx,bx,ax>
endm
;----------------------------------------
set_variable macro
	mov life,3
	mov score,0
	mov check1,0
	mov check2,0
	mov countk,0
	mov countloop,0
	mov count_gw,0
	mov time,100
	mov srx1,0
	mov sry1,0
	mov srs1,0
	mov srx2,0
	mov sry2,0
	mov srs2,0
	mov sgx,0
	mov sgy,0
	mov sgs,0
	mov r_snowx,250	          ;display snow_red position
	mov r_snowy,85
	mov g_snowx,20
	mov g_snowy,70	
endm
;----------------------------------------
load_score macro
        save_register <ax>
	gotoxy 8,23
	mov ax,score
	call outdec
	load_register <ax>
endm
;----------------------------------------
load_screen macro
	save_register <ax,bx,cx,dx>
	pixel 0,0,320,200,15,15
	pixel 5,180,315,195,0,0
	square 1,1,318,198,88,88  ; border out
	square 3,3,316,196,92,92
	square 5,5,314,194,88,88
	square 5,5,314,179,88,88  ; border in
	showmessage 1,23,mesg12
	showmessage 13,23,mesg11
	showmessage 30,23,mesg10
	showpicture 70,80,40,25,snow3
	showpicture 190,90,40,25,snow4		
	load_heart
	load_score
	load_redsnow
	pixel startx,starty,stopx,stopy,15
	showgame startx,starty,stopx,stopy,05,red1 
	load_greensnow
	pixel startx,starty,stopx,stopy,15
	showgame startx,starty,stopx,stopy,0,green1
	load_register <dx,cx,bx,ax>
endm
;----------------------------------------
over_screen macro
	local h1,h2
	save_register <ax,bx,cx,dx,si>
	showpicture 60,60,192,25,game_over
	delay 1000
h1:
	keyplay
	cmp key,1
	je h2
	delay 1000
	jmp h1
h2:
	load_register <si,dx,cx,bx,ax>
endm
;----------------------------------------
pause_screen macro
	local h1,h2
	save_register <ax,bx,cx,dx,si>
	showpicture 80,60,152,35,pause
	delay 1000
h1:
	keyplay
	cmp key,68
	je h2
	delay 100
	jmp h1
h2:
	load_register <si,dx,cx,bx,ax>
endm
;----------------------------------------
help_screen macro
	local h1,h2
	save_register <ax,bx,cx,dx,si>    
	pixel 50,10,275,175,0,0
	square 50,10,276,176,78,78	; border
	square 51,28,276,176,78,78
	square 51,11,275,175,78,78
	
	showmessage 17,2,mesg1		; message
	showmessage 10,4,mesg2
	showmessage 10,6,mesg3
	showmessage 10,8,mesg31
	showmessage 10,10,mesg32
	showmessage 10,12,mesg4
	showmessage 10,14,mesg5
	showmessage 10,16,mesg6
	showmessage 10,18,mesg7
	showmessage 10,20,mesg8
	;showmessage 10,23,mesg9
h1:
	keyplay
	cmp key,59
	je h2
	delay 100
	jmp h1
h2:
	load_register <si,dx,cx,bx,ax>
endm
;----------------------------------------
showredshoot macro
	showgame startx,starty,stopx,stopy,016,red1
	delay 500
	showgame startx,starty,stopx,stopy,016,red3
	delay 500
	showgame startx,starty,stopx,stopy,016,red4
	delay 500
endm
;----------------------------------------
showgreenshoot macro
	showgame startx,starty,stopx,stopy,016,green1
	delay 500
	showgame startx,starty,stopx,stopy,016,green2
	delay 500
	showgame startx,starty,stopx,stopy,016,green3
	delay 500
	showgame startx,starty,stopx,stopy,016,green4
	delay 500
	showgame startx,starty,stopx,stopy,016,green2
	delay 500
endm
;----------------------------------------
movegreensnow macro
        local l1,l2,l3,exitp
	save_register <ax>
	inc count_gw
	cmp count_gw,2
	jb  exitp
	mov ax,g_snowy
	cmp ax,r_snowy
	ja  l1
	cmp ax,r_snowy
	jb  l2
	jmp l3
    l1:
        dec g_snowy
	jmp l3
    l2: 
        inc g_snowy
    l3:
	mov count_gw,0
    exitp:	
	load_register <ax>
endm
;----------------------------------------
loadxyballred macro	
	mov ax,r_snowx
	mov bx,r_snowy		
endm
;----------------------------------------
newballred macro
         local l1,exitball
         save_register <ax,bx,cx,dx>
	 cmp srs1,0
	 jne l1
	 mov srx1,ax
         mov sry1,bx	 
	 mov srs1,1
	 jmp exitball
      l1:
         cmp srs2,0
	 jne exitball
	 mov srx2,ax
         mov sry2,bx	 
	 mov srs2,1
      exitball:         
	 load_register <dx,cx,bx,ax>
endm
;----------------------------------------
showballred macro
        local l1,l2,l3,l4,l5,l6,l7,l8,l9
        save_register <ax,bx,cx,dx> 
	cmp srs1,0
	jz  l1
	showballred1
    l1: 
	cmp srs2,0
	jz  l2
	showballred2
    l2: 
        load_register <dx,cx,bx,ax>
endm
;---------------------------------------------
showballred1 macro
        local move
	save_register <ax,bx,cx,dx>
	mov ax,srx1
	mov ganx,ax	
	add ax,10
	mov maxc,ax
	mov ax,sry1
	mov gany,ax	
	add ax,10
	mov maxr,ax
	pixel ganx,gany,maxc,maxr,015
        sub srx1,5 
    move:
	mov ax,srx1
	mov ganx,ax	
	add ax,10
	mov maxc,ax
	mov ax,sry1
	mov gany,ax	
	add ax,10
	mov maxr,ax
	showpic ganx,gany,maxc,maxr,0,snowball
        load_register <dx,cx,bx,ax>
endm
;----------------------------------------------
showballred2 macro
        local move
	save_register <ax,bx,cx,dx>
	mov ax,srx2
	mov ganx,ax	
	add ax,10
	mov maxc,ax
	mov ax,sry2
	mov gany,ax	
	add ax,10
	mov maxr,ax
	pixel ganx,gany,maxc,maxr,015
        sub srx2,5 
    move:
	mov ax,srx2
	mov ganx,ax	
	add ax,10
	mov maxc,ax
	mov ax,sry2
	mov gany,ax	
	add ax,10
	mov maxr,ax
	showpic ganx,gany,maxc,maxr,0,snowball
        load_register <dx,cx,bx,ax>
endm
;---------------------------------------------
checkredball macro
        local l1,l2
        save_register <ax,cx,dx>
        cmp srs1,0
	je  l1
	checkredball1
     l1:
        cmp srs2,0
	je  l2
	checkredball2
     l2:
	load_register <dx,cx,ax>
endm
;---------------------------------------------
checkredball1 macro
        local l1,l2
        save_register <ax,cx,dx>
	mov cx,srx1
	add cx,1     
	mov dx,sry1
	add dx,4
	cmp cx,15
	jnl  l1
	mov srs1,3
	mov check1,2
	jmp l2
     l1:
	mov ah,0dh
	int 10h
	cmp al,027
	je  l2
	mov srs1,2
	mov check1,1
	jmp l2
     l2:
	load_register <dx,cx,ax>
endm
;---------------------------------------------
checkredball2 macro
        local l1,l2
        save_register <ax,cx,dx>
	mov cx,srx2
	add cx,1     
	mov dx,sry2
	add dx,4
	cmp cx,15
	jnl  l1
	mov srs2,3
	mov check1,2
	jmp l2
     l1:
	mov ah,0dh
	int 10h
	cmp al,027
	je  l2
	mov srs2,2
	mov check1,1
	jmp l2
     l2:
	load_register <dx,cx,ax>
endm
;---------------------------------------------
clearballred macro
        local l1,l2
        save_register <ax,cx,dx>
	cmp srs1,0
	je l1
	cmp srs1,1
	je l1
	clearballred1
     l1:	
        cmp srs2,0
	je l2
	cmp srs2,1
	je l2
	clearballred2
     l2:
	load_register <dx,cx,ax>
endm
;---------------------------------------------
clearballred1 macro
        save_register <ax,cx,dx>
	mov ax,srx1
	mov ganx,ax
	add ax,10
	mov maxc,ax
	mov ax,sry1
	mov gany,ax
	add ax,10
	mov maxr,ax	
	mov srx1,0
	mov sry1,0
	mov srs1,0
	pixel ganx,gany,maxc,maxr,15
	load_register <dx,cx,ax>
endm
;---------------------------------------------
clearballred2 macro
        save_register <ax,cx,dx>
	mov ax,srx2
	mov ganx,ax
	add ax,10
	mov maxc,ax
	mov ax,sry2
	mov gany,ax
	add ax,10
	mov maxr,ax	
	mov srx2,0
	mov sry2,0
	mov srs2,0
	pixel ganx,gany,maxc,maxr,15
	load_register <dx,cx,ax>
endm
;----------------------------------------------
loadxyballgreen macro	
	mov ax,g_snowx
	add ax,41
	mov bx,g_snowy		
endm
;----------------------------------------
newballgreen macro
         local exitball
         save_register <ax,bx,cx,dx>
	 cmp sgs,0
	 jne exitball
	 mov sgx,ax
         mov sgy,bx	 
	 mov sgs,1	 
    exitball:  
	 load_register <dx,cx,bx,ax>
endm
;----------------------------------------
showballgreen macro
        local l1
        save_register <ax,bx,cx,dx> 
	cmp sgs,0
	jz  l1
	showballgreen1
    l1: 
        load_register <dx,cx,bx,ax>
endm
;---------------------------------------------
showballgreen1 macro
        local move
	save_register <ax,bx,cx,dx>
	mov ax,sgx
	mov ganx,ax	
	add ax,10
	mov maxc,ax
	mov ax,sgy
	mov gany,ax	
	add ax,10
	mov maxr,ax
	pixel ganx,gany,maxc,maxr,015
        add sgx,5 
    move:
	mov ax,sgx
	mov ganx,ax	
	add ax,10
	mov maxc,ax
	mov ax,sgy
	mov gany,ax	
	add ax,10
	mov maxr,ax
	showpic ganx,gany,maxc,maxr,0,snowball
        load_register <dx,cx,bx,ax>
endm
;--------------------------------------------
checkgreenball macro
        local l1
        save_register <ax,cx,dx>
        cmp sgs,0
	je  l1
	checkgreenball1
     l1:        
	load_register <dx,cx,ax>
endm
;---------------------------------------------
checkgreenball1 macro
        local l1,l2
        save_register <ax,cx,dx>
	mov cx,sgx
	add cx,8     
	mov dx,sgy
	add dx,4
	cmp cx,290
	jng l1
	mov sgs,3
	mov check2,2
	jmp l2
     l1:
	mov ah,0dh
	int 10h
	cmp al,027
	je  l2
	mov sgs,2
	mov check2,1
	jmp l2
     l2:
	load_register <dx,cx,ax>
endm
;--------------------------------------------------
greenshoot macro
        local exitp
	save_register <>
	cmp sgs,0
	jne exitp
        load_greensnow
	showgreenshoot
	loadxyballgreen
	newballgreen
      exitp:
	load_register <>
endm
;--------------------------------------------------
clearballgreen macro
        local l1
        save_register <ax,cx,dx>
	cmp sgs,0
	je l1
	cmp sgs,1
	je l1
	clearballgreen1
     l1:	       
	load_register <dx,cx,ax>
endm
clearballgreen1 macro
        save_register <ax,cx,dx>
	mov ax,sgx
	mov ganx,ax
	add ax,10
	mov maxc,ax
	mov ax,sgy
	mov gany,ax
	add ax,10
	mov maxr,ax	
	mov sgx,0
	mov sgy,0
	mov sgs,0
	pixel ganx,gany,maxc,maxr,15
	load_register <dx,cx,ax>
endm
;------------------------------------------------
play_screen macro
	local p1,left,right,up,down,help,pause,newgame,exitplay
	local l1,hit1,floor1,hit2,floor2
	set_variable
	pixel 0,0,319,199,00
	INPUTNAME
	load_screen
	load_greensnow
	;pixel 0,0,319,199,00
	;INPUTNAME
p1:
	showpicture 70,80,40,25,snow3	
	showpicture 190,90,40,25,snow4		        
        showballred 	
	showballgreen	
	load_greensnow
	showgame startx,starty,stopx,stopy,016,green1
	movegreensnow	
	load_redsnow
	showgame startx,starty,stopx,stopy,016,red1
	load_score	
	checkredball	 
	cmp check1,1
	je  hit1
	cmp check1,2
	je  floor1
	checkgreenball
	cmp check2,1
	je  hit2
	cmp check2,2
	je  floor2
	greenshoot
	keyplay	
	cmp key,57	; space bar
	je shootr
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
	cmp r_snowx,230
	je p1
	sub r_snowx,1
	jmp p1
right:
	cmp r_snowx,274
	je p1
	add r_snowx,1
	jmp p1
up:
	cmp r_snowy,6
	je p1
	sub r_snowy,1
	jmp p1
down:
	cmp r_snowy,147
	je p1
	add r_snowy,1
	jmp p1
hit1:
        add score,5
        clearballred
	load_greensnow
	showgame startx,starty,stopx,stopy,016,green5
	delay 1000
	showgame startx,starty,stopx,stopy,016,greended
	delay 2000
	mov check1,0
	jmp p1
floor1:
        clearballred
	mov check1,0
        jmp p1
hit2:
	sub life,1
	load_heart
	clearballgreen
	load_redsnow
	showgame startx,starty,stopx,stopy,016,red5
	delay 1000
	showgame startx,starty,stopx,stopy,016,redded
	delay 1000
	cmp life,0
	je gameover
	mov check2,0
	jmp p1
floor2:
        clearballgreen
	mov check2,0
	jmp p1
pause:
	pause_screen
	load_screen
	jmp p1
help:
	help_screen
	load_screen
	jmp p1
shootr:	
        load_redsnow
	showredshoot
	loadxyballred
	newballred	
	jmp p1
newgame:
	showpicture 80,60,160,24,new
	delay 10000
	set_variable
	load_screen
	load_greensnow
	jmp p1
gameover:
	over_screen
	pixel 0,0,319,199,00
	STORAGESCORE
	set_variable
	load_screen
	load_greensnow
	jmp p1
exitplay:

endm
;----------------------------------------
.data 
include variable.asm
include picgame.asm
.code
main proc
	
	mov ax,@data
	mov ds,ax
        MOV ES,AX

	opengraphic		
	play_screen	
	closegraphic
	mov ah,4ch
	int 21h
main endp
include outdec.asm
end main	
