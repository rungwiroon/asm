;ROUTINE TO SEARCH FOR A WORD IN AN ORDERED LIST OF WORDS		00000100
;									00000200
lexsearch     proc	far						00000300
;									00000400
	      push	si	  ;SAVE	REGISTERS			00000500
	      push	di						00000600
	      push	cx						00000700
;									00000800
;POINT TO BEGINNING OF LIST AND	GET IT'S LENGTH				00000900
	      mov	di,bp	  ;BEGINNING OF	LIST			00001000
	      mov	cx,[di]	  ;GET LENGTH				00001100
	      inc	di						00001200
	      inc	di						00001300
;									00001400
;COMPARE SOURCE	WORD WITH WORDS	IN THE LIST				00001500
;									00001600
lexsearch1:								00001700
;									00001800
	      mov	dx,di	  ;SAVE	BEGINNING OF DEST WORD		00001900
;									00002000
;FORWARD DIRECTION							00002100
	      cld		  ;FORWARD DIRECTION			00002200
;									00002300
;POINT TO BEGINNING OF SOURCE						00002400
	      mov	si,bx	  ;POINT TO BEGINNING OF SOURCE		00002500
	      inc	si						00002600
	      inc	si						00002700
;									00002800
;COMPARE SOURCE	WORD WITH A WORD OF THE	LIST				00002900
lexsearch2:								00003000
;									00003100
;CHECK FOR END OF LIST							00003200
	      jcxz	lexsearch5    ;END OF LIST - INSERT IT		00003300
;									00003400
;SET UP	CARRIAGE RETURN	AS CHARACTER FOR SCANNING			00003500
	      mov	al,0dh	  ;SCAN	FOR CARRIAGE RETURN		00003600
;									00003700
;CHECK FOR END OF SOURCE WORD						00003800
	      cmp	[si],al	  ;SOURCE BYTE = CARRIAGE RETURN?	00003900
	      je	lexsearch4    ;END OF SOURCE WORD FOUND		00004000
;									00004100
;CHECK FOR END OF DESTINATION WORD					00004200
	      cmp	es:[di],al   ;DEST. BYTE = CARRIAGE RETURN?	00004300
	      je	lexsearch3   ;NO MATCH - GOTO NEXT WORD		00004400
;									00004500
;COMPARE CHARACTER BY CHARACTER						00004600
	      dec	cx						00004700
	      cmpsb		  ;CHECK FOR MATCH			00004800
	      je	lexsearch2    ;MATCHED - CHECK NEXT CHARACTER	00004900
	      jb	lexsearch5    ;TOO HIGH	- THIS SI THE PLACE	00005000
;									00005100
;SCAN FOR NEXT CARRIAGE	RETURN						00005200
lexsearch3:								00005300
	      repnz	scasb	  ;SCAN	UNTIL CARRIAGE RETURN		00005400
	      jmp	lexsearch1    ;NEXT WORD			00005500
;									00005600
;END OF	SOURCE WORD WAS	FOUND						00005700
lexsearch4:								00005800
	      cmp	[di],al	  ;DEST	CHARACTER WAS CARRIAGE RETURN?	00005900
	      je	lexsearch6    ;END OF DESTINATION WORD?		00006000
;									00006100
;FOUND SPOT TO INSERT THE WORD						00006200
lexsearch5:								00006300
	      mov	al,0ffh	  ;SUCCESS				00006400
	      jmp	lexsearchexit					00006500
;									00006600
;WORD IS ALREADY PRESENT						00006700
lexsearch6:								00006800
	      mov	al,00h	  ;ALREADY THERE			00006900
	      jmp	lexsearchexit					00007000
;									00007100
lexsearchexit:								00007200
	      pop	cx	  ;RESTORE REGISTERS			00007300
	      pop	di						00007400
	      pop	si						00007500
	      ret							00007600
;									00007700
lexsearch     endp							00007800
                                                         