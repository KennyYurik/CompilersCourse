extern _printf, _scanf
section .data
	int_format_in db "%d", 0
	int_format_out db "%d", 10, 0
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
	
_fact:
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
	jne _fact_else1
	mov eax, 1
	push eax
	pop eax
	pop ebp
	ret
	jmp _fact_endif1
_fact_else1:
	mov eax, [ebp + 8]
	push eax
	mov eax, [ebp + 8]
	push eax
	mov eax, 1
	push eax
	pop eax
	sub [esp], eax
	call _fact
	add esp, 4
	push eax
	pop ebx
	pop eax
	mul ebx
	push eax
	pop eax
	pop ebp
	ret
_fact_endif1:
	pop ebp
	ret

_main:
	push ebp
	mov ebp, esp
	sub esp, 10
	sub esp, 4
	mov eax, 0
	push eax
	pop eax
	mov [ebp - 44], eax
_main_while1:
	mov eax, [ebp - 44]
	push eax
	mov eax, 10
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
	mov eax, [ebp - 44]
	push eax
	call _fact
	add esp, 4
	push eax
	mov eax, [ebp - 44]
	push eax
	pop ebx
	add ebx, 4
	pop eax
	mov [ebp - ebx], eax
	mov eax, [ebp - 44]
	push eax
	mov eax, 1
	push eax
	pop eax
	add [esp], eax
	pop eax
	mov [ebp - 44], eax
	jmp _main_while1
_main_endwhile1:
	mov eax, 0
	push eax
	pop eax
	mov [ebp - 44], eax
_main_while2:
	mov eax, [ebp - 44]
	push eax
	mov eax, 10
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
	mov eax, [ebp - 44]
	push eax
	pop ebx
	add ebx, 4
	mov eax, [ebp - ebx]
	push eax
	call _write
	add esp, 4
	push eax
	pop eax
	mov eax, [ebp - 44]
	push eax
	mov eax, 1
	push eax
	pop eax
	add [esp], eax
	pop eax
	mov [ebp - 44], eax
	jmp _main_while2
_main_endwhile2:
	add esp, 44
	pop ebp
	ret

