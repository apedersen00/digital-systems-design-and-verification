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
#include <vector>
#include <verilated.h>
#include "Vtop.h"

#define DEBUG 1

template <size_t N>
std::string to_binary(unsigned int value) {
    return std::bitset<N>(value).to_string();
}

// Legacy function required only so linking works on Cygwin and MSVC++
double sc_time_stamp() { return 0; }

struct TestCase {
    uint32_t a, b, c, d, e, f;
    uint64_t expected_res;
};

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
    top->c = 0;
    top->d = 0;
    top->e = 0;
    top->f = 0;

    std::vector<TestCase> test_vectors;
    int passed = 0;
    const int IN_WIDTH = 8;

    test_vectors.push_back({0, 0, 0, 0, 0, 0});
    test_vectors.push_back({1, 2, 3, 4, 5, 6});
    test_vectors.push_back({10, 20, 5, 8, 100, 2});

    uint32_t max_val = (1 << 8) - 1;
    test_vectors.push_back({max_val, max_val, max_val, max_val, max_val, max_val});

    for (auto& test : test_vectors) {
        test.expected_res = test.a * test.b + test.c * test.d + test.e * test.f;
    }

    for (auto& test : test_vectors) {
        contextp->timeInc(10);
        top->a = test.a;
        top->b = test.b;
        top->c = test.c;
        top->d = test.d;
        top->e = test.e;
        top->f = test.f;
        
        top->eval();
        if (top->res != test.expected_res) {
            VL_PRINTF("\n*** Error! ***\n");
            VL_PRINTF("    EXPECTED: %d * %d + %d * %d + %d * %d = %d\n", test.a, test.b, test.c, test.d, test.e, test.f, test.expected_res);
            VL_PRINTF("    GOT: %d\n", top->res);
            VL_PRINTF("    at time %" PRId64 "\n\n", contextp->time());
            break;
        }

#if DEBUG == 1
        VL_PRINTF("[%03" PRId64 "] a=%d b=%d c=%d d=%d e=%d f=%d prod=%d expected=%d\n",
            contextp->time(),
            top->a,
            top->b,
            top->c,
            top->d,
            top->e,
            top->f,
            top->res,
            test.expected_res
        );
#endif

    }

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
