;ROUTINE TO COMPARE TWO	STRINGS						00000100
;									00000200
compare	      proc	far						00000300
;									00000400
	      push	si	  ;SAVE	REGISTERS			00000500
	      push	di						00000600
	      push	cx						00000700
;									00000800
	      repz	cmpsb	  ;ONE COMPARE DOES IT			00000900
;									00001000
	      pop	cx	  ;RESTORE REGISTERS			00001100
	      pop	di						00001200
	      pop	si						00001300
	      ret							00001400
;									00001500
compare	      endp							00001600
 