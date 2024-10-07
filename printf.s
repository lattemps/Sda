.section    .rodata
    .nullstr_msg:   .string "[printf:fatal]: null string (rsi)\n"
    .nullstr_len:   .quad   34

    .buffovr_msg:   .string "[printf:fatal]: buffer overflow\n"
    .buffovr_len:   .quad   32

    .expectingfmt_msg:  .string "[printf:fatal]: format expected\n"
    .expectingfmt_len:   .quad   32

    .buffsz: .quad 1024
    .test: .string "test %d\n"

.section    .data
    .buffer:    .zero   1024
    .numbuf:    .zero   32

.section    .text
.include    "macros.inc"

.globl  _printf_

# rdi: stream
# rsi: fmt string
_printf_:
    cmpq    $0, %rsi
    je      .fatal_null_str
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $16, %rsp
    # -8(%rbp): stream to be written.............
    # -16(%rbp): number of bytes to be written...
    # -24(%rbp): nth argument....................
    movq    %rdi, -8(%rbp)
    movq    $0, -16(%rbp)
    # r8: reads the fmt string...
    # r9: modifies the buffer....
    movq    %rsi, %r8
    leaq    .buffer(%rip), %r9
._pfloop:
    # Making sure there is not overflow
    movq    -16(%rbp), %rax
    cmpq    %rax, .buffsz(%rip)
    je      .fatal_buff_overflow
    # Making sure there still is content to be read
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
    # r10 will hold this argument
    movq    -24(%rbp), %rbx
    leaq    16(%rbp), %r10
    movq    (%r10, %rbx, 8), %r10
    incq    %r8
    movzbl  (%r8), %eax
    cmpl    $'d', %eax
    je      ._pf_fmt_num
    cmpl    $'s', %eax
    je      ._pf_fmt_str
    cmpl    $'c', %eax
    je      ._pf_fmt_chr
    cmpl    $'%', %eax
    je      ._pf_fmt_pct
    jmp     .fatal_expecting_fmt
._pf_fmt_num:
    cmpq    $0, %r10
    jne      ._pf_fmt_num_nz
    movb    $'0', (%r9)
    incq    -16(%rbp)
    jmp     ._pfcontinue
._pf_fmt_num_nz:



._pf_fmt_str:
._pf_fmt_chr:
._pf_fmt_pct:

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

#  _____________
# < Errors here >
#  -------------
#  \
#   \
#    \ >()_
#       (__)__ _
.fatal_null_str:
    __eputs .nullstr_msg(%rip), .nullstr_len(%rip)
    __fini  $1
.fatal_buff_overflow:
    __eputs .buffovr_msg(%rip), .buffovr_len(%rip)
    __fini  $2
.fatal_expecting_fmt:
    __eputs .expectingfmt_msg(%rip), .expectingfmt_len(%rip)
    __fini  $3


#  _______________
# < Tests here... >
#  ---------------
#  \
#   \
#    \ >()_
#       (__)__ _
.globl  _start
_start:
    pushq   $0
    movq    $1, %rdi
    leaq    .test(%rip), %rsi
    call    _printf_

    movq    $60, %rax
    movq    $0, %rdi
    syscall
