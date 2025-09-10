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
      .d_i(in),
      .sel_i(sel),
      .d_o(out)
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