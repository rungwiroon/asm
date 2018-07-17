
filt.exe:	filt.obj \src\asm1\alib.lib
#		optlink /l /m filt,filt.exe,filt.map,\src\asm1\alib.lib;
		optlink /exepack /packcode filt,filt.exe,filt.map,\src\asm1\alib.lib;
		del filt.obj
		del filt.pss
#		link filt,filt,,alib.lib;
		
filt.obj:	filt.asm
#		optasm /zi /l /g filt;		
		optasm filt;		
#		masm filt;
