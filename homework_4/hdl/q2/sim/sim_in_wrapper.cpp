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

void tick(const std::unique_ptr<VerilatedContext>& contextp, const std::unique_ptr<Vtb_in_wrapper>& top) {
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

    const std::unique_ptr<Vtb_in_wrapper> top{new Vtb_in_wrapper{contextp.get(), "TOP"}};

    // Initialize signals
    top->clk        = 0;
    top->rstn       = 0;
    top->data_ready = 0;
    top->imc_ready  = 0;
    top->data       = 0;
    top->eval();
    tick(contextp, top);

    top->rstn       = 1;
    top->data_ready = 1;
    top->data       = 0xDEAD;
    for (int i = 0; i < 10; i++){
        tick(contextp, top);
        if (top->data_accept == 1){
            break;
        }
    }

    top->data_ready = 1;
    top->data       = 0xBEEF;
    for (int i = 0; i < 10; i++){
        tick(contextp, top);
        if (top->data_accept == 1){
            break;
        }
    }

    top->data_ready = 1;
    top->data       = 0xCAFE;
    for (int i = 0; i < 10; i++){
        tick(contextp, top);
        if (top->data_accept == 1){
            break;
        }
    }

    top->data_ready = 1;
    top->data       = 0xBABE;
    for (int i = 0; i < 10; i++){
        tick(contextp, top);
        if (top->data_accept == 1){
            break;
        }
    }

    top->data_ready = 0;
    top->imc_ready  = 1;
    tick(contextp, top);

    // Initialize signals
    top->rstn       = 0;
    top->data_ready = 0;
    top->imc_ready  = 0;
    top->data       = 0;
    tick(contextp, top);

    top->rstn       = 1;
    top->data_ready = 1;
    top->data       = 0x1111;
    tick(contextp, top);
    for (int i = 0; i < 10; i++){
        tick(contextp, top);
        if (top->data_accept == 1){
            break;
        }
    }

    top->data_ready = 0;
    tick(contextp, top);
    tick(contextp, top);
    top->data_ready = 1;
    top->data       = 0x2222;
    tick(contextp, top);
    for (int i = 0; i < 10; i++){
        tick(contextp, top);
        if (top->data_accept == 1){
            break;
        }
    }

    top->data_ready = 1;
    top->data       = 0x3333;
    for (int i = 0; i < 10; i++){
        tick(contextp, top);
        if (top->data_accept == 1){
            break;
        }
    }
    top->data_ready = 1;
    top->data       = 0x4444;
    for (int i = 0; i < 10; i++){
        tick(contextp, top);
        if (top->data_accept == 1){
            break;
        }
    }

    top->data_ready = 0;
    top->imc_ready  = 1;
    tick(contextp, top);

    for (int i = 0; i < 3; i++) {
        tick(contextp, top);
    }

    VL_PRINTF("\n[%0ld] Completed...\n", contextp->time());

    top->final();
    contextp->statsPrintSummary();

    return 0;
}
