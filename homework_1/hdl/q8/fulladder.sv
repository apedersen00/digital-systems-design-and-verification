//-------------------------------------------------------------------------------------------------
//
//  File: fulladder.sv
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  fulladder dut (
//    .a(),
//    .b(),
//    .c_in(),
//    .sum(),
//    .c_out()
//  );

module fulladder (
    input   logic a,
    input   logic b,
    input   logic c_in,
    output  logic sum,
    output  logic c_out
  );

  assign sum    = a ^ b ^ c_in;
  assign c_out  = (a & b) | (a & c_in) | (b & c_in);

endmodule