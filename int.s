.section    .rodata
    token_size:    .quad   32                  # size of a token...........................
    tokens_max:    .quad   1024                # maximum number of tokens..................
    loops_max:     .quad   64                  # maximum number of nested loops in a row...

    .globl  token_size
    .globl  tokens_max
    .globl  loops_max

.section    .bss 
    Tokens: .zero   1024 * 32  # Capcity of 1024 tokens of size 32 B.......
    Loops:  .zero   64 * 8     # Array of ptrs <ptr is size 8 B>...........
    .Mem:   .zero   30000

    .globl  Tokens
    .globl  Loops

.section    .text

.include    "macros.inc"                # Note: remove this

.globl  _int_
_int_:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $16, %rsp
    movq    $0, -8(%rbp)
    movq    %rdi, -16(%rbp)
    leaq    Tokens(%rip), %r8
    leaq    .Mem(%rip), %r9
._int_eat:
    movl    -8(%rbp), %eax
    cmpl    -16(%rbp), %eax
    je      ._int_fini
    xorq    %r10, %r10
    movq    24(%r8), %r10
    movq    (%r8), %rax
    movzbl  (%rax), %eax
    cmpl    $'+', %eax
    je      ._int_inc
    cmpl    $'-', %eax
    je      ._int_dec
    cmpl    $'<', %eax
    je      ._int_prv
    cmpl    $'>', %eax
    je      ._int_nxt
    cmpl    $',', %eax
    je      ._int_inp
    cmpl    $'.', %eax
    je      ._int_out
    cmpl    $'[', %eax
    je      ._int_bgn_loop
    cmpl    $']', %eax
    je      ._int_end_loop

    jmp     ._int_continue

._int_inc:
    addb    %r10b, (%r9)
    jmp     ._int_continue
._int_dec:
    subb    %r10b, (%r9)
    jmp     ._int_continue
._int_nxt:
    addq    %r10, %r9
    jmp     ._int_continue
._int_prv:
    subq    %r10, %r9
    jmp     ._int_continue
._int_inp:
    testq   %r10, %r10
    jz      ._int_continue
    movq    %r9, %rsi
    movq    $0, %rdi
    movq    $1, %rdx
    movq    $0, %rax
    syscall
    decq    %r10
    jmp     ._int_inp
._int_out:
    testq   %r10, %r10
    jz      ._int_continue
    movq    $1, %rax
    movq    $1, %rdx
    movq    $1, %rdi
    movq    %r9, %rsi
    syscall
    decq    %r10
    jmp     ._int_out
._int_bgn_loop:
    movzbl  (%r9), %eax
    testl   %eax, %eax
    jnz     ._int_continue
    xorq    %rax, %rax
    movq    24(%r8), %rax
    movq    %rax, -8(%rbp)
    movq    token_size(%rip), %rbx
    mulq    %rbx
    leaq    Tokens(%rip), %rbx
    addq    %rax, %rbx
    movq    %rbx, %r8
    jmp     ._int_continue
._int_end_loop:
    movzbl  (%r9), %eax
    testl   %eax, %eax
    jz      ._int_continue
    movq    24(%r8), %rax
    movq    %rax, -8(%rbp)
    movq    token_size(%rip), %rbx
    mulq    %rbx
    leaq    Tokens(%rip), %rbx
    addq    %rax, %rbx
    movq    %rbx, %r8
    jmp     ._int_eat
._int_continue:
    movq    token_size(%rip), %rax
    addq    %rax, %r8
    incl    -8(%rbp)
    jmp     ._int_eat
._int_fini:
    movzbl  (%r9), %eax
    cltq
    __fini  %rax
    leave
    ret
