default rel
section .text
global ft_read
extern __errno_location

;ssize_t          ft_read(int fd, void *buf, size_t count);
ft_read:
	mov		rax, 0
	syscall
	cmp		rax, 0
	jl		.errno
	ret
.errno:
	neg		rax
	push	rax
	call    __errno_location wrt ..plt
	pop		rcx
	mov		dword [rax], ecx
	mov		rax, -1
	ret