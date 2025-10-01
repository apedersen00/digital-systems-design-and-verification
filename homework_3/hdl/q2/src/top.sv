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
    input   logic x,
    output  logic z_moore,
    output  logic z_mealy
  );

    // DUT instance
    msg_converter_moore msg_converter_moore_0 (
      .clk_i(clk),
      .rstn_i(rstn),
      .x_i(x),
      .z_o(z_moore)
    );

    msg_converter_mealy msg_converter_mealy_0 (
      .clk_i(clk),
      .rstn_i(rstn),
      .x_i(x),
      .z_o(z_mealy)
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