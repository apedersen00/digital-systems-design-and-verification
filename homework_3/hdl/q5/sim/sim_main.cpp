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
#include <random>
#include <iomanip>
#include <iostream>
#include <verilated.h>
#include "Vtop.h"

// Legacy function required only so linking works on Cygwin and MSVC++
double sc_time_stamp() { return 0; }

// Convert fixed-point to double (Q15.16 format)
double fixed_to_double(uint16_t fixed_val) {
    return (double)fixed_val / 65536.0;
}

// Convert double to fixed-point (Q15.16 format) 
uint16_t double_to_fixed(double val) {
    return (uint16_t)(val * 65536.0);
}

// Reference sin(x) calculation using Taylor series (8 terms)
double reference_sin(double x) {
    double result = 0.0;
    double term = x;
    
    for (int n = 0; n < 8; n++) {
        if (n % 2 == 0) {
            result += term; // Add for even terms
        } else {
            result -= term; // Subtract for odd terms
        }
        
        // Calculate next term: multiply by x^2 and divide by (2n+2)(2n+3)
        term = term * x * x / ((2*n + 2) * (2*n + 3));
    }
    
    return result;
}

int main(int argc, char** argv) {
    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    const std::unique_ptr<Vtop> top{new Vtop{contextp.get(), "TOP"}};

    auto clock_cycle = [&]() {
        top->clk = 0;
        top->eval();
        contextp->timeInc(5);
        top->clk = 1;
        top->eval();
        contextp->timeInc(5);
    };

    auto wait_for_done = [&]() {
        int timeout = 100;
        while (!top->done && timeout > 0) {
            clock_cycle();
            timeout--;
        }
        if (timeout == 0) {
            VL_PRINTF("ERROR: Timeout waiting for done signal!\n");
        }
    };

    // Initialize signals
    top->clk = 0;
    top->rstn = 1;
    top->start = 0;
    top->x = 0;
    clock_cycle();

    // Reset
    VL_PRINTF("\n=== SINX ACCELERATOR TESTBENCH ===\n");
    VL_PRINTF("Resetting DUT...\n");
    top->rstn = 0;
    clock_cycle();
    top->rstn = 1;
    clock_cycle();

    // Test cases: x values in range [0, π/2) 
    // Using fixed-point representation Q15.16
    double test_angles[] = {
        0.0,           // 0 radians
        0.1,           // Small angle
        0.5,           // Medium angle 
        1.0,           // 1 radian
        1.57,          // Close to π/2
        M_PI/6,        // 30 degrees
        M_PI/4,        // 45 degrees
        M_PI/3         // 60 degrees
    };
    
    int num_tests = sizeof(test_angles) / sizeof(test_angles[0]);
    int passed = 0;
    
    VL_PRINTF("\n--- Testing %d different angles ---\n", num_tests);
    VL_PRINTF("%-8s %-12s %-12s %-12s %-12s %-10s\n", 
              "Test", "Angle (rad)", "Input (hex)", "HW Result", "SW Result", "Error");
    VL_PRINTF("------------------------------------------------------------------------\n");
    
    for (int i = 0; i < num_tests; i++) {
        double angle = test_angles[i];
        
        // Skip if angle >= π/2
        if (angle >= M_PI/2) {
            VL_PRINTF("Skipping angle %.3f (>= π/2)\n", angle);
            continue;
        }
        
        // Convert to fixed-point
        uint16_t x_fixed = double_to_fixed(angle);
        
        // Start calculation
        top->x = x_fixed;
        top->start = 1;
        clock_cycle();
        top->start = 0;
        
        // Wait for completion
        wait_for_done();
        
        // Get results
        double hw_result = fixed_to_double(top->result);
        double sw_result = reference_sin(angle);
        double error = fabs(hw_result - sw_result);
        
        VL_PRINTF("%-8d %-12.6f 0x%-10X %-12.6f %-12.6f %-10.6f\n",
                  i+1, angle, x_fixed, hw_result, sw_result, error);
        
        // Check if error is within acceptable range (adjust threshold as needed)
        if (error < 0.01) {
            passed++;
        } else {
            VL_PRINTF("  >>> ERROR: Result outside acceptable range!\n");
        }
        
        // Wait a few cycles before next test
        for (int j = 0; j < 3; j++) {
            clock_cycle();
        }
    }
    
    VL_PRINTF("\n--- Special Test Cases ---\n");
    
    // Test multiple starts (should handle gracefully)
    VL_PRINTF("Testing multiple start pulses...\n");
    top->x = double_to_fixed(0.5);
    top->start = 1;
    clock_cycle();
    top->start = 1; // Second start pulse
    clock_cycle();
    top->start = 0;
    wait_for_done();
    VL_PRINTF("Multiple start test completed.\n");
    
    // Test edge case: x = 0
    VL_PRINTF("Testing edge case x = 0...\n");
    top->x = 0;
    top->start = 1;
    clock_cycle();
    top->start = 0;
    wait_for_done();
    double zero_result = fixed_to_double(top->result);
    VL_PRINTF("sin(0) = %.6f (expected ≈ 0.0)\n", zero_result);
    
    VL_PRINTF("\n=== TEST SUMMARY ===\n");
    VL_PRINTF("Tests passed: %d/%d\n", passed, num_tests);
    VL_PRINTF("Success rate: %.1f%%\n", (double)passed/num_tests * 100.0);
    
    if (passed == num_tests) {
        VL_PRINTF("🎉 ALL TESTS PASSED! 🎉\n");
    } else {
        VL_PRINTF("❌ Some tests failed. Check implementation.\n");
    }

    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
