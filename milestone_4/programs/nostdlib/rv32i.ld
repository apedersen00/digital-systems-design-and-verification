ENTRY(_start)

MEMORY
{
    IMEM (rx)  : ORIGIN = 0x00000000, LENGTH = 32K
    DMEM (rw)  : ORIGIN = 0x00008000, LENGTH = 32K
}

SECTIONS
{
    /* Text section (instructions) */
    .text : ALIGN(4)
    {
        *(.text._start)
        *(.text)
        *(.text.*)
    } > IMEM

    /* Read-only data */
    .rodata : ALIGN(4)
    {
        *(.rodata)
        *(.rodata.*)
    } > IMEM

    /* Data section (initialized globals) */
    .data : ALIGN(4)
    {
        _data_load_start = LOADADDR(.data);  /* address in flash */
        _data_start = .;                     /* address in RAM */
        *(.data)
        *(.data.*)
        *(.sdata*)
        _data_end = .;
    } > DMEM AT > IMEM

    /* BSS section (zero-initialized globals) */
    .bss : ALIGN(4)
    {
        _bss_start = .;
        *(.bss)
        *(.bss.*)
        *(.sbss*)
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
