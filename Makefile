ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

AS := nasm
CC := gcc
LD := ld

OUT := $(ROOT)/out
TARGET := $(OUT)/tinyKernel.elf

CFLAGS := -m32 -ffreestanding -fno-pie -fno-stack-protector \
          -fno-builtin -Wall -Wextra
ASFLAGS := -f elf32
LDFLAGS := -m elf_i386 -T $(ROOT)/linker.ld -nostdlib

ALL_OBJECTS :=

# Recursively read Makefiles and collect objects.
define descend
$(eval OBJECTS :=)
$(eval SUBDIRS :=)
$(eval include $(ROOT)/$(1)/Makefile)
$(eval ALL_OBJECTS += $(addprefix $(ROOT)/$(1)/,$(OBJECTS)))
$(foreach child,$(SUBDIRS),$(call descend,$(1)/$(child)))
endef

$(call descend,boot)
$(call descend,kernel)

# Compile source files beside their corresponding objects.
$(ROOT)/%.o: $(ROOT)/%.c
	$(CC) $(CFLAGS) -c "$<" -o "$@"

$(ROOT)/%.o: $(ROOT)/%.asm
	$(AS) $(ASFLAGS) "$<" -o "$@"

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(ALL_OBJECTS) $(ROOT)/linker.ld
	mkdir -p "$(OUT)"
	$(LD) $(LDFLAGS) -o "$@" $(ALL_OBJECTS)

clean:
	rm -f $(ALL_OBJECTS) "$(TARGET)"