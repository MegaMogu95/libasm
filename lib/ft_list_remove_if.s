default rel
section .text
global ft_list_remove_if
extern free

ft_list_remove_if:
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15                     ; 5 pushes -> rsp 16-aligned for every call

    mov     rbx, rdi                ; rbx : begin_list  (&head)
    mov     r13, rsi                ; r13 : data_ref
    mov     r14, rdx                ; r14 : cmp
    mov     r15, rcx                ; r15 : free_fct

.loop:
    mov     r12, [rbx]              ; r12 = current node (*ptr)
    test    r12, r12
    jz      .done                   ; reached end of list

    mov     rdi, [r12]              ; current->data
    mov     rsi, r13                ; data_ref
    call    r14                     ; cmp(current->data, data_ref)
    test    eax, eax
    jnz     .keep                   ; cmp != 0  -> keep this node

    ; ---- remove current ----
    mov     rax, [r12 + 8]          ; current->next
    mov     [rbx], rax              ; *ptr = current->next   (unlink)
    mov     rdi, [r12]              ; current->data
    call    r15                     ; free_fct(current->data)
    mov     rdi, r12                ; current node
    call    free wrt ..plt          ; free the node struct itself
    jmp     .loop                   ; ptr unchanged -> re-check the new *ptr

.keep:
    lea     rbx, [r12 + 8]          ; ptr = &current->next   (advance)
    jmp     .loop

.done:
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret