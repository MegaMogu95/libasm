default rel
section .text
global ft_list_size

;int ft_list_size(t_list *begin_list)
ft_list_size:
    xor     rax, rax
    .loop:
        cmp     qword rdi, 0
        je      .done
        mov     rsi, [rdi + 8]
        mov     rdi, rsi
        inc     rax
        jmp     .loop
    .done:
        ret