@echo off

\MASM32\BIN\Cvtres.exe /machine:ix86 rsrc.res

if exist %1.obj del serlz.obj
if exist %1.exe del serlz.exe

\MASM32\BIN\Ml.exe /c /coff serlz.asm
if errorlevel 1 goto ErrAsm

\MASM32\BIN\Link.exe /SUBSYSTEM:WINDOWS serlz.obj rsrc.obj
if errorlevel 1 goto ErrLink

del *.obj
goto Pausa

:ErrAsm
echo _
echo Error al ensamblar...
goto Pausa

:ErrLink
echo _
echo Error al construir EXE...

:Pausa
pause
