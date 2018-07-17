;sound.asm      BWSB sound engine for Bush Land
.model small

include bwsb.inc                        ;external declarations
include gdmtype.inc                     ;GDM module file format structures

.386
.stack 512
.data

ModHead         GDMHeader   <?>

MSEConfigFile  struc
  SoundCard     dw      ?
  BaseIO        dw      ?
  IRQ           dw      ?
  DMA           dw      ?
  SoundQuality  dw      ?
MSEConfigFile   ends

MSEConfig       MSEConfigFile   <?>
MSECFGFileName  db      'MSE.CFG',0     ;Name of MSE.CFG file

MSEOversample   db      16, 22, 45, 8

Temp            dw      ?
Temp2           dw      ?


MSEFile         db      'GUS.MSE',0,"  "
                db      'SB1X.MSE',0," "
                db      'SB2X.MSE',0," "
                db      'SBPRO.MSE',0,""
                db      'SB16.MSE',0," "
                db      'PAS.MSE',0,"  "

ModFile         db      'among.gdm',0


old_int86 dd     ?

param   dw      0                       ;environment ptr
        dw      ctail                   ;command tail ptr
        dw      @data
        dw      0                       ;fcb1
        dw      0
        dw      0                       ;fcb2
        dw      0
filnam  db      'game.exe',0
ctail   db      08h,'        ',13
filnam1 db      'sound.ok',0
.code

Start:
        mov     ah,4Ah                  ;Shrink program memory for more free
        mov     bx,01830h               ;Keep 64K of memory
        int     21h

        mov     ax,@data                ;Initialize segment registers
        mov     ds,ax
        mov     es,ax

        mov     ah,35h                  ;get and save old int 86h vector
        mov     al,86h
        int     21h
        mov     word ptr old_int86[0],bx
        mov     word ptr old_int86[2],es

        push    ds                      ;set new int 86h vector
        mov     ax,cs
        mov     ds,ax
        mov     dx,offset fx_int
        mov     ah,25h
        mov     al,86h
        int     21h
        pop     ds

        call    sok                     ;create the sound ok semaphor


        mov     ax,3D00h                ;Open config file for read only
        mov     dx,offset MSECFGFileName
        int     21h
        jnc     @1                      ;Continue program if no errors

MSEError:
        jmp     Exit                    ;Return to DOS
@1:
        mov     bx,ax                   ;Put file handle in correct register
        mov     dx,offset MSEConfig     ;Load config file into our structure
        mov     cx,size MSEConfigFile   ;Read in only the right number of bytes
        mov     ah,3Fh                  ;3Fh - Read from Handle
        int     21h
        jc      MSEError                ;Quit if error while loading

        cmp     ax,size MSEConfigFile   ;Did we read the right number of bytes?
        jb      MSEError                ;Display error if MSE.CFG is too small

        mov     ah,3Eh                  ;Close file handle
        int     21h

        mov     bx,MSEConfig.SoundCard  ;Get sound card to load MSE for
        dec     bx
        mov     ax,10                   ;multiply sound card # by 10 for table
        mul     bl
        mov     bx,ax
        add     bx,offset MSEFile       ;ds:bx - ASCIIZ filename of MSE to load

        xor     edi,edi                 ;load from offset 0
        movzx   eax,MSEConfig.SoundQuality
        mov     ah,[MSEOversample+eax]  ;45KHz oversampling (or whatever is max)
        mov     al,10h                  ;4096 byte mixing buffer
        mov     dx,MSEConfig.BaseIO     ;Base I/O Address of sound card
        mov     ch,byte ptr MSEConfig.IRQ ;IRQ level of sound card
        mov     cl,byte ptr MSEConfig.DMA ;DMA channel of sound card

        call    LoadMSE                 ;Load the MSE file
        or      ax,ax                   ;Was there an error loading the MSE?
        jz      @2                      ;Skip over error if none

        jmp     Exit                    ;Return to DOS

@2:
        mov     MSEConfig.BaseIO, dx    ; save autodetected information
        mov     byte ptr MSEConfig.IRQ, ch
        mov     byte ptr MSEConfig.DMA, cl

        call    DeviceName              ;returns: dx:ax - pointer to dev name


