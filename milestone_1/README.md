# Digital Systems Design and Verification - Milestone 1

Implementation of a parameterized ALU module.

HDL is written to comply with the [lowRISC SystemVerilog style guidelines](https://github.com/lowRISC/style-guides).

## ALU Opcodes

The ALU supports 8 different opcodes:

| Opcode | Operation | Description |
|--------|-----------|-------------|
| 000    | ADD       | Addition: A + B |
| 001    | SUB       | Subtraction: A - B |
| 010    | AND       | Bitwise AND: A & B |
| 011    | OR        | Bitwise OR: A \| B |
| 100    | XOR       | Bitwise XOR: A ^ B |
| 101    | INC       | Increment: A + 1 |
| 110    | MOVA      | Move A: Pass A to output |
| 111    | MOVB      | Move B: Pass B to output |

### Flag Generation

The ALU generates three status flags:

- **Overflow**: Set when arithmetic operations result in signed overflow
- **Negative**: Set when the result is negative (MSB = 1)
- **Zero**: Set when the result equals zero

## Verilator Simulation

Simulation/verification is done using [Verilator](https://github.com/verilator/verilator). The testbench is written in C++ and found here: `sim/sim_main.cpp`. It performs verification by testing all possible combinations of:

- 8-bit signed operands A and B (-128 to +127)
- All 8 operation codes
- Total test vectors: 8 × 256 × 256 = 524,288 combinations

## Repository Structure

```
milestone_1/
├── hdl/                        # Hardware description files and testbench
│   ├── src/                    # SystemVerilog source files
│   │   ├── top.sv              # Top-level testbench module
│   │   ├── alu.sv              # Main ALU implementation
│   │   ├── cl_subtractor.sv    # Carry lookahead subtractor
│   │   ├── cl_adder.sv         # Carry lookahead adder
│   │   ├── mux.sv              # Parameterized NX-to-N multiplexer
│   │   └── fulladder.sv        # Full adder
│   │
│   ├── sim/                    # Simulation files
│   │   └── sim_main.cpp        # Verilator C++ testbench
│   │
│   └── Makefile                # Build rules
```

## Prerequisites

- Verilator
- Make
- C++ compiler
- [VaporView](https://github.com/Lramseyer/vaporview) (VSCode extension for viewing waveform files `.vcd`)

## Building/Simulation

The act of _building_ a project with verilator means compiling the Verilog/SystemVerilog modules and running the testbench/simulation described in `sim_main.cpp`.

Running `make` will:

1. Verilate the SystemVerilog files
2. Compile the C++ testbench
3. Run the simulation
4. Create waveform dump (`logs/vlt_dump.vcd`)

### Building Using Makefile

To build all questions:

```bash
milestone_1> make
```

## Viewing Waveforms

After running a simulation, the waveform file can be found in `logs/vlt_dump.vcd` and can be viewed using [VaporView](https://github.com/Lramseyer/vaporview).
