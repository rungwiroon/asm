;ROUTINE TO SEND OUT EXCEPTION MESSAGES
;
emessout      proc	far
;
	      push	si	       ;save registers
	      push	ax
;
	      add	ax,ax	       ;double to index	through	table
	      mov	si,ax	       ;SI points into table
	      mov	si,emess[si]   ;lookup address of message
	      call	messout	       ;send the message
;
	      pop	ax	       ;restore	the registers
	      pop	si
	      ret
;
emessout      endp
                                                                                 