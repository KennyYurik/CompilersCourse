extern _printf, _scanf
section .data
	int_format_in db "%d", 0
	int_format_out db "%d", 10, 0
	used times 100 dd 0
	dist times 100 dd 0
	edges_from times 1000 dd 0
	edges_to times 1000 dd 0
	edges_weights times 1000 dd 0
	n dd 0
	m dd 0
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
	
_min:
	push ebp
	mov ebp, esp
	mov eax, [ebp + 8]
	push eax
	mov eax, [ebp + 12]
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	setng dl
	push edx
	pop eax
	cmp eax, 1
	jne _min_else1
	mov eax, [ebp + 8]
	push eax
	pop eax
	pop ebp
	ret
	jmp _min_endif1
_min_else1:
	mov eax, [ebp + 12]
	push eax
	pop eax
	pop ebp
	ret
_min_endif1:
	pop ebp
	ret

_dijkstra:
	push ebp
	mov ebp, esp
	sub esp, 4
	mov eax, 0
	push eax
	pop eax
	mov [ebp - 4], eax
	sub esp, 4
	mov eax, 100000000
	push eax
	pop eax
	mov [ebp - 8], eax
	sub esp, 4
	mov eax, 0
	push eax
	mov eax, 1
	push eax
	pop eax
	sub [esp], eax
	pop eax
	mov [ebp - 12], eax
_dijkstra_while1:
	mov eax, [ebp - 4]
	push eax
	mov eax, [n]
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	setl dl
	push edx
	pop eax
	cmp eax, 1
	jne _dijkstra_endwhile1
	mov eax, [ebp - 4]
	push eax
	pop ebx
	mov edx, used
	mov eax, [edx + 4 * ebx]
	push eax
	mov eax, 0
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	sete dl
	push edx
	mov eax, [ebp - 4]
	push eax
	pop ebx
	mov edx, dist
	mov eax, [edx + 4 * ebx]
	push eax
	mov eax, [ebp - 8]
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	setl dl
	push edx
	pop eax
	and [esp], eax
	pop eax
	cmp eax, 1
	jne _dijkstra_while1_endif1
	mov eax, [ebp - 4]
	push eax
	pop ebx
	mov edx, dist
	mov eax, [edx + 4 * ebx]
	push eax
	pop eax
	mov [ebp - 8], eax
	mov eax, [ebp - 4]
	push eax
	pop eax
	mov [ebp - 12], eax
_dijkstra_while1_endif1:
	mov eax, [ebp - 4]
	push eax
	mov eax, 1
	push eax
	pop eax
	add [esp], eax
	pop eax
	mov [ebp - 4], eax
	jmp _dijkstra_while1
_dijkstra_endwhile1:
	mov eax, [ebp - 12]
	push eax
	mov eax, 0
	push eax
	mov eax, 1
	push eax
	pop eax
	sub [esp], eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	sete dl
	push edx
	pop eax
	cmp eax, 1
	jne _dijkstra_endif1
	add esp, 12
	pop ebp
	ret
_dijkstra_endif1:
	mov eax, 1
	push eax
	mov eax, [ebp - 12]
	push eax
	pop ebx
	mov eax, used
	pop edx
	mov [eax + 4 * ebx], edx
	mov eax, 0
	push eax
	pop eax
	mov [ebp - 4], eax
_dijkstra_while2:
	mov eax, [ebp - 4]
	push eax
	mov eax, [m]
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	setl dl
	push edx
	pop eax
	cmp eax, 1
	jne _dijkstra_endwhile2
	sub esp, 4
	sub esp, 4
	mov eax, [ebp - 4]
	push eax
	pop ebx
	mov edx, edges_from
	mov eax, [edx + 4 * ebx]
	push eax
	pop eax
	mov [ebp - 16], eax
	mov eax, [ebp - 4]
	push eax
	pop ebx
	mov edx, edges_to
	mov eax, [edx + 4 * ebx]
	push eax
	pop eax
	mov [ebp - 20], eax
	mov eax, [ebp - 16]
	push eax
	pop ebx
	mov edx, used
	mov eax, [edx + 4 * ebx]
	push eax
	mov eax, 0
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	sete dl
	push edx
	mov eax, [ebp - 20]
	push eax
	pop ebx
	mov edx, used
	mov eax, [edx + 4 * ebx]
	push eax
	mov eax, 1
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	sete dl
	push edx
	pop eax
	and [esp], eax
	pop eax
	cmp eax, 1
	jne _dijkstra_while2_endif1
	mov eax, [ebp - 20]
	push eax
	pop ebx
	mov edx, dist
	mov eax, [edx + 4 * ebx]
	push eax
	mov eax, [ebp - 4]
	push eax
	pop ebx
	mov edx, edges_weights
	mov eax, [edx + 4 * ebx]
	push eax
	pop eax
	add [esp], eax
	mov eax, [ebp - 16]
	push eax
	pop ebx
	mov edx, dist
	mov eax, [edx + 4 * ebx]
	push eax
	call _min
	add esp, 8
	push eax
	mov eax, [ebp - 16]
	push eax
	pop ebx
	mov eax, dist
	pop edx
	mov [eax + 4 * ebx], edx
