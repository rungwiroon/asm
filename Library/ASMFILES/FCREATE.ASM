;ROUTINE TO CREATE A FILE
;
createfile    proc	far
;
	      push	cx	  ;save	register
;
	      mov	cx,0	  ;attribute 0
	      mov	ah,3Ch	  ;create file
	      int	21h	  ;DOS call
;
	      pop	cx	  ;restore register
	      ret
;
createfile    endp
                                                                                                                           