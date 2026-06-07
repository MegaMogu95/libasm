default rel
section .text
global ft_atoi_base
extern ft_strlen

ft_isspace:
	cmp		byte [rdi + rcx], 9
	je		.isspace
	cmp		byte [rdi + rcx], 10
	je		.isspace
	cmp		byte [rdi + rcx], 11
	je		.isspace
	cmp		byte [rdi + rcx], 12
	je		.isspace
	cmp		byte [rdi + rcx], 13
	je		.isspace
	cmp		byte [rdi + rcx], 32
	je		.isspace
	xor		rax, rax
	ret
.isspace:
	mov		rax, 1
	ret

ft_atoi_base:
	push	rdi								;keep rdi (str) before calling check_base
	mov		rdi, rsi
	call	check_base						;rax is now 0 or 1
	pop		rsi								;getting back str in rsi
	cmp		rax, 0
	je		error
ft_convert:
	call	ft_strlen
	mov		r9, rax							;r9 contains strlen(base)
	xor		rcx, rcx						;for rsi (str)
	.skip_ws:
		cmp		byte [rsi + rcx], 0
		je		.done_skipping
		call	ft_isspace
		cmp		rax, 0
		je		.done_skipping
		inc		rcx
		jmp		.skip_ws
	.done_skipping:
		mov		r8, 1
		cmp		byte [rsi + rcx], 45
		jne		.not_minus
		mov		r8, -1						;r8 contains sign
		inc		rcx
		jmp		.next
	.not_minus:
		cmp		byte [rsi + rcx], 43
		jne		.next
		inc		rcx
	.next
	push	r8								;to keep sign
	push	r9								;to keep strlen
	xor		rax, rax
	.loop:
		cmp		byte [rsi + rcx], 0
		je		.done
		xor		rdx, rdx					;for rdi (base)
		.find_char:
			cmp		byte [rdi + rdx], 0
			je		.done
			mov		r8b, [rsi + rcx]
			mov		r9b, [rdi + rdx]
			cmp		r8b, r9b
			je		.found
			inc		rdx
			jmp		.find_char
	.found:
		pop		r9							;strlen(base)
		imul	rax, r9
		pop		r8							;sign
		imul	rdx, r8
		add		rax, rdx
		inc		rcx
		jmp		.loop
	.done:
		ret

;check_base -> ft_strlen > 2, no duplicates, no +- or whitespace (isspace)
;base in rdi, ret in rax. Doesn't touch rdi (base)
check_base:
	call	ft_strlen
	cmp		rax, 2
	jl		error
	call	check_duplicates
	cmp		rax, 0
	je		error
	call	check_char
	cmp		rax, 0
	je		error
	mov		rax, 1
	ret

check_duplicates:
	mov		rcx, 0
	.loop:
		cmp		byte [rdi + rcx], 0
		je		.done
		mov		rdx, rcx
		inc		rdx
		.loop1:
			cmp		byte [rdi + rdx], 0
			je		.done1
			mov		r8b, [rdi + rdx]
			mov		r9b, [rdi + rcx]
			cmp		r9b, r8b
			je		error
			inc		rdx
			jmp		.loop1
		.done1:
			inc		rcx
			jmp		.loop
	.done:
		mov		rax, 1
		ret

check_char:
	xor		rcx, rcx
	.loop:
		cmp		byte [rdi + rcx], 0
		je		.done
		call	ft_isspace
		cmp		rax, 1
		je		error
		cmp		byte [rdi + rcx], 43
		je		error
		cmp		byte [rdi + rcx], 45
		je		error
		inc		rcx
		jmp		.loop
	.done:
		mov		rax, 1
		ret

error:
	xor	rax, rax
	ret