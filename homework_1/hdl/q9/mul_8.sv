//-------------------------------------------------------------------------------------------------
//
//  File: mul_8.sv
//  Description: 8-bit multiplier built from 4-bit multipliers
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  mul_8 dut (
//    .a_i(),
//    .b_i(),
//    .prod_o()
//  );

module mul_8 #(
  localparam N = 8
) (
  input   logic [N-1:0]   a_i,
  input   logic [N-1:0]   b_i,
  output  logic [2*N-1:0] prod_o
);

  // Split the 8-bit inputs to 4-bit halves
  logic [N/2-1:0] a_L, a_H, b_L, b_H;

  assign a_L = a_i[N/2-1:0];
  assign a_H = a_i[N-1:N/2];
  assign b_L = b_i[N/2-1:0];
  assign b_H = b_i[N-1:N/2];

  // 8-bit logic vectors for the 4-bit multiplier products
  logic [N-1:0] prod_0, prod_1, prod_2, prod_3;

  mul_4 mul_LL (
    .a_i(a_L),
    .b_i(b_L),
    .prod_o(prod_0)
  );

  mul_4 mul_HL (
    .a_i(a_H),
    .b_i(b_L),
    .prod_o(prod_1)
  );

  mul_4 mul_LH (
    .a_i(a_L),
    .b_i(b_H),
    .prod_o(prod_2)
  );

  mul_4 mul_HH (
    .a_i(a_H),
    .b_i(b_H),
    .prod_o(prod_3)
  );

  // 16-bit logic vectors for the bit shifted partial products
  logic [2*N-1:0] term_0, term_1, term_2, term_3;

  assign term_0 = {8'b0, prod_0};
  assign term_1 = {4'b0, prod_1, 4'b0};
  assign term_2 = {4'b0, prod_2, 4'b0};
  assign term_3 = {prod_3, 8'b0};

  logic [2*N-1:0] sum_stage1_a, sum_stage1_b;
  logic           cout_stage1_a, cout_stage1_b, cout_final;

  cr_adder #(
    .Width(2*N)
  ) add_s1a (
    .a      (term_0),
    .b      (term_1),
    .c_in   (1'b0),
    .sum    (sum_stage1_a),
    .c_out  (cout_stage1_a)
  );

  cr_adder #(
    .Width(2*N)
  ) add_s1b (
    .a      (term_2),
    .b      (term_3),
    .c_in   (1'b0),
    .sum    (sum_stage1_b),
    .c_out  (cout_stage1_b)
  );

  cr_adder #(
    .Width(2*N)
  ) add_sum (
    .a      (sum_stage1_a),
    .b      (sum_stage1_b),
    .c_in   (1'b0),
    .sum    (prod_o),
    .c_out  (cout_final)
  );

endmodule
