PUTPIXEL PROC

         PUSH AX
         PUSH BX
         PUSH CX
         PUSH ES
         PUSH DI

         MOV AX,0A000H
         MOV ES,AX
         MOV AX,Y_POS
         MOV BX,AX
         MOV CL,8
         SHL AX,CL
         MOV CL,6
         SHL BX,CL
         ADD AX,BX
         MOV DI,X_POS
         ADD DI,AX
         MOV AL,COL
         MOV ES:[DI],AL

         POP DI
         POP ES
         POP CX
         POP BX
         POP AX
         RET
PUTPIXEL        ENDP

BORDER  PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

BDLP1:
        CALL PUTPIXEL
        INC X_POS
        CMP X_POS,320
        JNE BDLP1
        MOV X_POS,0
        INC Y_POS
        CMP Y_POS,200
        JNE BDLP1

        MOV CX,5
        MOV X_POS,0
        MOV Y_POS,0
BDLP2:
        MOV COL,1
        CALL PUTPIXEL
        INC X_POS
        CMP X_POS,320
        JNE BDLP2
        MOV X_POS,0
        INC Y_POS
        LOOP BDLP2

        MOV CX,5
        MOV X_POS,0
        MOV Y_POS,195
BDLP3:
        MOV COL,1
        CALL PUTPIXEL
        INC X_POS
        CMP X_POS,320
        JNE BDLP3
        MOV X_POS,0
        INC Y_POS
        LOOP BDLP3

        MOV CX,5
        MOV X_POS,0
        MOV Y_POS,5
BDLP4:
        MOV COL,1
        CALL PUTPIXEL
        INC Y_POS
        CMP Y_POS,195
        JNE BDLP4
        MOV Y_POS,5
        INC X_POS
        LOOP BDLP4

        MOV CX,5
        MOV X_POS,315
        MOV Y_POS,5
BDLP5:
        MOV COL,1
        CALL PUTPIXEL
        INC Y_POS
        CMP Y_POS,195
        JNE BDLP5
        MOV Y_POS,5
        INC X_POS
        LOOP BDLP5

        MOV CX,2
        MOV X_POS,40
        MOV Y_POS,58
BDLP6:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        CMP X_POS,280
        JNE BDLP6
        MOV X_POS,40
        INC Y_POS
        LOOP BDLP6

        MOV CX,2
        MOV X_POS,40
        MOV Y_POS,180
BDLP7:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        CMP X_POS,280
        JNE BDLP7
        MOV X_POS,40
        INC Y_POS
        LOOP BDLP7

        MOV CX,2
        MOV X_POS,38
        MOV Y_POS,58
BDLP8:
        MOV COL,0
        CALL PUTPIXEL
        INC Y_POS
        CMP Y_POS,182
        JNE BDLP8
        MOV Y_POS,58
        INC X_POS
        LOOP BDLP8

        MOV CX,2
        MOV X_POS,280
        MOV Y_POS,58
BDLP9:
        MOV COL,0
        CALL PUTPIXEL
        INC Y_POS
        CMP Y_POS,182
        JNE BDLP9
        MOV Y_POS,58
        INC X_POS
        LOOP BDLP9


        POP DX
        POP CX
        POP BX
        POP AX

        RET
BORDER  ENDP

BLOCK   PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS
        MOV CH,19

BLP1:
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BLP1
        MOV COL,7
        CALL PUTPIXEL
        MOV X_POS,AX
        INC Y_POS
        MOV CH,18
        MOV CL,2

BLP2:
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BLP2
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        MOV COL,8
        CALL PUTPIXEL
        MOV X_POS,AX
        INC Y_POS
        MOV CH,18
        DEC CL
        JZ  BLP7
        JMP BLP2
BLP7:
        MOV CL,15
BLP4:
        MOV CH,15
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
BLP3:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BLP3

        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        MOV COL,8
        CALL PUTPIXEL

        MOV X_POS,AX
        INC Y_POS
        DEC CL
        JZ  BLP8
        JMP BLP4
BLP8:
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        MOV CH,17

BLP5:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BLP5

        MOV X_POS,AX
        INC Y_POS
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        MOV CH,19

BLP6:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BLP6

        POP DX
        POP CX
        POP BX
        POP AX

        RET
BLOCK   ENDP

BLOCKING PROC

        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    X_POS
        PUSH    Y_POS

        MOV     AX,X_POS
        MOV     CH,20

BGLP1:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BGLP1
        MOV CH,19
BGLP2:
        MOV CL,19
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
BGLP3:
        INC X_POS
        MOV COL,7
        CALL PUTPIXEL
        DEC CL
        JNZ BGLP3

        DEC CH
        JNZ BGLP2

        POP     Y_POS
        POP     X_POS
        POP     DX
        POP     CX
        POP     BX
        POP     AX

        RET
BLOCKING        ENDP

BLOCKBOMB PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS

        MOV CH,20
BBLP0:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP0

        MOV CL,2
BBLP1B:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
BBLP1:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP1
        DEC CL
        JNZ BBLP1B

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        MOV CH,9
BBLP2:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP2
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV CH,9
BBLP3:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP3

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        MOV CH,9
BBLP4:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP4
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV CH,9
BBLP5:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP5

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP6:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP6

        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS

        MOV CH,6
BBLP7:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP7

        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP8:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP8

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP9:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP9

        MOV COL,7
        CALL PUTPIXEL
        INC X_POS

        MOV CH,9
BBLP10:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP10

        MOV CH,5
BBLP11:
       MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP11

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP12:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP12

        MOV COL,7
        CALL PUTPIXEL
        INC X_POS

        MOV CH,9
BBLP13:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP13

        MOV CH,5
BBLP14:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP14

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP15:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP15

        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        MOV CH,6
BBLP16:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP16
        MOV CH,4
BBLP17:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP17

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP18:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP18

        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        MOV CH,6
BBLP19:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP19
        MOV CH,4
BBLP20:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP20

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS

        MOV CH,16
BBLP21:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP21

        MOV COL,7
        CALL PUTPIXEL
        INC X_POS

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP22:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP22

        MOV CH,11
BBLP23:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP23
        MOV CH,4
BBLP24:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP24

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP25:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP25

        MOV CH,11
BBLP26:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP26
        MOV CH,4
BBLP27:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP27
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP28:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP28

        MOV CH,11
BBLP29:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP29
        MOV CH,4
