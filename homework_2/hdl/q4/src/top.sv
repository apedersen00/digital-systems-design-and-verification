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
    input   logic         up_down,
    input   logic         load_en,
    input   logic [15:0]  load,
    output  logic [15:0]  count,
    output  logic         carry
  );

    // DUT instance
    counter_16 counter_16_0 (
      .clk_i(clk),
      .rstn_i(rstn),
      .up_down_i(up_down),
      .load_en_i(load_en),
      .load_i(load),
      .count_o(count),
      .carry_o(carry)
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