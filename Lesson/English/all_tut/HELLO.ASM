;hello.asm  Lesson 1, first assembly lanugage program

.model small                            ;set memory model
.386                                    ;allow up to 80386 instructions
.stack                                  ;start the stack segment

.data                                   ;start the data segment

message db      'Hello world!',13,10,36 ;a dos string definition

.code                                   ;start the code segment


main:                                   ;a label, name that you can refer to
        mov     ax,@data                ;load the name of the data segment
        mov     ds,ax                   ;put the name in the data segment
                                        ; register

        mov     dx,offset message       ;tell print where the string is
        mov     ah,9                    ;dos function 9 = print string
        int     21h                     ;call dos

        mov     ah,4Ch                  ;dos function 4Ch = exit to dos
        int     21h                     ;call dos


        end     main                    ;end program, entry point is 'main'








comment #

You always need to set up your data segment to point to your data DS

DOS provides services that are preprogrammed for you to use.  You call these
services by causing an INTerrupt.  Interrupt 21h is the main DOS service int.
You always call int functions by placing a function number in AH.  Some
functions require other registers to be set before you call them.  In the print
string function 9, in addition to making ah=9, it also wants to know
where the string you want to print is located, its address.  You need 2 parts
to make up an address in memory.  The segment (DS) and the offset (DX)

Function 4Ch is the exit to dos function.  You need to make AH=4Ch and
AL=return_code.  The normal return code is 0.  If you had an error you could
make the return code some number like 1.  This is useful for batch files:

        if errorlevel=1 then goto :bad_stuff_happened

the next to last line is defines the string of characters, message, that we are
going to print.  Note the 13,10,36 at the end.
        13 = carriage return
        10 = new line
        36 = ascii '$'

DOS strings are always terminated with a $ sign.  DOS starts printing at 'H and
prints until it finds a $ sign.  So if you dont have one, you'll print a bunch
of junk or possibly crash your program.

There are 2 kinds of labels here.  Code labels always have a : and are places
you can jump to or refer to in other ways like stating where the start of the
program is, or the entry point.  Data labels do not have colons and are
usually followed by a data type which defines the size of the data.  Every
thing on the line after DB which means Define Byte will be data that is
the size of one byte, 8 bits. You might see data sizes DW (Define Word, 16 bits)
DD (Define Double word, 32 bits)

The memory model defines how the assembler will address memory, the size of
segments and their default names.  In the case of .model small, all you need to
know right now is that .code is the start of the code segment and it can be a
maximum of 65536 bytes long.  .stack is the stack segment and it could also be
a max of 65536 bytes long.  .data is where all the data is defined, the data
segment, max 65536 bytes long.  Its real name is @data.  This is 16 bit memory
addressing.  A pointer to some data in memory like DX will always be 16 bit.
Other memory models might have different segment sizes and names and use a
combination of 32 bit and 16 bit pointers.


If all this seems confusing, dont worry about it, just make the program with:

        tasm hello      (you start with hello.asm and get hello.obj)
        tlink hello     (you start with hello.obj and get hello.exe)

run hello.exe of course

#