BBLP30:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP30

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP31:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP31

        MOV CH,11
BBLP32:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP32
        MOV CH,4
BBLP33:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP33

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP34:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP34

        MOV COL,7
        CALL PUTPIXEL
        INC X_POS

        MOV CH,9
BBLP35:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP35

        MOV COL,7
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP36:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP36

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP37:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP37

        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS

        MOV CH,6
BBLP38:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP38

        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
BBLP39:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP39

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        MOV CH,9
BBLP40:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP40
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV CH,9
BBLP41:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP41
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        MOV CH,9
BBLP42:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP42
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV CH,9
BBLP43:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP43

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
BBLP44:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ BBLP44

        POP DX
        POP CX
        POP BX
        POP AX

        RET
BLOCKBOMB ENDP

BLOCK1  PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS

        MOV CH,20
B1LP1:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP1

        MOV CL,3
B1LP2:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B1LP3:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP3
        DEC CL
        JNZ B1LP2

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,9
B1LP4:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP4

        MOV COL,1
        CALL PUTPIXEL
        INC X_POS
        MOV COL,1
        CALL PUTPIXEL
        INC X_POS
        MOV COL,1
        CALL PUTPIXEL
        INC X_POS

        MOV CH,7
B1LP5:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP5

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,8
B1LP6:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP6

        MOV CH,4
B1LP7:
        MOV COL,1
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP7

        MOV CH,7
B1LP8:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP8

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,7
B1LP9:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP9

        MOV CH,5
B1LP10:
        MOV COL,1
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP10

        MOV CH,7
B1LP11:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP11

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,6
B1LP12:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP12

        MOV CH,6
B1LP13:
        MOV COL,1
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP13

        MOV CH,7
B1LP14:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP14

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,5
B1LP15:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP15

        MOV CH,7
B1LP16:
        MOV COL,1
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP16

        MOV CH,7
B1LP17:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP17

        MOV CL,5
B1LP21:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,8
B1LP18:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP18

        MOV CH,4
B1LP19:
        MOV COL,1
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP19

        MOV CH,7
B1LP20:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP20

        DEC CL
        JZ  B1LP22
        JMP B1LP21
B1LP22:
        MOV CL,2
B1LP23:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,5
B1LP24:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP24

        MOV CH,9
B1LP25:
        MOV COL,1
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP25

        MOV CH,5
B1LP26:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP26

        DEC CL
        JZ  B1LP27
        JMP B1LP23
B1LP27:
        MOV CL,4
B1LP28:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B1LP29:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B1LP29
        DEC CL
        JNZ B1LP28

        POP DX
        POP CX
        POP BX
        POP AX
        RET
BLOCK1  ENDP

BLOCK2  PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS

        MOV CH,20
B2LP1:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP1

        MOV CL,3
B2LP2:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B2LP3:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP3
        DEC CL
        JNZ B2LP2

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
B2LP4:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP4

        MOV CH,10
B2LP5:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP5

        MOV CH,5
B2LP5A:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP5A

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B2LP6:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP6

        MOV CH,12
B2LP7:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP7

        MOV CH,4
B2LP8:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP8

        MOV CL,2
B2LP11D:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B2LP9:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP9

        MOV CH,4
B2LP10:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP10

        MOV CH,5
B2LP11:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP11

        MOV CH,3
B2LP11A:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP11A

        MOV CH,4
B2LP11B:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP11B

        DEC CL
        JZ  B2LP11C
        JMP B2LP11D
B2LP11C:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,12
B2LP12:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP12

        MOV CH,3
B2LP13:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP13

        MOV CH,4
B2LP14:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP14

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,9
B2LP15:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP15

        MOV CH,5
B2LP16:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP16

        MOV CH,5
B2LP17:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP17

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,7
B2LP18:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP18

        MOV CH,6
B2LP19:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP19

        MOV CH,6
B2LP20:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP20

        MOV CL,2
B2LP21:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
B2LP24:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP24

        MOV CH,6
B2LP25:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP25

        MOV CH,9
B2LP26:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP26
        DEC CL
        JZ  B2LP22
        JMP B2LP21

B2LP22:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B2LP27:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP27

        MOV CH,5
B2LP28:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP28

        MOV CH,11
B2LP29:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP29

        MOV CL,2
B2LP30:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B2LP31:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP31

        MOV CH,12
B2LP32:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP32

        MOV CH,4
B2LP33:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP33
        DEC CL
        JZ  B2LP34
        JMP B2LP30

B2LP34:
        MOV CL,4
B2LP35:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B2LP36:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B2LP36
        DEC CL
        JNZ B2LP35

        POP DX
        POP CX
        POP BX
        POP AX
        RET
BLOCK2  ENDP

BLOCK3  PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS

        MOV CH,20
B3LP1:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP1

        MOV CL,3
B3LP2:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B3LP3:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP3
        DEC CL
        JNZ B3LP2

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B3LP4:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP4

        MOV CH,11
B3LP5:
        MOV COL,40
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP5

        MOV CH,5
B3LP5A:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP5A

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B3LP6:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP6

        MOV CH,12
B3LP7:
        MOV COL,40
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP7

        MOV CH,4
B3LP8:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP8

        MOV CL,3
B3LP9A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,12
B3LP9:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP9

        MOV CH,3
B3LP10:
        MOV COL,40
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP10

        MOV CH,4
B3LP11:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP11
        DEC CL
        JZ  B3LP9B
        JMP B3LP9A

B3LP9B:
        MOV CL,2
B3LP12A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,7
B3LP12:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP12

        MOV CH,7
B3LP13:
        MOV COL,40
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP13

        MOV CH,5
B3LP14:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP14
        DEC CL
        JZ  B3LP12B
        JMP B3LP12A

B3LP12B:
        MOV CL,3
B3LP15:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,12
B3LP16:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP16

        MOV CH,3
B3LP17:
        MOV COL,40
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP17

        MOV CH,4
B3LP18:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP18
        DEC CL
        JZ  B3LP19
        JMP B3LP15

B3LP19:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B3LP24:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP24

        MOV CH,12
B3LP25:
        MOV COL,40
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP25

        MOV CH,4
B3LP26:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP26
        DEC CL

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B3LP27:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP27

        MOV CH,11
B3LP28:
        MOV COL,40
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP28

        MOV CH,5
B3LP29:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP29

        MOV CL,4
