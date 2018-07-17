
timer.exe:	timer.obj \dos\src\asm1\alib.lib
#		optlink /l /m timer,timer.exe,timer.map,\src\asm1\alib.lib;
		optlink /l /m timer,timer.exe,timer.map,\dos\src\asm1\alib.lib;
		del timer.obj
		del timer.pss
#		link timer,timer,,alib.lib;
		
timer.obj:	timer.asm
		optasm /zi /l /g timer;		
#		optasm timer;		
#		masm timer;
