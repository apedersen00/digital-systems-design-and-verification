//-------------------------------------------------------------------------------------------------
//
//  File: sim_main.cpp
//  Description: Stimulus for testbench
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

#include <math.h>
#include <bitset>
#include <memory>
#include <random>
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
    top->a      = 0;
    top->b      = 0;
    top->opcode = 0;

    const int IN_WIDTH  = 8;
    int8_t true_res     = 0;
    int8_t a            = 0;
    int8_t b            = 0;
    bool error_found    = false;

    // bit values for flag vector
    const int FLAG_OVERFLOW = 4;
    const int FLAG_NEGATIVE = 2;
    const int FLAG_ZERO     = 1;

    // counters
    int flag_overflow_cnt   = 0;
    int flag_negative_cnt   = 0;
    int flag_zero_cnt       = 0;
    int iter_cnt            = 0;

    for (int op = 0; op < pow(2, 3); op++) {
        for (int a = -128; a < 128; a++) {
            for (int b = -128; b < 128; b++) {
                iter_cnt += 1;
                contextp->timeInc(10);
                top->opcode = op;
                top->a = a;
                top->b = b;
                top->eval();

                switch (op)
                {
                case 0:
                    true_res = a + b;
                    break;
                case 1:
                    true_res = a - b;
                    break;
                case 2:
                    true_res = a & b;
                    break;
                case 3:
                    true_res = a | b;
                    break;
                case 4:
                    true_res = a ^ b;
                    break;
                case 5:
                    true_res = a + 1;
                    break;
                case 6:
                    true_res = a;
                    break;
                case 7:
                    true_res = b;
                    break;                
                default:
                    break;
                }

                if (top->flags & FLAG_OVERFLOW) {
                    flag_overflow_cnt++;
                }
                if (top->flags & FLAG_NEGATIVE) {
                    flag_negative_cnt++;
                }
                if (top->flags & FLAG_ZERO) {
                    flag_zero_cnt++;
                }

                if (top->flags == FLAG_OVERFLOW) {
                    // VL_PRINTF("\n*** OVERFLOW! ***\n");
                    // VL_PRINTF("    a: %d, b: %d, op: %d, expected: %d\n", a, b, op, true_res);
                    // VL_PRINTF("    GOT: %d\n", top->out);
                    // VL_PRINTF("    at time %" PRId64 "\n\n", contextp->time());
                    break;
                }

                if ((int8_t)top->out != true_res) {
                    VL_PRINTF("\n*** Error! ***\n");
                    VL_PRINTF("    a: %d, b: %d, op: %d, expected: %d\n", a, b, op, true_res);
                    VL_PRINTF("    GOT: %d\n", top->out);
                    VL_PRINTF("    at time %" PRId64 "\n\n", contextp->time());
                    error_found = true;
                    break;
                }
            }
            if (error_found) {
                break;
            }
        }
        if (error_found) {
            break;
        }
        VL_PRINTF("Verification passed for op: %d\n", op);
    }

    VL_PRINTF("\nTotal iterations: %d\n", iter_cnt);
    VL_PRINTF("Flag overflow count: %d\n", flag_overflow_cnt);
    VL_PRINTF("Flag negative count: %d\n", flag_negative_cnt);
    VL_PRINTF("Flag zero count: %d\n", flag_zero_cnt);

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