B3LP30:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B3LP31:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B3LP31
        DEC CL
        JNZ B3LP30

        POP DX
        POP CX
        POP BX
        POP AX
        RET
BLOCK3  ENDP

BLOCK4  PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS

        MOV CH,20
B4LP1:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP1

        MOV CL,3
B4LP2:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B4LP3:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP3
        DEC CL
        JNZ B4LP2

        MOV CL,2
B4LP4A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,5
B4LP4:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP4

        MOV CH,4
B4LP5:
        MOV COL,104
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP5

        MOV CH,1
B4LP5A:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP5A

        MOV CH,4
B4LP5B:
        MOV COL,104
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP5B

        MOV CH,5
B4LP5C:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP5C
        DEC CL
        JZ  B4LP5D
        JMP B4LP4A

B4LP5D:
        MOV CL,3
B4LP6A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
B4LP6:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP6

        MOV CH,4
B4LP7:
        MOV COL,104
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP7

        MOV CH,2
B4LP8:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP8

        MOV CH,4
B4LP8A:
        MOV COL,104
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP8A

        MOV CH,5
B4LP8B:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP8B
        DEC CL
        JZ  B4LP8BC
        JMP B4LP6A

B4LP8BC:
        MOV CL,2
B4LP9A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B4LP9:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP9

        MOV CH,12
B4LP10:
        MOV COL,104
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP10

        MOV CH,4
B4LP11:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP11
        DEC CL
        JZ  B4LP9B
        JMP B4LP9A

B4LP9B:
        MOV CL,5
B4LP12A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,10
B4LP12:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP12

        MOV CH,4
B4LP13:
        MOV COL,104
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP13

        MOV CH,5
B4LP14:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP14
        DEC CL
        JZ  B4LP12B
        JMP B4LP12A

B4LP12B:
        MOV CL,4
B4LP15:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B4LP16:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B4LP16
        DEC CL
        JNZ B4LP15

        POP DX
        POP CX
        POP BX
        POP AX
        RET
BLOCK4  ENDP

BLOCK5  PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS

        MOV CH,20
B5LP1:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP1

        MOV CL,3
B5LP2:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B5LP3:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP3
        DEC CL
        JNZ B5LP2

        MOV CL,2
B5LP4A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B5LP4:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP4

        MOV CH,12
B5LP5:
        MOV COL,111
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP5

        MOV CH,4
B5LP5A:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP5A
        DEC CL
        JZ  B5LP5B
        JMP B5LP4A

B5LP5B:
        MOV CL,3
B5LP6A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B5LP6:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP6

        MOV CH,4
B5LP7:
        MOV COL,111
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP7

        MOV CH,12
B5LP8:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP8
        DEC CL
        JZ  B5LP8A
        JMP B5LP6A

B5LP8A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B5LP9:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP9

        MOV CH,11
B5LP10:
        MOV COL,111
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP10

        MOV CH,5
B5LP11:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP11

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B5LP12:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP12

        MOV CH,12
B5LP13:
        MOV COL,111
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP13

        MOV CH,4
B5LP14:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP14

        MOV CL,3
B5LP15:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,12
B5LP16:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP16

        MOV CH,3
B5LP17:
        MOV COL,111
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP17

        MOV CH,4
B5LP18:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP18
        DEC CL
        JZ  B5LP18A
        JMP B5LP15

B5LP18A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B5LP19:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP19

        MOV CH,12
B5LP20:
        MOV COL,111
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP20

        MOV CH,4
B5LP21:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP21

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B5LP22:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP22

        MOV CH,11
B5LP23:
        MOV COL,111
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP23

        MOV CH,5
B5LP24:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP24

        MOV CL,4
B5LP25:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B5LP26:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B5LP26
        DEC CL
        JNZ B5LP25

        POP DX
        POP CX
        POP BX
        POP AX
        RET
BLOCK5  ENDP

BLOCK6  PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS

        MOV CH,20
B6LP1:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP1

        MOV CL,3
B6LP2:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B6LP3:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP3
        DEC CL
        JNZ B6LP2

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
B6LP4:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP4

        MOV CH,10
B6LP5:
        MOV COL,3
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP5

        MOV CH,5
B6LP5A:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP5A

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B6LP6:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP6

        MOV CH,11
B6LP7:
        MOV COL,3
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP7

        MOV CH,5
B6LP8:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP8

        MOV     CL,3
B6LP9A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B6LP9:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP9

        MOV CH,4
B6LP10:
        MOV COL,3
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP10

        MOV CH,12
B6LP11:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP11
        DEC     CL
        JZ      B6LP9B
        JMP     B6LP9A
B6LP9B:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B6LP12:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP12

        MOV CH,11
B6LP13:
        MOV COL,3
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP13

        MOV CH,5
B6LP14:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP14

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B6LP16:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP16

        MOV CH,12
B6LP17:
        MOV COL,3
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP17

        MOV CH,4
B6LP18:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP18

        MOV     CL,3
B6LP18A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B6LP19:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP19

        MOV CH,4
B6LP20:
        MOV COL,3
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP20

        MOV CH,5
B6LP21:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP21

        MOV CH,3
B6LP21A:
        MOV COL,3
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP21A

        MOV CH,4
B6LP21B:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP21B
        DEC     CL
        JZ      B6LP18B
        JMP     B6LP18A
B6LP18B:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B6LP22:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP22

        MOV CH,12
B6LP23:
        MOV COL,3
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP23

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
B6LP24:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP24

        MOV CH,10
B6LP25:
        MOV COL,3
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP25

        MOV CH,5
B6LP26:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP26

        MOV     CL,4
B6LP27:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B6LP28:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B6LP28
        DEC CL
        JNZ B6LP27

        POP DX
        POP CX
        POP BX
        POP AX
        RET
BLOCK6  ENDP

BLOCK7  PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS

        MOV CH,20
B7LP1:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP1

        MOV CL,3
B7LP2:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B7LP3:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP3
        DEC CL
        JNZ B7LP2

        MOV     CL,2
B7LP4A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B7LP4:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP4

        MOV CH,12
B7LP5:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP5

        MOV CH,4
B7LP5A:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP5A
        DEC     CL
        JZ      B7LP5B
        JMP     B7LP4A
B7LP5B:
        MOV     CL,3
B7LP6A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,12
B7LP6:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP6

        MOV CH,3
B7LP7:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP7

        MOV CH,4
