.section    .rodata
    .usage_msg: .string "[inst:usage]: % inst <filename>\n"
    .usage_len: .quad   32

    .openf_msg: .string "[inst:error]: cannot open file\n"
    .openf_len: .quad   31

    .readf_msg: .string "[inst:error]: cannot read file\n"
    .readf_len: .quad   31

    .toklim_msg: .string "[inst:error]: token limit reached\n"
    .toklim_len: .quad   34

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
