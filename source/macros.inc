.macro  __eputs msg, len
    leaq    \msg, %rsi
    movq    \len, %rdx
    movq    $2, %rdi
    movq    $1, %rax
    syscall
.endm

.macro  __fini a
    movq    \a, %rdi
    movq    $60, %rax
    syscall
.endm
