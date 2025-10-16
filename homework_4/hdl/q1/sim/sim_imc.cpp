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
#include "Vtb_imc.h"

template <size_t N>
std::string to_binary(unsigned int value) {
    return std::bitset<N>(value).to_string();
}

void tick(const std::unique_ptr<VerilatedContext>& contextp, const std::unique_ptr<Vtb_imc>& top) {
    contextp->timeInc(5);
    top->clk = 0;
    top->eval();

    contextp->timeInc(5);
    top->clk = 1;
    top->eval();
}

int main(int argc, char** argv) {
    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    const std::unique_ptr<Vtb_imc> top{new Vtb_imc{contextp.get(), "TOP"}};

    auto q8_8_to_float = [](int16_t x) -> float {
        return static_cast<float>(x) / 256.0f;
    };

    auto float_to_q8_8 = [](float x) -> int16_t {
        return static_cast<int16_t>(roundf(x * 256.0f));
    };

    // Initialize signals
    top->clk    = 0;
    top->start  = 0;
    top->rstn   = 1;
    top->a_in   = 0;
    top->b_in   = 0;
    top->c_in   = 0;
    top->d_in   = 0;

    for (int i = 0; i < 2; i++) {
        tick(contextp, top);
    }

    // test
    top->rstn   = 1;
    top->a_in   = float_to_q8_8(1.0f);
    top->b_in   = float_to_q8_8(2.0f);
    top->c_in   = float_to_q8_8(2.0f);
    top->d_in   = float_to_q8_8(1.0f);
    top->start  = 1;
    tick(contextp, top);

    for (int i = 0; i < 100; i++) {
        tick(contextp, top);
        if (top->ready == 1) {
            VL_PRINTF("Done!\n");
            break;
        }
    }

    VL_PRINTF("a: %.4f\n", q8_8_to_float(top->a_out));
    VL_PRINTF("b: %.4f\n", q8_8_to_float(top->b_out));
    VL_PRINTF("c: %.4f\n", q8_8_to_float(top->c_out));
    VL_PRINTF("d: %.4f\n", q8_8_to_float(top->d_out));

    VL_PRINTF("a_sign: %d\n", top->a_sign);
    VL_PRINTF("b_sign: %d\n", top->b_sign);
    VL_PRINTF("c_sign: %d\n", top->c_sign);
    VL_PRINTF("d_sign: %d\n", top->d_sign);

    VL_PRINTF("\n[%0ld] Completed...\n", contextp->time());

    top->final();
    contextp->statsPrintSummary();

    return 0;
}
