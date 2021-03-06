;ROUTINE TO SEARCH FOR ONE STRING WITHIN ANOTHER			00000100
;									00000200
strsearch     proc	far						00000300
;									00000400
	      push	si	  ;SAVE	REGISTERS			00000500
	      push	di						00000600
	      push	cx						00000700
;									00000800
;GET LENGTH OF DESTINATION AND POINT TO	FIRST BYTE			00000900
;									00001000
	      mov	si,dx	  ;USE SOURCE INDEX			00001100
	      lodsw		  ;GET THE LENGTH OF DESTINATION	00001200
	      mov	cx,ax	  ;USE THE LENGTH AS COUNT		00001300
	      mov	dx,si	  ;TEXT	BEGINS HERE			00001400
;									00001500
strsearch1:								00001600
;									00001700
;POINT INDICES TO BEGINNING OF SOURCE AND DESTINATION			00001800
	      mov	si,bx	  ;LOAD	SOURCE INDEX			00001900
	      mov	di,dx	  ;LOAD	DESTINATION INDEX		00002000
;									00002100
;SCAN FOR MATCH								00002200
	      mov	al,[si+2] ;GET THE FIRST CHARACTER		00002300
	      cld		  ;FORWARD DIRECTION			00002400
	      repnz	scasb	  ;SCAN	FOR MATCH			00002500
	      jcxz	strsearch2   ;QUIT IF FOUND NO MATCH		00002600
;									00002700
;HAVE A	MATCH OF FIRST CHARACTERS- NOW CHECK ENTIRE STRING		00002800
	      mov	dx,di	  ;SAVE	CURRENT	DEST. LOCATION		00002900
	      dec	di	  ;BEGINNING OF	WORD			00003000
	      lodsw		  ;GET LENGTH OF SOURCE			00003100
	      xchg	cx,ax	  ;USE SOURCE COUNT AND	SAVE DEST. COUNT00003200
	      repz	cmpsb	  ;COMPARE THE TWO STRINGS		00003300
	      jcxz	strsearch3   ;IT'S A MATCH IF NO MORE SOURCE	00003400
;									00003500
;CONTINUE THE SCAN							00003600
	      xchg	cx,ax	  ;USE DEST. COUNT			00003700
	      jmp	strsearch1    ;BACK FOR	MORE SCANNING OF DEST.	00003800
;									00003900
;NO MATCH IS POSSIBLE							00004000
strsearch2:								00004100
	      mov	al,0h	  ;UNSUCCESSFUL	OUTCOME			00004200
	      jmp	strsearchexit					00004300
;									00004400
;FOUND A MATCH								00004500
strsearch3:								00004600
	      dec	dx	  ;POINT TO BEGINNING OF MATCH		00004700
	      mov	al,0ffh	  ;SUCCESSFUL MATCH			00004800
	      jmp	strsearchexit					00004900
;									00005000
strsearchexit:								00005100
	      pop	cx	  ;RESTORE REGISTERS			00005200
	      pop	di						00005300
	      pop	si						00005400
	      ret							00005500
;									00005600
strsearch     endp							00005700
                                                                                                                     