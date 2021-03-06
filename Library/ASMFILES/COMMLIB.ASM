; I/O MODULE FILE COMMLIB.ASM
;------------------- CODE AREA STARTS --------------------------
;
codes	      segment
;
;+++++++++++++++++ PUBLIC DECLARATIONS START +++++++++++++++++++
;
public	      cominit,cominck,comout,comon,comoff
;
;+++++++++++++++++ PUBLIC DECLARATIONS END +++++++++++++++++++++
;
assume	      cs:codes
;
;--------------------- routine begins --------------------------
;
;ROUTINE TO INITIALIZE A COMMUNICATIONS	LINE
;
cominit	      proc far
;
	      mov  ah,0
	      int  14h
	      ret
;
cominit	      endp
;
;----------------------	routine	ends ---------------------------
;
;
;--------------------- routine begins --------------------------
;
;ROUTINE TO CHECK FOR INPUT FROM A COMMUNICATIONS LINE
;
cominck	      proc far
;
	      push ds
	      push dx
	      push si
;
	      mov  si,dx
	      add  si,si
	      mov  dx,40h
	      mov  ds,dx
	      mov  dx,[si]
	      add  dx,5
	      in   al,dx
	      test al,1
	      jz   cominckexit
;
	      mov  dx,[si]
	      in   al,dx
cominckexit:
;
	      pop  si
	      pop  dx
	      pop  ds
	      ret
;
cominck	      endp
;
;----------------------	routine	ends ---------------------------
;
;
;--------------------- routine begins --------------------------
;
;ROUTINE TO SEND OUTPUT	TO A COMMUNICATIONS LINE
;
comout	      proc far
;
	      mov  ah,1
	      int  14h
	      ret
;
comout	      endp
;
;----------------------	routine	ends ---------------------------
;
;
;--------------------- routine begins --------------------------
;
;ROUTINE TO TURN ON INPUT FROM A COMMUNICATIONS	LINE
;
comon	      proc far
;
	      push ds
	      push dx
	      push si
;
	      mov  si,dx
	      add  si,si
	      mov  dx,40h
	      mov  ds,dx
	      mov  dx,[si]
	      add  dx,4
	      mov  al,3
	      out  dx,al
;
	      pop  si
	      pop  dx
	      pop  ds
	      ret
;
comon	      endp
;
;----------------------	routine	ends ---------------------------
;
;
;--------------------- routine begins --------------------------
;
;ROUTINE TO TURN OFF INPUT FROM	A COMMUNICATIONS LINE
;
comoff	      proc far
;
	      push ds
	      push dx
	      push si
;
	      mov  si,dx
	      add  si,si
	      mov  dx,40h
	      mov  ds,dx
	      mov  dx,[si]
	      add  dx,4
	      mov  al,2
	      out  dx,al
;
	      pop  si
	      pop  dx
	      pop  ds
	      ret
;
comoff	      endp
;
;----------------------	routine	ends ---------------------------
;
codes	      ends
;
;--------------------- code area ends --------------------------
	      end
;---------------------------------------------------------------
                                                                                                 