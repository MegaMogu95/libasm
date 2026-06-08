default rel
section .text
global ft_atoi_base
extern ft_strlen

ft_isspace:
	cmp		dil, 9
	je		.isspace
	cmp		dil, 10
	je		.isspace
	cmp		dil, 11
	je		.isspace
	cmp		dil, 12
	je		.isspace
	cmp		dil, 13
	je		.isspace
	cmp		dil, 32
	je		.isspace
	xor		rax, rax
	ret
.isspace:
	mov		rax, 1
	ret

ft_atoi_base:
	push	rdi								;keep rdi (str) before calling check_base
	mov		rdi, rsi
	call	check_base						;rax is now 0 or 1.
	pop		rsi								;str in rsi
	cmp		rax, 0
	je		error

;need	: strlen + str + base + sign + str iterator + base iterator + rax + 
;base	: rdi
;str	: rsi
;it1	: rcx
;it2	: rdx
;sign	: r8
;strlen	: r9
ft_convert:
	xor		rcx, rcx						;for rsi (str)
	push	rdi								;keep base
	call	ft_strlen
	mov		r9, rax
	.skip_ws:
		cmp		byte [rsi + rcx], 0
		je		.done_skipping
		mov		dil, [rsi + rcx]
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
	.next:
	pop		rdi								;base
	xor		rax, rax
	.loop:
		cmp		byte [rsi + rcx], 0
		je		.done
		xor		rdx, rdx					;for rdi (base)
		.find_char:
			cmp		byte [rdi + rdx], 0
			je		.done
			mov		r10b, [rsi + rcx]
			mov		r11b, [rdi + rdx]
			cmp		r10b, r11b
			je		.found
			inc		rdx
			jmp		.find_char
	.found:
		imul	rax, r9
		imul	rdx, r8
		add		rax, rdx
		inc		rcx
		jmp		.loop
	.done:
		ret

;rdi : base (unchanged)
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

;rsi : main loop iterator
;rdx : second loop iterator
;rdi : base (uncahnged)
check_duplicates:
	xor		rsi, rsi
	.loop:
		cmp		byte [rdi + rsi], 0
		je		.done
		mov		rdx, rsi
		inc		rdx
		.loop1:
			cmp		byte [rdi + rdx], 0
			je		.done1
			mov		r8b, [rdi + rdx]
			mov		r9b, [rdi + rsi]
			cmp		r9b, r8b
			je		error
			inc		rdx
			jmp		.loop1
		.done1:
			inc		rsi
			jmp		.loop
	.done:
		mov		rax, 1
		ret


;rdi : base (unchanged)
;rsi : iterator
check_char:
	xor		rsi, rsi
	.loop:
		cmp		byte [rdi + rsi], 0
		je		.done
		push	rdi						;keep rdi (base) before calling isspace on dil
		mov		byte dl, [rdi + rsi]
		mov		dil, dl
		call	ft_isspace
		pop		rdi
		cmp		rax, 1
		je		error
		cmp		byte [rdi + rsi], 43
		je		error
		cmp		byte [rdi + rsi], 45
		je		error
		inc		rsi
		jmp		.loop
	.done:
		mov		rax, 1
		ret

error:
	xor	rax, rax
	ret