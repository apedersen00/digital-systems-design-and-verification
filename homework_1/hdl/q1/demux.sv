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
//    .in(in),
//    .sel(sel),
//    .out(out)
//  );

module demux #(
    parameter OutputWidth = 16,
    parameter SelectWidth = $clog2(OutputWidth)
  ) (
    input   logic                   in,
    input   logic [SelectWidth-1:0] sel,
    output  logic [OutputWidth-1:0] out
  );

  always_comb begin
    out = '0;
    out[sel] = in;
  end

endmodule