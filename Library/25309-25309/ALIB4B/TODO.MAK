todo.exe:	todo.obj \dos\src\asm1\alib.lib
		optlink /l /m todo,todo.exe,todo.map,\dos\src\asm1\alib.lib;
		ts todo.map
		
todo.obj:	todo.asm
		optasm /zi /l /g todo;		

