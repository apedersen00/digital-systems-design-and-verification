//-------------------------------------------------------------------------------------------------
//
//  File: cs_adder_8.sv
//  Description: 8-bit Carry Select Adder (CSA)
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  csa_8 dut (
//    .a_i(),
//    .b_i(),
//    .sum_o(),
//    .carry_o(),
//  );

module cs_adder_8 (
    input   logic [7:0] a_i,
    input   logic [7:0] b_i,
    output  logic [7:0] sum_o,
    output  logic       carry_o
  );

  logic [3:0] sum_low;
  logic       c_low;

  logic [3:0] sum_high_0;
  logic [3:0] sum_high_1;
  logic       c_high_0;
  logic       c_high_1;

  cr_adder #(
    .Width(4)
  ) adder_high_0 (
    .a_i    (a_i[7:4]),
    .b_i    (b_i[7:4]),
    .c_i    (1'b0),
    .sum_o  (sum_high_0),
    .c_o    (c_high_0)
  );

  cr_adder #(
    .Width(4)
  ) adder_high_1 (
    .a_i    (a_i[7:4]),
    .b_i    (b_i[7:4]),
    .c_i    (1'b1),
    .sum_o  (sum_high_1),
    .c_o    (c_high_1)
  );

  cr_adder #(
    .Width(4)
  ) adder_2 (
    .a_i    (a_i[3:0]),
    .b_i    (b_i[3:0]),
    .c_i    (1'b0),
    .sum_o  (sum_low),
    .c_o    (c_low)
  );

  assign sum_o[3:0] = sum_low;
  assign {carry_o, sum_o[7:4]} = (c_low == 1'b0)  ? {c_high_0, sum_high_0}
                                                  : {c_high_1, sum_high_1};

endmodule