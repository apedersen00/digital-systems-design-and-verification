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
    input   logic [7:0]   d_i,
    input   logic [1:0]   control_i,
    output  logic [7:0]   d_o
  );

    // DUT instance
    rightshifter #(
      .Width(8)
    ) dut (
      .d_i(d_i),
      .control_i(control_i),
      .d_o(d_o)
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