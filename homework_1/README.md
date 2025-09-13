# Digital Systems Design and Verification - Homework 1

Solutions for all question in Homework 1.

HDL is written to comply with the [lowRISC SystemVerilog style guidelines](https://github.com/lowRISC/style-guides).

Testbench output and schematics are seen in the report.

## Verilator

Fueled by a bitter distaste for Vivado and waveform driven verification, I do simulation/verification using [Verilator](https://github.com/verilator/verilator). Verilator is a _super fast_ open-source Verilog/SystemVerilog simulator. Verilator compiles Verilog code to C++, therefore the testbenches can also be written in C++ (nice).

Another advantage is that testbenches can be run using `Make`.

## Repository Structure

```
homework_1/
├── hdl/                        # Hardware description files and testbenches
│   ├── common/                 # Shared modules used across questions
│   │   ├── fulladder.sv
│   │   ├── mux.sv
│   │   ├── cr_adder.sv
│   │   └── cl_adder.sv
│   │
│   ├── q1/                     # Question 1
│   │   ├── src/                # SystemVerilog source files
│   │   │   ├── top.sv          # Top-level module
│   │   │   └── demux.sv        # Implementation
│   │   ├── sim/                # Simulation files
│   │   │   └── sim_main.cpp    # Verilator testbench
│   │   └── Makefile            # Build rules
│   │
│   └── q2..q9/                 # Similar structure for other questions
│
├── report/                     # LaTeX report files
└── Makefile                    # Top-level build system
```

The SystemVerilog modules for each question can be found in the `src/` directory. A few modules are shared and are thus stored in a `common/` directory. For simulation the module in question is instantiated in a `top.sv` file which is then applied stimulus in the `sim_main.cpp` testbench.

## Prerequisites

- Verilator
- Make
- C++ compiler
- [VaporView](https://github.com/Lramseyer/vaporview) (VSCode extension for viewing waveform files `.vcd`)

## Building/Simulation

The act of _building_ a project with verilator means compiling the Verilog/SystemVerilog modules and running the testbench/simulation described in each projects `sim_main.cpp`.

Running `make` for a project will:

1. Verilate the SystemVerilog files
2. Compile the C++ testbench
3. Run the simulation
4. Create waveform dump (`logs/vlt_dump.vcd`)

### Building Using Top Level Makefile

To build all questions:

```bash
hdl> make
```

To build a specific question:

```bash
hdl> make q1
hdl> make q2
# etc.
```

### Building Using Question Specific Makefile

```bash
hdl/q1> make
```

## Viewing Waveforms

After running a simulation, the waveform file can be found in `logs/vlt_dump.vcd` and can be viewed using [VaporView](https://github.com/Lramseyer/vaporview).
