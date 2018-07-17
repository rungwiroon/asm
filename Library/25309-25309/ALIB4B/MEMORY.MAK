
memory.exe:	memory.obj \src\asm1\alib.lib
#		optlink /l /m memory,memory.exe,memory.map,\src\asm1\alib.lib;
		optlink  memory,memory.exe,memory.map,\src\asm1\alib.lib;
		del memory.obj
		del memory.pss
#		link memory,memory,,alib.lib;
		
memory.obj:	memory.asm
#		optasm /zi /l /g memory;		
		optasm memory;		
#		masm memory;

