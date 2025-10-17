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
#include "Vtb_in_wrapper.h"

template <size_t N>
std::string to_binary(unsigned int value) {
    return std::bitset<N>(value).to_string();
}

void tick(const std::unique_ptr<VerilatedContext>& contextp,
          const std::unique_ptr<Vtb_in_wrapper>& top) {
    contextp->timeInc(5);
    top->clk = 0;
    top->eval();

    contextp->timeInc(5);
    top->clk = 1;
    top->eval();
}

void send_word(const std::unique_ptr<VerilatedContext>& contextp,
               const std::unique_ptr<Vtb_in_wrapper>& top,
               uint16_t value) {

    top->data = value;
    top->data_ready = 1;

    bool accepted = false;
    for (int i = 0; i < 20 && !accepted; i++) {
        tick(contextp, top);
        if (top->data_accept) {
            accepted = true;
            top->data_ready = 0;
            tick(contextp, top);
        }
    }

    if (accepted)
        VL_PRINTF("[%5ld] Sent 0x%04X\n", contextp->time(), value);
    else
        VL_PRINTF("[%5ld] Data 0x%04X not accepted\n", contextp->time(), value);
}

int main(int argc, char** argv) {
    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    const std::unique_ptr<Vtb_in_wrapper> top{new Vtb_in_wrapper{contextp.get(), "TOP"}};

    // Initialize signals
    top->clk        = 0;
    top->rstn       = 0;
    top->data_ready = 0;
    top->imc_ready  = 0;
    top->data       = 0;
    top->eval();

    for (int i = 0; i < 5; i++) {
        tick(contextp, top);
    }

    top->rstn = 1;
    tick(contextp, top);
    VL_PRINTF("[%0ld] Reset...\n", contextp->time());

    send_word(contextp, top, 0xDEAD);
    send_word(contextp, top, 0xBEEF);
    send_word(contextp, top, 0xCAFE);
    send_word(contextp, top, 0xBABE);
    VL_PRINTF("[%0ld] Sent 4 words...\n", contextp->time());

    top->imc_ready = 1;
    tick(contextp, top);
    for (int i = 0; i < 20 && !top->imc_start; i++) {
        tick(contextp, top);
    }
    VL_PRINTF("[%0ld] IMC start\n", contextp->time());

    top->imc_ready = 0;
    send_word(contextp, top, 0x1111);
    send_word(contextp, top, 0x2222);
    send_word(contextp, top, 0x3333);
    send_word(contextp, top, 0x4444);
    VL_PRINTF("[%0ld] Sent 4 words...\n", contextp->time());

    top->imc_ready = 1;
    tick(contextp, top);
    for (int i = 0; i < 20 && !top->imc_start; i++) {
        tick(contextp, top);
    }
    VL_PRINTF("[%0ld] IMC start\n", contextp->time());

    for (int i = 0; i < 3; i++) {
        tick(contextp, top);
    }

    VL_PRINTF("\n[%0ld] Completed...\n", contextp->time());

    top->final();
    contextp->statsPrintSummary();

    return 0;
}
