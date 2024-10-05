.section    .rodata
    .usage_msg: .string "[inst:usage]: % inst <filename>\n"
    .usage_len: .quad   32

    .openf_msg: .string "[inst:error]: cannot open file\n"
    .openf_len: .quad   31

.section    .text

.include    "macros.inc"

.globl  fatal_usage
fatal_usage:
    __eputs .usage_msg(%rip), .usage_len(%rip)
    __fini  $0

.globl  fatal_opening_file
fatal_opening_file:
    __eputs .openf_msg(%rip), .openf_len(%rip)
    __fini  $0
