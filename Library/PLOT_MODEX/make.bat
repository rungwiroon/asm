@echo off
PATH = %PATH%;ASSEMBLER

masm showpic;
masm modex;
masm picdisp;
pause

link showpic+modex+picdisp;
pause