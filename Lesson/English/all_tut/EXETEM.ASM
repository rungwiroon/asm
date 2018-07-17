;title

.model small
.386
.stack
.data


blah    db      'whatever'


.code

main    proc
        mov     ax,@data
        mov     ds,ax



        mov     ax,4C00h
        int     21h

main    endp

        end     main
