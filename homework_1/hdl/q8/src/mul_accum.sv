//-------------------------------------------------------------------------------------------------
//
//  File: mul_accum.sv
//  Description: Parametric multiply/accumulate module
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  mul_accum #(
//    .Width(8)
//  ) dut (
//    .a_i(),
//    .b_i(),
//    .c_i(),
//    .d_i(),
//    .e_i(),
//    .f_i(),
//    .res_o()
//  );

module mul_accum #(
    parameter Width = 8
  ) (
    input   logic [Width-1:0]   a_i,      // input vector
    input   logic [Width-1:0]   b_i,      // input vector
    input   logic [Width-1:0]   c_i,      // input vector
    input   logic [Width-1:0]   d_i,      // input vector
    input   logic [Width-1:0]   e_i,      // input vector
    input   logic [Width-1:0]   f_i,      // input vector
    output  logic [2*Width:0]   res_o     // result vector
  );

  logic [Width-1:0] input_mat [5:0];
  assign input_mat[0] = a_i;
  assign input_mat[1] = b_i;
  assign input_mat[2] = c_i;
  assign input_mat[3] = d_i;
  assign input_mat[4] = e_i;
  assign input_mat[5] = f_i;

  logic [2*Width-1:0] intermediate_prods [2:0];
  logic [2*Width:0]   sums [1:0];

  genvar i;
  generate
    for (i = 0; i < 3; i++) begin
      multiplier #(
        .Width(Width)
      ) mul (
        .a_i(input_mat[2*i]),
        .b_i(input_mat[2*i+1]),
        .prod_o(intermediate_prods[i])
      );
    end
  endgenerate

  cl_adder #(
    .Width(2*Width+1)
  ) cl_adder_0 (
    .a_i({ {1{intermediate_prods[0][-1]}}, intermediate_prods[0]}),
    .b_i({ {1{intermediate_prods[1][-1]}}, intermediate_prods[1]}),
    .sum_o(sums[0]),
    .c_o()
  );

  cl_adder #(
    .Width(2*Width+1)
  ) cl_adder_1 (
    .a_i(sums[0]),
    .b_i({ {1{intermediate_prods[2][-1]}}, intermediate_prods[2]}),
    .sum_o(sums[1]),
    .c_o()
  );

  assign res_o = sums[1];

endmodule