.section    .rodata
    .usage_msg: .string "[inst:usage]: % inst <filename>\n"
    .usage_len: .quad   32

    .openf_msg: .string "[inst:error]: cannot open file\n"
    .openf_len: .quad   31

    .readf_msg: .string "[inst:error]: cannot read file\n"
    .readf_len: .quad   31

    .toklim_msg: .string "[inst:error]: token limit reached\n"
    .toklim_len: .quad   34

    .pairs_msg: .string "[inst:error]: (unmatched/maximum) pair on %d line with an offset of %d\n"

.section    .text

.include    "macros.inc"

.globl  fatal_usage
fatal_usage:
    __eputs .usage_msg(%rip), .usage_len(%rip)
    __fini  $0

.globl  fatal_opening_file
fatal_opening_file:
    __eputs .openf_msg(%rip), .openf_len(%rip)
    __fini  $1

.globl  fatal_readfile
fatal_readfile:
    __eputs .readf_msg(%rip), .readf_len(%rip)
    __fini  $2

.globl  fatal_toklim
fatal_toklim:
    __eputs .toklim_msg(%rip), .toklim_len(%rip)
    __fini  $3

.globl  fatal_pair
fatal_pair:
    pushq   16(%r8)
    pushq   8(%r8)
    movq    $2, %rdi
    leaq    .pairs_msg(%rip), %rsi
    call    _printf_
    __fini  $4

.globl _fatal_pairs_
_fatal_pairs_:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp
    movq    $0, -8(%rbp)
    movq    %rdi, -16(%rbp)
    leaq    Loops(%rip), %r15
    movq    (%r15), %r14
._ftp_loop:
    movq    -8(%rbp), %rax
    cmpq    %rax, -16(%rbp)
    je      ._ftp_fini
    pushq   16(%r14)
    pushq   8(%r14)
    movq    $2, %rdi
    leaq    .pairs_msg(%rip), %rsi
    call    _printf_
    popq    %rax
    popq    %rax
    incq    -8(%rbp)
    addq    $8, %r15
    movq    (%r15), %r14
    jmp     ._ftp_loop
._ftp_fini:
    __fini  $5