B7LP8:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP8
        DEC     CL
        JZ      B7LP8A
        JMP     B7LP6A
B7LP8A:
        MOV     CL,2
B7LP9A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,10
B7LP9:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP9

        MOV CH,4
B7LP10:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP10

        MOV CH,5
B7LP11:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP11
        DEC     CL
        JZ      B7LP12
        JMP     B7LP9A
B7LP12:               
        MOV     CL,3
B7LP13:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,9
B7LP14:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP14

        MOV CH,4
B7LP15:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP15

        MOV CH,6
B7LP16:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP16
        DEC     CL
        JZ      B7LP17
        JMP     B7LP13
B7LP17:
        MOV     CL,2
B7LP18:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,8
B7LP19:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP19

        MOV CH,4
B7LP20:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP20

        MOV CH,7
B7LP21:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP21
        DEC     CL
        JZ      B7LP22
        JMP     B7LP18
B7LP22:
        MOV     CL,4
B7LP27:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B7LP28:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B7LP28
        DEC CL
        JNZ B7LP27

        POP DX
        POP CX
        POP BX
        POP AX
        RET
BLOCK7  ENDP

BLOCK8  PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS

        MOV CH,20
B8LP1:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP1

        MOV CL,3
B8LP2:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B8LP3:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP3
        DEC CL
        JNZ B8LP2

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
B8LP4:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP4

        MOV CH,10
B8LP5:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP5

        MOV CH,5
B8LP5A:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP5A

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B8LP6:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP6

        MOV CH,12
B8LP7:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP7

        MOV CH,4
B8LP8:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP8

        MOV     CL,3
B8LP9A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B8LP9:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP9

        MOV CH,4
B8LP10:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP10

        MOV CH,5
B8LP11:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP11

        MOV CH,3
B8LP12:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP12

        MOV CH,4
B8LP13:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP13
        DEC     CL
        JZ      B8LP14
        JMP     B8LP9A
B8LP14:               
        MOV     CL,2
B8LP14A:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
B8LP14B:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP14B

        MOV CH,10
B8LP15:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP15

        MOV CH,5
B8LP16:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP16
        DEC     CL
        JZ      B8LP17
        JMP     B8LP14A
B8LP17:
        MOV     CL,3
B8LP18:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B8LP19:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP19

        MOV CH,4
B8LP20:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP20

        MOV CH,5
B8LP21:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP21

        MOV CH,3
B8LP21A:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP21A

        MOV CH,4
B8LP21B:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP21B
        DEC     CL
        JZ      B8LP22
        JMP     B8LP18
B8LP22:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
B8LP23:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP23

        MOV CH,12
B8LP24:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP24

        MOV CH,4
B8LP25:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP25

        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
B8LP26:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP26

        MOV CH,10
B8LP27:
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP27

        MOV CH,5
B8LP28:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP28

        MOV     CL,4
B8LP29:
        MOV X_POS,AX
        INC Y_POS
        MOV COL,8
        CALL PUTPIXEL
        INC X_POS

        MOV CH,19
B8LP30:
        MOV COL,7
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ B8LP30
        DEC CL
        JNZ B8LP29

        POP DX
        POP CX
        POP BX
        POP AX
        RET
BLOCK8  ENDP

HEAD    PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV     X_POS,40
        MOV     Y_POS,10
        MOV     AX,X_POS

        MOV     CH,240
HEADLP1:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP1

        MOV X_POS,AX
        INC Y_POS

        MOV CH,240
HEADLP2:
        MOV COL,10
        CALL PUTPIXEL  
        INC X_POS
        DEC CH
        JNZ HEADLP2

        MOV X_POS,AX
        INC Y_POS

        MOV CH,239
HEADLP3:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP3
        MOV COL,0
        CALL PUTPIXEL

        MOV X_POS,AX
        INC Y_POS

        MOV CH,238
HEADLP4:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP4
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL

        MOV CL,20
HEADLP5:
        MOV X_POS,AX
        INC Y_POS

        MOV CH,4
HEADLP6:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP6

        MOV CH,234
HEADLP7:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP7

        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        DEC     CL
        JZ      HEADLP8
        JMP     HEADLP5

HEADLP8:
        MOV X_POS,AX
        INC Y_POS

        MOV CH,4
HEADLP9:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP9

        MOV CH,233
HEADLP10:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP10

        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL

        MOV X_POS,AX
        INC Y_POS

        MOV CH,4
HEADLP11:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP11

        MOV CH,232
HEADLP12:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP12

        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL

        MOV X_POS,AX
        INC Y_POS

        MOV CH,4
HEADLP13:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP13

        MOV CH,231
HEADLP14:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP14

        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL

        MOV X_POS,AX
        INC Y_POS

        MOV CH,4
HEADLP15:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP15

        MOV CH,146
HEADLP16:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP16

        MOV CH,88
HEADLP17:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP17

        MOV X_POS,AX
        INC Y_POS

        MOV CH,4
HEADLP18:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP18

        MOV CH,145
HEADLP19:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP19

        MOV CH,88
HEADLP20:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP20

        MOV X_POS,AX
        INC Y_POS

        MOV CH,4
HEADLP21:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP21

        MOV CH,144
HEADLP22:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP22

        MOV CH,88
HEADLP23:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP23

        MOV X_POS,AX
        INC Y_POS

        MOV CH,4
HEADLP24:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP24

        MOV CH,143
HEADLP25:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP25

        MOV CH,4
HEADLP26:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP26

        MOV X_POS,AX
        INC Y_POS

        MOV CH,4
HEADLP27:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP27

        MOV CH,142
HEADLP28:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP28

        MOV CH,4
HEADLP29:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP29

        MOV X_POS,AX
        INC Y_POS

        MOV CH,4
HEADLP30:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP30

        MOV CH,141
HEADLP31:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP31

        MOV CH,4
HEADLP32:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP32

        MOV X_POS,AX
        INC Y_POS

        MOV CH,4
HEADLP33:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP33

        MOV CH,140
HEADLP34:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP34

        MOV CH,4
HEADLP35:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP35

        MOV X_POS,AX
        INC Y_POS

        MOV CH,4
HEADLP36:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP36

        MOV CH,139
HEADLP37:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP37

        MOV CH,4
HEADLP38:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP38

        MOV X_POS,AX
        INC Y_POS

        MOV COL,0
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
HEADLP39:
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP39

        MOV CH,138
