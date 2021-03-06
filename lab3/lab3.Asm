.386
.model flat, STDCALL
option casemap :none  ;case sensitive

comment #
������� ���������� ��� ���������� ������. ��������� ��������� � �������� �����. �����������
������� GlobalMemoryStatus.
#

include lab3.inc

.code
Begin:
	call main
	
invoke ExitProcess, NULL

Mem_Alloc PROC Buf_Size:DWORD
	
	add Buf_Size, 4 		;4 ����� ��� ������
	invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, Buf_Size
	
	push eax 
	invoke GlobalLock, eax
	pop [eax] 				;�������� ����� � ������� ���'���
	
	add eax, 4 			;������� �������� ������� ������ �� 4 �����
	
	ret
Mem_Alloc endp

Mem_Free PROC DATA:DWORD
	
	mov eax, DATA 		;������ ������ (������� + 4 �����)
	sub eax, 4 			;4 ����� ������ - �� ����� ������
	push [eax] 			;�������� ����� � ����
	invoke GlobalUnlock, eax
	call GlobalFree 		;�������� � �����
	
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