# Directories
PROGRAM_DIR = programs/nostdlib
HDL_DIR = hdl

# Default target - build everything and run simulation
all: compile simulate

# Help target
help:
	@echo "=== Milestone 4 Build System ==="
	@echo ""
	@echo "Available targets:"
	@echo "  all              - Compile program and run simulation (default)"
	@echo "  compile          - Compile C program to RISC-V hex file"
	@echo "  disassemble      - Compile and create disassembly file"
	@echo "  simulate         - Run HDL testbench (requires compiled program)"
	@echo "  run              - Alias for 'all'"
	@echo "  clean            - Clean all build artifacts"
	@echo "  clean-program    - Clean program build artifacts only"
	@echo "  clean-hdl        - Clean HDL build artifacts only"
	@echo "  check-tools      - Check if required tools are available"
	@echo "  help             - Show this help message"
	@echo ""
	@echo "Build flow:"
	@echo "  1. Compile C program to RISC-V binary"
	@echo "  2. Generate hex file for SystemVerilog \$$readmemh"
	@echo "  3. Generate disassembly for debugging"
	@echo "  4. Run Verilator simulation with compiled program"
	@echo ""

# Alias for all
run: all

#################################################################################
# Program Compilation Targets
#################################################################################

# Compile C program to hex file
compile:
	@echo "=== Compiling RISC-V Program ==="
	@echo "Building C program in $(PROGRAM_DIR)..."
	$(MAKE) -C $(PROGRAM_DIR) all
	@echo "✓ Program compilation complete"
	@echo "✓ Hex file ready: $(PROGRAM_DIR)/out/test_program.hex"
	@echo ""

# Compile and create disassembly
disassemble:
	@echo "=== Compiling RISC-V Program with Disassembly ==="
	@echo "Building C program and disassembly in $(PROGRAM_DIR)..."
	$(MAKE) -C $(PROGRAM_DIR) debug
	@echo "✓ Program compilation and disassembly complete"
	@echo "✓ Hex file ready: $(PROGRAM_DIR)/out/test_program.hex"
	@echo "✓ Disassembly ready: $(PROGRAM_DIR)/out/test_program.dis"
	@echo ""

#################################################################################
# HDL Simulation Targets
#################################################################################

# Run HDL testbench (assumes program is already compiled)
simulate:
	@echo "=== Running HDL Simulation ==="
	@if [ ! -f "$(PROGRAM_DIR)/out/test_program.hex" ]; then \
		echo "❌ Program hex file not found!"; \
		echo "   Run 'make compile' first to build the RISC-V program."; \
		exit 1; \
	fi
	@echo "✓ Program hex file found: $(PROGRAM_DIR)/out/test_program.hex"
	@echo "Starting Verilator simulation in $(HDL_DIR)..."
	$(MAKE) -C $(HDL_DIR) run
	@echo "✓ HDL simulation complete"
	@echo "✓ Waveforms available: $(HDL_DIR)/vlt_dump.vcd"
	@echo "✓ Coverage report: $(HDL_DIR)/logs/annotated/"
	@echo ""

# Force simulation even if hex file doesn't exist
simulate-force:
	@echo "=== Running HDL Simulation (Force) ==="
	@echo "Starting Verilator simulation in $(HDL_DIR)..."
	$(MAKE) -C $(HDL_DIR) run
	@echo "✓ HDL simulation complete"
	@echo ""

#################################################################################
# Combined Targets
#################################################################################

# Full debug build - compile with disassembly then simulate
debug: disassemble simulate
	@echo "=== Debug Build Complete ==="
	@echo "✓ Program compiled with disassembly"
	@echo "✓ HDL simulation executed"
	@echo ""
	@echo "Files generated:"
	@echo "  - Program hex:    $(PROGRAM_DIR)/out/test_program.hex"
	@echo "  - Disassembly:    $(PROGRAM_DIR)/out/test_program.dis"
	@echo "  - Waveforms:      $(HDL_DIR)/vlt_dump.vcd"
	@echo "  - Coverage:       $(HDL_DIR)/logs/annotated/"
	@echo ""

