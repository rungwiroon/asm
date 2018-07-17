
loan.exe:	loan.obj alib.lib
#		optlink /l /m loan,loan.exe,loan.map,alib.lib;
		link loan,loan,,alib.lib;
		
loan.obj:	loan.asm
#		optasm /zi /l /g loan;		
		masm loan;

