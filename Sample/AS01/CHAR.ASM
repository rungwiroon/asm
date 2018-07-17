
ctable	 segment para public 'DATA
	db	9 dup(' ')
	db	9,10,' ',12,13
	db	13 dup(' ')
	db	27
	db	4 dup(' ')
	db	' !"#$%&',39,'()*+,-./0123456789:;<=>?@'
	db	'ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`'
	db	'abcdefghijklmnopqrstuvwxyz{|}~'
	db	52 dup(' ')
	db	'|++++++|+++++++++-++++++++-+++++++++++++'
	db	36 dup(' ')
ctable	ends
	end
