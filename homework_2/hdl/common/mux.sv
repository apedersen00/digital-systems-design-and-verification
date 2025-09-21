//-------------------------------------------------------------------------------------------------
//
//  File: mux.sv
//  Description: Parameterized NX-to-X multiplexer module.
//
//  Author(s):
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  mux #(
//    .Bitwidth(),
//    .N()
//   ) mux_0 (
//    .d_i(),
//    .sel_i(),
//    .d_o()
//  );

module mux #(
    parameter   BitWidth  = 8,
    parameter   N         = 8,
    localparam  SelWidth  = $clog2(N)
  ) (
    input  logic [BitWidth-1:0] d_i [N-1:0],
    input  logic [SelWidth-1:0] sel_i,
    output logic [BitWidth-1:0] d_o
  );

  assign d_o = d_i[sel_i];

endmodule
