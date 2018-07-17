
calc.com:       calc.obj
                link /l /m /dosseg calc
                exe2bin calc.exe calc.com

calc.obj:       calc.asm
                tasm /zi /m calc

