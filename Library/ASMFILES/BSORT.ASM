;ROUTINE TO SORT A STRING ARRAY						00000100
;									00000200
bsort	      proc	far						00000300
;									00000400
	      push	si	  ;SAVE	REGISTERS			00000500
	      push	di						00000600
	      push	cx						00000700
	      push	ax						00000800
;									00000900
;ADJUST	COUNT FOR ONE LESS THAN	THE NUMBER OF ITEMS			00001000
	      dec	cx	  ;ADJUST THE COUNT			00001100
;									00001200
;OUTER LOOP - FOR SI = 1 TO N-1						00001300
bsort1:									00001400
	      push	cx	  ;SAVE	THE COUNT			00001500
	      mov	di,si	  ;DESTINATION POINTS TO SOURCE		00001600
;									00001700
;INNER LOOP - FOR DI = SI+1 TO N					00001800
bsort2:									00001900
	      push	cx	  ;SAVE	THE COUNT			00002000
	      add	di,dx	  ;POINT TO NEXT DESTINATION		00002100
	      mov	cx,dx	  ;ENTRY LENGTH				00002200
	      call	compare	  ;COMPARE THE STRINGS			00002300
	      jle	bsort3	  ;SKIP	IF SOURCE <= DESTINATION	00002400
	      call	switch	  ;SWITCH IF NOT			00002500
;									00002600
bsort3:									00002700
	      pop	cx	  ;RESTORE THE COUNT			00002800
	      loop	bsort2						00002900
;									00003000
	      add	si,dx	  ;POINT TO NEXT SOURCE			00003100
	      pop	cx	  ;RESTORE THE COUNT			00003200
	      loop	bsort1						00003300
;									00003400
bsortexit:								00003500
	      pop	ax	  ;RESTORE REGISTERS			00003600
	      pop	cx						00003700
	      pop	di						00003800
	      pop	si						00003900
	      ret							00004000
;									00004100
bsort	      endp							00004200
 