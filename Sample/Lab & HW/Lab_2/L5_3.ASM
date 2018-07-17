        .model small
        .stack 100h
        .code

        extrn dispbin:far

main proc near

     mov        ah,1
     int        21h
     call       dispB
     mov        ah,4ch    ;end program
     int        21h       ;same int 20h

main endp
     end main
