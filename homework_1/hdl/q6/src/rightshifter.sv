//-------------------------------------------------------------------------------------------------
//
//  File: rightshifter.sv
//  Description: Parametric implementation of a right-only barrel shifter
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  rightshifter #(
//    .Width(8)
//  ) dut (
//    .d_i(),
//    .control_i(),
//    .d_o()
//  );

module rightshifter #(
    parameter Width = 8
  ) (
    input   logic [Width-1:0] d_i,
    input   logic [1:0]       control_i,  // shift amount 0-3
    output  logic [Width-1:0] d_o
  );

  logic [Width+2:0] in_vec;
  assign in_vec = {3'b000, d_i};

  genvar i;
  generate
    for (i = 0; i < Width; i++) begin : mux_chain
      mux #(
        .InputWidth(4)
      ) mux_x (
        .d_i(in_vec[i+3:i]),
        .sel_i(control_i),
        .d_o(d_o[i])
      );
    end
  endgenerate

endmodule