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
	
_main:
	push ebp
	mov ebp, esp
	sub esp, 4
	call _read
	add esp, 0
	push eax
	pop eax
	mov [ebp - 4], eax
	mov eax, [ebp - 4]
	push eax
	call _write
	add esp, 4
	push eax
	pop eax
	add esp, 4
	pop ebp
	ret

