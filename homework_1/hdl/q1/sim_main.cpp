//-------------------------------------------------------------------------------------------------
//
//  File: sim_main.cpp
//  Description: testbench for FIFO
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
    top->a = 0;
    top->b = 0;

    const int IN_WIDTH = 4;

    for (int i = 0; i < pow(2, IN_WIDTH); i++) {
        for (int j = 0; j < pow(2, IN_WIDTH); j++) {
            contextp->timeInc(10);
            top->a = i;
            top->b = j;
            top->eval();

            VL_PRINTF("[%03" PRId64 "] a=%d b=%d sum=%d, c_out=%d\n",
                contextp->time(),
                top->a,
                top->b,
                top->sum,
                top->c_out
            );
        }
    }

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
