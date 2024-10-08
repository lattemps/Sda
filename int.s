.section    .rodata
    token_size:    .quad   32                  # size of a token...........................
    tokens_max:    .quad   1024                # maximum number of tokens..................
    loops_max:     .quad   64                  # maximum number of nested loops in a row...

    .globl  token_size
    .globl  tokens_max
    .globl  loops_max

.section    .bss 
	.align 32
	.type	Tokens, @object
	.size	Tokens, 1024 * 32
    Tokens: .zero   1024 * 32   # Capcity of 1024 tokens of size 32 B.......

	.align 32
	.type	Loops, @object
	.size	Loops, 64 * 8
    Loops:  .zero   64 * 8     # Array of ptrs <ptr is size 8 B>...........

    .globl  Tokens
    .globl  Loops
