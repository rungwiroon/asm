tasm.exe sound /um510 /m9 /iinclude
tlink -3 sound lib\mse_asm
  
del sound.map
del sound.obj
