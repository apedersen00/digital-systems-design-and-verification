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
#include "Vtb_adder.h"

template <size_t N>
std::string to_binary(unsigned int value) {
    return std::bitset<N>(value).to_string();
}

void tick(const std::unique_ptr<VerilatedContext>& contextp, const std::unique_ptr<Vtb_adder>& top) {
    contextp->timeInc(5);
    top->eval();

    contextp->timeInc(5);
    top->eval();
}

int main(int argc, char** argv) {
    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    const std::unique_ptr<Vtb_adder> top{new Vtb_adder{contextp.get(), "TOP"}};

    // Initialize signals
    top->sub = 0;
    top->a = 0;
    top->b = 0;
    top->eval();

    int failed = 0;
    int count = 0;

    for (int sub = 0; sub <= 1; sub++) {
        for (int i = -32768; i < 32767; i += 1024) {
            for (int j = -32768; j < 32767; j += 1024) {
                count += 1;
                top->a = i;
                top->b = j;
                top->sub = sub;

                tick(contextp, top);

                int16_t result      = top->res;
                int16_t true_res    = sub ? (i - j) : (i + j);
                if (result != true_res) {
                    if (sub == 0) {
                        VL_PRINTF("FAILED: %d + %d = %d\tSW: %d\n", i, j, result, true_res);
                    }
                    else {
                        VL_PRINTF("FAILED: %d - %d = %d\tSW: %d\n", i, j, result, true_res);
                    }
                    failed += 1;
                }
            }
        }
    }

    if (failed == 0) {
        VL_PRINTF("Completed %d tests without errors...\n", count);
    }

    VL_PRINTF("\n[%0ld] Completed...\n", contextp->time());

    top->final();
    contextp->statsPrintSummary();

    return 0;
}
