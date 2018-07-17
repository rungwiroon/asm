                .MODEL SMALL
		.stack 100h
		.data
			b db 0
			a dd 120000EFh
                .CODE
start:
		mov	ax,@data
		mov	ds,ax

		lea	si,a

		xor	ax,ax
		mov	al,[si+7]
		call	outdec

		mov	ah,4ch
		int	21h
		include	outdec.asm
		END start
