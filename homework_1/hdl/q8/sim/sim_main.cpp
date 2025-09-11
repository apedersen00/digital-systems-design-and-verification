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

int32_t sign_extend(uint64_t value, int bits) {
    int shift = 8 * sizeof(int32_t) - bits;
    int32_t shifted_value = (int32_t)(value << shift);
    return shifted_value >> shift;
}

struct TestCase {
    int8_t a, b, c, d, e, f;
    int64_t expected_res;
};

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
    top->c = 0;
    top->d = 0;
    top->e = 0;
    top->f = 0;

    std::vector<TestCase> test_vectors;
    int passed = 0;

    test_vectors.push_back({0, 0, 0, 0, 0, 0});
    test_vectors.push_back({1, 2, 3, 4, 5, 6});
    test_vectors.push_back({10, 20, 5, 8, 100, 2});
    test_vectors.push_back({-1, 10, -5, 4, 1, -1});

    int8_t max_val = 127;
    int8_t min_val = -128;
    test_vectors.push_back({max_val, max_val, max_val, max_val, max_val, max_val});
    test_vectors.push_back({min_val, min_val, min_val, min_val, min_val, min_val});

    for (auto& test : test_vectors) {
        test.expected_res = (int64_t)test.a * test.b + (int64_t)test.c * test.d + (int64_t)test.e * test.f;
    }

    static int32_t res;

    for (auto& test : test_vectors) {
        contextp->timeInc(10);
        top->a = test.a;
        top->b = test.b;
        top->c = test.c;
        top->d = test.d;
        top->e = test.e;
        top->f = test.f;

        top->eval();

        res = sign_extend(top->res, 17);

        if (res != test.expected_res) {
            VL_PRINTF("\n*** Error! ***\n");
            VL_PRINTF("   INPUTS:     a=%d, b=%d, c=%d, d=%d, e=%d, f=%d\n", test.a, test.b, test.c, test.d, test.e, test.f);
            VL_PRINTF("   EXPECTED:   %lld\n", test.expected_res);
            VL_PRINTF("   GOT:        %d\n", res);
            VL_PRINTF("   at time %" PRId64 "\n\n", contextp->time());
        }

#if DEBUG == 1
        VL_PRINTF("[%03" PRId64 "] a=%d b=%d c=%d d=%d e=%d f=%d res=%d expected=%d\n",
            contextp->time(),
            (int8_t)top->a,
            (int8_t)top->b,
            (int8_t)top->c,
            (int8_t)top->d,
            (int8_t)top->e,
            (int8_t)top->f,
            res,
            test.expected_res
        );
#endif

    }

    VL_PRINTF("\nSimulation finished.\n");

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
