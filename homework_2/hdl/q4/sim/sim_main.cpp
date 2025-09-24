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

    // Helper function for clock cycle
    auto clock_cycle = [&]() {
        top->clk = 0;
        top->eval();
        contextp->timeInc(5);
        top->clk = 1;
        top->eval();
        contextp->timeInc(5);
    };

    // Initialize signals
    top->clk = 0;
    top->rstn = 1;
    top->eval();

    // Reset the system
    VL_PRINTF("--- Reset Test ---\n");
    top->rstn = 0;
    clock_cycle();
    clock_cycle();
    top->rstn = 1;
    clock_cycle();

    int state = top->div;
    int last_edge = 0;

    VL_PRINTF("--- Testbench ---\n");
    for (int i = 1; i < 2000; i++) {
        clock_cycle();
        
        if (top->div == !state) {
            VL_PRINTF("Changing edge at: %d\n", i);
            VL_PRINTF("Interval: %d\n\n", i - last_edge);
            last_edge = i;
        }

        state = top->div;
    }

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
