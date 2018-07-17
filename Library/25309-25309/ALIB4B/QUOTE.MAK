
quote.exe:	quote.obj \src\asm1\alib.lib
#		optlink /l /m quote,quote.exe,quote.map,\src\asm1\alib.lib;
		optlink  quote,quote.exe,quote.map,\src\asm1\alib.lib;
		del quote.obj
		del quote.pss
#		link quote,quote,,alib.lib;
		
quote.obj:	quote.asm
#		optasm /zi /l /g quote;		
		optasm quote;		
#		masm quote;

