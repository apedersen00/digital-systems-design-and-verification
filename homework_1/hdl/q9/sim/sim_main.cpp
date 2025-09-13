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
#include <random>
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

    const int IN_WIDTH  = 16;
    const int NUM_TESTS = 1000000;
    bool error_found    = false;
    static int true_prod;

    // init random number generator
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> distrib(0, (1 << IN_WIDTH) - 1);

    for (int i = 0; i < NUM_TESTS; i++) {
        int a = distrib(gen);
        int b = distrib(gen);

        contextp->timeInc(10);
        top->a = a;
        top->b = b;
        top->eval();

        true_prod = a * b;

        if (top->prod != true_prod) {
            VL_PRINTF("\n*** Error! ***\n");
            VL_PRINTF("    EXPECTED: %d * %d = %d\n", a, b, true_prod);
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

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