#################################################################################
# Cleaning Targets
#################################################################################

# Clean all build artifacts
clean: clean-program clean-hdl
	@echo "✓ All build artifacts cleaned"

# Clean program build artifacts only
clean-program:
	@echo "Cleaning program build artifacts..."
	$(MAKE) -C $(PROGRAM_DIR) clean

# Clean HDL build artifacts only  
clean-hdl:
	@echo "Cleaning HDL build artifacts..."
	$(MAKE) -C $(HDL_DIR) clean

#################################################################################
# Utility Targets
#################################################################################

# Check if required tools are available
check-tools:
	@echo "=== Checking Required Tools ==="
	@echo -n "RISC-V GCC:       "
	@which riscv64-elf-gcc > /dev/null 2>&1 && echo "✓ Found" || echo "❌ Not found (install riscv64-elf-gcc)"
	@echo -n "RISC-V Objcopy:   "
	@which riscv64-elf-objcopy > /dev/null 2>&1 && echo "✓ Found" || echo "❌ Not found"
	@echo -n "RISC-V Objdump:   "
	@which riscv64-elf-objdump > /dev/null 2>&1 && echo "✓ Found" || echo "❌ Not found"
	@echo -n "Verilator:        "
	@which verilator > /dev/null 2>&1 && echo "✓ Found" || echo "❌ Not found (install verilator)"
	@echo -n "Make:             "
	@which make > /dev/null 2>&1 && echo "✓ Found" || echo "❌ Not found"
	@echo ""

# Show status of build artifacts
status:
	@echo "=== Build Status ==="
	@echo -n "Program hex file: "
	@if [ -f "$(PROGRAM_DIR)/out/test_program.hex" ]; then \
		echo "✓ $(PROGRAM_DIR)/out/test_program.hex"; \
	else \
		echo "❌ Not built"; \
	fi
	@echo -n "Disassembly file: "
	@if [ -f "$(PROGRAM_DIR)/out/test_program.dis" ]; then \
		echo "✓ $(PROGRAM_DIR)/out/test_program.dis"; \
	else \
		echo "❌ Not built"; \
	fi
	@echo -n "HDL simulation:   "
	@if [ -f "$(HDL_DIR)/vlt_dump.vcd" ]; then \
		echo "✓ $(HDL_DIR)/vlt_dump.vcd"; \
	else \
		echo "❌ Not run"; \
	fi
	@echo ""

# Show program information
info-program:
	@echo "=== Program Information ==="
	@if [ -f "$(PROGRAM_DIR)/out/test_program.hex" ]; then \
		echo "Program hex file: $(PROGRAM_DIR)/out/test_program.hex"; \
		echo "Size: $$(wc -l < $(PROGRAM_DIR)/out/test_program.hex) lines"; \
		echo "First 10 instructions:"; \
		head -10 $(PROGRAM_DIR)/out/test_program.hex; \
	else \
		echo "❌ Program not compiled. Run 'make compile' first."; \
	fi
	@echo ""

# Show simulation results
info-simulation:
	@echo "=== Simulation Information ==="
	@if [ -f "$(HDL_DIR)/vlt_dump.vcd" ]; then \
		echo "✓ Simulation completed"; \
		echo "Waveform file: $(HDL_DIR)/vlt_dump.vcd"; \
		echo "File size: $$(ls -lh $(HDL_DIR)/vlt_dump.vcd | awk '{print $$5}')"; \
		if [ -d "$(HDL_DIR)/logs/annotated" ]; then \
			echo "✓ Coverage analysis available in $(HDL_DIR)/logs/annotated/"; \
		fi \
	else \
		echo "❌ Simulation not run. Run 'make simulate' first."; \
	fi
	@echo ""

#################################################################################
# Phony Targets
#################################################################################

.PHONY: all run help compile disassemble simulate simulate-force debug clean clean-program clean-hdl check-tools status info-program info-simulation