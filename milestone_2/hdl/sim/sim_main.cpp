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
    top->clk            = 0;
    top->rst_n          = 0;
    top->data_in        = 0;
    top->read_addr_1    = 0;
    top->read_addr_2    = 0;
    top->write_addr     = 0;
    top->write_en_n     = 1;
    top->chip_en        = 0;
    top->data_out_1     = 0;
    top->data_out_2     = 0;
    top->eval();

    const int DEPTH = 256;
    const int WIDTH = 8;

    // init random number generator
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> distrib(0, (1 << WIDTH) - 1);

    contextp->timeInc(10);
    top->rst_n = 1;
    top->chip_en = 1;
    top->eval();

    uint8_t test_vals[DEPTH];

    for (int i = 0; i < DEPTH; i++) {
        contextp->timeInc(10);
        top->clk = 0;

        top->write_en_n = 0;
        top->write_addr = i;
        uint8_t val = distrib(gen);
        test_vals[i] = val;
        top->data_in = val;
        top->eval();

        contextp->timeInc(10);
        top->clk = 1;
        top->eval();
    }

    for (int i = 0; i < DEPTH; i++) {
        contextp->timeInc(10);
        top->clk = 0;

        top->write_en_n = 1;

        uint8_t addr = distrib(gen);
        addr = i;
        top->read_addr_1 = addr;
        top->eval();

        if (addr == 127) {
            contextp->timeInc(5);
            top->rst_n = 0;
            top->eval();
            contextp->timeInc(5);
            top->rst_n = 1;
            top->clk = 1;
            top->eval();
        } else {
            top->rst_n = 1;
            contextp->timeInc(10);
            top->clk = 1;
            top->eval();
        }

        uint8_t val = top->data_out_1;
        VL_PRINTF(" addr: %d, val: %d, expected: %d\n", addr, val, test_vals[addr]);
    }


    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
