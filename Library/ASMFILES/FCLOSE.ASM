;ROUTINE TO CLOSE A FILE
;
closefile    proc      far
;
	      mov	ah,3Eh	  ;close file
	      int	21h	  ;DOS call
;
	      ret
;
closefile    endp
                                                                                                 