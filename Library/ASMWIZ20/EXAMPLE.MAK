PROJ    =EXAMPLE
DEBUG   =0
CC  =qcl
AS  =qcl
CFLAGS_G    = /AS /W1 /Ze
CFLAGS_D    = /Zi /Zr /Gi$(PROJ).mdt /Od
CFLAGS_R    = /O /Ol /DNDEBUG
CFLAGS  =$(CFLAGS_G) $(CFLAGS_R)
AFLAGS_G    = /Cx /W1 /P1
AFLAGS_D    = /Zi
AFLAGS_R    = /DNDEBUG
AFLAGS  =$(AFLAGS_G) $(AFLAGS_R)
LFLAGS_G    = /CP:0xfff /NOI /NOE /SE:0x80 /T /ST:0x800
LFLAGS_D    =
LFLAGS_R    =
LFLAGS  =$(LFLAGS_G) $(LFLAGS_R)
RUNFLAGS    =
OBJS_EXT =
LIBS_EXT =  asmwiz.lib

.asm.obj: ; $(AS) $(AFLAGS) -c $*.asm

all:    $(PROJ).COM

example.obj:    example.asm

$(PROJ).COM:    example.obj $(OBJS_EXT)
    echo >NUL @<<$(PROJ).crf
example.obj +
$(OBJS_EXT)
$(PROJ).COM

$(LIBS_EXT);
<<
    link $(LFLAGS) @$(PROJ).crf

run: $(PROJ).COM
    $(PROJ) $(RUNFLAGS)
