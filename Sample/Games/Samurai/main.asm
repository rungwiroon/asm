.model small
.stack 100h

vBUFFERSEG	SEGMENT	
	VBUFFER DB	64000	DUP (0)
vBUFFERSEG	ENDS

bgbufferseg	segment
	bgbuffer db	64000	dup (0)
bgbufferseg	ends

objbufferseg	segment
	objbuffer db	64000	dup (0)
objbufferseg	ends

include macro.asm
.data
filehandle	dw	?
bmp_y		dw	1
bmp_x		dw	1
gpw1		dw	?		;wide of picture
gpw2		dw	?		;high	 of picture
byte_buffer	db	?

;filebg	db 'main.pic',0
	CHOICE	DB	?
	MENU1	DB	'.\PIC\main.PIC',0
	MENU2	DB	'.\PIC\main2.PIC',0
	MENU3	DB	'.\PIC\main3.PIC',0
	MENU4	DB	'.\PIC\main4.PIC',0
	control	db	'control.pic',0
	play	db	'unit1.pic',0
	unit2	db	'unit2.pic',0
	unit3	db	'unit3.pic',0
	unit4	db	'unit4.pic',0
        gamewin     db      'END.pic',0
	samurai	db	'samurai.pic',0
	sattack	db	'sattack.pic',0
	devil1	db	'devil1.pic',0
	d1attack db	'd1attack.pic',0
	over	 db	'over.pic',0
	credit	db	'credit.pic',0
	x_pos	dw	10
	y_pos	dw	120
	x_devil	dw	?
	devilstatus	db 0
	herodie		db 0
	numdevil	db 0
	state		db 1
.code
main proc
mov ax,@data
mov ds,ax
mov es,ax

	mov	ah,0			;open graphic
	mov	al,13h			;mode picter
	int	10h
	
startmenu_:	
        mov     herodie,0
	MOV	CHOICE,1
	CALL	LOADMENU
	cmp	choice,1
	je	loadplay_
	cmp	choice,2
	je	loadcontrol_
	cmp	choice,3
	je	loadcredit_
	jmp	exit	
loadcontrol_:
	lea	si,control
	call	clrobjbuffer
	call	loadbgbuffer	
	call	swapvideoram
	call	syncvideo
	mov	ah,8
	int	21h
	jmp	startmenu_
loadcredit_:
	lea	si,credit
	call	clrobjbuffer
	call	loadbgbuffer	
	call	swapvideoram
	call	syncvideo
	mov	ah,8
	int	21h
	jmp	startmenu_
loadplay_:
	mov	x_pos,10
	mov	y_pos,120
	mov	x_devil,270
	lea	si,play
	call	clrobjbuffer
	call	loadbgbuffer	
	
	lea	si,samurai
	mov	ax,x_pos		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer

	mov	numdevil,0

waitkey:	
	mov	ah,1
	int	16h
	jnz	keypress
	call	chkdevil
	cmp	numdevil,3
	jge	waitkey
	call	getdevil
	call	chkdie
	jmp	waitkey
keypress:
	mov	ah,0
	int	16h
	cmp	ah,4dh
	jne	notright
	cmp	x_pos,270
	jge	chkright
	add	x_pos,5
	lea	si,samurai
	mov	ax,x_pos		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
	cmp	devilstatus,0
	je	hasdevil1
	lea	si,devil1
	mov	ax,x_devil		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
hasdevil1:
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	jmp	waitkey
chkright:
	cmp	numdevil,3
	jne	notright
	call	nextstate
	jmp	waitkey
notright:
	cmp	ah,4bh
	jne	notleft
	cmp	x_pos,5
	jle	notleft
	sub	x_pos,5
	lea	si,samurai
	mov	ax,x_pos		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
	cmp	devilstatus,0
	je	hasdevil2
	lea	si,devil1
	mov	ax,x_devil		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
hasdevil2:
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	jmp	waitkey
notleft:
	cmp	ah,39h
	je	isatt
	jmp	notatt
isatt:
	call	chkhit
	lea	si,sattack
	mov	ax,x_pos		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
	cmp	devilstatus,0
	je	hasdevil3
	lea	si,devil1
	mov	ax,x_devil		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
hasdevil3:
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	delay	300
	lea	si,samurai
	mov	ax,x_pos		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
	cmp	devilstatus,0
	je	hasdevil4
	lea	si,devil1
	mov	ax,x_devil		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
hasdevil4:
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	jmp	waitkey
notatt:	
	cmp	ah,01h
	je	notesc
	jmp	waitkey
notesc:
exit:
	mov ah,0			;close graphic
	mov al,3h			;close mode
	int  10h

mov ah,4ch
int 21h
main endp

LOADMENU PROC
	PUSHX	<AX,BX,CX,DX,SI>
	LEA	SI,MENU1
	mov	ax,0
	mov	bx,0
	drawbmp	ax,bx,320,200,si
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
LOOPMENU_:
	MOV	AH,8
	INT	21H
	CMP	AL,72
	JE	CHOICE_DEC_
	CMP	AL,80
	JE	CHOICE_INC_
	CMP	AL,13
	jne	gotomenu_
	Jmp	EXITLOOPMENU_
