;ROUTINE TO CONVERT STRING TO UPPER CASE				00000100
;									00000200
uppercase     proc	far						00000300
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
uppercase1:								00001600
	      mov	al,[bx]	  ;GET THE CHARACTER			00001700
	      cmp	al,'a'	  ;BELOW THE LOWERCASE CHARACTERS?	00001800
	      jb	uppercase2    ;SKIP IF SO			00001900
	      cmp	al,'z'	  ;ABOVE THE LOWERCASE CHARACTERS?	00002000
	      ja	uppercase2    ;SKIP IF SO			00002100
;									00002200
	      or	al,5fh	  ;MASK	OUT BIT	NUMBER 5		00002300
;									00002400
uppercase2:								00002500
	      mov	[bx],al	  ;STORE THE CHARACTER			00002600
	      inc	bx	  ;POINT TO NEXT CHARACTER		00002700
	      loop	uppercase1					00002800
;									00002900
	      pop	ax	  ;RESTORE REGISTERS			00003000
	      pop	cx						00003100
	      pop	bx						00003200
	      ret							00003300
;									00003400
lowercase     endp							00003500
                                                                                                    