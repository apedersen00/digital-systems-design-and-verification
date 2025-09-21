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
    input   logic         clk,
    input   logic         rstn,
    input   logic         sel,
    input   logic [5:0]   parallel_in,
    output  logic [5:0]   parallel_out
  );

    // DUT instance
    lfsr lfsr_0 (
      .clk_i(clk),
      .rstn_i(rstn),
      .sel_i(sel),
      .parallel_i(parallel_in),
      .parallel_o(parallel_out)
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