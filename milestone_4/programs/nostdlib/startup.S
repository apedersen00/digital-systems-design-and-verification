    .section .text
    .globl _start

_start:
    # Initialize stack pointer
    la sp, _stack_top
    mv ra, zero
    mv s0, zero
    mv s1, zero
    mv s2, zero
    mv gp, zero
    mv tp, zero

    # -----------------------------
    # Copy .data from flash to RAM
    # -----------------------------
    la a0, _data_start        # destination in RAM
    la a1, _data_load_start   # source in flash
    la a2, _data_end          # end of data in RAM
copy_data:
    bge a0, a2, data_done
    lw t0, 0(a1)
    sw t0, 0(a0)
    addi a0, a0, 4
    addi a1, a1, 4
    j copy_data
data_done:

    # -----------------------------
    # Zero-initialize .bss
    # -----------------------------
    la a0, _bss_start
    la a1, _bss_end
    li a2, 0
bss_clear:
    bge a0, a1, bss_done
    sw a2, 0(a0)
    addi a0, a0, 4
    j bss_clear
bss_done:

    # Call main
    call main

hang:
    j hang
