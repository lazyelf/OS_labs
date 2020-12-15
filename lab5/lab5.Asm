.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include lab5.inc
include RADbg.inc

comment #
Реалізувати анімаційну іконку, тобто в таймері циклічно міняти іконку вікна. 
Створити “повзунок” TrackBar, для регуляції швидкості зміни іконки. 
Розмістити кнопку на вікні, реакція якої буде вибір шляху до папки. 
результат (шлях) записати у створене вікно.
#

.code

start:

	invoke GetModuleHandle, 0
	mov	hInstance, eax
	invoke InitCommonControls
	
	mov openFileName.lStructSize, sizeof(OPENFILENAME)
	mov openFileName.lpstrFilter, offset filtr
    	mov openFileName.nFilterIndex, 1
    	mov openFileName.lpstrFile, offset fileName
   	mov openFileName.nMaxFile, 256
    	mov openFileName.lpstrInitialDir, offset dir
    	mov openFileName.lpstrTitle, offset openFileNameTitle
    	mov openFileName.Flags, OFN_PATHMUSTEXIST + OFN_FILEMUSTEXIST
    	
	invoke DialogBoxParam, hInstance, DIALOG, 0, addr DlgProc, 0
	invoke ExitProcess, 0

;########################################################################

TimerFunc proc
	cmp order, 5
	jnz change
	mov order, 1

change:
	invoke LoadIcon, hInstance, order
	mov icon_, eax
	invoke SendMessage, h_img, STM_SETIMAGE, IMAGE_ICON, icon_
	add order, 1
	
;invoke MessageBox, 0, 0, 0, MB_OK
	ret;
TimerFunc endp

DlgProc proc hWin:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

	mov	eax, uMsg
	.if eax == WM_INITDIALOG	
		invoke SetScrollRange, hWin, SB_VERT, 1000, 50000, TRUE
		invoke GetDlgItem, hWin, 1004
		mov h_img, eax
		
	.elseif eax == WM_COMMAND
		.if wParam == 1001
    			invoke GetOpenFileName,  addr openFileName
			invoke SendDlgItemMessage, hWin, 1002, WM_SETTEXT, 0, openFileName.lpstrFile
		.endif
	.elseif eax == WM_HSCROLL
		mov eax, wParam
		shl eax, 16
		shr eax, 16
		.if eax == SB_THUMBTRACK
			invoke KillTimer, hWin, 1
			mov eax, wParam
			shr eax, 16
			invoke SetTimer, hWin, 1, eax, addr TimerFunc
		.endif
	.elseif eax == WM_CLOSE
		invoke EndDialog, hWin, 0
	.else
		mov	eax, FALSE
		ret
	.endif
	mov	eax, TRUE  
	ret

DlgProc endp

		;invoke GetScrollPos, hWin, SB_HORZ
		;invoke GetDlgItem, hWin, 1003
		;invoke GetScrollInfo, eax, SB_HORZ, addr SckrollInfo
		;mov eax, SckrollInfo.nTrackPos
		;mov eax, SckrollInfo.nPos

end start
