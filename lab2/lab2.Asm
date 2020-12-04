.386
.model flat,STDCALL
option casemap :none  ;case sensitive

include lab2.inc

comment #
Створити нові програми, котрі використовують наступні функції: GetSystemTime, DeleteFile,
CopyFile, RemoveDirectory, SetCurrentDirectory, SetVolumeLabel, GetVolumeInformation,
GetTempFileName, SetFileAttributes, GetFileAttributes, GetLogicalDrives, GetLogicalDriveStrings,
MoveFile, FileTimeToLocalFileTime, SetFileTime, LocalFileTimeToFileTime, FindFirstFile, FindNextFile,
FindClose.

Визначити атрибут файлу, якщо файл прихований та має мітку «тільки читання », зняти властивість
«тільки читати» скопіювати у задану наперед директорію та стерти файл.
#

.code
Begin:
	call main
	
invoke ExitProcess, NULL

initDirectory proc, FileName:dword, fileAtributs:dword, text:dword
	
	invoke CreateFile, FileName, GENERIC_WRITE, FILE_SHARE_WRITE or FILE_SHARE_READ, NULL, OPEN_ALWAYS, fileAtributs, NULL
	mov hFile, eax	
	invoke lstrlen, text
	invoke WriteFile, hFile, text, eax, 0, 0
	invoke CloseHandle, hFile
	ret
	
initDirectory endp

checkFileAtributs proc, FileName:dword
LOCAL fileAtributs :dword 
LOCAL buf[256] :byte
	
	mov fileAtributs, FILE_ATTRIBUTE_HIDDEN 
	or fileAtributs, FILE_ATTRIBUTE_READONLY
	
	mov ecx, fileAtributs
	
	invoke GetFileAttributes, FileName
	push eax
	and eax, fileAtributs
	cmp eax, fileAtributs
	jnz endProc
	
	invoke lstrcat, addr buf, addr directory
	invoke lstrcat, addr buf, addr copiedFile
	invoke CopyFile, FileName, addr buf, FALSE
	
	pop eax
	xor eax, FILE_ATTRIBUTE_READONLY
	push eax
	invoke SetFileAttributes, addr buf, eax	
	pop eax
	invoke SetFileAttributes, FileName, eax
	
	invoke DeleteFile, FileName
	
	
endProc:
	ret

checkFileAtributs endp

main proc
	
	invoke initDirectory, addr FileName1, FILE_ATTRIBUTE_NORMAL, addr text1
	invoke initDirectory, addr FileName2, FILE_ATTRIBUTE_HIDDEN, addr text2
	invoke initDirectory, addr FileName3, FILE_ATTRIBUTE_READONLY, addr text3
	invoke initDirectory, addr FileName4, FILE_ATTRIBUTE_HIDDEN or FILE_ATTRIBUTE_READONLY, addr text4
	
	invoke checkFileAtributs, addr FileName1
	invoke checkFileAtributs, addr FileName2
	invoke checkFileAtributs, addr FileName3
	invoke checkFileAtributs, addr FileName4
	
	ret

main endp

end Begin