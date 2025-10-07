# Digital Systems Design and Verification - Homework 3

Solutions for all questions in Homework 3.

HDL is written to comply with the [lowRISC SystemVerilog style guidelines](https://github.com/lowRISC/style-guides).

Report is found [here](https://github.com/kth-ees/il2234ht25-hw3-apedersen00/releases/download/v1.0/andreasp_hw3.pdf).

## Verilator Simulation

Simulation/verification is done using [Verilator](https://github.com/verilator/verilator). Verilator is a _super fast_ open-source Verilog/SystemVerilog simulator. Verilator compiles Verilog code to C++, therefore the testbenches can also be written in C++.

Testbenches are run using `Make`.

## Repository Structure

```
homework_3/
├── hdl/                        
│   ├── q1/                     
│   ├── q2/                     
│   ├── q3/                     
│   ├── q4/                     
│   ├── q5/
│   └── Makefile                # Top-level build file
│
└── python/                    
    ├── plot.ipynb              # Plotting script for waveforms
    ├── q5.ipynb                # Q5 Taylor series floobydust
    ├── q5_lut.py               # Q5 LUT generation script
    └── sinx.csv                # Q5 testbench output
```

## Prerequisites

- Verilator (≥ 5.0)
- Make
- C++ compiler (GCC/Clang)
- [VaporView](https://github.com/Lramseyer/vaporview) (VSCode extension for viewing waveform files `.vcd`)
- Python 3.8+ with Poetry (for analysis notebooks)

## Building/Simulation

The act of _building_ a project with verilator means compiling the Verilog/SystemVerilog modules and running the testbench/simulation described in each project's `sim_main.cpp`.

Running `make` for a project will:

1. Verilate the SystemVerilog files
2. Compile the C++ testbench
3. Run the simulation
4. Create waveform dump (`logs/vlt_dump.vcd`)
5. Generate coverage report (`logs/coverage.dat`)

### Building Using Top Level Makefile

To build all questions:

```bash
hdl> make
```

To build a specific question:

```bash
hdl> make q1
hdl> make q4
hdl> make q5
```

### Building Using Question Specific Makefile

```bash
hdl/q1> make
hdl/q4> make
hdl/q5> make
```

## Viewing Waveforms

After running a simulation, the waveform file can be found in `logs/vlt_dump.vcd` and can be viewed using [VaporView](https://github.com/Lramseyer/vaporview).

## Report Generation

The LaTeX report can be built using:

```bash
report> make
```
