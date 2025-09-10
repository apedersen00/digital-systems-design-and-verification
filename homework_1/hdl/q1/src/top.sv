//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

module top
  (
    input   logic         in,
    input   logic [3:0]   sel,
    output  logic [15:0]  out
  );

    // DUT instance
    demux #(
      .OutputWidth(16)
      ) dut (
      .in(in),
      .sel(sel),
      .out(out)
    );

    // Stimulus
    initial begin

      if ($test$plusargs("trace") != 0) begin
        $dumpfile("logs/vlt_dump.vcd");
        $dumpvars();
      end

      $display("[%0t] Starting simulation...", $time);
    end

endmodule