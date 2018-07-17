;	List File Name is use in program
	Bitmap1	db 'title.bmp',0		
	Bitmap2 db 'menu.bmp',0
	Bitmap3	db 'scr.bmp',0
	Bitmap4	db 'win.bmp',0
	Bitmap5 db 'lose.bmp',0
	Bitmap6 db 'tophigh.bmp',0
	filePal	db 'use.act',0			; File Pallete Color
	fileHandle	dw ?			; Temp to link file open *use fileScore
	fileScore	db 'highscr.dat',0	; File Save Score