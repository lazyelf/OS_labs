.386
.model flat, STDCALL
option casemap :none  ;case sensitive

comment #
Вивести інформацію про операційну пам’ять. Структуру розмістити у виділеній пам’яті. Використати
функцію GlobalMemoryStatus.
#

include lab3.inc

.code
Begin:
	call main
	
invoke ExitProcess, NULL

Mem_Alloc PROC Buf_Size:DWORD
	
	add Buf_Size, 4 		;4 байти для хендлу
	invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, Buf_Size
	
	push eax 
	invoke GlobalLock, eax
	pop [eax] 				;записуємо хендл у виділену пам'ять
	
	add eax, 4 			;зсуваємо вказівних початку масиву на 4 байти
	
	ret
Mem_Alloc endp

Mem_Free PROC DATA:DWORD
	
	mov eax, DATA 		;адреса буфера (початок + 4 байти)
	sub eax, 4 			;4 байти масиву - це хендл буфера
	push [eax] 			;заносимо хендл у стек
	invoke GlobalUnlock, eax
	call GlobalFree 		;параметр у стеці
	
	ret
Mem_Free endp

main proc
	invoke Mem_Alloc, sizeof (MEMORYSTATUS)
	mov memory, eax
	
	invoke GlobalMemoryStatus, memory
	
	mov eax, memory
	assume eax: ptr MEMORYSTATUS
	

comment #
	mov ecx, 6
	mov eax, 7
	
L:
	shr memory[sizeof(dword) * eax], 20
	push memory[sizeof(dword) * eax]
	dec eax
	loop L
#
comment #
	shr memory[sizeof(dword) * 2], 20
	shr memory[sizeof(dword) * 3], 20
	shr memory[sizeof(dword) * 4], 20
	shr memory[sizeof(dword) * 5], 20
	shr memory[sizeof(dword) * 6], 20
	shr memory[sizeof(dword) * 7], 20
#

	invoke wsprintf, addr String, addr Format, [eax].dwMemoryLoad, 
	[eax].dwTotalPhys, [eax].dwAvailPhys,
	[eax].dwTotalPageFile, [eax].dwAvailPageFile, 
	[eax].dwTotalVirtual, [eax].dwAvailVirtual
	
	invoke Mem_Free, addr memory
	
	invoke MessageBox, 0, addr String, addr My_Title, MB_OK
	
	ret

main endp

end Begin