HEADLP40:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP40

        MOV CH,4
HEADLP41:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP41

        MOV X_POS,AX
        INC Y_POS

        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS

        MOV CH,137
HEADLP42:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP42

        MOV CH,4
HEADLP43:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP43

        MOV X_POS,AX
        INC Y_POS

        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        MOV COL,10
        CALL PUTPIXEL
        INC X_POS

        MOV CH,136
HEADLP44:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP44

        MOV CH,4
HEADLP45:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP45

        MOV X_POS,AX
        INC Y_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        MOV CH,142
HEADLP46:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP46

        MOV X_POS,AX
        INC Y_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        MOV CH,140
HEADLP47:
        MOV COL,0
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP47
;TEXT DISPLAY
        MOV     X_POS,61
        MOV     Y_POS,19
        MOV     CH,7
HEADLP48:
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP48

        MOV     X_POS,48
        MOV     Y_POS,21
        MOV     AX,X_POS

        MOV     CH,5
HEADLP49:
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP49

        INC     X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV     CH,7
HEADLP50:
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP50

        ADD     X_POS,27

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV     CH,6
HEADLP51:
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP51

        INC X_POS

        MOV     CH,6
HEADLP52:
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP52

        INC X_POS

        MOV     CH,6
HEADLP53:
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP53

        ADD     X_POS,43

        MOV     CH,8
HEADLP54:
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ HEADLP54

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        MOV X_POS,AX
        INC Y_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,27

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,6

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,6

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,43

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
;====LINE 13
        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,9

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,27

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,6

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,6
        
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,43

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

;====LINE 14
        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,27

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,6

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,6
        
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,43

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

;====LINE 15
        MOV     X_POS,AX
        INC     Y_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,27

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,6

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5
        
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,43

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

;====LINE 16 17
        MOV     X_POS,AX
        INC     Y_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS
        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,27

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,6

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3
        
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5
        
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,43

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,4

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

;====LINE 18
        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,27

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2
        
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5
        
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,43

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

;====LINE 19
        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,27

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,5
        
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,43
        
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        INC X_POS

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,2

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        ADD     X_POS,3

        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS
        MOV COL,15
        CALL PUTPIXEL
        INC X_POS

        POP DX
        POP CX
        POP BX
        POP AX
        RET
HEAD    ENDP

NUM1    PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS
        MOV DL,COL

        MOV CH,6
NUM1LP1:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP1

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
NUM1LP2:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP2

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM1LP3:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP3

        MOV CH,4
NUM1LP4:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP4

        MOV CH,4
NUM1LP5:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP5

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM1LP6:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP6

        MOV CH,5
NUM1LP7:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP7

        MOV CH,4
NUM1LP8:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP8

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM1LP9:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP9

        MOV CH,4
NUM1LP10:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP10

        MOV CH,4
NUM1LP11:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP11

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,5
NUM1LP12:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP12

        MOV CH,3
NUM1LP13:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP13

        MOV CH,4
NUM1LP14:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP14

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,5
NUM1LP15:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP15

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,5
NUM1LP16:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP16

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM1LP17:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP17

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,5
NUM1LP18:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP18

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM1LP19:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP19
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,6
NUM1LP20:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP20

        MOV     CL,2
NUM1LP23:
        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM1LP21:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP21

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,6
NUM1LP22:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP22
        DEC     CL
        JZ      NUM1LP24
        JMP     NUM1LP23
NUM1LP24:        
        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM1LP25:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP25

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS

        MOV CH,7
NUM1LP26:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM1LP26

        POP DX
        POP CX
        POP BX
        POP AX
        RET
NUM1    ENDP

NUM2    PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS
        MOV DL,COL

        MOV CH,5
NUM2LP1:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP1

        MOV CH,4
NUM2LP1A:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP1A

        MOV CH,3
NUM2LP2:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP2

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM2LP3:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP3

        MOV CH,6
NUM2LP4:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP4

        MOV CH,2
NUM2LP5:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP5

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM2LP6:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP6

        MOV CH,3
NUM2LP7:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP7

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM2LP8:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP8

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM2LP9:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP9

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS


        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM2LP10:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP10

        MOV CH,2
NUM2LP11:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP11

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,6
NUM2LP12:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP12

        MOV CH,3
NUM2LP13:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP13

        MOV CH,3
NUM2LP14:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP14

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,5
NUM2LP15:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP15

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
NUM2LP16:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP16

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM2LP17:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP17

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,5
NUM2LP18:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP18

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM2LP19:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP19

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,6
NUM2LP20:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP20

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM2LP21:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP21

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM2LP22:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP22

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,2
NUM2LP23:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP23

        MOV CH,8
NUM2LP24:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP24

        MOV CH,2
NUM2LP25:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP25

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM2LP26:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP26

        MOV CH,5
NUM2LP27:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP27

        MOV CH,4
NUM2LP28:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM2LP28

        POP DX
        POP CX
        POP BX
        POP AX
        RET
NUM2    ENDP

NUM3    PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS
        MOV DL,COL

        MOV CH,4
NUM3LP1:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP1

        MOV CH,5
NUM3LP1A:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP1A

        MOV CH,3
NUM3LP2:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP2

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM3LP3:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP3

        MOV CH,7
NUM3LP4:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP4

        MOV CH,2
NUM3LP5:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP5

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM3LP6:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP6

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
 
        MOV CH,3
NUM3LP7:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP7

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,7
NUM3LP9:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP9

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM3LP11:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP11

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,6
NUM3LP12:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP12

        MOV CH,2
NUM3LP13:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP13

        MOV CH,4
NUM3LP14:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP14

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,6
NUM3LP12A:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP12A

        MOV CH,2
NUM3LP13A:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP13A

        MOV CH,4
NUM3LP14A:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP14A

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,7
NUM3LP15:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP15

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM3LP16:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP16

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM3LP17:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP17

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM3LP18:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP18

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,2
NUM3LP17A:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP17A

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM3LP18A:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP18A

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,2
NUM3LP23:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP23

        MOV CH,8
NUM3LP24:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP24

        MOV CH,2
NUM3LP25:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP25

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM3LP26:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP26

        MOV CH,5
NUM3LP27:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP27

        MOV CH,3
NUM3LP28:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM3LP28

        POP DX
        POP CX
        POP BX
        POP AX
        RET
NUM3    ENDP

