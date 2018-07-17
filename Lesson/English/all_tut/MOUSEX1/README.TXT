demonstrates the useage of external asm binaries in qbasic
by reading the mouse


You must use the following command line to run this program:

        qb /l qb.qbl mousex1

this loads the qbasic quick library and the program to be run
you will get a SUB PROGRAM NOT DEFINED error unless you do this


do not run the com file. it will crash. it is only inteded to be loaded
by qbasic

to build the com file:

tasm mousex1
tlink /t mousex1


the /t makes it a com file


-mcarp
