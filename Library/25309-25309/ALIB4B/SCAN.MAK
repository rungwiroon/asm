scan.exe:	scan.obj
		optlink /l /m scan,scan.exe,scan.map,\alib\alib.lib;
		ts scan.map
		
scan.obj:	scan.asm
		optasm /zi /l /g scan;		

