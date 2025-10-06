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

void tick(const std::unique_ptr<VerilatedContext>& contextp, const std::unique_ptr<Vtop>& top) {
    contextp->timeInc(5);
    top->clk = 0;
    top->eval();

    contextp->timeInc(5);
    top->clk = 1;
    top->eval();
}

void reset(const std::unique_ptr<VerilatedContext>& contextp, const std::unique_ptr<Vtop>& top) {
    top->rst_n = 0;
    tick(contextp, top);
    tick(contextp, top);
    top->rst_n = 1;
    VL_PRINTF("System reset.\n");
}

int main(int argc, char** argv) {
    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);
    const std::unique_ptr<Vtop> top{new Vtop{contextp.get(), "TOP"}};

    const int DEPTH = 256;
    const int WIDTH = 8;

    // init random number generator
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> distrib(0, (1 << WIDTH) - 1);

    // array for keeping expected values
    uint8_t ref_vals[DEPTH] = {0};

    // initialize
    top->clk            = 0;
    top->rst_n          = 0;
    top->data_in        = 0;
    top->read_addr_1    = 0;
    top->read_addr_2    = 0;
    top->write_addr     = 0;
    top->write_en_n     = 0;
    top->chip_en        = 0;
    top->data_out_1     = 0;
    top->data_out_2     = 0;
    top->eval();

    reset(contextp, top);
    top->chip_en = 1;

    VL_PRINTF("Writing to all registers...\n");
    for (int i = 0; i < DEPTH; i++) {
        uint8_t rand_val = distrib(gen);
        ref_vals[i] = rand_val;

        top->write_addr = i;
        top->data_in = rand_val;
        top->write_en_n = 0;

        tick(contextp, top);

        top->write_en_n = 1;
    }
    VL_PRINTF("Completed...\n\n");

    VL_PRINTF("Reading an verifying all registers (port 1)...\n");
    int error_count = 0;
    for (int i = 0; i < DEPTH; i++) {
        top->read_addr_1 = i;
        tick(contextp, top);

        uint8_t read_val = top->data_out_1;
        if (read_val != ref_vals[i]) {
            VL_PRINTF("ERROR: Addr %d: RF returned %d, expected %d\n", i, read_val, ref_vals[i]);
            error_count++;
        }
    }
    VL_PRINTF("Completed with %d errors...\n\n", error_count);

    VL_PRINTF("Reading an verifying all registers (port 2)...\n");
    error_count = 0;
    for (int i = 0; i < DEPTH; i++) {
        top->read_addr_2 = i;
        tick(contextp, top);

        uint8_t read_val = top->data_out_2;
        if (read_val != ref_vals[i]) {
            VL_PRINTF("ERROR: Addr %d: RF returned %d, expected %d\n", i, read_val, ref_vals[i]);
            error_count++;
        }
    }
    VL_PRINTF("Completed with %d errors...\n\n", error_count);

    VL_PRINTF("Verifying reset...\n");
    error_count = 0;
    reset(contextp, top);

    top->read_addr_1 = 127;
    tick(contextp, top);
    uint8_t val_after_reset = top->data_out_1;
    if (val_after_reset != 0) {
        VL_PRINTF("ERROR: Addr %d: RF returned %d, expected 0\n", 127, val_after_reset);
    }
    VL_PRINTF("Completed with %d errors...\n\n", error_count);

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
