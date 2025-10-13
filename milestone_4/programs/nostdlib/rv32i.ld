/*
 * Linker script for RV32I processor
 * Defines memory layout and section placement
 */

ENTRY(_start)

MEMORY
{
    /* Instruction memory - matches your inst_mem module */
    IMEM (rx)  : ORIGIN = 0x00000000, LENGTH = 1K
    /* Data memory (if you have one) */
    DMEM (rw)  : ORIGIN = 0x00000400, LENGTH = 1K
}

SECTIONS
{
    /* Text section - program instructions */
    .text : ALIGN(4)
    {
        *(.text._start)     /* Start function first */
        *(.text)            /* All other text */
        *(.text.*)
    } > IMEM

    /* Read-only data */
    .rodata : ALIGN(4)
    {
        *(.rodata)
        *(.rodata.*)
    } > IMEM

    /* Data section */
    .data : ALIGN(4)
    {
        _data_start = .;
        *(.data)
        *(.data.*)
        _data_end = .;
    } > DMEM

    /* BSS section */
    .bss : ALIGN(4)
    {
        _bss_start = .;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        _bss_end = .;
    } > DMEM

    /* Stack (grows downward from end of DMEM) */
    _stack_top = ORIGIN(DMEM) + LENGTH(DMEM);

    /* Discard unnecessary sections */
    /DISCARD/ :
    {
        *(.note*)
        *(.comment)
        *(.eh_frame*)
    }
}