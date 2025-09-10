//-------------------------------------------------------------------------------------------------
//
//  File: demux.sv
//  Description: Parameterized de-multiplexer
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  demux #(
//    .OutputWidth(16)
//    ) dut (
//    .d_i(),
//    .sel_i(),
//    .d_o()
//  );

module demux #(
    parameter OutputWidth = 16,
    parameter SelectWidth = $clog2(OutputWidth)
  ) (
    input   logic                   d_i,
    input   logic [SelectWidth-1:0] sel_i,
    output  logic [OutputWidth-1:0] d_o
  );

  always_comb begin
    d_o = '0;
    d_o[sel_i] = d_i;
  end

endmodule