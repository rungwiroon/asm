;ROUTINE TO INSERT ONE STRING WITHIN ANOTHER				00000100
;									00000200
;ADDRESSING EQUATES							00000300
essorc	      equ	es:[si]	  ;EQUATE FOR SOURCE IN	EXTRA SEGMENT	00000400
dsdest	      equ	byte ptr[di]	;EQUATE	FOR USUAL DESTINATION	00000500
;									00000600
strinsert     proc	far						00000700
;									00000800
	      push	si	  ;SAVE	REGISTERS			00000900
	      push	di						00001000
	      push	cx						00001100
	      push	ax						00001200
;									00001300
;FIND CURRENT END OF DESTINATION STRING					00001400
	      mov	si,bp	  ;START OF STRING			00001500
	      add	si,es:[si]    ;POINT TO	NEXT TO	LAST BYTE	00001600
	      inc	si	  ;ADJUST FOR LENGTH INFORMATION	00001700
;									00001800
;FIND NEW END OF DEST. STRING AND UPDATE LENGTH				00001900
	      mov	di,si	  ;GET OLD END OF DESTINATION		00002000
	      mov	ax,[bx]	  ;GET LENGTH OF SOURCE			00002100
	      add	di,ax	  ;NEW END OF DEST.			00002200
	      add	es:[bp],ax    ;NEW LENGTH OF DEST.		00002300
;									00002400
;MOVE TAIL OF DESTINATION STRING OUT OF	THE WAY				00002500
	      mov	cx,si	  ;SI-DX+1 IS THE COUNT			00002600
	      sub	cx,dx						00002700
	      inc	cx						00002800
	      std		  ;BACKWARD DIRECTION			00002900
rep	      movs	dsdest,essorc	 ;MOVE THE TAIL			00003000
;									00003100
;MOVE SOURCE STRING INTO PLACE						00003200
	      mov	di,dx	  ;DESTINATION OF MOVE			00003300
	      mov	si,bx	  ;SOURCE OF MOVE			00003400
	      cld		  ;FORWARD DIRECTION			00003500
	      lodsw		  ;LENGTH OF SOURCE			00003600
	      mov	cx,ax	  ;THE COUNT				00003700
	      rep	movsb	  ;MAKE	THE STRING MOVE			00003800
;									00003900
strinsertexit:								00004000
	      pop	ax	  ;RESTORE REGISTERS			00004100
	      pop	cx						00004200
	      pop	di						00004300
	      pop	si						00004400
	      ret							00004500
;									00004600
;									00004700
strinsert     endp							00004800
                                                                                                 