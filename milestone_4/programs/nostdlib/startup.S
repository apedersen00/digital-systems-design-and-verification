    .section .text
    .globl _start

_start:
    la sp, _stack_top
    mv s0, zero
    mv ra, zero

    call main

1: j 1b

    .section .bss
    .align 4