default rel
section .text
global ft_strdup
extern	ft_strlen
extern	ft_strcpy
extern	malloc

ft_strdup:
	push	rdi
	call	ft_strlen			;rax->strlen
	mov		rdi, rax			;rdi->strlen
	add		rdi, 1
	call	malloc wrt ..plt	;rax->ret
	pop		rsi
	cmp		rax, 0
	je		.done
	mov		rdi, rax
	sub		rsp, 8
	call	ft_strcpy
	add		rsp, 8
	ret
.done:
	ret