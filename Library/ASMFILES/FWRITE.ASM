;ROUTINE TO WRITE A BYTE TO A FILE
;
writefile     proc	far
;
	      mov	ah,40h	  ;write to file
	      int	21h	  ;DOS call
	      cmp	ax,cx	  ;was it all written?
	      je	writefile1 ;skip if OK
	      mov	ax,21	  ;not all bytes were transferred
	      stc		  ;set carry if	error
;
writefile1:
	      ret
;
writefile     endp
                                        