;ROUTINE TO INSERT A WORD IN AN	ORDERED	LIST OF	WORDS			00000100
;									00000200
lexinsert     proc	far						00000300
;									00000400
	      push	ax	  ;SAVE	REGISTERS			00000500
	      call	lexsearch ;SEARCH FOR MATCH			00000600
	      cmp	al,0	  ;ALREADY THERE?			00000700
	      je	lexinsertexit	 ;SKIP IF SO			00000800
	      call	strinsert ;INSERT THE NEW WORD			00000900
;									00001000
lexinsertexit:								00001100
	      pop	ax	  ;RESTORE REGISTERS			00001200
	      ret							00001300
;									00001400
lexinsert     endp							00001500
                                                                   