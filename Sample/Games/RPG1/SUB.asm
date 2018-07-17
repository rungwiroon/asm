 EXTRN	OPENERR:BYTE,ERRCODE:BYTE,HANDLE:WORD
 PUBLIC  OPEN_ERROR,EXIT,OUTDEC                                    
 .MODEL SMALL                                                                         
 .CODE                                               
 OPEN_ERROR  PROC    NEAR                                                                 
 	LEA		DX,OPENERR		;get error message         
 	ADD	ERRCODE,AL		 ;convert error code to ASCII
 	MOV	AH,9                                       
 	INT		21H				 ;display error message   
	MOV	AH,4CH
	INT		21H
	RET                                     
 OPEN_ERROR	ENDP

 EXIT  PROC    NEAR                                                   
 	MOV	BX,HANDLE       ;get handle                
 	MOV	AH,3EH          ;close file fcn           
 	INT		21H             ;close file                    
 	MOV	AH,4CH                                     
 	INT		21H             ;dos exit      
 EXIT   ENDP

 OUTDEC  PROC
            PUSH    AX              
            PUSH    BX
            PUSH    CX
            PUSH    DX              
            OR      AX,AX           
            JGE     @END_IF1      
            PUSH    AX              
            MOV     DL,'-'         
            MOV     AH,2           
            INT     21H             
            POP     AX              
            NEG     AX              
    @END_IF1: 
            XOR     CX,CX                
            MOV     BX,10D         
    @REPEAT1:
            XOR     DX,DX         
            DIV     BX           
            PUSH    DX            
            INC     CX            
            OR      AX,AX          
            JNE     @REPEAT1        
            MOV     AH,2           
    @PRINT_LOOP:
            POP     DX              
            OR      DL,30H       
            INT     21H             
            LOOP    @PRINT_LOOP    
            POP     DX             
            POP     CX
            POP     BX
            POP     AX
            RET
    OUTDEC  ENDP
	END	
