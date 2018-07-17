edrec.exe:	edrec.obj alib.lib
#		optlink /l /m edrec,edrec.exe,edrec.map,alib.lib;
		link edrec,edrec,,alib.lib;
		
edrec.obj:	edrec.asm
#		optasm /zi /l /g edrec;
		masm edrec;

