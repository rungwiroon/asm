/******************************************************************************/

#include <windows.h>
#include <commctrl.h>

/******************************************************************************/

HINSTANCE hInst;
HWND hLista,hVel,hAbrir,hCerrar,hAct,hEnviar,hRecv,hAEnviar;
HANDLE hPort;
int i;
BOOL FinHilo;
char buf[10],buf2[MAX_PATH];

/******************************************************************************/

void CierraPuerto(void)
{
    SetCommMask(hPort,0);
    CloseHandle(hPort);
    FinHilo=TRUE;
    EnableWindow(hLista,TRUE);
    EnableWindow(hVel,TRUE);
    EnableWindow(hAbrir,TRUE);
    EnableWindow(hCerrar,FALSE);
    EnableWindow(hAct,TRUE);
    EnableWindow(hEnviar,FALSE);
}

/******************************************************************************/

BOOL CALLBACK Hilo(HWND hWnd)
{
    OVERLAPPED ov;
    DWORD mascara,r,read;

// Inicio de configuración del evento overlapped:
    memset(&ov,0,sizeof(ov));
    ov.hEvent=CreateEvent(NULL,FALSE,FALSE,NULL);
    if(ov.hEvent==INVALID_HANDLE_VALUE) MessageBox(hWnd,
    "Error al crear evento",NULL,MB_ICONERROR);
// Fin de configuración del evento overlapped
// Inicio de aplicación de máscara:
    if(!SetCommMask(hPort,EV_RXCHAR)) MessageBox(hWnd,
    "Error al aplicar máscara",NULL,MB_ICONERROR);
// Fin de aplicación de máscara
    while(FinHilo==FALSE)
    {
        if(!WaitCommEvent(hPort,&mascara,&ov))
        {
            if(GetLastError()==ERROR_IO_PENDING)
            {
                if(!GetOverlappedResult(hPort,&ov,&r,TRUE))
                {
                    CierraPuerto();
                    break;
                }
            } else {
                CierraPuerto();
                break;
            }
        }
        if(mascara==EV_RXCHAR) do
        {
            memset(&buf2,0,sizeof(buf));
            read=0;
            if(!ReadFile(hPort,buf2,sizeof(buf2),&read,&ov))
            {
                if(GetLastError()==ERROR_IO_PENDING)
                {
                    if(!GetOverlappedResult(hPort,&ov,&read,TRUE))
                    {
                        CierraPuerto();
                        return SetCommMask(hPort,0);
                    }
                } else {
                    CierraPuerto();
                    return SetCommMask(hPort,0);
                }
            }
            if(!read) break;
            SendMessage(hRecv,EM_SETSEL,SendMessage(hRecv,EM_LINEINDEX,
                        SendMessage(hRecv,EM_GETLINECOUNT,0,0),0)-1,-1);
            SendMessage(hRecv,EM_REPLACESEL,FALSE,(LPARAM)&buf2);
        } while(read!=0);
        mascara=0;
    }
    return SetCommMask(hPort,0);
}

/******************************************************************************/

void Actualizar(void)
{
    HANDLE hFile;

    while(SendMessage(hLista,CB_DELETESTRING,0,0)!=CB_ERR);
    for(i=1;i<100;i++)
    {
        sprintf(buf,"\\\\.\\COM%i",i);
        hFile=CreateFileA(buf,0,0,NULL,OPEN_EXISTING,
                          FILE_ATTRIBUTE_NORMAL,NULL);
        if(hFile!=INVALID_HANDLE_VALUE)
        {
            CloseHandle(hFile);
            SendMessage(hLista,CB_ADDSTRING,0,(LPARAM)&buf+4);
        }
    }
    SendMessage(hLista,CB_SETCURSEL,0,0);
}

/******************************************************************************/

