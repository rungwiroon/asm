;ROUTINE TO CONVERT STRING TO LOWER CASE				00000100
;									00000200
lowercase     proc	far						00000300
;									00000400
	      push	bx	  ;SAVE	REGISTERS			00000500
	      push	cx						00000600
	      push	ax						00000700
;									00000800
;GET THE LENTH								00000900
	      mov	cx,[bx]	  ;FIRST TWO BYTES CONTAIN THE LENGTH	00001000
	      inc	bx	  ;POINT TO BEGINNING OF TEXT		00001100
	      inc	bx						00001200
;									00001300
;LOOP THROUGH THE BYTES	OF THE STRING					00001400
;									00001500
lowercase1:								00001600
	      mov	al,[bx]	  ;GET THE CHARACTER			00001700
	      cmp	al,'A'	  ;BELOW THE UPPERCASE CHARACTERS?	00001800
	      jb	lowercase2    ;SKIP IF SO			00001900
	      cmp	al,'Z'	  ;ABOVE THE UPPERCASE CHARACTERS?	00002000
	      ja	lowercase2    ;SKIP IF SO			00002100
;									00002200
	      or	al,20h	  ;OR BIT 5 INTO THE BYTE		00002300
;									00002400
lowercase2:								00002500
	      mov	[bx],al	  ;STORE THE CHARACTER			00002600
	      inc	bx	  ;POINT TO NEXT CHARACTER		00002700
	      loop	lowercase1					00002800
;									00002900
	      pop	ax	  ;RESTORE REGISTERS			00003000
	      pop	cx						00003100
	      pop	bx						00003200
	      ret							00003300
;									00003400
lowercase     endp							00003500
                                                                                                   