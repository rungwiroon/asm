 slide     dw ?
 position  db 13
 dead      db ?
 cdead     db ?
 aloop     db ?
 pstb1     db ?
 pstb2     db ?
 life      db ?
 direction db 0
 nloop     db ?
 over      dw ?
 fly       dw 0
 color     db ?
 hh        db 0
 mm        db 0
 sec       db 0
 ms        db 0
 nms       db 0
 pre       db ?
 bcount    db 0
 level     db ?
 cmonk     db ?
 cbat      db ?
 lcol      dw 160,160
 col       dw ?
 row       dw ?
 last      dw ?
 wi        dw ?
 hi        dw ?
 pic       db ?
 stat      db 35 dup (0)
 str_time  db '00:00:00$'            
 pname     db 80 dup (?)
 filename1 db 'SCORE.DAT',0
 filename2 db 'backup',0
 buffer    db 80 dup (?)
 handle1   dw ?
 handle2   dw ?
 paste     db ?
 rec       db ?
 clear     db 'CLEAR'
 ok        db 'O.K'
 point     db ?
 x         dw ?
 y         dw ?
 license   db '  This software is create by  '
 author    db 'Mr. Kiatiyos Boonchotphitugkul'
 iden      db '    CSs1-R   43-4055-003-9    '