NUM4    PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS
        MOV DL,COL

        MOV CH,6
NUM4LP1:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP1

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
NUM4LP2:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP2

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,5
NUM4LP3:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP3

        MOV CH,3
NUM4LP4:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP4

        MOV CH,4
NUM4LP5:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP5

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM4LP6:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP6

        MOV CH,4
NUM4LP6A:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP6A
 
        MOV CH,4
NUM4LP7:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP7

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM4LP9:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP9

        MOV CH,3
NUM4LP10:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP10

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM4LP11:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP11

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM4LP12:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP12

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM4LP13:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP13

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM4LP14:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP14

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM4LP14A:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP14A

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM4LP14B:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP14B

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM4LP15:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP15

        MOV CH,3
NUM4LP16:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP16

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV    COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,8
NUM4LP17:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP17

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     CL,3
NUM4LP18:
        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,6
NUM4LP19:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP19

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
NUM4LP20:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM4LP20
        DEC     CL
        JZ      NUM4LP21
        JMP     NUM4LP18
NUM4LP21:
        POP DX
        POP CX
        POP BX
        POP AX
        RET
NUM4    ENDP

NUM5    PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS
        MOV DL,COL

        MOV CH,5
NUM5LP1:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP1

        MOV CH,4
NUM5LP1A:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP1A

        MOV CH,3
NUM5LP2:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP2

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM5LP3:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP3

        MOV CH,6
NUM5LP4:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP4

        MOV CH,3
NUM5LP5:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP5

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,2
NUM5LP6:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP6

        MOV CH,4
NUM5LP6A:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP6A
 
        MOV CH,6
NUM5LP7:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP7

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,2
NUM5LP9:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP9

        MOV CH,3
NUM5LP10:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP10

        MOV CH,7
NUM5LP11:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP11

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,2
NUM5LP12:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP12

        MOV CH,7
NUM5LP13:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP13

        MOV CH,3
NUM5LP13A:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP13A

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM5LP14:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP14

        MOV CH,6
NUM5LP14A:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP14A

        MOV CH,3
NUM5LP14B:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP14B

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,8
NUM5LP15:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP15

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,7
NUM5LP16:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP16

        MOV CH,3
NUM5LP17:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP17

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM5LP18:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP18

        MOV CH,4
NUM5LP19:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP19

        MOV CH,4
NUM5LP20:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP20

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM5LP21:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP21

        MOV CH,5
NUM5LP22:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP22

        MOV CH,4
NUM5LP23:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP23

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM5LP24:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP24

        MOV CH,4
NUM5LP25:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP25

        MOV CH,4
NUM5LP26:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM5LP26

        POP DX
        POP CX
        POP BX
        POP AX
        RET
NUM5    ENDP

NUM6    PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS
        MOV DL,COL

        MOV CH,5
NUM6LP1:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP1

        MOV CH,3
NUM6LP1A:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP1A

        MOV CH,4
NUM6LP2:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP2

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM6LP3:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP3

        MOV CH,4
NUM6LP4:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP4

        MOV CH,4
NUM6LP5:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP5

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM6LP6:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP6

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
 
        MOV CH,7
NUM6LP7:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP7

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM6LP9:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP9

        MOV CH,2
NUM6LP10:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP10

        MOV CH,7
NUM6LP11:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP11

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM6LP9C:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP9C

        MOV CH,5
NUM6LP10C:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP10C

        MOV CH,4
NUM6LP11C:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP11C

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,2
NUM6LP12:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP12

        MOV CH,7
NUM6LP13:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP13

        MOV CH,3
NUM6LP13A:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP13A

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM6LP14:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP14

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM6LP14C:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP14C

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS


        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM6LP16:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP16

        MOV CH,5
NUM6LP17:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP17

        MOV CH,4
NUM6LP18:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM6LP18

        POP DX
        POP CX
        POP BX
        POP AX
        RET
NUM6    ENDP

NUM7    PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS
        MOV DL,COL

        MOV CH,3
NUM7LP1:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP1

        MOV CH,7
NUM7LP2:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP2

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,8
NUM7LP3:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP3

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
NUM7LP4:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP4

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
 
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
NUM7LP5:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP5

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM7LP6:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP6

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,6
NUM7LP7:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP7

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
NUM7LP8:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP8

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,6
NUM7LP9:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP9

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
NUM7LP10:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP10

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM7LP11:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP11

        MOV CH,3
NUM7LP12:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP12

        MOV CH,5
NUM7LP13:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP13

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM7LP14:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP14

        MOV CH,3
NUM7LP15:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP15

        MOV CH,5
NUM7LP16:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP16

        MOV     CL,3
NUM7LP17:
        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM7LP18:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP18

        MOV CH,2
NUM7LP19:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP19

        MOV CH,6
NUM7LP20:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM7LP20
        DEC     CL
        JZ      NUM7LP21
        JMP     NUM7LP17
NUM7LP21:

        POP DX
        POP CX
        POP BX
        POP AX
        RET
NUM7    ENDP

NUM8    PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS
        MOV DL,COL

        MOV CH,3
NUM8LP1:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP1

        MOV CH,5
NUM8LP2:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP2

        MOV CH,4
NUM8LP3:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP3

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM8LP4:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP4

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM8LP5:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP5

        MOV CH,3
NUM8LP6:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP6

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM8LP7:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP7

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
 
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM8LP8:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP8

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM8LP9:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP9

        MOV CH,3
NUM8LP10:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP10

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM8LP11:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP11

        MOV CH,5
NUM8LP12:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP12

        MOV CH,4
NUM8LP13:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP13

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,7
NUM8LP14:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP14

        MOV CH,3
NUM8LP15:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP15

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
NUM8LP16:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP16

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM8LP17:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP17

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM8LP18:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP18

        MOV CH,4
NUM8LP19:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP19

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
NUM8LP20:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP20

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM8LP21:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP21

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,7
NUM8LP22:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP22

        MOV CH,3
NUM8LP23:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP23

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM8LP24:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP24

        MOV CH,5
NUM8LP25:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP25

        MOV CH,4
NUM8LP26:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM8LP26

        POP DX
        POP CX
        POP BX
        POP AX
        RET
NUM8    ENDP

NUM9    PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS
        MOV DL,COL

        MOV CH,3
NUM9LP1:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP1

        MOV CH,6
NUM9LP2:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP2

        MOV CH,3
