//-------------------------------------------------------------------------------------------------
//
//  File: mult.sv
//  Description: Multiplier
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  mult mult_0 (
//    .sel_i(),
//    .a_i(),
//    .b_i(),
//    .res_o()
//  );

module mult (
    input   logic         sel_i,
    input   logic [15:0]  a_i,
    input   logic [15:0]  b_i,
    output  logic [15:0]  res_o
  );
  /* verilator lint_off UNUSEDSIGNAL */
  logic [31:0] result;
  /* verilator lint_on UNUSEDSIGNAL */

  assign result = a_i * b_i;
  assign res_o  = sel_i ? result[31:16] : result[23:8];

endmodule