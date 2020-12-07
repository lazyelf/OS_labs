   include windows.inc
   include user32.inc
   include kernel32.inc
   include comdlg32.inc
   
   includelib user32.lib
   includelib kernel32.lib
   includelib comdlg32.lib
   includelib shell32.lib


WinMain proto :DWORD,:DWORD,:DWORD,:DWORD


.data
   ClassName		db "MainWinClass",0
   AppNamea		db "Remastering1", 0
   AppNameb      	db "Remastering2", 0
   AppNamec   		db "Remastering3", 0
   AppNamed    	db "Remastering4", 0
   
   fileName     		db 256 dup(0)
   dir        			db "/home/_lazyelf/_Download", 0
   filtr        			db "ICONS", 0, "*.ico", 0, 0
   openFileName  	OPENFILENAME  <0>
   
   position 			WINDOWPLACEMENT <0>
   iterator 			dd 0
   rect			RECT <0, 0, 200, 200>

.data?
   hInstance      HINSTANCE     ?
   CommandLine     LPSTR       ?


