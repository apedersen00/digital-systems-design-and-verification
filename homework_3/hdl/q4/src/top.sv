//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

module top #(
    localparam m = 8,
    localparam n = 4
  ) (
    input   logic         clk,
    input   logic         rstn,
    input   logic         start,
    input   logic [m-1:0] data,
    output  logic         done,
    output  logic [m-1:0] result
  );

    // DUT instance
    avg_calc #(
      .m(m),
      .n(n)
    ) avg_calc_0 (
      .clk_i(clk),
      .rstn_i(rstn),
      .start_i(start),
      .data_i(data),
      .done_o(done),
      .result_o(result)
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