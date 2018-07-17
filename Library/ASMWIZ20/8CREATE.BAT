@echo off
echo off
echo   This batch file will assemble and link the EXAMPLE.ASM file using
echo   A86 and LINK.  If you are using a different assembler and/or linker,
echo   this batch file must be changed to reflect the names of your assembler
echo   and linker.
echo   --------------------------------------------------------------------
pause
ren example.asm example.8
a86 example.8 example.obj
ren example.8 example.asm
link example,,nul,asmwiz;
erase example.obj
execom example
