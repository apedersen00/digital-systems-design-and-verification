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
#include "Vtb_dflop.h"

template <size_t N>
std::string to_binary(unsigned int value) {
    return std::bitset<N>(value).to_string();
}

void tick(const std::unique_ptr<VerilatedContext>& contextp, const std::unique_ptr<Vtb_dflop>& top) {
    contextp->timeInc(5);
    top->clk = 1;
    top->eval();

    contextp->timeInc(5);
    top->clk = 0;
    top->eval();
}

int main(int argc, char** argv) {
    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    const std::unique_ptr<Vtb_dflop> top{new Vtb_dflop{contextp.get(), "TOP"}};

    // Initialize signals
    top->clk    = 0;
    top->rst_n  = 0;
    top->D      = 0;
    tick(contextp, top);

    top->rst_n  = 1;
    tick(contextp, top);
    top->D      = 1;
    tick(contextp, top);
    top->D      = 3;
    tick(contextp, top);
    top->D      = 4;
    tick(contextp, top);
    top->D      = 5;
    tick(contextp, top);

    VL_PRINTF("\n[%0ld] Completed...\n", contextp->time());

    top->final();
    contextp->statsPrintSummary();

    return 0;
}
