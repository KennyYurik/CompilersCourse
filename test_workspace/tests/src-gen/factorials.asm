extern _printf, _scanf
section .data
	int_format_in db "%d", 0
	int_format_out db "%d\n", 0
	m dd 0
section .text
global _main
 _write:
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
	add esp, 4
	mov eax, [ebp + 4]
	push eax
	mov eax, 2
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp eax, ebx
	setl dl
	push edx
	pop eax
	cmp eax, 1
	jne _fact1_else1
	mov eax, 1
	push eax
	pop eax
	sub esp, 4
	pop ebp
	ret
	jmp _fact1_endif1
_fact1_else1:
	mov eax, [ebp + 4]
	push eax
	mov eax, [ebp + 4]
	push eax
	mov eax, 1
	push eax
	pop eax
	sub [esp], eax
	call _fact1
	push eax
	pop ebx
	pop eax
	mul ebx
	push eax
	pop eax
	sub esp, 4
	pop ebp
	ret
_fact1_endif:
	sub esp, 4
	pop ebp
	ret

_fact2:
	push ebp
	mov ebp, esp
	add esp, 4
	mov eax, 1
	push eax
	pop eax
	mov [ebp + 12], eax
	mov eax, 1
	push eax
	pop eax
	mov [ebp + 8], eax
_fact2_while1:
	mov eax, [ebp + 8]
	push eax
	mov eax, [ebp + 4]
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp eax, ebx
	setng dl
	push edx
	pop eax
	cmp eax, 1
	jne _fact2_endwhile1
	mov eax, [ebp + 12]
	push eax
	mov eax, [ebp + 8]
	push eax
	pop ebx
	pop eax
	mul ebx
	push eax
	pop eax
	mov [ebp + 12], eax
	mov eax, [ebp + 8]
	push eax
	mov eax, 1
	push eax
	pop eax
	add [esp], eax
	pop eax
	mov [ebp + 8], eax
_fact2_endwhile1:
	mov eax, [ebp + 12]
	push eax
	pop eax
	sub esp, 12
	pop ebp
	ret
	sub esp, 8
	sub esp, 4
	pop ebp
	ret

_main:
	push ebp
	mov ebp, esp
	call _read
	push eax
	pop eax
	mov [ebp + 4], eax
	mov eax, [ebp + 4]
	push eax
	call _fact1
	push eax
	call _write
	push eax
	mov eax, [ebp + 4]
	push eax
	call _fact2
	push eax
	call _write
	push eax
	sub esp, 4
	pop ebp
	ret

