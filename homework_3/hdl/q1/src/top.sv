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
    input   logic clk,
    input   logic rstn,
    input   logic seq,
    output  logic det
  );

    // DUT instance
    seq_detector_struct seq_detector_struct_0 (
      .clk_i(clk),
      .rstn_i(rstn),
      .seq_i(seq),
      .det_o(det)
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