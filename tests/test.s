.section    .text
.globl  _start

_start:
    movq    $10, %rax
    movq    $10, %rcx
    divq    %rcx

    movq    %rdx, %rdi
    movq    $60, %rax
    syscall
