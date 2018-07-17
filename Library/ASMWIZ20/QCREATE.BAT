@echo off
echo off
echo   This batch file will assemble and link the EXAMPLE.ASM file using
echo   QuickC/QuickAssembler and LINK.  If you are using a different assembler,
echo   this batch file must be changed to reflect the names of your assembler
echo   and linker.
echo   --------------------------------------------------------------------
pause
qcl example.asm /link asmwiz
erase example.obj
execom example
