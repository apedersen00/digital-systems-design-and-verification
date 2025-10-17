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
#include "Vtb_iab.h"

template <size_t N>
std::string to_binary(unsigned int value) {
    return std::bitset<N>(value).to_string();
}

void tick(const std::unique_ptr<VerilatedContext>& contextp, const std::unique_ptr<Vtb_iab>& top) {
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

    const std::unique_ptr<Vtb_iab> top{new Vtb_iab{contextp.get(), "TOP"}};

    // Initialize signals
    top->clk_i          = 0;
    top->rstn_i         = 0;
    top->a_ready_i      = 0;
    top->bus_grant_i    = 0;
    top->accepted_i     = 0;
    top->data_a_i       = 0x1122334455667788;
    top->eval();

    for (int i = 0; i < 5; i++) tick(contextp, top);
    top->rstn_i = 1;
    tick(contextp, top);
    VL_PRINTF("[%0ld] Reset...\n", contextp->time());

    top->a_ready_i = 1;
    tick(contextp, top);

    while (!top->accepted_a_o) tick(contextp, top);
    top->a_ready_i = 0;
    VL_PRINTF("[%0ld] IAB accepted 64-bit data from A\n", contextp->time());

    while (!top->bus_req_o) tick(contextp, top);
    VL_PRINTF("[%0ld] IAB requested bus\n", contextp->time());

    top->bus_grant_i = 1;
    tick(contextp, top);
    VL_PRINTF("[%0ld] Bus granted to IAB\n", contextp->time());

    for (int byte_idx = 0; byte_idx < 8; byte_idx++) {
        for (int i = 0; i < 10; i++) {
            tick(contextp, top);
            if (top->ready_o) {
                break;
            }
        }

        VL_PRINTF("[%0ld] IAB sent %d: 0x%02X\n",
                  contextp->time(), byte_idx, top->data_b_o);

        top->accepted_i = 1;
        tick(contextp, top);
        top->accepted_i = 0;
        tick(contextp, top);
    }

    top->bus_grant_i = 0;
    tick(contextp, top);

    VL_PRINTF("[%0ld] Completed transfer\n", contextp->time());

    top->final();
    contextp->statsPrintSummary();

    return 0;
}
