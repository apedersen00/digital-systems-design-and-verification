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
    top->x                  = 1;
    top->eval();

    VL_PRINTF("\n--- Reset ---\n");
    top->rstn = 0;
    clock_cycle();
    top->rstn = 1;
    VL_PRINTF("moore = %d\nmealy = %d\n", top->z_moore, top->z_mealy);
    
    int seq_1[] = {1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0};
    int seq_1_length = sizeof(seq_1) / sizeof(seq_1[0]);
    
    VL_PRINTF("\n--- Test Sequence ---\n");
    for (int i = 0; i < seq_1_length; i++) {
        top->x = seq_1[i];
        VL_PRINTF("Cycle: %2d, x = %d, moore = %d, mealy = %d\n", 
                  i, top->x, top->z_moore, top->z_mealy);
        clock_cycle();
    }
    VL_PRINTF("Cycle: %2d, x = %d, moore = %d, mealy = %d\n", 
                seq_1_length, top->x, top->z_moore, top->z_mealy);

    VL_PRINTF("\n--- Reset ---\n");
    top->rstn = 0;
    clock_cycle();
    top->rstn = 1;
    VL_PRINTF("moore = %d\nmealy = %d\n", top->z_moore, top->z_mealy);

    int seq_2[] = {0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0};
    int seq_2_length = sizeof(seq_2) / sizeof(seq_2[0]);
    
    VL_PRINTF("\n--- Test Sequence ---\n");
    for (int i = 0; i < seq_2_length; i++) {
        top->x = seq_2[i];
        VL_PRINTF("Cycle: %2d, x = %d, moore = %d, mealy = %d\n", 
                  i, top->x, top->z_moore, top->z_mealy);
        clock_cycle();
    }
    VL_PRINTF("Cycle: %2d, x = %d, moore = %d, mealy = %d\n", 
                seq_2_length, top->x, top->z_moore, top->z_mealy);

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
