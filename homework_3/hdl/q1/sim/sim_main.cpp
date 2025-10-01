//-------------------------------------------------------------------------------------------------
//
//  File: sim_main.cpp
//  Description: Stimulus for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

#include <math.h>
#include <memory>
#include <bitset>
#include <verilated.h>
#include "Vtop.h"

// Legacy function required only so linking works on Cygwin and MSVC++
double sc_time_stamp() { return 0; }

template <size_t N>
std::string to_binary(unsigned int value) {
    return std::bitset<N>(value).to_string();
}

int main(int argc, char** argv) {
    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    const std::unique_ptr<Vtop> top{new Vtop{contextp.get(), "TOP"}};

    auto clock_cycle = [&]() {
        top->clk = 0;
        top->eval();
        contextp->timeInc(5);
        top->clk = 1;
        top->eval();
        contextp->timeInc(5);
    };

    // Initialize signals
    top->clk                = 0;
    top->rstn               = 1;
    top->seq                = 0;
    top->eval();

    VL_PRINTF("\n--- Reset ---");
    top->rstn = 0;
    clock_cycle();
    top->rstn = 1;
    clock_cycle();
    VL_PRINTF("det_struct = %d\ndet_behav = %d\n", top->det_struct, top->det_behav);
    
    VL_PRINTF("\n--- Sequence ---\n");
    top->seq = 1;
    for (int i = 0; i < 10; i++) {
    VL_PRINTF("Cycle: %d, det_struct = %d det_behav = %d\n", i, top->det_struct, top->det_behav);
        clock_cycle();
    }

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
