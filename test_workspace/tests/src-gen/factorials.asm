extern _printf, _scanf
section .data
	int_format_in db "%d", 0
	int_format_out db "%d", 10, 0
	arr times 20 dd 0
section .text
global _main
 _write:
	mov eax, [esp + 4]
	push eax
	push int_format_out
	call _printf
	add esp, 8
	ret
	
_read:
	sub esp, 4
	mov [esp], esp
	push int_format_in
	call _scanf
	mov eax, [esp + 4]
	add esp, 8
	ret
	
_fact1:
	push ebp
	mov ebp, esp
	mov eax, [ebp + 8]
	push eax
	mov eax, 2
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	setl dl
	push edx
	pop eax
	cmp eax, 1
	jne _fact1_else1
	mov eax, 1
	push eax
	pop eax
	pop ebp
	ret
	jmp _fact1_endif1
_fact1_else1:
	mov eax, [ebp + 8]
	push eax
	mov eax, [ebp + 8]
	push eax
	mov eax, 1
	push eax
	pop eax
	sub [esp], eax
	call _fact1
	add esp, 4
	push eax
	pop ebx
	pop eax
	mul ebx
	push eax
	pop eax
	pop ebp
	ret
_fact1_endif1:
	pop ebp
	ret

_fact2:
	push ebp
	mov ebp, esp
	sub esp, 4
	sub esp, 4
	mov eax, 1
	push eax
	pop eax
	mov [ebp - 8], eax
	mov eax, 1
	push eax
	pop eax
	mov [ebp - 4], eax
_fact2_while1:
	mov eax, [ebp - 4]
	push eax
	mov eax, [ebp + 8]
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	setng dl
	push edx
	pop eax
	cmp eax, 1
	jne _fact2_endwhile1
	mov eax, [ebp - 8]
	push eax
	mov eax, [ebp - 4]
	push eax
	pop ebx
	pop eax
	mul ebx
	push eax
	pop eax
	mov [ebp - 8], eax
	mov eax, [ebp - 4]
	push eax
	mov eax, 1
	push eax
	pop eax
	add [esp], eax
	pop eax
	mov [ebp - 4], eax
	jmp _fact2_while1
_fact2_endwhile1:
	mov eax, [ebp - 8]
	push eax
	pop eax
	add esp, 8
	pop ebp
	ret
	add esp, 8
	pop ebp
	ret

_main:
	push ebp
	mov ebp, esp
	sub esp, 4
	call _read
	add esp, 0
	push eax
	pop eax
	mov [ebp - 4], eax
	sub esp, 4
	mov eax, 0
	push eax
	pop eax
	mov [ebp - 8], eax
_main_while1:
	mov eax, [ebp - 8]
	push eax
	mov eax, [ebp - 4]
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	setl dl
	push edx
	pop eax
	cmp eax, 1
	jne _main_endwhile1
	mov eax, [ebp - 8]
	push eax
	call _fact1
	add esp, 4
	push eax
	mov eax, [ebp - 8]
	push eax
	pop ebx
	mov eax, arr
	pop edx
	mov [eax + 4 * ebx], edx
	mov eax, [ebp - 8]
	push eax
	mov eax, 1
	push eax
	pop eax
	add [esp], eax
	pop eax
	mov [ebp - 8], eax
	jmp _main_while1
_main_endwhile1:
	mov eax, 0
	push eax
	pop eax
	mov [ebp - 8], eax
_main_while2:
	mov eax, [ebp - 8]
	push eax
	mov eax, [ebp - 4]
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	setl dl
	push edx
	pop eax
	cmp eax, 1
	jne _main_endwhile2
	mov eax, [ebp - 8]
	push eax
	pop ebx
	mov edx, arr
	mov eax, [edx + 4 * ebx]
	push eax
	call _write
	add esp, 4
	push eax
	pop eax
	mov eax, [ebp - 8]
	push eax
	mov eax, 1
	push eax
	pop eax
	add [esp], eax
	pop eax
	mov [ebp - 8], eax
	jmp _main_while2
_main_endwhile2:
	mov eax, 0
	push eax
	pop eax
	mov [ebp - 8], eax
_main_while3:
	mov eax, [ebp - 8]
	push eax
	mov eax, [ebp - 4]
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	setl dl
	push edx
	pop eax
	cmp eax, 1
	jne _main_endwhile3
	mov eax, [ebp - 8]
	push eax
	call _fact2
	add esp, 4
	push eax
	mov eax, [ebp - 8]
	push eax
	pop ebx
	mov eax, arr
	pop edx
	mov [eax + 4 * ebx], edx
	mov eax, [ebp - 8]
	push eax
	mov eax, 1
	push eax
	pop eax
	add [esp], eax
	pop eax
	mov [ebp - 8], eax
	jmp _main_while3
_main_endwhile3:
	mov eax, 0
	push eax
	pop eax
	mov [ebp - 8], eax
_main_while4:
	mov eax, [ebp - 8]
	push eax
	mov eax, [ebp - 4]
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	setl dl
	push edx
	pop eax
	cmp eax, 1
	jne _main_endwhile4
	mov eax, [ebp - 8]
	push eax
	pop ebx
	mov edx, arr
	mov eax, [edx + 4 * ebx]
	push eax
	call _write
	add esp, 4
	push eax
	pop eax
	mov eax, [ebp - 8]
	push eax
	mov eax, 1
	push eax
	pop eax
	add [esp], eax
	pop eax
	mov [ebp - 8], eax
	jmp _main_while4
_main_endwhile4:
	add esp, 8
	pop ebp
	ret

