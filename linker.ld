/* tinyKernel linker script */
/* Target: 32-bit x86, Multiboot 1 */

OUTPUT_FORMAT(elf32-i386)
OUTPUT_ARCH(i386)
ENTRY(_start)

SECTIONS
{
    /* Load the kernel at 1 MiB. */
    . = 1M;

    /* Keep the Multiboot header near the beginning of the file. */
    .multiboot ALIGN(4) :
    {
        KEEP(*(.multiboot))
    }

    /* Kernel code. */
    .text ALIGN(4K) :
    {
        *(.text)
        *(.text.*)
    }

    /* Read-only data. */
    .rodata ALIGN(4K) :
    {
        *(.rodata)
        *(.rodata.*)
    }

    /* Initialized writable data. */
    .data ALIGN(4K) :
    {
        *(.data)
        *(.data.*)
    }

    /* Uninitialized data and stack. */
    .bss ALIGN(4K) :
    {
        *(COMMON)
        *(.bss)
        *(.bss.*)
    }

    /* Discard metadata that is not needed in the kernel image. */
    /DISCARD/ :
    {
        *(.comment)
        *(.note*)
        *(.eh_frame*)
    }
}