# Digital Systems Design and Verification - Homework 2

Solutions for all questions in Homework 2.

Schematics are shown below.

## Verilator Simulation

Simulation/verification is done using [Verilator](https://github.com/verilator/verilator). Verilator is a _super fast_ open-source Verilog/SystemVerilog simulator. Verilator compiles Verilog code to C++, therefore the testbenches can also be written in C++.

Testbenches are run using `Make`.

## Repository Structure

```
homework_2/
├── hdl/
│   ├── common/                 # Shared modules used across questions
│   │   └── mux.sv
│   │
│   ├── q1/                     # Question 1: Shift Register
│   │   ├── src/
│   │   │   ├── top.sv
│   │   │   └── shift_reg.sv    # Shift register implementation
│   │   ├── sim/
│   │   │   └── sim_main.cpp
│   │   └── Makefile
│   │
│   ├── q2/                     # Question 2: LFSR
│   │   ├── src/
│   │   │   ├── top.sv
│   │   │   └── lfsr.sv
│   │   ├── sim/
│   │   │   └── sim_main.cpp
│   │   └── Makefile
│   │
│   ├── q3/                     # Question 3: Up/Down Counter
│   │   ├── src/
│   │   │   ├── top.sv
│   │   │   └── counter.sv
│   │   ├── sim/
│   │   │   └── sim_main.cpp
│   │   └── Makefile
│   │
│   ├── q4/                     # Question 4: Frequency Divider
│   │   ├── src/
│   │   │   ├── top.sv
│   │   │   ├── freq_div.sv     # Frequency divider implementation
│   │   │   ├── counter_16.sv   # 16-bit counter using cascaded 4-bit counters
│   │   │   └── counter_4.sv    # 4-bit counter building block
│   │   ├── sim/
│   │   │   └── sim_main.cpp
│   │   └── Makefile
│   │
│   ├── q5/                     # Question 5: Register File
│   │   ├── src/
│   │   │   ├── top.sv
│   │   │   └── rf.sv           # Register file implementation
│   │   ├── sim/
│   │   │   └── sim_main.cpp
│   │   └── Makefile
│   │
│   └── Makefile                # Top-level build system
│
└── docs/
    └── homework_2.pdf
```

The SystemVerilog modules for each question can be found in the `src/` directory. Shared modules are stored in the `common/` directory. For simulation, the module in question is instantiated in a `top.sv` file which is then applied stimulus in the `sim_main.cpp` testbench.

## Prerequisites

- Verilator
- Make
- C++ compiler
- [VaporView](https://github.com/Lramseyer/vaporview) (VSCode extension for viewing waveform files `.vcd`)

## Building/Simulation

The act of _building_ a project with verilator means compiling the Verilog/SystemVerilog modules and running the testbench/simulation described in each project's `sim_main.cpp`.

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
hdl> make q3
hdl> make q4
hdl> make q5
```

### Building Using Question Specific Makefile

```bash
hdl/q1> make
hdl/q2> make
# etc.
```

## Viewing Waveforms

After running a simulation, the waveform file can be found in `logs/vlt_dump.vcd` and can be viewed using [VaporView](https://github.com/Lramseyer/vaporview).

## Schematics

### Question 3

![Q3](report/assets/hw2_q3.png)