NUM9LP3:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP3

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM9LP4:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP4

        MOV CH,3
NUM9LP5:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP5

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,5
NUM9LP7:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP7

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
 
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM9LP8:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP8

        MOV CH,3
NUM9LP9:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP9

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
NUM9LP11:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP11

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM9LP12:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP12

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM9LP13:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP13

        MOV CH,6
NUM9LP14:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP14

        MOV CH,3
NUM9LP15:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP15

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,6
NUM9LP16C:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP16C

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM9LP17C:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP17C

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,6
NUM9LP16:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP16

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV CH,4
NUM9LP17:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP17

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,5
NUM9LP18:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP18

        MOV CH,3
NUM9LP19:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP19

        MOV CH,4
NUM9LP20:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP20

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM9LP21:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP21

        MOV CH,4
NUM9LP22:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP22

        MOV CH,4
NUM9LP23:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP23

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM9LP24:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP24

        MOV CH,3
NUM9LP25:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP25

        MOV CH,5
NUM9LP26:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM9LP26

        POP DX
        POP CX
        POP BX
        POP AX
        RET
NUM9    ENDP

NUM0    PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS
        MOV DL,COL

        MOV CH,4
NUM0LP1:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP1

        MOV CH,4
NUM0LP2:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP2

        MOV CH,4
NUM0LP3:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP3

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM0LP4:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP4

        MOV CH,6
NUM0LP5:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP5

        MOV CH,3
NUM0LP7:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP7

        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,8
NUM0LP8:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP8

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     CL,5
NUM0LP13:
        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,3
NUM0LP11:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP11

        MOV CH,3
NUM0LP12:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP12

        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        CALL PUTPIXEL
        INC X_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC     CL
        JZ      NUM0LP14
        JMP     NUM0LP13

NUM0LP14:
        MOV     X_POS,AX
        INC     Y_POS

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV CH,8
NUM0LP16:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP16

        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,3
NUM0LP17:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP17

        MOV CH,6
NUM0LP18:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP18

        MOV CH,3
NUM0LP19:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP19

        MOV     X_POS,AX
        INC     Y_POS

        MOV CH,4
NUM0LP21:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP21

        MOV CH,4
NUM0LP22:
        MOV     COL,DL
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP22

        MOV CH,4
NUM0LP23:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ NUM0LP23

        POP DX
        POP CX
        POP BX
        POP AX
        RET
NUM0    ENDP

CLRNUM   PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV AX,X_POS
        MOV     CL,11
CLRNUMLP2:
        MOV     CH,12
CLRNUMLP1:
        MOV COL,2
        CALL PUTPIXEL
        INC X_POS
        DEC CH
        JNZ CLRNUMLP1

        MOV     X_POS,AX
        INC     Y_POS
        DEC     CL
        JNZ     CLRNUMLP2

        POP DX
        POP CX
        POP BX
        POP AX
        RET
CLRNUM  ENDP

INAME       PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        MOV     X_POS,40
        MOV     Y_POS,75

        MOV     CL,5
IPNLP2:
        MOV     CH,240
IPNLP1:
        MOV COL,15
       CALL PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     IPNLP1
        MOV     X_POS,40
        INC     Y_POS
        DEC     CL
        JNZ     IPNLP2

        MOV     CL,40
IPNLP6:
        MOV     CH,5
IPNLP3:
        MOV COL,15
       CALL PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     IPNLP3

        MOV     CH,230
IPNLP4:
        MOV COL,0
       CALL PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     IPNLP4

        MOV     CH,5
IPNLP5:
        MOV COL,15
       CALL PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     IPNLP5
        MOV     X_POS,40
        INC     Y_POS
        DEC     CL
        JZ      IPNLP7
        JMP     IPNLP6
IPNLP7:
        MOV     CL,5
IPNLP8:
        MOV     CH,240
IPNLP9:
        MOV COL,15
        CALL PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     IPNLP9
        MOV     X_POS,40
        INC     Y_POS
        DEC     CL
        JNZ     IPNLP8

        POP DX
        POP CX
        POP BX
        POP AX

        RET
INAME       ENDP

POINTER         PROC
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX

        MOV     AX,X_POS
        MOV     Y_POS,150
        ADD     X_POS,12
        CALL    PUTPIXEL

        MOV     X_POS,AX
        INC     Y_POS
        ADD     X_POS,12
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL

        MOV     X_POS,AX
        INC     Y_POS
        ADD     X_POS,12
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL

        MOV     X_POS,AX
        INC     Y_POS
        ADD     X_POS,12
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL

        MOV     X_POS,AX
        INC     Y_POS
        ADD     X_POS,12
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL

        MOV     X_POS,AX
        INC     Y_POS

        MOV     CH,18
PTRLP1:
        CALL    PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     PTRLP1

        MOV     X_POS,AX
        INC     Y_POS
        MOV     CH,19
PTRLP2:
        CALL    PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     PTRLP2

        MOV     X_POS,AX
        INC     Y_POS
        MOV     CH,20
PTRLP3:
        CALL    PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     PTRLP3

        MOV     X_POS,AX
        INC     Y_POS
        MOV     CH,19
PTRLP4:
        CALL    PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     PTRLP4

        MOV     X_POS,AX
        INC     Y_POS
        MOV     CH,18
PTRLP5:
        CALL    PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     PTRLP5

        MOV     X_POS,AX
        INC     Y_POS
        ADD     X_POS,12
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL

        MOV     X_POS,AX
        INC     Y_POS
        ADD     X_POS,12
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL

        MOV     X_POS,AX
        INC     Y_POS
        ADD     X_POS,12
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL

        MOV     X_POS,AX
        INC     Y_POS
        ADD     X_POS,12
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL

        MOV     X_POS,AX
        INC     Y_POS
        ADD     X_POS,12
        CALL    PUTPIXEL

        POP DX
        POP CX
        POP BX
        POP AX

        RET
POINTER     ENDP


LOADBMP PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

	MOV BMP_COUNT,0

;OPEN BMP FILE
	MOV DX,SI
	MOV AX,3D00H
	INT 21H
	JC  ERROR_BMP_1
	MOV BX,AX
;SEEK TO COLOR
	MOV AX,4200H
	XOR CX,CX
	MOV DX,54D
	INT 21H
