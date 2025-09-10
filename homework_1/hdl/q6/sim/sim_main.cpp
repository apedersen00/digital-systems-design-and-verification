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
    top->d_i = 170;

    const int CONTROL_WIDTH = 2;

    for (int i = 0; i < pow(2, CONTROL_WIDTH); i++) {
        contextp->timeInc(10);
        top->control_i = i;
        top->eval();

        VL_PRINTF("[%03" PRId64 "] Input=%s Control=%d Output=%s\n",
            contextp->time(),
            to_binary<8>(top->d_i).c_str(),
            top->control_i,
            to_binary<8>(top->d_o).c_str()
        );
    }

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
