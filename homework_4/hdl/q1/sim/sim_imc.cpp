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
#include <array>
#include <verilated.h>
#include "Vtb_imc.h"

template <size_t N>
std::string to_binary(unsigned int value) {
    return std::bitset<N>(value).to_string();
}

void tick(const std::unique_ptr<VerilatedContext>& contextp, const std::unique_ptr<Vtb_imc>& top) {
    contextp->timeInc(5);
    top->clk = 0;
    top->eval();

    contextp->timeInc(5);
    top->clk = 1;
    top->eval();
}

typedef std::array<std::array<float, 2>, 2> Matrix2x2;

Matrix2x2 inv_mat(Matrix2x2 mat) {
    float a = mat[0][0];
    float b = mat[0][1];
    float c = mat[1][0];
    float d = mat[1][1];
    float det = a * d - b * c;

    if (det == 0.0f) {
        return {{
            { 0, 0 },
            { 0, 0 }
        }};
    }

    float rec = 1.0f / det;
    
    Matrix2x2 inv = {{
        {  d * rec, -b * rec },
        { -c * rec,  a * rec }
    }};
    
    return inv;
}

float q8_8_to_float(int16_t val, bool sign) {
    float f = static_cast<float>(val) / 256.0f;
    return sign ? -f : f;
}

// Convert float to int16_t Q8.8 (always positive)
int16_t float_to_q8_8(float val) {
    return static_cast<int16_t>(roundf(std::fabs(val) * 256.0f));
}

int main(int argc, char** argv) {
    Verilated::mkdir("logs");
    const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};
    contextp->debug(0);
    contextp->randReset(2);
    contextp->traceEverOn(true);
    contextp->commandArgs(argc, argv);

    const std::unique_ptr<Vtb_imc> top{new Vtb_imc{contextp.get(), "TOP"}};

    // Initialize signals
    top->clk    = 0;
    top->start  = 0;
    top->rstn   = 1;
    top->a_in   = 0;
    top->b_in   = 0;
    top->c_in   = 0;
    top->d_in   = 0;

    for (int i = 0; i < 2; i++) {
        tick(contextp, top);
    }

    // test
    top->rstn   = 1;
    top->a_in   = float_to_q8_8(1.0f);
    top->b_in   = float_to_q8_8(2.0f);
    top->c_in   = float_to_q8_8(2.0f);
    top->d_in   = float_to_q8_8(1.0f);
    top->start  = 1;
    tick(contextp, top);

    int error_count = 0;
    for (int a = 0; a <= 15; a++) {
        for (int b = 0; b <= 15; b++) {
            for (int c = 0; c <= 15; c++) {
                for (int d = 0; d <= 15; d++) {

                    Matrix2x2 mat = {{
                        { static_cast<float>(a), static_cast<float>(b) },
                        { static_cast<float>(c), static_cast<float>(d) }
                    }};

                    float a_float = static_cast<float>(a);
                    float b_float = static_cast<float>(b);
                    float c_float = static_cast<float>(c);
                    float d_float = static_cast<float>(d);
                    float det = a_float * d_float - b_float * c_float;

                    if (det > 15.0f || det < -15.0f) {
                        continue;
                    }

                    Matrix2x2 mat_inv = inv_mat(mat);

                    top->a_in = float_to_q8_8(mat[0][0]);
                    top->b_in = float_to_q8_8(mat[0][1]);
                    top->c_in = float_to_q8_8(mat[1][0]);
                    top->d_in = float_to_q8_8(mat[1][1]);

                    top->start = 1;
                    tick(contextp, top);
                    top->start = 0;

                    while (top->ready != 1) {
                        tick(contextp, top);
                    }

                    float a_hw = q8_8_to_float(top->a_out, top->a_sign);
                    float b_hw = q8_8_to_float(top->b_out, top->b_sign);
                    float c_hw = q8_8_to_float(top->c_out, top->c_sign);
                    float d_hw = q8_8_to_float(top->d_out, top->d_sign);

                    float tol = 0.041f;
                    float err_a = std::fabs(a_hw - mat_inv[0][0]);
                    float err_b = std::fabs(b_hw - mat_inv[0][1]);
                    float err_c = std::fabs(c_hw - mat_inv[1][0]);
                    float err_d = std::fabs(d_hw - mat_inv[1][1]);

                    VL_PRINTF("Matrix: [[%d, %d], [%d, %d]]\n", a, b, c, d);
                    VL_PRINTF("HW inv: [%.4f, %.4f; %.4f, %.4f]\n", a_hw, b_hw, c_hw, d_hw);
                    VL_PRINTF("Ref inv: [%.4f, %.4f; %.4f, %.4f]\n",
                        mat_inv[0][0], mat_inv[0][1],
                        mat_inv[1][0], mat_inv[1][1]);

                    if (err_a > tol || err_b > tol || err_c > tol || err_d > tol) {
                        error_count += 1;
                        VL_PRINTF("ERROR!\n\n");
                    }
                    else {
                        VL_PRINTF("\n");
                    }

                }
            }
        }
    }

    VL_PRINTF("\n[%0ld] Completed with %d errors...\n", contextp->time(), error_count);

    top->final();
    contextp->statsPrintSummary();

    return 0;
}
