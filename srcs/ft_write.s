default rel
section .text
global ft_write
extern __errno_location

;ssize_t	ft_write(int fd, const void buf[count], size_t count)
;syscall number : 1 (in rax)
;retval in rax
ft_write:
	mov		rax, 1
	syscall
	cmp		rax, 0
	jl		.errno
	ret
.errno:
	neg		rax
	push	rax
	call	__errno_location wrt ..plt
	pop		rcx
	mov		[rax], rcx
	mov		rax, -1
	ret