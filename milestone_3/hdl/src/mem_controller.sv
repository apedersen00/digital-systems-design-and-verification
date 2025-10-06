//-------------------------------------------------------------------------------------------------
//
//  File: mem_controller.sv
//  Description: Parameterized NX-to-X multiplexer module.
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

//  mem_controller #(
//    .Bitwidth(),
//    .N()
//   ) mem_controller_0 (
//    .d_i(),
//    .sel_i(),
//    .d_o()
//  );

module mem_controller (
    input   logic       clk_i,
    input   logic [1:0] write_en_i,
    output  logic       mem_ready;
  );

  assign d_o = d_i[sel_i];

endmodule
