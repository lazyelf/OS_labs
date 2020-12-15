
include windows.inc
include kernel32.inc
include user32.inc
include Comctl32.inc
include shell32.inc
include comdlg32.inc

includelib kernel32.lib
includelib user32.lib
includelib Comctl32.lib
includelib shell32.lib
includelib comdlg32.lib


DlgProc			PROTO	:HWND,:UINT,:WPARAM,:LPARAM

.data
openFileName			OPENFILENAME <0>
fileName				db 256 dup(0)
openFileNameTitle		db "Choose", 0
filtr					db "ALL", 0, "*.*", 0, 0
dir					db "/home/_lazyelf/", 0

order				db 1
;SckrollInfo			SCROLLINFO <0>

;#########################################################################

.const

DIALOG				equ 101

;#########################################################################

.data?

hInstance				dd ?
h_img				dd ?
icon_ 				dd ?

;#########################################################################
