section .text
global ft_write
extern ft_strlen


;int ft_atoi_base(char *str, char *base)
ft_atoi_base:
	push	rdi								;keep rdi (str) before calling check_base
	mov		rdi, rsi
	call	check_base						;rax is now 0 or 1
	pull	rsi								;getting back str in rsi
	cmp		rax, 0
	je		.error							;jump and return 0 in case of error (0 was returned)

;check_base -> ft_strlen > 2, no duplicates, no +- or whitespace (isspace)
;base in rdi, ret in rax. Doesn't touch rdi (base)
check_base:
	call	ft_strlen
	cmp		rax, 2
	jl		.error
	call	check_duplicates
	cmp		rax, 1
	jl		.error
	call	check_char
	cmp		rax, 1
	jl		.error

check_duplicates:
	mov		rcx, 0
	.loop:
		cmp		byte [rdi + rcx], 0
		je		.done
		mov		rdx, rcx
		inc		rdx
		.loop1:
			cmp		byte [rdi + rcx], [rdi + rdx]
			je		.done1

	.done:


.error:
	xor	rax, rax
	ret