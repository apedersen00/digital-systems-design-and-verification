//-------------------------------------------------------------------------------------------------
//
//  File: csa_8.sv
//  Description: 8-bit Carry Select Adder (CSA)
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  csa_8 dut (
//    .A(),
//    .B(),
//    .sum(),
//    .carry(),
//  );

module csa_8 (
    input   logic [7:0] A,
    input   logic [7:0] B,
    output  logic [7:0] sum,
    output  logic carry
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
    .a(A[7:4]),
    .b(B[7:4]),
    .c_in(1'b0),
    .sum(sum_high_0),
    .c_out(c_high_0)
  );

  cr_adder #(
    .Width(4)
  ) adder_high_1 (
    .a(A[7:4]),
    .b(B[7:4]),
    .c_in(1'b1),
    .sum(sum_high_1),
    .c_out(c_high_1)
  );

  cr_adder #(
    .Width(4)
  ) adder_2 (
    .a(A[3:0]),
    .b(B[3:0]),
    .c_in(1'b0),
    .sum(sum_low),
    .c_out(c_low)
  );

  assign sum[3:0] = sum_low;
  assign {carry, sum[7:4]} = (c_low == 1'b0)  ? {c_high_0, sum_high_0}
                                              : {c_high_1, sum_high_1};

endmodule