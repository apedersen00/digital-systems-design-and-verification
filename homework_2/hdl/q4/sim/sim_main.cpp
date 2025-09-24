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
#include "Vtop.h"

// Legacy function required only so linking works on Cygwin and MSVC++
double sc_time_stamp() { return 0; }

template <size_t N>
std::string to_binary(unsigned int value) {
    return std::bitset<N>(value).to_string();
}

int main(int argc, char** argv) {
    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    const std::unique_ptr<Vtop> top{new Vtop{contextp.get(), "TOP"}};

    // Helper function for clock cycle
    auto clock_cycle = [&]() {
        top->clk = 0;
        top->eval();
        contextp->timeInc(5);
        top->clk = 1;
        top->eval();
        contextp->timeInc(5);
    };

    // Initialize signals
    top->clk            = 0;
    top->rstn           = 0;
    top->up_down        = 0;
    top->load_en        = 0;
    top->load           = 0;
    top->eval();
    
    VL_PRINTF("\n--- Testing: Reset ---\n");
    clock_cycle();
    VL_PRINTF("After reset: count=%s carry=%d (expected: 0000, 0)\n",
              to_binary<4>(top->count).c_str(), top->carry);

    VL_PRINTF("\n--- Testing: Load value 0b1010 ---\n");
    top->rstn    = 1;
    top->load    = 0xA;
    top->load_en = 1;
    clock_cycle();
    top->load_en = 0;
    VL_PRINTF("After load: count=%s carry=%d (expected: 1010, 0)\n",
              to_binary<4>(top->count).c_str(), top->carry);

    VL_PRINTF("\n--- Testing: Count Up ---\n");
    top->up_down = 1;
    for (int i = 0; i < 6; i++) {
        clock_cycle();
        VL_PRINTF("Cycle %d: count=%s carry=%d\n",
                  i+1, to_binary<4>(top->count).c_str(), top->carry);
    }

    VL_PRINTF("\n--- Testing: Count Down ---\n");
    top->up_down = 0;
    for (int i = 0; i < 6; i++) {
        clock_cycle();
        VL_PRINTF("Cycle %d: count=%s carry=%d\n",
                  i+1, to_binary<4>(top->count).c_str(), top->carry);
    }

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