BOOL CALLBACK DlgProc(HWND hDlg,UINT uMsg,WPARAM wParam,LPARAM lParam)
{
    HMENU hSysMenu;
    COMMTIMEOUTS cto;
    DCB dcb;
    OVERLAPPED ov;
    DWORD written,HiloID;
    HANDLE hHilo;

// Inicio del diálogo
    if(uMsg==WM_INITDIALOG)
    {
        SendMessage(hDlg,WM_SETICON,ICON_SMALL,
                    (LPARAM)LoadIcon(hInst,(LPCTSTR)2));
        hSysMenu=GetSystemMenu(hDlg,FALSE);
        DeleteMenu(hSysMenu,2,MF_BYPOSITION); // Borra Tamaño
        DeleteMenu(hSysMenu,3,MF_BYPOSITION); // Borra Maximizar
        AppendMenu(hSysMenu,MF_SEPARATOR,0,NULL);
        AppendMenu(hSysMenu,MF_STRING,40,"Acerca de...");
        hLista=GetDlgItem(hDlg,10);
        hVel=GetDlgItem(hDlg,11);
        hAbrir=GetDlgItem(hDlg,20);
        hCerrar=GetDlgItem(hDlg,21);
        hAct=GetDlgItem(hDlg,22);
        hEnviar=GetDlgItem(hDlg,23);
        hRecv=GetDlgItem(hDlg,30);
        hAEnviar=GetDlgItem(hDlg,31);
        SendMessage(hVel,CB_ADDSTRING,0,(LPARAM)"1200");
        SendMessage(hVel,CB_ADDSTRING,0,(LPARAM)"2400");
        SendMessage(hVel,CB_ADDSTRING,0,(LPARAM)"9600");
        SendMessage(hVel,CB_ADDSTRING,0,(LPARAM)"19200");
        SendMessage(hVel,CB_ADDSTRING,0,(LPARAM)"38400");
        SendMessage(hVel,CB_ADDSTRING,0,(LPARAM)"57600");
        SendMessage(hVel,CB_ADDSTRING,0,(LPARAM)"115200");
        SendMessage(hVel,CB_SETCURSEL,2,0);
        CheckDlgButton(hDlg,24,BST_CHECKED);
        Actualizar();
    }

// Se escogió Acerca de... en el sysmenu
    else if(uMsg==WM_SYSCOMMAND)
    {
         if(wParam==40) MessageBox(hDlg,"Hecho por Armando G. Mondul.\r\nBasado\
 en Serialterm por Albrecht Schmidt.\r\n\r\nContacto, dudas y sugerencias:\r\n\
southrealist@gmail.com","Acerca de...",MB_ICONINFORMATION);
    }

// ; Hubo algún comando
    else if(uMsg==WM_COMMAND)
    {
// Se presionó Abrir
        if(wParam==20)
        {
            SendMessage(hLista,CB_GETLBTEXT,
                        SendMessage(hLista,CB_GETCURSEL,0,0),(LPARAM)&buf);
            sprintf(buf2,"\\\\.\\%s",buf);
            hPort=CreateFile(buf2,GENERIC_READ|GENERIC_WRITE,0,NULL,
                             OPEN_EXISTING,FILE_FLAG_OVERLAPPED,NULL);
            if(hPort==INVALID_HANDLE_VALUE)
            {
                sprintf(buf2,"No se pudo abrir %s",buf);
                MessageBox(hDlg,buf2,NULL,MB_ICONERROR);
            } else {
// Inicio de configuración de Timeouts:
                cto.ReadIntervalTimeout=2;
                cto.ReadTotalTimeoutConstant=1;
                cto.ReadTotalTimeoutMultiplier=1;
                cto.WriteTotalTimeoutConstant=0;
                cto.WriteTotalTimeoutMultiplier=0;
                if(!SetCommTimeouts(hPort,&cto)) MessageBox(hDlg,
                "Error al configurar Timeouts",NULL,MB_ICONERROR);
// Fin de configuración de Timeouts
// Inicio de configuración del puerto:
                memset(&dcb,0,sizeof(dcb));
                dcb.DCBlength=sizeof(dcb);
                SendMessage(hVel,CB_GETLBTEXT,
                            SendMessage(hVel,CB_GETCURSEL,0,0),(LPARAM)&buf);
                dcb.BaudRate=atoi(buf);
                dcb.fBinary=1;
                dcb.fDtrControl=DTR_CONTROL_ENABLE;
                dcb.fRtsControl=RTS_CONTROL_ENABLE;
                dcb.Parity=NOPARITY;
                dcb.StopBits=ONESTOPBIT;
                dcb.ByteSize=8;
                if(!SetCommState(hPort,&dcb)) MessageBox(hDlg,
                "Error al configurar puerto",NULL,MB_ICONERROR);
// Fin de configuración del puerto
// Inicio de configuración del evento overlapped:
                memset(&ov,0,sizeof(ov));
                ov.hEvent=CreateEvent(NULL,FALSE,FALSE,NULL);
                if(ov.hEvent==INVALID_HANDLE_VALUE) MessageBox(hDlg,
                "Error al crear evento",NULL,MB_ICONERROR);
// Fin de configuración del evento overlapped
// Inicio de creación del thread:
                FinHilo=FALSE;
                hHilo=CreateThread(NULL,0,
                                   (unsigned long (__stdcall *)(void *))Hilo,
                                   hDlg,NORMAL_PRIORITY_CLASS,&HiloID);
                if(hHilo==INVALID_HANDLE_VALUE)
                {
                    CloseHandle(hPort);
                    MessageBox(hDlg,"Error al crear el hilo",NULL,MB_ICONERROR);
// Fin de creación del thread
                } else {
                    CloseHandle(hHilo);
                    EnableWindow(hLista,FALSE);
	                EnableWindow(hVel,FALSE);
	                EnableWindow(hAbrir,FALSE);
	                EnableWindow(hCerrar,TRUE);
	                EnableWindow(hAct,FALSE);
	                EnableWindow(hEnviar,TRUE);
                }
            }
        }
// Se presionó Cerrar
        else if(wParam==21) CierraPuerto();
// Se presionó Actualizar
        else if(wParam==22) Actualizar();
// Se presionó Enviar
        else if(wParam==23)
        {
            GetWindowText(hAEnviar,buf2,sizeof(buf2));
            i=strlen(buf2);
            if(IsDlgButtonChecked(hDlg,24)==BST_CHECKED)
            {
                buf2[i]=13;
                buf2[i+1]=10;
                buf2[i+2]=0;
                i+=2;
            }
            if(!WriteFile(hPort,buf2,i,&written,&ov))
            {
                if(GetLastError()==ERROR_IO_PENDING)
                {
                    if(!GetOverlappedResult(hPort,&ov,&written,TRUE)) return 0;
                }
            }
            SetWindowText(hAEnviar,"");
        }
    }

//Se mandó a cerrar
    else if(uMsg==WM_CLOSE) EndDialog(hDlg,0);

    return 0;
}

/******************************************************************************/

int WINAPI WinMain(HINSTANCE hInstance,HINSTANCE hPrevInstance,
                   LPSTR lpCmdLine,int nCmdShow)
{
    hInst=hInstance;
    InitCommonControls(); // Para los estilos visuales de XP
    return DialogBox(hInstance,(LPCTSTR)1,NULL,DlgProc);
}

/******************************************************************************/
