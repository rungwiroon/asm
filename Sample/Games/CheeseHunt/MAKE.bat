@echo off
SET PATH=%path%;.\ASSEMBLER
MASM 0240;
pause
MASM GRAPHIC;
PAUSE
LINK 0240+GRAPHIC;
pause
0240.exe

