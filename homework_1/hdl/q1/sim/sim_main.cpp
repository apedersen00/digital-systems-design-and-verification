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
#include <verilated.h>
#include "Vtop.h"

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
    top->in     = 1;
    top->sel    = 0;

    const int OUT_WIDTH = 16;
    const int SEL_WIDTH = 4;

    for (int i = 0; i < pow(2, SEL_WIDTH); i++) {
        contextp->timeInc(10);
        top->sel = i;
        top->eval();

        VL_PRINTF("[%03" PRId64 "] in=%d sel=%d out=%d\n",
            contextp->time(),
            top->in,
            top->sel,
            top->out
        );
    }

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
