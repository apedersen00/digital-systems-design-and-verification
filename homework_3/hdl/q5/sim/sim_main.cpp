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
#include <random>
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
    top->start              = 0;
    top->data               = 0;
    clock_cycle();

    // reset
    top->rstn = 0;
    clock_cycle();
    top->rstn = 1;

    VL_PRINTF("\n--- Sequence 1 ---\n");
    int seq_1[] = {4, 8, 8, 4};
    for (int i = 0; i < 4; i++) {
        if (i == 0) {
            top->start = 1;
        }
        else {
            top->start = 0;
        }
        top->data = seq_1[i];
        VL_PRINTF("Num: %d, Start: %d, Data: %d, Res: %d, Done: %d\n", i, top->start, top->data, top->result, top->done);
        clock_cycle();
    }

    for (int i = 0; i < 3; i++) {
        VL_PRINTF("Num: %d, Start: %d, Data: %d, Res: %d, Done: %d\n", i, top->start, top->data, top->result, top->done);
        clock_cycle();
    }

    VL_PRINTF("\n--- Sequence 2 ---\n");
    int seq_2[] = {255, 255, 255, 255};
    for (int i = 0; i < 4; i++) {
        if (i == 0) {
            top->start = 1;
        }
        else {
            top->start = 0;
        }
        top->data = seq_2[i];
        VL_PRINTF("Num: %d, Start: %d, Data: %d, Res: %d, Done: %d\n", i, top->start, top->data, top->result, top->done);
        clock_cycle();
    }

    for (int i = 0; i < 2; i++) {
        VL_PRINTF("Num: %d, Start: %d, Data: %d, Res: %d, Done: %d\n", i, top->start, top->data, top->result, top->done);
        clock_cycle();
    }

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