_dijkstra_while2_endif1:
	mov eax, [ebp - 16]
	push eax
	pop ebx
	mov edx, used
	mov eax, [edx + 4 * ebx]
	push eax
	mov eax, 1
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	sete dl
	push edx
	mov eax, [ebp - 20]
	push eax
	pop ebx
	mov edx, used
	mov eax, [edx + 4 * ebx]
	push eax
	mov eax, 0
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	sete dl
	push edx
	pop eax
	and [esp], eax
	pop eax
	cmp eax, 1
	jne _dijkstra_while2_endif2
	mov eax, [ebp - 16]
	push eax
	pop ebx
	mov edx, dist
	mov eax, [edx + 4 * ebx]
	push eax
	mov eax, [ebp - 4]
	push eax
	pop ebx
	mov edx, edges_weights
	mov eax, [edx + 4 * ebx]
	push eax
	pop eax
	add [esp], eax
	mov eax, [ebp - 20]
	push eax
	pop ebx
	mov edx, dist
	mov eax, [edx + 4 * ebx]
	push eax
	call _min
	add esp, 8
	push eax
	mov eax, [ebp - 20]
	push eax
	pop ebx
	mov eax, dist
	pop edx
	mov [eax + 4 * ebx], edx
_dijkstra_while2_endif2:
	mov eax, [ebp - 4]
	push eax
	mov eax, 1
	push eax
	pop eax
	add [esp], eax
	pop eax
	mov [ebp - 4], eax
	add esp, 8
	jmp _dijkstra_while2
_dijkstra_endwhile2:
	call _dijkstra
	add esp, 0
	push eax
	pop eax
	add esp, 12
	pop ebp
	ret

_main:
	push ebp
	mov ebp, esp
	call _read
	add esp, 0
	push eax
	pop eax
	mov [n], eax
	call _read
	add esp, 0
	push eax
	pop eax
	mov [m], eax
	sub esp, 4
	mov eax, 0
	push eax
	pop eax
	mov [ebp - 4], eax
_main_while1:
	mov eax, [ebp - 4]
	push eax
	mov eax, [n]
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
	mov eax, 100000000
	push eax
	mov eax, [ebp - 4]
	push eax
	pop ebx
	mov eax, dist
	pop edx
	mov [eax + 4 * ebx], edx
	mov eax, [ebp - 4]
	push eax
	mov eax, 1
	push eax
	pop eax
	add [esp], eax
	pop eax
	mov [ebp - 4], eax
	jmp _main_while1
_main_endwhile1:
	mov eax, 0
	push eax
	pop eax
	mov [ebp - 4], eax
_main_while2:
	mov eax, [ebp - 4]
	push eax
	mov eax, [m]
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
	call _read
	add esp, 0
	push eax
	mov eax, [ebp - 4]
	push eax
	pop ebx
	mov eax, edges_from
	pop edx
	mov [eax + 4 * ebx], edx
	call _read
	add esp, 0
	push eax
	mov eax, [ebp - 4]
	push eax
	pop ebx
	mov eax, edges_to
	pop edx
	mov [eax + 4 * ebx], edx
	call _read
	add esp, 0
	push eax
	mov eax, [ebp - 4]
	push eax
	pop ebx
	mov eax, edges_weights
	pop edx
	mov [eax + 4 * ebx], edx
	mov eax, [ebp - 4]
	push eax
	mov eax, 1
	push eax
	pop eax
	add [esp], eax
	pop eax
	mov [ebp - 4], eax
	jmp _main_while2
_main_endwhile2:
	mov eax, 0
	push eax
	mov eax, 0
	push eax
	pop ebx
	mov eax, dist
	pop edx
	mov [eax + 4 * ebx], edx
	call _dijkstra
	add esp, 0
	push eax
	pop eax
	mov eax, 0
	push eax
	pop eax
	mov [ebp - 4], eax
_main_while3:
	mov eax, [ebp - 4]
	push eax
	mov eax, [n]
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
	mov eax, [ebp - 4]
	push eax
	pop ebx
	mov edx, dist
	mov eax, [edx + 4 * ebx]
	push eax
	mov eax, 100000000
	push eax
	pop eax
	pop ebx
	xor edx, edx
	cmp ebx, eax
	setl dl
	push edx
	pop eax
	cmp eax, 1
	jne _main_while3_else1
	mov eax, [ebp - 4]
	push eax
	pop ebx
	mov edx, dist
	mov eax, [edx + 4 * ebx]
	push eax
	call _write
	add esp, 4
	push eax
	pop eax
	jmp _main_while3_endif1
_main_while3_else1:
	mov eax, 0
	push eax
	mov eax, 1
	push eax
	pop eax
	sub [esp], eax
	call _write
	add esp, 4
	push eax
	pop eax
_main_while3_endif1:
	mov eax, [ebp - 4]
	push eax
	mov eax, 1
	push eax
	pop eax
	add [esp], eax
	pop eax
	mov [ebp - 4], eax
	jmp _main_while3
_main_endwhile3:
	add esp, 4
	pop ebp
	ret

