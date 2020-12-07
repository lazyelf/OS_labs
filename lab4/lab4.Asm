.586
.model flat,stdcall
option casemap:none
include lab4.Inc
.code

comment #
Знайти всі вікна і поміняти в них іконки. Іконку вибрати через діалог вибору файлів з фільтром "*.ico". 
Примітка: Перевірити чи вікно яке ми знайшли є вікном верхнього рівня, якщо так то змінити ікону та звернути вікно.
#

start:
  invoke GetModuleHandle,  NULL
  mov hInstance, eax
  
  invoke GetCommandLine
  mov CommandLine, eax
  
  invoke WinMain, hInstance, NULL, CommandLine, SW_SHOWDEFAULT
  invoke ExitProcess, eax
  
EnumWndProc proc hwnd, lParam : DWORD
  
  invoke GetFocus
  .if eax == hwnd
  
    invoke GetOpenFileName,  addr openFileName
    
    invoke LoadImage, hInstance, openFileName.lpstrFile, IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_MONOCHROME + LR_DEFAULTSIZE
  
    invoke SendMessage, hwnd, WM_SETICON, 0, eax
    
    mov position.iLength, sizeof(WINDOWPLACEMENT)    
    mov position.showCmd, SW_MINIMIZE
    
    mov position.rcNormalPosition.left, 0
    mov position.rcNormalPosition.top, 0
    mov position.rcNormalPosition.right, 250
    mov position.rcNormalPosition.bottom, 200
    
    invoke SetWindowPlacement, hwnd, addr position
    
  .endif
  
  mov eax, 1
  
  ret
EnumWndProc endp

CreateWindowProc proc hInst, name_, hwnd : DWORD

	invoke CreateWindowEx, NULL, addr ClassName, name_, \
	WS_OVERLAPPEDWINDOW, CW_USEDEFAULT,\
         CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, \
         hInst, NULL
  	
  	mov   hwnd, eax
	
  	invoke ShowWindow, hwnd, SW_SHOWNORMAL
 	invoke UpdateWindow, hwnd
	
	ret

CreateWindowProc endp

WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD
  LOCAL wc :WNDCLASSEX
  LOCAL msg :MSG
  LOCAL hwnd1 :HWND
  LOCAL hwnd2 :HWND
  LOCAL hwnd3 :HWND
  LOCAL hwnd4 :HWND
  
  mov   wc.cbSize, SIZEOF WNDCLASSEX
  mov   wc.style, CS_HREDRAW or CS_VREDRAW
  mov   wc.lpfnWndProc, OFFSET WndProc
  mov   wc.cbClsExtra, NULL
  mov   wc.cbWndExtra, NULL
  push  hInstance
  pop   wc.hInstance
  mov   wc.hbrBackground, COLOR_BTNFACE + 7
  mov   wc.lpszMenuName, NULL
  mov   wc.lpszClassName, OFFSET ClassName
  
  invoke LoadIcon, NULL, IDI_WINLOGO
  mov   wc.hIcon, eax
  mov   wc.hIconSm, eax
  
  invoke LoadCursor, NULL, IDC_UPARROW
  mov   wc.hCursor, eax
  
  invoke RegisterClassEx, addr wc
 
	invoke CreateWindowProc, hInst, addr AppNamea, hwnd1
	invoke CreateWindowProc, hInst, addr AppNameb, hwnd2
	invoke CreateWindowProc, hInst, addr AppNamec, hwnd3
	invoke CreateWindowProc, hInst, addr AppNamed, hwnd4
	
	
	mov openFileName.lStructSize, sizeof(OPENFILENAME)
	mov openFileName.lpstrFilter, offset filtr
    mov openFileName.nFilterIndex, 1
    mov openFileName.lpstrFile, offset fileName
    mov openFileName.nMaxFile, 256
    mov openFileName.lpstrInitialDir, offset dir
    mov openFileName.lpstrTitle, offset AppNamea
    mov openFileName.Flags, OFN_PATHMUSTEXIST + OFN_FILEMUSTEXIST
  
  invoke EnumWindows, addr EnumWndProc, 0
  
  .while TRUE
    invoke GetMessage, addr msg, NULL, 0, 0
    .BREAK .IF (!eax)
    invoke TranslateMessage, addr msg
    invoke DispatchMessage, addr msg
  .endw
  
  mov     eax,msg.wParam
  ret
WinMain endp

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
  
  
  .if uMsg == WM_DESTROY
  	.if iterator == 3
   		invoke PostQuitMessage,NULL
   		.else 
   			add iterator, 1
   	.endif
  .elseif uMsg == WM_CREATE
  .else
    invoke DefWindowProc, hWnd, uMsg, wParam, lParam    
    ret
  .endif
  
  xor eax,eax
  ret
WndProc endp
  
end start