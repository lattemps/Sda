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
    movq    %r8, %rax
    movq    (%rax), %rax
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

    jmp     ._int_continue


._int_inc:
    movq    24(%r8), %r10
    addb    %r10b, (%r9)
    jmp     ._int_continue
._int_dec:
    movq    24(%r8), %r10
    decb    %r10b, (%r9)
    jmp     ._int_continue
._int_nxt:
    incq    %r9
    jmp     ._int_continue
._int_prv:
    decq    %r9
    jmp     ._int_continue
._int_inp:
    movq    %r9, %rsi
    movq    $0, %rdi
    movq    $1, %rdx
    movq    $0, %rax
    syscall
    jmp     ._int_continue
._int_out:
    movq    $1, %rax
    movq    $1, %rdx
    movq    $1, %rdi
    movq    %r9, %rsi
    syscall
    jmp     ._int_continue
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