LoadModule:

        mov     ax,3D00h                ;Open module for read only
        mov     dx,offset ModFile
        int     21h
        jnc     @3

        jmp     Exit                    ;Return to dos
@3:
        mov     Temp,ax                 ;save file handle

        call    EmsExist                ;Find out if EMS memory exists
        and     al,1                    ;Only keep bit 0
        mov     bl,al                   ;Set load flags

        mov     ax,Temp                 ;File Handle to load from
        xor     ecx,ecx                 ;File offest to load from: 0
        mov     dx,ds
        mov     di,offset ModHead
        call    LoadGDM

        push    bx
        mov     ah,3Eh                  ;Close module file handle
        mov     bx,Temp
        int     21h
        pop     bx

        or      bl,bl
        jz      @4

        jmp     Exit                    ;Return to DOS
@4:
        mov     cx,32
        mov     bx,offset ModHead.PanMap
        xor     al,al                   ;channel counter set to zero
ChanScanLoop:
        cmp     byte ptr ds:[bx], 0FFh
        je      @5
        inc     al                      ;increment channel counter
@5:
        inc     bx
        dec     cx
        jnz     ChanScanLoop

        add     al,4                    ;4 more channels for fx


        mov     byte ptr Temp, al
        call    StartOutput
        mov     Temp2, ax


        mov     ah,48
        call    MusicVolume

        call    StartMusic

        call    game

xit:
        call    StopMusic
        call    StopOutput
        call    UnloadModule
        call    FreeMSE

Exit:
        push    ds                      ;restore old int 86h vector
        lds     dx,old_int86
        mov     ah,25h
        mov     al,86h
        int     21h
        pop     ds

        call    soke                    ;erase the sound ok semaphor

        mov     ax,4C00h
        int     21h


game    proc
        push    ss
        push    sp
        push    ds
        push    es


        mov     bx,offset param
        mov     dx,offset filnam
        mov     ax,4B00h
        int     21h
        jnc     exok
        add     al,65
        mov     ah,02h
        mov     dl,al
        int     21h
exok:
        pop     es
        pop     ds
        pop     sp
        pop     ss



        ret
game    endp

sok     proc
        mov     dx,offset filnam1       ;create a file
        mov     cx,0
        mov     ah,3Ch
        int     21h

        mov     bx,ax                   ;get handle

        mov     ah,3Eh                  ;close
        int     21h
        ret
sok     endp

soke    proc
        mov     dx,offset filnam1       ;delete file
        mov     cx,0
        mov     ah,41h
        int     21h
        ret
soke    endp



fx_int  proc    far
        sti                             ;ISR 86h play sample
        push    ds
        push    ax
        push    bx
        push    cx
        push    dx

        push    ax
        mov     ax,@data
        mov     ds,ax
        pop     ax

fx1:
        cmp     ah,6
        jne     fx2

        mov     bl,5                    ;channel
        mov     cl,31                   ;sample #
        mov     ax,7936                 ;rate
        mov     dl,64                   ;volume
        mov     dh,8                    ;pan
        call    PlaySample
        jmp     fxend
fx2:
        cmp     ah,7
        jne     fx3

        mov     bl,6
        mov     cl,32
        mov     ax,7936
        mov     dl,64
        mov     dh,8
        call    PlaySample
        jmp     fxend
fx3:
        cmp     ah,8
        jne     fx4

        mov     bl,7
        mov     cl,33
        mov     ax,11025
        mov     dl,64
        mov     dh,8
        call    PlaySample
        jmp     fxend
fx4:
        cmp     ah,9
        jne     fx5

        mov     bl,8
        mov     cl,34
        mov     ax,11025
        mov     dl,64
        mov     dh,8
        call    PlaySample
        jmp     fxend
fx5:
        cmp     ah,10
        jne     fxend

        mov     bl,5
        mov     cl,30
        mov     ax,7936
        mov     dl,64
        mov     dh,8
        call    PlaySample
        jmp     fxend



fxend:
        mov     al,20h                  ;reset ints
        out     20h,al                  ; in interupt controler (pic)

        pop     dx
        pop     cx
        pop     bx
        pop     ax
        pop     ds
        iret
fx_int  endp



        end     Start
