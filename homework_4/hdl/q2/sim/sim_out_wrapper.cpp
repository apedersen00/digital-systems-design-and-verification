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
#include "Vtb_out_wrapper.h"

template <size_t N>
std::string to_binary(unsigned int value) {
    return std::bitset<N>(value).to_string();
}

void tick(const std::unique_ptr<VerilatedContext>& contextp, const std::unique_ptr<Vtb_out_wrapper>& top) {
    contextp->timeInc(5);
    top->clk_i = 0;
    top->eval();

    contextp->timeInc(5);
    top->clk_i = 1;
    top->eval();
}
int main(int argc, char** argv) {
    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    const std::unique_ptr<Vtb_out_wrapper> top{new Vtb_out_wrapper{contextp.get(), "TOP"}};

    // Initialize signals
    top->clk_i            = 0;
    top->rstn_i           = 0;
    top->imc_ready_i      = 0;
    top->start_transmit_i = 0;
    top->grant_i          = 0;
    top->accepted_i       = 0;
    top->a_i = 0x1111;
    top->b_i = 0x2222;
    top->c_i = 0x3333;
    top->d_i = 0x4444;
    top->eval();

    for (int i = 0; i < 5; i++) {
        tick(contextp, top);
    }

    // release reset
    top->rstn_i = 1;
    tick(contextp, top);
    VL_PRINTF("[%0ld] Reset...\n", contextp->time());

    // imc produces outputs
    top->imc_ready_i = 1;
    tick(contextp, top);
    VL_PRINTF("[%0ld] IMC ready...\n", contextp->time());

    // wait for wrapper to be available
    while (!top->avail_o) {
        tick(contextp, top);
    }
    VL_PRINTF("[%0ld] Signal avail_o...\n", contextp->time());

    top->start_transmit_i = 1;
    tick(contextp, top);
    top->start_transmit_i = 0;
    VL_PRINTF("[%0ld] Start transmit...\n", contextp->time()); 

    // wait until wrapper requests bus
    while (!top->request_o) {
        tick(contextp, top);
    }
    VL_PRINTF("[%0ld] Wrapper requested bus...\n", contextp->time());

    top->grant_i = 1;
    tick(contextp, top);
    VL_PRINTF("[%0ld] Bus granted...\n", contextp->time());

    for (int i = 0; i < 4; i++) {
        // Wait until wrapper ready to send next word
        for (int i = 0; i < 10; i++) {
            tick(contextp, top);
            if (top->ready_o) {
                break;
            }
        }

        VL_PRINTF("[%0ld] Sending data %d: 0x%04X\n",
                  contextp->time(), i + 1, top->data_o);

        // External device accepts data
        top->accepted_i = 1;
        tick(contextp, top);
        top->accepted_i = 0;
        tick(contextp, top);
    }

    top->grant_i = 0;
    top->imc_ready_i = 0;
    for (int i = 0; i < 5; i++) {
        tick(contextp, top);
    }

    VL_PRINTF("\n[%0ld] Completed...\n", contextp->time());

    top->final();
    contextp->statsPrintSummary();

    return 0;
}
