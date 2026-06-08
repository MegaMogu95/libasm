default rel
section .text
global ft_list_push_front
extern malloc

;void ft_list_push_front(t_list **begin_list, void *data)
;rdi : begin_list
;rsi : data
;rax : new_node
;rdx : tmp
ft_list_push_front:
    push    rdi
    push    rsi
    mov     rdi, 16
    sub     rsp, 8
    call    malloc  wrt ..plt
    add     rsp, 8
    pop     rsi
    pop     rdi
    mov     [rax], rsi
    mov     rdx, [rdi]
    mov     [rax + 8], rdx
    mov     [rdi], rax
    ret