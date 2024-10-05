.section    .text
.globl  _start

.include    "macros.inc"

_start:
    # Checking number of arguments is correct
    # it must be two.
    popq    %rax
    cmpq    $2, %rax
    jne     fatal_usage
    popq    %rdi
    popq    %rdi
    # Setting up the stack for this function
    #
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp
    # rdi saves the name of the file to be
    # interpreted: edi = open(rdi, O_RDWR, 0)
    movq    $2, %rsi
    xorq    %rdx, %rdx
    movq    $2, %rax
    syscall
    cmpq    $3, %rax
    jl      fatal_opening_file
    movl    %eax, %edi
    # Getting file's size by lseek syscalls.
    # r15 = lseek(rdi, 0, SEEK_END)
    # (void) lseek(rdi, 0, SEEK_SET)
    xorq    %rsi, %rsi
    movq    $2, %rdx
    movq    $8, %rax
    syscall
    movq    %rax, %r15
    movq    $0, %rdx
    movq    $8, %rax
    syscall
    __fini  %r15
