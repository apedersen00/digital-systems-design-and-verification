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

#include <memory>
#include <verilated.h>
#include "Vtop_tb.h"

void tick(const std::unique_ptr<VerilatedContext>& contextp, const std::unique_ptr<Vtop_tb>& top) {
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
    
    // create DUT instance
    const std::unique_ptr<Vtop_tb> top{new Vtop_tb{contextp.get(), "TOP"}};

    // initialize
    top->clk    = 0;
    top->rstn   = 0;
    top->eval();

    tick(contextp, top);
    tick(contextp, top);
    tick(contextp, top);

    int out_reg = top->out_reg;
    top->rstn   = 1;
    uint32_t cycle = 0;

    VL_PRINTF("CYCLE: %d\tOUT_REG: (0x%08X)\t%d\n", cycle, out_reg, out_reg);
    for (int i = 0; i< 1000000; i++) {
        tick(contextp, top);
        if (out_reg != top->out_reg) {
            out_reg = top->out_reg;
            VL_PRINTF("CYCLE: %d\tOUT_REG: (0x%08X)\t%d\n", cycle, out_reg, out_reg);
        }
        cycle += 1;
    }

    VL_PRINTF("\n[%0ld] Completed...\n", contextp->time());

    top->final();
    contextp->statsPrintSummary();
    
    return 0;
}
