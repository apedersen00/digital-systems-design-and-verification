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

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> distrib(0, 1);

    // Initialize signals
    top->clk                = 0;
    top->rstn               = 1;
    top->serdata            = 1;
    clock_cycle();

    // reset
    top->rstn = 0;
    clock_cycle();
    top->rstn = 1;

    int seq[] = {0, 1, 1, 0, 1, 0};

    for (int j = 0; j < 2; j++) {
        VL_PRINTF("\n--- Sequence Test %d ---\n", j);
        for (int i = 0; i < 40; i++) {
            top->serdata = i < 6 ? seq[i] : 0;
            VL_PRINTF("serdata: %d,\t cycle: %d,\t valid: %d\n", top->serdata, i - 6, top->valid);
            clock_cycle();
        }
    }

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
