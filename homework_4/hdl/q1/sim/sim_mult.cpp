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
#include "Vtb_mult.h"

template <size_t N>
std::string to_binary(unsigned int value) {
    return std::bitset<N>(value).to_string();
}

void tick(const std::unique_ptr<VerilatedContext>& contextp, const std::unique_ptr<Vtb_mult>& top) {
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

    const std::unique_ptr<Vtb_mult> top{new Vtb_mult{contextp.get(), "TOP"}};

    // Initialize signals
    top->sel = 0;
    top->a = 0;
    top->b = 0;
    top->eval();

    struct TestCase {
        uint16_t a;
        uint16_t b;
        uint8_t sel;
        const char* description;
    };

    TestCase test_cases[] = {
        // Multiplication to Q8.8
        {0x0100, 0x0100, 0, "1.0 * 1.0 = 1.0 (Q8.8)"},
        {0x0200, 0x0100, 0, "2.0 * 1.0 = 2.0"},
        {0x0100, 0x0200, 0, "1.0 * 2.0 = 2.0"},
        {0x0080, 0x0100, 0, "0.5 * 1.0 = 0.5"},
        {0x0040, 0x0200, 0, "0.25 * 2.0 = 0.5"},
        
        // Multiplication to Q16.0
        {0x0100, 0x0100, 1, "1.0 * 1.0 = 1.0 (Q16.0)"},
        {0x1000, 0x1000, 1, "16.0 * 16.0 = 256.0 (Q16.0)"},
        {0x8000, 0x0100, 1, "128.0 * 1.0 = 128.0 (Q16.0)"},
        
        // Edge cases
        {0x0000, 0x1234, 0, "0 * anything = 0"},
        {0x1234, 0x0000, 1, "anything * 0 = 0"},
        {0xFFFF, 0x0001, 0, "Max * 1 (Q8.8)"},
        {0xFFFF, 0x0001, 1, "Max * 1 (Q16.0)"},
        {0xFFFF, 0xFFFF, 0, "Max * Max (Q8.8)"},
        {0xFFFF, 0xFFFF, 1, "Max * Max (Q16.0)"},
        
        // Multiplication to Q8.8
        {0x0180, 0x0080, 0, "1.5 * 0.5 = 0.75"},
        {0x0140, 0x0140, 0, "1.25 * 1.25 = 1.5625"},
        {0x00C0, 0x0200, 0, "0.75 * 2.0 = 1.5"},
    };

    int num_tests = sizeof(test_cases) / sizeof(TestCase);

    for (int i = 0; i < num_tests; i++) {
        top->a      = test_cases[i].a;
        top->b      = test_cases[i].b; 
        top->sel    = test_cases[i].sel;

        tick(contextp, top);
        
        printf("Test %2d: %s\n", i+1, test_cases[i].description);
        printf("  Inputs:  a=0x%04X, b=0x%04X, sel=%d\n", 
               test_cases[i].a, test_cases[i].b, test_cases[i].sel);
        printf("  Result:   0x%04X\n\n", top->res);
    }

    VL_PRINTF("\n[%0ld] Completed...\n", contextp->time());

    top->final();
    contextp->statsPrintSummary();

    return 0;
}