;SET COLOR
COLOR_BMP_LOOP:
;READ 4 BYTES FROM BMP FILE TO BUFFER
	MOV AH,3FH
	MOV CX,4
	LEA DX,BMP_BUFFER
	INT 21H

	PUSH BX
	MOV BX,BMP_COUNT
	MOV [BMP_BUFFER + 3],4
	XOR AX,AX
	MOV AL,[BMP_BUFFER + 1]	;GREEN	
	DIV [BMP_BUFFER + 3]
	MOV CH,AL
	MOV AL,[BMP_BUFFER + 0]	;BLUE
	DIV [BMP_BUFFER + 3]
	MOV CL,AL
	MOV AL,[BMP_BUFFER + 2]	;RED
	DIV [BMP_BUFFER + 3]
	MOV DH,AL
	MOV AX,1010H
	INT 10H
	INC BMP_COUNT
	POP BX
	CMP BMP_COUNT,256D
	JGE EXIT_COLOR_LOOP
	JMP COLOR_BMP_LOOP

ERROR_BMP_1:
	JMP ERROR_BMP_2
EXIT_COLOR_LOOP:

;SEEK TO HEIGHT
	MOV AX,4200H
	XOR CX,CX
	MOV DX,22D
	INT 21H
;READ HEIGHT TO BUFFER AND SAVE TO BMP_HEIGHT
	MOV AH,3FH
	MOV CX,2
	LEA DX,BMP_BUFFER
	INT 21H
	MOV AX,WORD PTR BMP_BUFFER
	MOV BMP_HEIGHT,AX
;SEEK TO WIDTH
	MOV AX,4200H
	XOR CX,CX
	MOV DX,18D
	INT 21H
;READ WIDTH TO BUFFER AND SAVE TO BMP_WIDTH
	MOV AH,3FH
	MOV CX,2
	LEA DX,BMP_BUFFER
	INT 21H
	MOV AX,WORD PTR BMP_BUFFER
	MOV BMP_WIDTH,AX
;SEEK TO BIT IMAGE
	MOV AX,4200H
	XOR CX,CX
	MOV DX,1078D
	INT 21H

	MOV AX,BMP_X		;AX = BMP_X
	PUSH BX			
	MOV BX,BMP_Y
	ADD BX,BMP_HEIGHT
	MOV CX,320
ADD_BMP_COUNT:
	ADD AX,BX		;AX += (BMY_Y+BMP_H)*320
	LOOP ADD_BMP_COUNT
	POP BX

	MOV BMP_COUNT,AX	;USE FOR POINT TO VGA MEMORY
	MOV CX,BMP_WIDTH	;USE IN READ FILE FUNCTION(READ EACH BMP_WIDTH BYTES)
;COMPUTE BLANK PIXEL
SUB_BMP_WIDTH:
	SUB BMP_WIDTH,4
	CMP BMP_WIDTH,4
	JLE EXIT_SUB_BMP_WIDTH
	JMP SUB_BMP_WIDTH
EXIT_SUB_BMP_WIDTH:
	MOV AX,4
	SUB AX,BMP_WIDTH
	MOV BMP_WIDTH,AX
SHOW_BMP_LOOP:
;UPDATE BMP_COUNT
	SUB BMP_COUNT,320	;SUB BY WIDTH
	MOV DX,BMP_COUNT
;READ BMP TO VGA MEMORY	
	PUSH DS			;SAVE DS(FROM MAIN)	
	MOV AX,0A000H		;VGA MEMORY
	MOV DS,AX		;POINT TO VGA MEMORY
	XOR AX,AX		;CLEAR AX
	MOV AH,3FH		;READ FILE FUNCTION
	INT 21H			;TO BUFFER DS:DX
	POP DS

;POINT PASS THE BLANK BMP PIXEL
	PUSH AX
	PUSH CX
	PUSH DX
	MOV AX,4201H
	XOR CX,CX
	MOV DX,BMP_WIDTH
	INT 21H
	POP DX
	POP CX
	POP AX


;CHECK FOR END OF FILE AND EXIT LOOP
	CMP AX,CX		;CHECK EOF?
	JL EXIT_BMP
	JMP SHOW_BMP_LOOP

EXIT_BMP:
;CLOSE BMP FILE
	MOV AH,3EH
	INT 21H
ERROR_BMP_2:

	POP DX
	POP CX
	POP BX
	POP AX
	RET
LOADBMP ENDP

WINBG           PROC

        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        MOV     X_POS,40
        MOV     Y_POS,80

        MOV     CL,5
WINLP2:
        MOV     CH,240
WINLP1:
        MOV     COL,0
        CALL    PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     WINLP1
        MOV     X_POS,40
        INC     Y_POS
        DEC     CL
        JNZ     WINLP2

        MOV     CL,80
WINLP6:
        MOV     CH,5
WINLP3:
        MOV     COL,0
        CALL    PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     WINLP3

        MOV     CH,230
WINLP4:
        MOV     COL,2
        CALL    PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     WINLP4

        MOV     CH,5
WINLP5:
        MOV     COL,0
        CALL    PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     WINLP5
        MOV     X_POS,40
        INC     Y_POS
        DEC     CL
        JZ      WINLP7
        JMP     WINLP6
WINLP7:
        MOV     CL,5
WINLP8:
        MOV     CH,240
WINLP9:
        MOV     COL,0
        CALL    PUTPIXEL
        INC     X_POS
        DEC     CH
        JNZ     WINLP9
        MOV     X_POS,40
        INC     Y_POS
        DEC     CL
        JNZ     WINLP8

        MOV     X_POS,40
        MOV     Y_POS,96
        MOV     COL,1
        
        ADD     X_POS,44
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,10
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,42
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,37
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS


        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,42
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,8
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,42
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,8
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,42
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,37
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS


        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,42
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,8
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        MOV     Y_POS,115
        MOV     COL,4
        
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,4
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,7
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,7
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,49
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,7
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,6
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,7
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,6
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,6
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,49
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,6
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,5
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,5
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        MOV     Y_POS,135
        MOV     COL,15
        
        ADD     X_POS,44
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,4
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,42
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,11
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,53
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,7
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,47
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,6
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,53
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,2
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        MOV     X_POS,40
        INC     Y_POS
        ADD     X_POS,43
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,3
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        ADD     X_POS,4
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS
        CALL    PUTPIXEL
        INC     X_POS

        POP DX
        POP CX
        POP BX
        POP AX

        RET
WINBG           ENDP



END
