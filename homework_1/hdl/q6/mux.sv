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
//    .in(),
//    .select(),
//    .out()
//  );

module mux #(
    parameter InputWidth = 4,
    parameter SelectWidth = $clog2(InputWidth)
  ) (
    input logic   [InputWidth-1:0]  in,
    input logic   [SelectWidth-1:0] select,
    output logic                    out
  );

  assign out = in[select];

endmodule