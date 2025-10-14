    .section .text
    .globl _start

_start:
    # Initialize stack pointer
    la sp, _stack_top
    mv s0, zero
    mv ra, zero

    # --------------------------------------------------------------------
    # Zero-initialize the .bss section
    # --------------------------------------------------------------------
    la a0, _bss_start        # a0 = start address of .bss
    la a1, _bss_end          # a1 = end address of .bss
    li a2, 0                 # a2 = zero

bss_clear:
    bge a0, a1, bss_done     # while (a0 < a1)
    sw a2, 0(a0)             # *a0 = 0
    addi a0, a0, 4           # a0++
    j bss_clear
bss_done:

    # --------------------------------------------------------------------
    # Call main
    # --------------------------------------------------------------------
    call main

1:  j 1b                     # Infinite loop after main returns
