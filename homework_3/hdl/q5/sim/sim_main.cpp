//-------------------------------------------------------------------------------------------------
//
//  File: sim_main.cpp
//  Description: Stimulus for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

#include <fstream>
#include <cmath>
#include <memory>
#include <iostream>
#include <verilated.h>
#include "Vtop.h"

// Legacy function required only so linking works on Cygwin and MSVC++
double sc_time_stamp() { return 0; }

double x_fixed_to_double(uint16_t fixed_val) {
    return (double)fixed_val / 32768.0;
}

uint16_t double_to_x_fixed(double val) {
    return (uint16_t)(val * 32768.0);
}

double result_fixed_to_double(uint16_t fixed_val) {
    return (double)fixed_val / 65536.0;
}

double reference_sin(double x) {
    double result = 0.0;
    double term = x;

    for (int n = 0; n < 8; n++) {
        if (n % 2 == 0) {
            result += term;
        } else {
            result -= term;
        }
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
    };

    // Initialize signals
    top->clk = 0;
    top->rstn = 1;
    top->start = 0;
    top->x = 0;
    clock_cycle();

    // Reset
    VL_PRINTF("\n--- Reset ---\n");
    top->rstn = 0;
    clock_cycle();
    top->rstn = 1;
    clock_cycle();

    double test_angles[] = {
        0.0,
        0.1,
        0.5,
        1.0,
        1.57,
        M_PI/6,
        M_PI/4,
        M_PI/3
    };

    int num_tests = sizeof(test_angles) / sizeof(test_angles[0]);
    int passed = 0;

    VL_PRINTF("%-8s %-12s %-12s %-12s %-12s %-10s\n",
              "Test", "Angle (rad)", "Input (hex)", "HW Result", "SW Result", "Error");
    VL_PRINTF("------------------------------------------------------------------------\n");

    for (int i = 0; i < num_tests; i++) {
        double angle = test_angles[i];

        // Convert to fixed-point
        uint16_t x_fixed = double_to_x_fixed(angle);

        top->x = x_fixed;
        top->start = 1;
        clock_cycle();
        top->start = 0;

        wait_for_done();

        // Get results
        double hw_result = result_fixed_to_double(top->result);
        double sw_result = reference_sin(angle);
        double error = fabs(hw_result - sw_result);

        VL_PRINTF("%-8d %-12.6f 0x%-10X %-12.6f %-12.6f %-10.6f\n",
                  i+1, angle, x_fixed, hw_result, sw_result, error);

        for (int j = 0; j < 3; j++) {
            clock_cycle();
        }
    }


    VL_PRINTF("\n--- Writing to file ---\n");
    std::ofstream outfile("sinx.csv");
    outfile << "rad,res\n";

    int N = 100;
    for (int i = 0; i <= N; i++) {
        double angle = (M_PI / 2.0) * i / N;
        uint16_t x = double_to_x_fixed(angle);

        top->x = x;
        top->start = 1;
        clock_cycle();
        top->start = 0;

        wait_for_done();

        double result = result_fixed_to_double(top->result);
        outfile << angle << "," << result << "\n";

        for (int j = 0; j < 3; j++) {
            clock_cycle();
        }
    }

    outfile.close();
    top->final();
    contextp->statsPrintSummary();
    Verilated::threadContextp()->coveragep()->write("logs/coverage.dat");
    return 0;
}
