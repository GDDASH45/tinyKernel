#include <stdint.h>

#define VGA_MEMORY ((volatile uint16_t *)0xB8000)
#define VGA_WIDTH  80
#define VGA_HEIGHT 25
#define VGA_COLOR  0x0F

static void terminal_clear(void)
{
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        VGA_MEMORY[i] = ((uint16_t)VGA_COLOR << 8) | ' ';
    }
}

static void terminal_write(const char *text)
{
    static unsigned int cursor = 0;

    while (*text && cursor < VGA_WIDTH * VGA_HEIGHT) {
        VGA_MEMORY[cursor++] =
            ((uint16_t)VGA_COLOR << 8) | (uint8_t)*text++;
    }
}

void kernel_main(uint32_t multiboot_magic, uint32_t multiboot_info)
{
    (void)multiboot_info;

    terminal_clear();

    if (multiboot_magic == 0x2BADB002) {
        terminal_write("tinyKernel: Multiboot boot successful!");
    } else {
        terminal_write("tinyKernel: Invalid Multiboot magic.");
    }

    for (;;) {
        __asm__ volatile ("cli; hlt");
    }
}