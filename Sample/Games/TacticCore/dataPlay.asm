	hPlus	dw 8			; Next Draw Y
	wPlus	dw 15			; Next Draw X
	minus	dw 30
	walk	db 64 dup (0)		; Map Walk in Index whoPlay
	map	db 64 dup (0)		; Map Play in Index whoPlay
	tempWho db   ?
	whereX	dw   ?
	whereY	dw   ?
	endGame	db   ?			; End Game ?
	MaxHum	db   ?			; Max Human Player
	MaxCom	db   ?			; Max Computer Player
	AllPlayMax	dw	20	; Maximum All Hero
	maxPlay	dw   2			; Max Player on board
	minPlay	dw   ?			; Min Player on board
	turnWho	dw   2			; Turn who in Index whoPlay
	whoPlay	db	20 dup(?)	; 1:Human 0:Computer
	Who	db	20 dup(?)	; Who is hero
					; 1 is Ninja
					; 2 is Wizzard
					; 3 is Mong
					; 4 is fighter
					; 5 is Dragon
	noDie	db	20 dup(?)	; Die ?
	hX	db	20 dup(?)	; Where X is hero on board
	hY	db	20 dup(?)	; Where Y is hero on board
	hp	db	20 dup(?)	; Health
	at	db	20 dup(?)	; Attack;	STATUS CHARACTOR
	SeekScore	dw	12	; Seek to Scorce
	SeekAttack	dw	14	; Seek from Status to Table Attack ( 14 byte )
	_Head	db	7
	_Ninja	db	1		; ID Who
		db	"   Ninja"	; Name is 8 length only
		db	1		; Human Play
		db	85		; Health Maximum
		db	45		; Attack Maximum
		dw	100		; Score
		db	4,-1,0,0,-1,1,0,0,1
	_Wiz	db	2		; ID
		db	" Wizzard"	; Name
		db	0		; Computer Play
		db	45		; Health
		db	55		; Attack
		dw	250		; Score
		db	4,-2,-2,-2,2,2,-2,2,2
	_Mong	db	3		; ID
		db	"    Mong"	; Name
		db	1		; Hum play
		db	100		; Health
		db	20		; Attack
		dw	100		; Score
		db	4,-1,-1,-1,1,1,1,1,-1
	_Fight	db	4		; ID
		db	" Fighter"	; Name
		db	0		; Com play
		db	60		; Health
		db	18		; Attack
		dw	150		; Score
		db	6,-1,-1,-1,0,-1,1,1,-1,1,0,1,1
	_Dragon	db	5
		db	"  Dragon"	; Name
		db	0		; Com play
		db	120		; Health
		db	35		; Attack
		dw	300		; Score
		db	6,-2,0,-1,-1,-1,1,1,-1,2,0,1,1