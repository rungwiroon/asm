;
;
;
;********************************************************************
prognam       segment                  ;define code segment
;
;--------------------------------------------------------------------
main          proc      far            ;main part of program
;
              assume    cs:prognam
;
;REM          org       100h           ;first address
;
;
start:                                 ;starting execution address
;
;
main          endp                     ;end main part of program
;--------------------------------------------------------------------
prognam       ends                     ;end code segment
;********************************************************************
              end                      ;end of assembly
;====================================================================
main          endp                     ;end main part of program
;--------------------------------------------------------------------
;
prognam       ends                    ;end of code segment
;********************************************************************
;
              end       start         ;end assembly
;====================================================================
                                 