; I/O MODULE FILE STDIO.ASM
;------------------- CODE AREA STARTS --------------------------
;
codes	      segment
;
;+++++++++++++++++ PUBLIC DECLARATIONS START +++++++++++++++++++
;
public	      stdin,stdinne,stdinck,stdout,stdoutdr,stdcrlf
public	      stdspace,stdmessout
;
;+++++++++++++++++ PUBLIC DECLARATIONS END +++++++++++++++++++++
;
assume	      cs:codes
;
;--------------------- routine begins --------------------------
;
;ROUTINE FOR STANDARD INPUT WITH ECHO
;
stdin	      proc far
	      mov  ah,1
	      int  21h
	      ret
stdin	      endp
;
;----------------------	routine	ends ---------------------------
;
;--------------------- routine begins --------------------------
;
;ROUTINE FOR STANDARD INPUT WITHOUT ECHO
;
stdinne	      proc far
	      mov  ah,8
	      int  21h
	      ret
stdinne	      endp
;
;----------------------	routine	ends ---------------------------
;
;--------------------- routine begins --------------------------
;
;ROUTINE TO CHECK FOR STANDARD INPUT
;
stdinck	      proc far
	      push dx
	      mov  dl,0FFh
	      mov  ah,06h
	      int  21h
	      pop  dx
	      ret
stdinck	      endp
;
;----------------------	routine	ends ---------------------------
;
;--------------------- routine begins --------------------------
;
;ROUTINE FOR STANDARD OUTPUT
;
stdout	      proc far
	      push dx
	      mov  dl,al
	      mov  ah,2
	      int  21h
	      pop  dx
	      ret
stdout	      endp
;
;----------------------	routine	ends ---------------------------
;
;--------------------- routine begins --------------------------
;
;ROUTINE FOR DIRECT CONSOLE OUTPUT
;
stdoutdr      proc far
	      push dx
;
	      cmp  al,0FFh
	      je   stdoutdrexit
	      mov  dl,al
	      mov  ah,6
	      int  21h
;
stdoutdrexit:
	      pop  dx
	      ret
stdoutdr      endp
;
;----------------------	routine	ends ---------------------------
;
;--------------------- routine begins --------------------------
;
;ROUTINE TO SEND CR LF TO STANDARD OUTPUT
;
stdcrlf	      proc far
	      push ax
;
	      mov  al,13
	      call stdout
	      mov  al,10
	      call stdout
;
	      pop  ax
	      ret
stdcrlf	      endp
;
;----------------------	routine	ends ---------------------------
;
;--------------------- routine begins --------------------------
;
;ROUTINE TO SEND SPACE TO STANDARD OUTPUT
;
;A space is sent to the	standard outout	device
;
stdspace      proc far
	      push ax
;
	      mov  al,32
	      call stdout
;
	      pop  ax
	      ret
stdspace      endp
;
;----------------------	routine	ends ---------------------------
;
;--------------------- routine begins --------------------------
;
;ROUTINE TO SEND MESSAGE TO STANDARD OUTPUT
;
stdmessout    proc far
	      push si
	      push ax
;
stdmessout1:
	      mov  al,[si]
	      inc  si
	      cmp  al,0
	      je   stdmessoutexit
	      call stdout
	      jmp  stdmessout1
;
stdmessoutexit:
	      pop  ax
	      pop  si
	      ret
stdmessout    endp
;
;----------------------	routine	ends ---------------------------
;
codes	      ends
;
;--------------------- code area ends --------------------------
	      end
;---------------------------------------------------------------
                                                                                                                            