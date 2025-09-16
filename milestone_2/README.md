# Digital Systems Design and Verification - Milestone 2

Implementation of a register file (RF) module.

HDL is written to comply with the [lowRISC SystemVerilog style guidelines](https://github.com/lowRISC/style-guides).

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
