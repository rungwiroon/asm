;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.386
.model flat,stdcall
option casemap:none

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Librerías de Windows

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\msvcrt.inc
include \masm32\include\comctl32.inc

includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib
includelib \masm32\lib\comctl32.lib

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.const

MenuText	db "Acerca de...",0
CTxt		db "\\.\COM%i",0
RTxt		db "\\.\%s"
NTxt		db 0
Err1Text	db "No se pudo abrir %s",0
Err2Text	db "Error al configurar Timeouts",0
Err3Text	db "Error al configurar puerto",0
Err4Text	db "Error al crear el hilo",0
Err5Text	db "Error al crear evento",0
Err6Text	db "Error al aplicar máscara",0
vel1		db "1200",0
vel2		db "2400",0
vel3		db "9600",0
vel4		db "19200",0
vel5		db "38400",0
vel6		db "57600",0
vel7		db "115200",0
AboutText	db "Hecho por Armando G. Mondul.",13,10,"Basado en Serialterm por Albrecht Schmidt."
		db 13,10,13,10
		db "Contacto, dudas y sugerencias:",13,10,"southrealist@gmail.com",0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.data?

hInstance	dd ?
hSysMenu	dd ?
hLista		dd ?
hVel		dd ?
hAbrir		dd ?
hCerrar		dd ?
hAct		dd ?
hEnviar		dd ?
hRecv		dd ?
hAEnviar	dd ?
hPort		dd ?
i		dd ?
FinHilo		dd ?
HiloID		dd ?
hHilo		dd ?
buf		db 10 dup(?)
buf2		db MAX_PATH dup(?)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CierraPuerto proc

	invoke	SetCommMask,hPort,0
	invoke	CloseHandle,hPort
	mov	FinHilo,1
	invoke	EnableWindow,hLista,TRUE
	invoke	EnableWindow,hVel,TRUE
	invoke	EnableWindow,hAbrir,TRUE
	invoke	EnableWindow,hCerrar,FALSE
	invoke	EnableWindow,hAct,TRUE
	invoke	EnableWindow,hEnviar,FALSE
	ret

CierraPuerto endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Hilo proc hWnd :DWORD

	LOCAL read	:DWORD
	LOCAL mascara	:DWORD
	LOCAL r		:DWORD
	LOCAL ov	:OVERLAPPED

	invoke	crt_memset,ADDR ov,NULL,SIZEOF ov;
	invoke	CreateEvent,NULL,FALSE,FALSE,NULL
	mov	ov.hEvent,eax
	cmp	eax,INVALID_HANDLE_VALUE
	jne	@F
	invoke	MessageBox,hWnd,ADDR Err5Text,NULL,MB_OK+MB_ICONERROR
@@:
	invoke	SetCommMask,hPort,EV_RXCHAR
	cmp	eax,0
	jne	HLazo
	invoke	MessageBox,hWnd,ADDR Err6Text,NULL,MB_OK+MB_ICONERROR
HLazo:
	cmp	FinHilo,1
	jne	@F
	invoke	SetCommMask,hPort,0
	ret
@@:
	invoke	WaitCommEvent,hPort,ADDR mascara,ADDR ov
	cmp	eax,0
	jne	@F
	invoke	GetLastError
	cmp	eax,ERROR_IO_PENDING
	jne	CierraLazo
	invoke	GetOverlappedResult,hPort,ADDR ov,ADDR r,TRUE
	cmp	eax,0
	je	CierraLazo
	cmp	mascara,0
	jne	@F
CierraLazo:
	call	CierraPuerto
	jmp	HLazo
@@:
	cmp	mascara,EV_RXCHAR
	jne	LHilo
L1Hilo:
	invoke	crt_memset,ADDR buf2,NULL,SIZEOF buf2 ; Limpia el buffer
	mov	read,0
	invoke	ReadFile,hPort,ADDR buf2,SIZEOF buf2,ADDR read,ADDR ov
	cmp	eax,0
	jne	@F
	invoke	GetLastError
	cmp	eax,ERROR_IO_PENDING
	jne	CierraHilo
	invoke	GetOverlappedResult,hPort,ADDR ov,ADDR read,TRUE
	cmp	eax,0
	jne	@F
CierraHilo:
	call	CierraPuerto
	jmp	LHilo
@@:
	cmp	read,0
	je	LHilo
	invoke	SendMessage,hRecv,EM_GETLINECOUNT,0,0		; \
	invoke	SendMessage,hRecv,EM_LINEINDEX,eax,0		; | Forma poco práctica
	dec	eax						; | para agregar texto.
	invoke	SendMessage,hRecv,EM_SETSEL,eax,-1		; | Si sabe otra escríbame
	invoke	SendMessage,hRecv,EM_REPLACESEL,FALSE,ADDR buf2	; /
	jmp	L1Hilo
LHilo:
	mov	mascara,0
	jmp	HLazo

