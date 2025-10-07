//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

module top (
    input   logic         clk,
    input   logic         rstn,
    input   logic         start,
    input   logic [15:0]  x,
    output  logic         done,
    output  logic [15:0]  result
  );

    // DUT instance
    sinx sinx_0 (
      .clk_i(clk),
      .rstn_i(rstn),
      .start_i(start),
      .x_i(x),
      .result_o(result),
      .done_o(done)
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