SORT PROC
        PUSH  BX
        PUSH  CX
        PUSH  DX
        PUSH  SI
        DEC   BX                ;N=N-1
        JE    END_SORT          ;EXIT IF 1-ELT ARRAY
        ;XOR   SI,SI

        MOV   DX,SI             ;SAVE ARRAY OFFSET
;FOR N-1 TIMES DO
SORT_LOOP:
        MOV   SI,DX             ;SI PTS TO ARRAY
        MOV   CX,BX             ;NO. OF MOMPARISONS TO MAKE
        MOV   DI,SI             ;DI PTS TO TARGEST ELEMENT
        MOV   AX,[DI]           ;AL HAS LARGEST ELEMENT
;LOCATE BIGGEST OF REMAINING ELTS
FIND_BIG:
        ADD   SI,2              ;SI PTS OT NEXT ELEMENT
        CMP   [SI],AX           ;IS NEW ELEMENT > LARGEST?
        JNL   NEXT              ;NO,GO ON
        MOV   DI,SI             ;YES,MOVE DI
        MOV   AX,[DI]           ;AL HAS LARGEST ELEMENT
NEXT:
        LOOP  FIND_BIG          ;LOOP UNTIL DONE
;SWAP BIGGEST ELT WITH LAST ELT
        ;CALL  SWAP              ;SWAP WITH LAST ELT
        PUSH  AX                ;SAVE AX
        MOV   AX,[SI]           ;GET A[I]
        XCHG  AX,[DI]           ;PLACE IN A[K]
        MOV   [SI],AX           ;PUT A[K] IN A[I]
        POP   AX                ;RESTORE AX

        DEC   BX                ;N=N-1
        JNE   SORT_LOOP         ;REPEAT IF N<>0
END_SORT:
        POP   SI
        POP   DX
        POP   CX
        POP   BX
        RET
SORT  ENDP



