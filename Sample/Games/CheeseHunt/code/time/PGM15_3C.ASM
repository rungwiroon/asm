        TITLE   PGM15_3C: GET AND CONVERT TIME TO ASCII
        PUBLIC  GET_TIME,SETUP_INT
C_SEG   SEGMENT PUBLIC
        ASSUME  CS:C_SEG
;
GET_TIME        PROC
;get time of day and store ASCII digits in time buffer
;input:  BX = address of time buffer
        MOV     AH,2CH          ;gettime
        INT     21H             ;CH = hr, CL =  min, DH = sec
;convert hours into ASCII and store
        MOV     AL,CH           ;hour
        CALL    CONVERT         ;convert to ASCII
        MOV     [BX],AX         ;store
;convert minutes into ASCII and store
        MOV     AL,CL           ;minute
        CALL    CONVERT         ;convert to ASCII
        MOV     [BX+3],AX       ;store
;convert seconds into ASCII and store
        MOV     AL,DH           ;second
        CALL    CONVERT         ;convert to ASCII
        MOV     [BX+6],AX       ;store
        RET
GET_TIME        ENDP
;
CONVERT PROC
;converts byte number (0-59) into ASCII digits
;input: AL = number
;output: AX = ASCII digits, AL = high digit, AH = low digit
        MOV     AH,0            ;clear AH
        MOV     DL,10           ;divide AX by 10
        DIV     DL              ;AH has remainder, AL has quotient
        OR      AX,3030H        ;convert to ASCII, AH has low digit
        RET                     ;AL has high digit
CONVERT ENDP
;
SETUP_INT       PROC
;saves old vector and sets up new  vector
;input:  AL = interrupt type
;       DI = address of buffer for old vector
;       SI = address of buffer containing new vector
;save old interrupt vector
        MOV     AH,35H          ;function 35h, get vector
        INT     21H             ;ES:BX = vector
        MOV     [DI],BX         ;save offset
        MOV     [DI+2],ES       ;save segment
;setup new vector
        MOV     DX,[SI]         ;DX has offset
        PUSH    DS              ;save it
        MOV     DS,[SI+2]       ;DS has segment number
        MOV     AH,25H          ;function 25h, set vector
        INT     21H             ;
        POP     DS              ;restore DS
        RET
SETUP_INT       ENDP
;
C_SEG   ENDS
        END
