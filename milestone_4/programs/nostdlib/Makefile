# Makefile for compiling C programs to RV32I hex files
# Requires RISC-V GNU toolchain to be installed

CROSS_COMPILE ?= riscv64-elf-
CC = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
SIZE = $(CROSS_COMPILE)size

# Compiler flags for RV32I
CFLAGS = -march=rv32i -mabi=ilp32 -static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles
CFLAGS += -O0 -Wall -Wextra
CFLAGS += -fno-common -ffunction-sections -fdata-sections

# Linker flags
LDFLAGS = -T rv32i.ld -nostdlib -Wl,--gc-sections -Wl,--print-memory-usage

# Available programs
PROGRAMS = verification primes
DEFAULT_PROGRAM = primes

# Directory structure
SRC_DIR = src
OUT_DIR = out

# Default target
all: $(DEFAULT_PROGRAM)

# Create output directory
$(OUT_DIR):
	@mkdir -p $(OUT_DIR)

# Generic rules for each program
define PROGRAM_RULES
$(1): $(OUT_DIR)/$(1).hex

$(OUT_DIR)/$(1).elf: startup.S $(SRC_DIR)/$(1).c rv32i.ld | $(OUT_DIR)
	@echo "Compiling $(1)..."
	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-Map=$(OUT_DIR)/$(1).map -o $$@ startup.S $(SRC_DIR)/$(1).c

$(OUT_DIR)/$(1).bin: $(OUT_DIR)/$(1).elf
	@echo "Creating binary file $(OUT_DIR)/$(1).bin..."
	$(OBJCOPY) -O binary $$< $$@

$(OUT_DIR)/$(1).hex: $(OUT_DIR)/$(1).elf
	@echo "Creating hex file $(OUT_DIR)/$(1).hex..."
	$(OBJCOPY) -O verilog --verilog-data-width=4 $$< $$@
	@echo "Hex file created: $(OUT_DIR)/$(1).hex"
	@echo "Instructions in hex file:"
	@head -10 $$@

$(OUT_DIR)/$(1).dis: $(OUT_DIR)/$(1).elf
	@echo "Creating disassembly $(OUT_DIR)/$(1).dis..."
	$(OBJDUMP) -D $$< > $$@

$(1)-debug: $(OUT_DIR)/$(1).hex $(OUT_DIR)/$(1).dis
	@echo "Debug build complete for $(1). Check $(OUT_DIR)/$(1).dis for disassembly."

.PHONY: $(1) $(1)-debug
endef

# Generate rules for each program
$(foreach prog,$(PROGRAMS),$(eval $(call PROGRAM_RULES,$(prog))))

# Build all programs
all-programs: $(PROGRAMS)

# Debug builds for all programs
debug-all: $(foreach prog,$(PROGRAMS),$(prog)-debug)

# Clean build artifacts
clean:
	rm -rf $(OUT_DIR)

# Show available programs
list-programs:
	@echo "Available programs:"
	@for prog in $(PROGRAMS); do echo "  $$prog"; done

# Show targets
help:
	@echo "Available targets:"
	@echo "  all                    - Build default program ($(DEFAULT_PROGRAM))"
	@echo "  all-programs           - Build all programs"
	@echo "  <program>              - Build specific program ($(PROGRAMS))"
	@echo "  <program>-debug        - Build program with debug info"
	@echo "  debug-all              - Build all programs with debug info"
	@echo "  list-programs          - List available programs"
	@echo "  clean                  - Remove build artifacts"
	@echo "  help                   - Show this help"
	@echo ""
	@echo "Available programs: $(PROGRAMS)"

.PHONY: all all-programs debug-all clean list-programs help