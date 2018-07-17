
sort.exe:	sort.obj \src\asm1\alib.lib
#		optlink /l /m sort,sort.exe,sort.map,\src\asm1\alib.lib;
		optlink  sort,sort.exe,sort.map,\src\asm1\alib.lib;
		del sort.obj
		del sort.pss
#		link sort,sort,,alib.lib;
		
sort.obj:	sort.asm
#		optasm /zi /l /g sort;		
		optasm sort;		
#		masm sort;

