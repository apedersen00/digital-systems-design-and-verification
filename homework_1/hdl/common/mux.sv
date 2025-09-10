//-------------------------------------------------------------------------------------------------
//
//  File: mux.sv
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  mux #(
//    .InputWidth(4)
//   ) dut (
//    .d_i(),
//    .sel_i(),
//    .d_o()
//  );

module mux #(
    parameter InputWidth = 4,
    parameter SelectWidth = $clog2(InputWidth)
  ) (
    input  logic [InputWidth-1:0]  d_i,
    input  logic [SelectWidth-1:0] sel_i,
    output logic                   d_o
  );

  assign d_o = d_i[sel_i];

endmodule
