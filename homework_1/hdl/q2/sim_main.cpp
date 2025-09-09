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
#include <bitset>
#include <memory>
#include <verilated.h>
#include "Vtop.h"

template <size_t N>
std::string to_binary(unsigned int value) {
    return std::bitset<N>(value).to_string();
}

// Legacy function required only so linking works on Cygwin and MSVC++
double sc_time_stamp() { return 0; }

int main(int argc, char** argv) {
    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    const std::unique_ptr<Vtop> top{new Vtop{contextp.get(), "TOP"}};

    // initialize
    top->binary = 0;

    const int IN_WIDTH = 4;

    for (int i = 0; i < pow(2, IN_WIDTH); i++) {
        contextp->timeInc(10);
        top->binary = i;
        top->eval();

        VL_PRINTF("[%03" PRId64 "] binary=%s bcd=%s carry=%d\n",
            contextp->time(),
            to_binary<4>(top->binary).c_str(),
            to_binary<4>(top->bcd).c_str(),
            top->carry
        );
    }

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
