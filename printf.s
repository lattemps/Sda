.section    .rodata
    .test:  .string "hola\n"


.section    .data
    .buffer:    .zero   1024


.section    .text
.globl  _printf_


# rdi: stream
# rsi: fmt string
_printf_:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $16, %rsp
    # -8(%rbp): stream to be written.............
    # -16(%rbp): number of bytes to be written...
    movq    %rdi, -8(%rbp)
    movq    $0, -16(%rbp)
    # r8: reads the fmt string...
    # r9: modifies the buffer....
    movq    %rsi, %r8
    leaq    .buffer(%rip), %r9
._pfloop:
    # Making sure EOF has not been reached
    movzbl  (%r8), %eax
    testl   %eax, %eax
    jz      ._pffini
    # Check for possible formats
    cmpl    $'%', %eax
    je      ._pfformat
    # If ain't format just write the byte into the buffer
    incq    -16(%rbp)
    movb    %al, (%r9)
    jmp     ._pfcontinue
._pfformat:


._pfcontinue:
    incq    %r8
    incq    %r9
    jmp     ._pfloop

._pffini:
    movq    -16(%rbp), %rdx
    leaq    .buffer(%rip), %rsi
    movq    -8(%rbp), %rdi
    movq    $1, %rax
    syscall
    leave
    ret


.globl  _start
_start:
    movq    $1, %rdi
    leaq    .test(%rip), %rsi
    call    _printf_

    movq    $60, %rax
    movq    $0, %rdi
    syscall
