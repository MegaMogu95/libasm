default rel
section .text
global ft_strcmp

;int strcmp(const char *s1, const char *s2)
;s1 : rdi
;s2 : rsi
ft_strcmp:
	xor	rax, rax
	xor	rcx, rcx
	xor	rdx, rdx
.loop:
	mov	cl, [rdi + rax]
	mov	dl, [rsi + rax]
	cmp	cl, 0
	je	.done
	cmp	rcx, rdx
	jne	.done
	inc	rax
	jmp	.loop
.done:
	mov	rax, rcx
	sub	rax, rdx
	ret