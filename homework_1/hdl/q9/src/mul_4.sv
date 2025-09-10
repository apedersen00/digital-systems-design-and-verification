//-------------------------------------------------------------------------------------------------
//
//  File: mul_4.sv
//  Description: 4-bit multiplier implementation
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  mul_4 dut (
//    .a_i(),
//    .b_i(),
//    .prod_o()
//  );

module mul_4 (
    input   logic [3:0] a_i,
    input   logic [3:0] b_i,
    output  logic [7:0] prod_o
  );

  assign prod_o = a_i * b_i;

endmodule