;ROUTINE TO READ A BYTE	FROM A FILE
;
readfile     proc      far
;
	      mov	ah,3Fh	  ;read	from a file
	      int	21h	  ;DOS call
	      cmp	ax,cx	  ;everything back?
	      je	readfile1 ;skip	if OK
	      mov	ax,21	  ;not all read
	      stc		  ;set carry if	error
;
readfile1:
	      ret
;
readfile     endp
                                                        