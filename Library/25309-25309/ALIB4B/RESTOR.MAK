both:		compres.exe restor.exe

compres.exe:	compres.obj alib.lib
#		optlink /l /m compres,compres.exe,compres.map,alib.lib;
		link compres,compres,,alib.lib;
		
compres.obj:	compres.asm
#		optasm compres;	
		masm compres;	

restor.exe:	restor.obj alib.lib
#		optlink /l /m restor,restor.exe,restor.map,alib.lib;
		link restor,restor,,alib.lib;
		
restor.obj:	restor.asm
#		optasm restor;		
		masm restor;
