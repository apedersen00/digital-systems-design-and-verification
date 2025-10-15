//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

import rv32i_pkg::*;

module top
  (
    input   logic         clk,
    input   logic         rstn,
    output  logic [31:0]  out_reg,
    output  logic [15:0]  data,
    output  logic [15:0]  addr,
    output  logic [2:0]   signals
  );

    // DUT instance
    core core_0 (
      .clk_i(clk),
      .rstn_i(rstn),
      .reg_o(out_reg),
      .data_o(data),
      .addr_o(addr),
      .signals_o(signals)
    );

    // Stimulus
    initial begin
      if ($test$plusargs("trace") != 0) begin
        $dumpfile("logs/tb_core.vcd");
        $dumpvars();
      end

      $display("[%0t] Starting simulation...", $time);
    end

endmodule