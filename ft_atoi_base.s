section .text
global ft_write
extern ft_strlen


;int ft_atoi_base(char *str, char *base)
ft_atoi_base:
	xor		rax, rax						;zero rax to cumulate XOR
	push	rdi								;keep rdi (str) before calling check_base
	call	.check_base						;rax is now 0 or 1
	pull	rdi								;getting back str in rdi
	cmp		rax, 0
	je		.error							;jump and return 0 in case of error (0 was returned)

.error:
	ret

;check_base -> ft_strlen > 2, no duplicates, no +- or whitespace (isspace)

.check_base:
	mov		rdi, rsi						;move rsi (base) to rdi (first argument)
	call	ft_strlen
	cmp		rax, 2