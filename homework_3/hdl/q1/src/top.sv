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
    input   logic         serial_parallel,
    input   logic         load_enable,
    input   logic         serial_in,
    input   logic [7:0]   parallel_in,
    output  logic [7:0]   parallel_out,
    output  logic         serial_out
  );

    // DUT instance
    shift_reg #(
      .N(8)
      ) dut (
      .clk_i(clk),
      .rstn_i(rstn),
      .serial_parallel_i(serial_parallel),
      .load_enable_i(load_enable),
      .serial_i(serial_in),
      .parallel_i(parallel_in),
      .parallel_o(parallel_out),
      .serial_o(serial_out)
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