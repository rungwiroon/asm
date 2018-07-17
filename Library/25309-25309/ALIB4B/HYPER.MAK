
hyper.exe:	hyper.obj alib.lib
#		optlink /l /m hyper,hyper.exe,hyper.map,alib.lib;
		link hyper,hyper,,alib.lib;
		
hyper.obj:	hyper.asm
#		optasm /zi /l /g hyper;		
		masm hyper;

