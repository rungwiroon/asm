@echo off
tasm /q k:\asm\pm32\modex32\*.asm
del k:\asm\pm32\obj\xlib.lib
tlib @!objs.lst
del *.obj 
del *.bak >nul