gotomenu_:	
	JMP	LOOPMENU_
CHOICE_DEC_:
	CMP	CHOICE,1
	JE	SHOWMENU_
	SUB	CHOICE,1
	JMP	SHOWMENU_
CHOICE_INC_:
	CMP	CHOICE,4
	JE	SHOWMENU_
	ADD	CHOICE,1
SHOWMENU_:
        mov     herodie,0
	CMP	CHOICE,1
	JNE	NEXTMENU1_
	LEA	SI,MENU1
	mov	ax,0
	mov	bx,0
	drawbmp	ax,bx,320,200,si
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	JMP	SHOWPIC_
NEXTMENU1_:
	CMP	CHOICE,2
	JNE	NEXTMENU2_
	LEA	SI,MENU2
	mov	ax,0
	mov	bx,0
	drawbmp	ax,bx,320,200,si
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	JMP	SHOWPIC_
NEXTMENU2_:
	CMP	CHOICE,3
	JNE	NEXTMENU3_
	LEA	SI,MENU3
	mov	ax,0
	mov	bx,0
	drawbmp	ax,bx,320,200,si
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	JMP	SHOWPIC_
NEXTMENU3_:
	LEA	SI,MENU4
	mov	ax,0
	mov	bx,0
	drawbmp	ax,bx,320,200,si
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
SHOWPIC_:
	JMP	LOOPMENU_
EXITLOOPMENU_:

	POPX	<SI,DX,CX,BX,AX>
	RET
LOADMENU ENDP

chkdevil	proc
	cmp	devilstatus,1
	je	hasdevil
	jmp	devilstay
hasdevil:
;check devil random	
	mov	ah,2ch
	int	21h
	xor	ax,ax
	mov	al,dl
	mov	bl,10
	div	bl
	cmp	ah,9
	je	devilatt
	cmp	ah,5
	jg	devilwalktmp
	jmp	devilstay
devilwalktmp:
	jmp	devilwalk
devilatt:
	lea	si,d1attack
	mov	ax,x_devil		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
	lea	si,samurai
	mov	ax,x_pos		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	delay	300
	lea	si,devil1
	mov	ax,x_devil		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
	lea	si,samurai
	mov	ax,x_pos
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	jmp	devilstay
devilwalk:
	lea	si,devil1
	sub	x_devil,5
	mov	ax,x_devil		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
	lea	si,samurai
	mov	ax,x_pos
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer
	mov	ax,x_pos
	add	ax,40
	cmp	ax,x_devil
	jle	devilstay
	mov	herodie,1
devilstay:
	ret
chkdevil	endp

getdevil	proc
	cmp	devilstatus,0
	jne	endgetdevil
	mov	ah,2ch
	int	21h
	xor	ax,ax
	mov	al,dl
	mov	bl,20
	div	bl
	cmp	ah,0
	jne	endgetdevil
	mov	devilstatus,1
	mov	x_devil,270
	inc	numdevil
endgetdevil:
	ret
getdevil	endp

chkhit	proc
	mov	ax,x_pos
	add	ax,155
	cmp	ax,x_devil
	jle	nothit
	mov	devilstatus,0
nothit:
	ret
chkhit	endp

chkdie	proc
	cmp	herodie,0
	je	notdie
	lea	si,over
	call	loadbgbuffer	
	call	clrobjbuffer
	call	swapvideoram
	call	syncvideo
	mov	ah,1
	int	21h
	mov	ah,1
	int	21h
	mov	ah,1
	int	21h
        jmp     startmenu_
notdie:
	ret
chkdie	endp

nextstate	proc
	inc	state

	cmp	state,2
	jne	notstate2
	lea	si,unit2
	call	clrobjbuffer
	call	loadbgbuffer	
	jmp	reset
notstate2:
	cmp	state,3
	jne	notstate3
	lea	si,unit3
	call	clrobjbuffer
	call	loadbgbuffer
	jmp	reset
notstate3:
	cmp	state,4
	jne	notstate4
	lea	si,unit4
	call	clrobjbuffer
	call	loadbgbuffer
	jmp	reset
        
notstate4:
        lea     si,gamewin
	call	loadbgbuffer	
	call	clrobjbuffer
	call	swapvideoram
	call	syncvideo
	mov	ah,1
	int	21h
	mov	ah,1
	int	21h
	mov	ah,1
	int	21h

        jmp     startmenu_
reset:
	mov	numdevil,0
	mov	x_pos,10
	mov	x_devil,270
	lea	si,samurai
	mov	ax,x_pos		
	mov	bx,y_pos		
	drawbmp	ax,bx,50,57,si
	call	swapvideoram
	call	syncvideo
	call	clrobjbuffer

	ret
nextstate	endp
include	graphic.asm
end
