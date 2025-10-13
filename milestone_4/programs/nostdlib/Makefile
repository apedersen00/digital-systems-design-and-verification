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

# Target program
PROGRAM = test_program
SRC = startup.S $(PROGRAM).c
OUT_DIR = out
ELF = $(OUT_DIR)/$(PROGRAM).elf
BIN = $(OUT_DIR)/$(PROGRAM).bin
HEX = $(OUT_DIR)/$(PROGRAM).hex
MAP = $(OUT_DIR)/$(PROGRAM).map
DIS = $(OUT_DIR)/$(PROGRAM).dis

# Default target
all: $(HEX)

# Create output directory
$(OUT_DIR):
	@mkdir -p $(OUT_DIR)

# Compile C to ELF
$(ELF): $(SRC) rv32i.ld | $(OUT_DIR)
	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-Map=$(MAP) -o $@ $(SRC)

# Convert ELF to binary
$(BIN): $(ELF)
	@echo "Creating binary file $(BIN)..."
	$(OBJCOPY) -O binary $< $@

# Convert ELF to hex file for SystemVerilog $readmemh
$(HEX): $(ELF)
	@echo "Creating hex file $(HEX)..."
	$(OBJCOPY) -O verilog --verilog-data-width=4 $< $@
	@echo "Hex file created: $(HEX)"
	@echo "Instructions in hex file:"
	@head -10 $@

# Create disassembly for debugging
$(DIS): $(ELF)
	@echo "Creating disassembly $(DIS)..."
	$(OBJDUMP) -D $< > $@

# Build everything including disassembly
debug: $(HEX) $(DIS)
	@echo "Debug build complete. Check $(DIS) for disassembly."

# Clean build artifacts
clean:
	rm -rf $(OUT_DIR)

# Show targets
help:
	@echo "Available targets:"
	@echo "  all            - Build hex file (default)"
	@echo "  $(OUT_DIR)/$(PROGRAM).hex - Build hex file for SystemVerilog"
	@echo "  $(OUT_DIR)/$(PROGRAM).dis - Build disassembly file"
	@echo "  debug          - Build hex and disassembly"
	@echo "  clean          - Remove build artifacts"
	@echo "  help           - Show this help"

.PHONY: all clean debug help check-toolchain install-toolchain try-alternatives