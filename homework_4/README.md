# Digital Systems Design and Verification - Homework 4

Solutions for all questions in Homework 4.

Report can be found [here](https://github.com/kth-ees/il2234ht25-homework-4-apedersen00/releases/download/v1.0/andreasp_hw4.pdf).

## Verilator Simulation

Simulation/verification is done using [Verilator](https://github.com/verilator/verilator). Verilator is a _super fast_ open-source Verilog/SystemVerilog simulator. Verilator compiles Verilog code to C++, therefore the testbenches can also be written in C++.

Testbenches are run using `Make`.

## Repository Structure

```
homework_4
├── hdl
│   ├── q1
│   │   ├── Makefile
│   │   ├── sim                     # Verilator simulations and testbench instantiations
│   │   │   ├── sim_adder.cpp       
│   │   │   ├── sim_imc.cpp         
│   │   │   ├── sim_mult.cpp        
│   │   │   ├── tb_adder.sv         
│   │   │   ├── tb_imc.sv           
│   │   │   └── tb_mult.sv          
│   │   └── src
│   │       ├── adder.sv
│   │       ├── imc_controller.sv
│   │       ├── imc_dp.sv
│   │       ├── imc.sv
│   │       ├── mult.sv
│   │       └── reciprocal.sv
│   ├── q2
│   │   ├── Makefile
│   │   ├── sim
│   │   │   ├── sim_in_wrapper.cpp
│   │   │   ├── sim_out_wrapper.cpp
│   │   │   ├── tb_in_wrapper.sv
│   │   │   └── tb_out_wrapper.sv
│   │   └── src
│   │       ├── in_wrapper_controller.sv
│   │       ├── in_wrapper_dp.sv
│   │       ├── in_wrapper.sv
│   │       ├── out_wrapper_controller.sv
│   │       ├── out_wrapper_dp.sv
│   │       └── out_wrapper.sv
│   ├── q3
│   │   ├── Makefile
│   │   ├── sim
│   │   │   ├── sim_iab.cpp
│   │   │   └── tb_iab.sv
│   │   └── src
│   │       ├── iab_controller.sv
│   │       ├── iab_dp.sv
│   │       └── iab.sv
│   ├── q4
│   │   ├── Makefile
│   │   ├── sim
│   │   │   ├── mem_transaction.sv          # mem_transaction class for constrained tests
│   │   │   ├── sim_mem_64kib.cpp           # Verilator sim of memory module
│   │   │   ├── tb_mem_64kib_constraint.sv  # SystemVerilog constrained testbench of memory module
│   │   │   └── tb_mem_64kib.sv             # Verilator testbench of memory module
│   │   └── src
│   │       ├── bram_64kib.sv
│   │       ├── mem_64kib.sv
│   │       └── mem_controller.sv
│   └── q5
│       ├── sim
│       │   └── tb_moore_1011.sv            # Assertion-based testbench for sequence detector
│       └── src
│           └── moore_1011.sv
├── python
│   ├── imc.py                              # Sanity checks for IMC module
│   ├── plot.ipynb                          # Waveform plots
│   ├── poetry.lock
│   └── pyproject.toml
├── report
└── waveforms
    ├── tb_mem_64kib_constraint.vcd 
    └── tb_moore_1011.vcd
```

Question 1-3 were simulated and verified using Verilator and C++ based testbenches. Questions 4 and 5 were verified using SystemVerilog based testbenches, simulated in Vivado.

## Building/Simulation

The act of _building_ a project with verilator means compiling the Verilog/SystemVerilog modules and running the testbench/simulation described in each project's `sim_main.cpp`.

Running `make` for a project will:

1. Verilate the SystemVerilog files
2. Compile the C++ testbench
3. Run the simulation
4. Create waveform dump (`logs/vlt_dump.vcd`)

### Question 1

Available simulation targets (Verilator):

```console
q1> make adder
q1> make mult
q1> make imc
```

### Question 2

Available simulation targets (Verilator):

```console
q2> make in_wrapper
q2> make out_wrapper
```

### Question 3

Avaiable simulation targets (Verilator):

```console
q3> make iab
```

### Question 4

To run the Verilator testbench defined in `tb_mem_64kib.sv` and `sim_mem_64kib.cpp`:

```console
q4> make mem_64kib
```

Otherwise, the constrained testbench is defined in

- `tb_mem_64kib_constraint.sv`
- `mem_transaction.sv`

Can be simulated using Vivado (or probably ModelSim).

### Question 5

Assertion-based testbench is defined in

- `tb_moore_1011.sv`

Can be simulated using Vivado (or probably ModelSim).
