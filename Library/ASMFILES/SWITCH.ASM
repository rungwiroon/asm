;ROUTINE TO SWITCH TWO STRINGS						00000100
;									00000200
switch	      proc	far						00000300
;									00000400
	      push	si	  ;SAVE	REGISTERS			00000500
	      push	di						00000600
	      push	cx						00000700
	      push	ax						00000800
;									00000900
	      cld		  ;FORWARD DIRECTION			00001000
switch1:								00001100
	      mov	al,[di]	  ;GET BYTE FROM DESTINATION		00001200
	      movsb		  ;MOVE	FROM SOURCE TO DESTINATION	00001300
	      mov	es:[si-1],al	;PUT BYTE IN SOURCE		00001400
	      loop	switch1	  ;LOOP	BACK FOR MORE			00001500
;									00001600
	      pop	ax	  ;RESTORE REGISTERS			00001700
	      pop	cx						00001800
	      pop	di						00001900
	      pop	si						00002000
	      ret							00002100
;									00002200
switch	      endp							00002300
                                                                                    