default rel
section .text
global ft_list_sort
extern ft_list_size

;void ft_list_sort(t_list **begin_list, int (*cmp)())
ft_list_sort:
    push    r12
    push    r13
    push    r14
    mov     r12, rdi            ;begin_list in r12
    mov     r13, rsi            ;cmp in r13
    mov     rdi, [r12]
    call    ft_list_size
    mov     r14, rax            ;list_size in r14
    .loop:
        cmp     r14, 1
        jle     .done
        mov     rdi, [r12]      ;node
        mov     rsi, [rdi + 8]  ;next
        .bubble:
            cmp     rsi, 0
            je      .done_bubble
            push    rdi
            push    rsi
            mov     rdi, [rdi]
            mov     rsi, [rsi]
            call    r13
            pop     rsi
            pop     rdi
            cmp     eax, 0
            jle      .skip_swap
            call    ft_swap_node
            .skip_swap:
            mov     rdi, rsi
            mov     rsi, [rdi + 8]
            jmp     .bubble
        .done_bubble:
            dec     r14
            jmp     .loop
    .done:
        pop     r14
        pop     r13
        pop     r12
        ret

ft_swap_node:
    mov     rdx, [rdi]
    mov     rcx, [rsi]
    mov     [rdi], rcx
    mov     [rsi], rdx
    ret