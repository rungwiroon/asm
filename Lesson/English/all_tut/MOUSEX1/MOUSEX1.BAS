CLS

CONST nASMBYTES = 102                   '# of bytes in asm program

DEFINT A-Z                              'all integer variables

x = 160
y = 100
SCREEN 13


DIM asmprog(1 TO (nASMBYTES / 2))       'the array space for asm program

DEF SEG = VARSEG(asmprog(1))            'the segment of asm program


OPEN "mousex1.com" FOR BINARY AS #1     'load the asm program

FOR I = 1 TO nASMBYTES / 2
        GET #1, , asmprog(I)
NEXT I
CLOSE #1

DEF SEG                                 'restore qbasic segment


start:
        GOSUB mouse

        LOCATE 1, 1
        PRINT "mouse xf ="; mousxf%
        PRINT "mouse yf ="; mousyf%
        PRINT "left button ="; mousl%
        PRINT "right button"; mousr%
       
        x = x + mousxf
        y = y + mousyf
        PSET (x, y), 15

        k$ = INKEY$
        IF k$ = "" THEN GOTO start



END


mouse:                                          'calls the check mouse
        DEF SEG = VARSEG(asmprog(1))            'asm program
        CALL ABSOLUTE(mousxf%, mousyf%, mousl%, mousr%, VARPTR(asmprog(1)))
        DEF SEG


        RETURN


