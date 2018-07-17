viddemo.exe : viddemo.obj video.obj
  tlink viddemo+video

viddemo.obj : viddemo.asm video.inc
  tasm viddemo

video.obj : video.asm video.inc
  tasm video
