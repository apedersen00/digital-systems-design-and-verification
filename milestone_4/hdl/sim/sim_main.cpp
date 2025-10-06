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

void wait_for_ready(const std::unique_ptr<VerilatedContext>& contextp, const std::unique_ptr<Vtop>& top) {
    while (!top->ready) {
        tick(contextp, top);
    }
}

int main(int argc, char** argv) {
    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);
    const std::unique_ptr<Vtop> top{new Vtop{contextp.get(), "TOP"}};

    // Memory parameters
    const int NUM_WORDS = 16384;
    const int WORD_SIZE = 32;
    
    // Initialize random number generator
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<uint32_t> data_dist(0, UINT32_MAX);
    std::uniform_int_distribution<uint32_t> addr_dist(0, (NUM_WORDS - 1) * 8); // Word-aligned addresses

    // Array for keeping expected values
    uint32_t ref_memory[NUM_WORDS] = {0};

    // Initialize signals
    top->clk        = 0;
    top->read_en    = 0;
    top->addr       = 0;
    top->d_i        = 0;
    top->eval();

    VL_PRINTF("\n--- 64KiB Memory System Test ---\n");

    tick(contextp, top);
    wait_for_ready(contextp, top);

    // Read initialization data
    for (int i = 0; i < 16; i++) {
        uint32_t word_addr = i * 4;
        top->addr = word_addr | 0x3;
        top->read_en = 1;

        tick(contextp, top);
        wait_for_ready(contextp, top);

        uint32_t read_data = top->d_o;
        VL_PRINTF("  Read 0x%08X from address 0x%08X ✓\n", read_data, word_addr);
    }

    // Write test data to memory
    VL_PRINTF("\n--- Write Test ---\n");
    
    for (int i = 0; i < NUM_WORDS; i++) {
        uint32_t test_data = data_dist(gen);
        uint32_t word_addr = i * 4;
        
        ref_memory[i] = test_data;
        
        top->addr = word_addr | 0x3;
        top->d_i = test_data;
        top->read_en = 0;
        
        tick(contextp, top);
        wait_for_ready(contextp, top);
        
        if (i < 5) {
            VL_PRINTF("  Wrote 0x%08X to address 0x%08X\n", test_data, word_addr);
        }
    }
    VL_PRINTF("Write test completed.\n\n");

    // Test 2: Read back and verify data
    VL_PRINTF("\n--- Read Test ---\n");
    
    int error_count = 0;
    for (int i = 0; i < NUM_WORDS; i++) {
        uint32_t word_addr = i * 4;
        
        top->addr = word_addr;
        top->d_i = 0;
        top->read_en = 1;
        
        tick(contextp, top);
        wait_for_ready(contextp, top);
        
        uint32_t read_data = top->d_o;
        uint32_t expected_data = ref_memory[i];
        
        if (read_data != expected_data) {
            VL_PRINTF("ERROR: Addr 0x%08X: Read 0x%08X, expected 0x%08X\n", 
                     word_addr, read_data, expected_data);
            error_count++;
        } else if (i < 5) { // Show first few successful reads
            VL_PRINTF("  Read 0x%08X from address 0x%08X ✓\n", read_data, word_addr);
        }
        
        top->read_en = 0;
    }
    
    if (error_count == 0) {
        VL_PRINTF("All %d read operations completed successfully! ✓\n\n", NUM_WORDS);
    } else {
        VL_PRINTF("Read test completed with %d errors.\n\n", error_count);
    }

    // Test 3: State machine timing test
    VL_PRINTF("--- Timing Test ---\n");
    VL_PRINTF("Testing read/write state machine timing...\n");
    
    // Test read timing
    top->addr = 0x00;
    top->read_en = 1;
    int read_cycles = 0;
    
    tick(contextp, top);
    while (!top->ready) {
        tick(contextp, top);
        read_cycles++;
    }
    VL_PRINTF("Read operation took %d cycles\n", read_cycles + 1);
    
    top->read_en = 0;
    tick(contextp, top);
    
    // Test write timing  
    top->addr = 0x03;  // Write enable
    top->d_i = 0xDEADBEEF;
    int write_cycles = 0;
    
    tick(contextp, top);
    while (!top->ready) {
        tick(contextp, top);
        write_cycles++;
    }
    VL_PRINTF("Write operation took %d cycles\n", write_cycles + 1);

    // Test 4: Address boundary test
    VL_PRINTF("\n--- Address Boundary Test ---\n");
    VL_PRINTF("Testing edge addresses...\n");
    
    // Test first address
    top->addr = 0b00000000000001;
    top->d_i = 0x12345678;
    top->read_en = 0;
    tick(contextp, top);
    wait_for_ready(contextp, top);
    
    top->read_en = 1;
    tick(contextp, top);
    wait_for_ready(contextp, top);
    
    if (top->d_o == 0x12345678) {
        VL_PRINTF("Address 0x00:\n");
    } else {
        VL_PRINTF("Address 0x00: ERROR - got 0x%08X\n", top->d_o);
        error_count++;
    }
    
    top->read_en = 0;

    VL_PRINTF("\n=== Test Summary ===\n");
    if (error_count == 0) {
        VL_PRINTF("All tests PASSED!\n");
    } else {
        VL_PRINTF("Tests FAILED with %d errors.\n", error_count);
    }

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return error_count == 0 ? 0 : 1;
}
