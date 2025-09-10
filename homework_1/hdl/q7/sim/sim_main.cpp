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

#define DEBUG 0

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
    top->a = 0;
    top->b = 0;

    const int IN_WIDTH = 8;
    static int true_prod;
    bool error_found = false;

    for (int i = 0; i < pow(2, IN_WIDTH); i++) {
        for (int j = 0; j < pow(2, IN_WIDTH); j++) {
            contextp->timeInc(10);
            top->a = i;
            top->b = j;
            top->eval();

            true_prod = i * j;

            if (top->prod != true_prod) {
                VL_PRINTF("\n*** Error! ***\n");
                VL_PRINTF("    EXPECTED: %d * %d = %d\n", i, j, true_prod);
                VL_PRINTF("    GOT: %d\n", top->prod);
                VL_PRINTF("    at time %" PRId64 "\n\n", contextp->time());

                error_found = true;
                break;
            }

#if DEBUG == 1
            VL_PRINTF("[%03" PRId64 "] a=%d b=%d prod=%d\n",
                contextp->time(),
                top->a,
                top->b,
                top->prod
            );
#endif
        }
        if (error_found) {
            break;
        }
    }

    VL_PRINTF("Testbench succesfully completed!\n\n");

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
