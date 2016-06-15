extern _printf, _scanf
section .data
	int_format_in db "%d", 0
	int_format_out db "%d\n", 0
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
_main:
	push ebp
	mov ebp, esp
	call _read
	push eax
	pop eax
	mov [ebp + 4], eax
	mov eax, [ebp + 4]
	push eax
	call _write
	push eax
	sub esp, 4
	pop ebp
	ret

