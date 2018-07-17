
diskinfo.exe:	diskinfo.obj alib.lib
#		optlink /l /m diskinfo,diskinfo.exe,diskinfo.map,alib.lib;
		link diskinfo,diskinfo,,alib.lib;
		
diskinfo.obj:	diskinfo.asm
#		optasm /zi /l /g diskinfo;		
		masm diskinfo;

