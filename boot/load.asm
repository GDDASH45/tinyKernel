; tinyKernel - boot/load.asm
; Multiboot 1 boot entry point (32-bit x86)

BITS 32

section .multiboot
align 4

MB_MAGIC    equ 0x1BADB002
MB_FLAGS    equ 0x00000003
MB_CHECKSUM equ -(MB_MAGIC + MB_FLAGS)

dd MB_MAGIC
dd MB_FLAGS
dd MB_CHECKSUM

section .bss
align 16

stack_bottom:
    resb 16384
stack_top:

section .text
global _start
extern kernel_main

_start:
    cli

    ; Set up the stack.
    mov esp, stack_top
    xor ebp, ebp

    ; Multiboot provides EAX = bootloader magic and EBX = info pointer.
    ; Preserve both as C arguments.
    push ebx
    push eax
    call kernel_main

.hang:
    cli
    hlt
    jmp .hang

section .note.GNU-stack noalloc noexec nowrite progbits