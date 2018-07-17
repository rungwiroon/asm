public	getNewMemory
title	Memory
.model	small
.data
	extrn	mem:dword
	memory	db 16000 dup(100)
.code
getNewMemory	proc far
	push	ax
	push	ds
	mov	ax,@data
	mov	ds,ax


	mov	esAdr,ax
	mov	diAdr,offset memory
	pop	ds
	pop	ax
	ret
getNewMemory	endp
	end