Hilo endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Actualizar proc

Borra:
	invoke	SendMessage,hLista,CB_DELETESTRING,0,0
	cmp	eax,CB_ERR
	jne	Borra
	mov	i,1
Lazo:
	invoke	crt_sprintf,ADDR buf,ADDR CTxt,i
	invoke	CreateFileA,ADDR buf,0,0,NULL,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,NULL
	cmp	eax,INVALID_HANDLE_VALUE
	je	@F
	invoke	CloseHandle,eax
	invoke	SendMessage,hLista,CB_ADDSTRING,0,ADDR buf+4
@@:
	inc	i
	cmp	i,100
	jb	Lazo
	invoke	SendMessage,hLista,CB_SETCURSEL,0,0
	ret

Actualizar endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DlgProc proc hDlg   :DWORD,
             uMsg   :DWORD,
             wParam :DWORD,
             lParam :DWORD

	LOCAL written	:DWORD
	LOCAL cto	:COMMTIMEOUTS
	LOCAL dcb	:DCB
	LOCAL ov	:OVERLAPPED

; Inicio del diálogo
	cmp	uMsg,WM_INITDIALOG
	jne	wSysCommand
	invoke	LoadIcon,hInstance,2
	invoke	SendMessage,hDlg,WM_SETICON,ICON_SMALL,eax
	invoke	GetSystemMenu,hDlg,FALSE
	mov	hSysMenu,eax
	invoke	DeleteMenu,hSysMenu,2,MF_BYPOSITION ; Borra Tamaño
	invoke	DeleteMenu,hSysMenu,3,MF_BYPOSITION ; Borra Maximizar
	invoke	AppendMenu,hSysMenu,MF_SEPARATOR,NULL,NULL
	invoke	AppendMenu,hSysMenu,MF_STRING,40,ADDR MenuText
	invoke	GetDlgItem,hDlg,10
	mov	hLista,eax
	invoke	GetDlgItem,hDlg,11
	mov	hVel,eax
	invoke	GetDlgItem,hDlg,20
	mov	hAbrir,eax
	invoke	GetDlgItem,hDlg,21
	mov	hCerrar,eax
	invoke	GetDlgItem,hDlg,22
	mov	hAct,eax
	invoke	GetDlgItem,hDlg,23
	mov	hEnviar,eax
	invoke	GetDlgItem,hDlg,30
	mov	hRecv,eax
	invoke	GetDlgItem,hDlg,31
	mov	hAEnviar,eax
	invoke	SendMessage,hVel,CB_ADDSTRING,0,ADDR vel1
	invoke	SendMessage,hVel,CB_ADDSTRING,0,ADDR vel2
	invoke	SendMessage,hVel,CB_ADDSTRING,0,ADDR vel3
	invoke	SendMessage,hVel,CB_ADDSTRING,0,ADDR vel4
	invoke	SendMessage,hVel,CB_ADDSTRING,0,ADDR vel5
	invoke	SendMessage,hVel,CB_ADDSTRING,0,ADDR vel6
	invoke	SendMessage,hVel,CB_ADDSTRING,0,ADDR vel7
	invoke	SendMessage,hVel,CB_SETCURSEL,2,0
	invoke	CheckDlgButton,hDlg,24,BST_CHECKED
	call	Actualizar
	jmp	SalDlgProc

; Se escogió Acerca de... en el sysmenu
wSysCommand:
	cmp	uMsg,WM_SYSCOMMAND
	jne	wCommand
	cmp	wParam,40
	jne	SalDlgProc
	invoke	MessageBox,hDlg,ADDR AboutText,ADDR MenuText,MB_ICONINFORMATION
	jmp	SalDlgProc

; Hubo algún comando
wCommand:
	cmp	uMsg,WM_COMMAND
	jne	wClose
; Se presionó Abrir
	cmp	wParam,20
	jne	wPCerrar
	invoke	SendMessage,hLista,CB_GETCURSEL,0,0
	invoke	SendMessage,hLista,CB_GETLBTEXT,eax,ADDR buf
	invoke	crt_sprintf,ADDR buf2,ADDR RTxt,ADDR buf
	invoke	CreateFile,ADDR buf2,GENERIC_READ or GENERIC_WRITE,0,NULL,OPEN_EXISTING,FILE_FLAG_OVERLAPPED,NULL
	cmp	eax,INVALID_HANDLE_VALUE
	jne	@F
	invoke	crt_sprintf,ADDR buf2,ADDR Err1Text,ADDR buf
	invoke	MessageBox,hDlg,ADDR buf2,NULL,MB_OK+MB_ICONERROR
	jmp	SalDlgProc
