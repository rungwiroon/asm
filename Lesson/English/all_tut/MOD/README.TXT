build this program with

        make.bat

to automaticly run setup if sound config file does not exist, run the

        runme.bat

this example is setup to execute game.exe and play the mod, push 1 2 3 4 or 5
to play the sound effects


to run YOUR program, look in the data segment and simply replace the string
'game.exe' with your program name

the program plays sound fx by hooking int 86h b4 it executes your program.
to call a sound effect, you must put a sound effect number in ah and do

        int 86h

your program can be real mode or pmode

currently, you can use ah = 5 6 7 8 9 or 10
you could change all that tho, simple add cmp's to fx_int

the following mapping shows which mod sample will be played if you use ah=#

        5  31
        6  32
        7  33
        8  34
        9  35
        10 30


you must place the desired sound effect inside the mod you are playing
at the sample slot you want to use. if you look inside fx_int proc you can
see that it looks to see what # is in ah and sets

        bl=channel
        cl=sample slot

and then calls the play_sample routine inside the library which in turn
calls the function in the mse library for your card

i used channels 5 6 7 8 in the mod since channels 1 2 3 4 were used for music


example sound effect call from your program:

        mov     ah,7
        int     86h
