
;Об’єднати результати функцій GetComputerName та GetCurrentDirectory в одну
;стрічку, попереставляти слова ззаду на перед. (символ пробілу вважати слеш «/»).


.386
.model flat,STDCALL
option casemap :none  ;case sensitive

include lab1.Inc

.code
Begin:
	call main


	invoke ExitProcess,NULL

get_data proc

	invoke GetCurrentDirectory, buf_len, addr directory
	invoke GetComputerName,  addr user_name, addr buf_len
	ret

get_data endp

concat proc

LOCAL Save_esp :dword
	mov Save_esp, esp
	invoke wsprintf, addr span, addr format_, addr name_title, addr user_name, addr enter_, addr directory_title, addr directory
	mov esp, Save_esp
	
	ret

concat endp

reverse proc

	;xor eax, eax
	invoke lstrlen, addr span
	lea ebx, span
	add ebx, eax	
	
word_len:
	dec ebx	
	
	mov al, [ebx - 1]
	cmp AL, 5ch ;/
	jz add_word
	cmp AL, 20h ;spc
	jz add_word
	cmp AL, 0D ;enter
	jnz word_len
	

add_word:

	invoke lstrcat, addr result, ebx
	invoke lstrcat, addr result, addr enter_
	
	cmp ebx, offset span
	jz return
	
	mov byte ptr [ebx - 1], 0
	jmp word_len
	
return:
	ret


reverse endp

main proc

	call get_data
	call concat

	invoke MessageBox, 0, addr span, addr title_, MB_OK
	
	call reverse
	invoke MessageBox, 0, addr result, addr title_, MB_OK
	ret

	main endp

end Begin















