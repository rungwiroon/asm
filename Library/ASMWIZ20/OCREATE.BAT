@echo off
echo off
echo   This batch file will assemble and link the EXAMPLE.ASM file using
echo   OPTASM and LINK.  If you are using a different assembler and/or linker,
echo   this batch file must be changed to reflect the names of your assembler
echo   and linker.
echo   --------------------------------------------------------------------
pause
optasm example;
link example,,nul,asmwiz;
erase example.obj
execom example
