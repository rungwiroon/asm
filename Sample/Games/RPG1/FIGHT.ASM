;TITLE :EXAMPLE FOR LOAD BMP WITH PROC LOADBMP
.MODEL SMALL
.386
INCLUDE macro.ASM
.STACK 100H
.DATA
INCLUDE VARIABLE.ASM 


.CODE

MAIN PROC
MOV AX,@DATA
	MOV DS,AX

;SAVE DISPLAY MODE IF NECESSORY
	MOV AH,0FH
	INT 10H
	PUSH AX
;CHANGE DISPLAY MODE  TO 13H(320*200:256 COLORS)
	MOV AH,00H
	MOV AL,13H
	INT 10H
	call SELECT_MONSTER	
	lea si,HERO
	mov BMP_X,50
	mov BMP_Y,150
	call LOADBMP	
	lea si,ENEMY
	mov BMP_X,230
	call LOADBMP	

seang:
	delay 1000
	delay 1000
	cmp  DIE_FLG,0
	jne endoff
	xor ax,ax
	random 0,10
	call outdec
	cmp al,4	
	JL attacked 
	
	 call SHOW_F_MENU
	jmp seang
attacked:
	call MONSTER_ATTACK
	jmp seang
endoff:
;LOAD OLD DISPLAY MODE
	POP AX
	MOV AH,00H
	INT 10H
;DOS EXIT
	MOV AH,4CH
	INT 21H

MAIN ENDP

MONSTER_ATTACK PROC
	lea si,BLANK_F_NAME
	mov BMP_X,230
	mov BMP_Y,150
	call LOADBMP	
	mov cx,3
	dec HERO_HP
mrun:
	lea si,ENEMY
	sub BMP_X,50
	call LOADBMP
	delay 1000
	lea si,BLANK_F_NAME
	call LOADBMP
	loop mrun
	
	mov cx,3
	
mfun:
	lea si,ENEMY
	mov BMP_X,80
	call LOADBMP
	delay 500
	mov BMP_X,50
	lea si,HIT
	call LOADBMP
	delay 500
	lea si,HERO
	call LOADBMP
	loop mfun	
	
	mov BMP_X,80
	lea si,BLANK_F_NAME
	call LOADBMP
	mov cx,3
mrunback:

	lea si,ENEMY
	add BMP_X,50
	call LOADBMP
	delay 1000
	lea si,BLANK_F_NAME
	call LOADBMP
	loop mrunback
	mov BMP_X,230
	mov BMP_Y,150
	lea si,ENEMY
	call LOADBMP
	cmp HERO_HP,0
	jne mattend
	mov BMP_X,50
	lea si,DIE
	call LOADBMP	
	delay 1000
	delay 1000
	delay 1000
	delay 1000
	delay 1000
	delay 1000
	mov DIE_FLG,2
	lea si,BLANK_F_NAME
	call LOADBMP
mattend:
	RET

MONSTER_ATTACK ENDP


ATTACK PROC
	call CLR_ME
	lea si,BLANK_F_NAME
	mov BMP_X,50
	mov BMP_Y,150
	call LOADBMP	
	mov cx,3
	dec MONSTER_HP
	
run:
	lea si,HERO
	add BMP_X,50
	call LOADBMP
	delay 1000
	lea si,BLANK_F_NAME
	call LOADBMP
	loop run
	
	mov cx,3
	
fun:
	lea si,HERO
	mov BMP_X,200
	call LOADBMP
	delay 500
	mov BMP_X,230
	lea si,HIT
	call LOADBMP
	delay 500
	lea si,ENEMY
	call LOADBMP
	loop fun	
	
	mov BMP_X,200
	lea si,BLANK_F_NAME
	call LOADBMP
	mov cx,3
runback:

	lea si,HERO
	sub BMP_X,50
	call LOADBMP
	delay 1000
	lea si,BLANK_F_NAME
	call LOADBMP
	loop runback
	mov BMP_X,50
	mov BMP_Y,150
	lea si,HERO
	call LOADBMP
	cmp MONSTER_HP,0
	jne attend
	mov BMP_X,230
	lea si,DIE
	call LOADBMP	
	delay 1000
	delay 1000
	delay 1000
	delay 1000
	delay 1000
	delay 1000
	mov DIE_FLG,1
	lea si,BLANK_F_NAME
	call LOADBMP
attend:
	RET
ATTACK ENDP

DEF PROC
	call CLR_ME
	mov cx,6
	mov BMP_X,50
	mov BMP_Y,150
defn:
	lea si,HERO_DEF
	mov BMP_X,50
	call LOADBMP
	delay 1000
	lea si,HERO
	call LOADBMP
	loop defn	
	RET
DEF ENDP

RUN_AWAY PROC
	call CLR_ME
	mov BMP_X,50
	mov BMP_Y,150
away1:
	CMP FLG,0	;check for actual walk,left and right lag
	JNE away2
	MOV FLG,1	;set alternate lag
	lea si,LEFT_F_NAME1
	JMP away3
away2:	
	LEA SI,LEFT_F_NAME2
	MOV FLG,0
away3:
	call CLRPIC	
	sub BMP_X,5	;move left 5 pixel
	call LOADBMP	;and show character
	delay 100
	cmp BMP_X,0
	jne away1
	RET
RUN_AWAY ENDP

SHOW_F_MENU PROC
	
	lea si,F_MENU1
	mov F_CHOICE,1
x2:
	mov BMP_X,10
	mov BMP_Y,10
	call LOADBMP
	mov ah,0h	
	int 16h		;waiting for key board
	cmp ah,72	; up
	je movup
	cmp ah,80	; down
	je movdown	
	cmp ah,57	;space bar
	je select		
	cmp ah,01	; ESC
	je exit_m	
	jmp x2
movup:
	cmp F_CHOICE,1
	je x2
	sub F_CHOICE,1
	cmp F_CHOICE,2
	je mu
	lea si,F_MENU1
	call LOADBMP
	jmp x2
mu:
	lea si,F_MENU2
	call LOADBMP
	jmp x2
movdown:
	cmp F_CHOICE,3
	je x2
	add F_CHOICE,1
	cmp F_CHOICE,2
	je md
	lea si,F_MENU3
	call LOADBMP
	jmp x2
md:
	lea si,F_MENU2
	call LOADBMP
	jmp x2	
select:
	cmp F_CHOICE,1
	je strike
	cmp F_CHOICE,2
	je defend
	cmp F_CHOICE,3
	je flee
strike:
	call ATTACK
	cmp DIE_FLG,0
	jne exit_m
	lea si,F_MENU1
	jmp exit_m
defend:
	call DEF
	lea si,F_MENU2
	jmp exit_m
flee:
	call RUN_AWAY
	mov DIE_FLG,1
exit_m:	
	RET
SHOW_F_MENU ENDP

CLR_ME PROC
	mov BMP_X,10
	mov BMP_Y,10
	lea si,CLR_MENU
	call LOADBMP
	RET
CLR_ME ENDP

SELECT_MONSTER PROC
	random 0,17
	xor bx,bx
	xor cx,cx
	mov cl,al
seek:
	add bx,11
	loop seek
	xor si,si
	xor cx,cx
inname:
	mov ah,MONSTER[bx]
	mov ENEMY[si],ah		
	inc si
	inc bx
	inc cx
	cmp cx,11
	jne inname
	RET
SELECT_MONSTER ENDP

INCLUDE LOADBMP.ASM
INCLUDE OUTDEC.ASM

END