@@:
	mov	hPort,eax
	mov	cto.ReadIntervalTimeout,2		; \
	mov	cto.ReadTotalTimeoutMultiplier,1	; |
	mov	cto.ReadTotalTimeoutConstant,1		; | Configuración de
	mov	cto.WriteTotalTimeoutMultiplier,0	; | Timeouts
	mov	cto.WriteTotalTimeoutConstant,0		; |
	invoke	SetCommTimeouts,hPort,ADDR cto		; /
	cmp	eax,0
	jne	@F
	invoke	MessageBox,hDlg,ADDR Err2Text,NULL,MB_OK+MB_ICONERROR
@@:
	invoke	crt_memset,ADDR dcb,NULL,SIZEOF dcb		; \
	mov	dcb.DCBlength,SIZEOF dcb			; |
	invoke	SendMessage,hVel,CB_GETCURSEL,0,0		; |
	invoke	SendMessage,hVel,CB_GETLBTEXT,eax,ADDR buf	; |
	invoke	crt_atoi,ADDR buf				; |
	mov	dcb.BaudRate,eax				; |
;	mov	dcb.fBinary,1					; | Configuración del puerto
;	mov	dcb.fDtrControl,DTR_CONTROL_ENABLE		; |
;	mov	dcb.fRtsControl,RTS_CONTROL_ENABLE		; |
	mov	dcb.Parity,NOPARITY				; |
	mov	dcb.StopBits,ONESTOPBIT				; |
	mov	dcb.ByteSize,8					; |
	invoke	SetCommState,hPort,ADDR dcb			; /
	cmp	eax,0
	jne	@F
	invoke	MessageBox,hDlg,ADDR Err3Text,NULL,MB_OK+MB_ICONERROR
@@:
	invoke	crt_memset,ADDR ov,NULL,SIZEOF ov	; \
	invoke	CreateEvent,NULL,FALSE,FALSE,NULL	; | Evento Overlapped
	mov	ov.hEvent,eax				; /
	cmp	eax,INVALID_HANDLE_VALUE
	jne	@F
	invoke	MessageBox,hDlg,ADDR Err5Text,NULL,MB_OK+MB_ICONERROR
@@:
	mov	FinHilo,0 ; Creación del thread:
	invoke	CreateThread,NULL,NULL,ADDR Hilo,hDlg,NORMAL_PRIORITY_CLASS,ADDR HiloID
	mov	hHilo,eax
	cmp	eax,INVALID_HANDLE_VALUE
	jne	@F
	invoke	CloseHandle,hPort
	invoke	MessageBox,hDlg,ADDR Err4Text,NULL,MB_OK+MB_ICONERROR
	jmp	SalDlgProc
@@:
	invoke	CloseHandle,hHilo ; No necesito este handle
	invoke	EnableWindow,hLista,FALSE
	invoke	EnableWindow,hVel,FALSE
	invoke	EnableWindow,hAbrir,FALSE
	invoke	EnableWindow,hCerrar,TRUE
	invoke	EnableWindow,hAct,FALSE
	invoke	EnableWindow,hEnviar,TRUE
	jmp	SalDlgProc
; Se presionó Cerrar
wPCerrar:
	cmp	wParam,21
	jne	wPAct
	call	CierraPuerto
	jmp	SalDlgProc
; Se presionó Actualizar
wPAct:
	cmp	wParam,22
	jne	wPEnviar
	call	Actualizar
	jmp	SalDlgProc
; Se presionó Enviar
wPEnviar:
	cmp	wParam,23
	jne	SalDlgProc
	invoke	GetWindowText,hAEnviar,ADDR buf2,SIZEOF buf2
	invoke	IsDlgButtonChecked,hDlg,24
	mov	i,eax
	invoke	crt_strlen,ADDR buf2
	cmp	i,BST_CHECKED
	jne	@F
	mov	[buf2+eax],13	; \
	mov	[buf2+1+eax],10	; | Se agregan retorno de
	mov	[buf2+2+eax],0	; | carro y avance de línea
	add	eax,2		; /
@@:
	mov	edx,eax
	invoke	WriteFile,hPort,ADDR buf2,edx,ADDR written,ADDR ov
	cmp	eax,0
	jne	@F
	invoke	GetLastError
	cmp	eax,ERROR_IO_PENDING
	jne	SalDlgProc
	invoke	GetOverlappedResult,hPort,ADDR ov,ADDR written,TRUE
	cmp	eax,0
	je	SalDlgProc
@@:
	invoke	SetWindowText,hAEnviar,ADDR NTxt
	jmp	SalDlgProc

; Se mandó a cerrar
wClose:
	cmp	uMsg,WM_CLOSE
	jne	SalDlgProc
	invoke	EndDialog,hDlg,NULL

SalDlgProc:
	xor	eax,eax ; Se debe colocar en NT/2K/XP/Vista
	ret

DlgProc endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start:
	invoke	GetModuleHandle,NULL
	mov	hInstance,eax
	invoke	InitCommonControls ; Para los estilos visuales de XP
	invoke	DialogBoxParam,hInstance,1,NULL,ADDR DlgProc,NULL
	invoke	ExitProcess,eax
end start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
