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
    top->clk                = 0;
    top->rstn               = 0;
    top->serial_parallel    = 0;
    top->load_enable        = 0;
    top->serial_in          = 0;
    top->parallel_in        = 0;
    top->eval();
    
    // Reset
    VL_PRINTF("\n--- Testing: Reset ---\n");
    top->rstn = 0;
    clock_cycle();
    VL_PRINTF("After reset: parallel_out=0x%02x (expected: 0x00)\n", top->parallel_out);
    
    // Parallel load
    VL_PRINTF("\n--- Testing: Parallel Load (10100101)---\n");
    top->rstn               = 1;
    top->load_enable        = 1;
    top->serial_parallel    = 1;
    top->parallel_in        = 0xA5;   // 10100101
    clock_cycle();
    VL_PRINTF("Parallel load 0x10100101: parallel_out=%s, serial_out=%d\n", 
              to_binary<8>(top->parallel_out).c_str(), top->serial_out);
    
    // Serial shifting with 0s
    VL_PRINTF("\n--- Testing: Serial Shifting with 0s ---\n");
    top->serial_parallel    = 0;  // Select serial mode
    top->serial_in          = 0;        // Shift in 0s
    
    for (int i = 0; i < 8; i++) {
        clock_cycle();
        VL_PRINTF("Shift %d: parallel_out=%s, serial_out=%d\n", 
                i+1, to_binary<8>(top->parallel_out).c_str(), top->serial_out);
    }
    
    // Serial shifting with 1s
    VL_PRINTF("\n--- Testing: Serial Shift with 1s ---\n");
    top->parallel_in        = 0x00;     // load all zeros
    top->serial_parallel    = 1;
    clock_cycle();
    VL_PRINTF("Loaded 0x00: parallel_out=%s\n", to_binary<8>(top->parallel_out).c_str());
    
    top->serial_parallel = 0;  // Switch to serial mode
    top->serial_in = 1;
    
    for (int i = 0; i < 8; i++) {
        clock_cycle();
        VL_PRINTF("Shift in 1 [%d]: parallel_out=%s, serial_out=%d\n", 
                  i+1, to_binary<8>(top->parallel_out).c_str(), top->serial_out);
    }

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
