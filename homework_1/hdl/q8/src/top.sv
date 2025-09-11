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
    input   logic [7:0]   a,
    input   logic [7:0]   b,
    input   logic [7:0]   c,
    input   logic [7:0]   d,
    input   logic [7:0]   e,
    input   logic [7:0]   f,
    output  logic [16:0]  res
  );

    // DUT instance
    mul_accum #(
      .Width(8)
    ) dut (
      .a_i(a),
      .b_i(b),
      .c_i(c),
      .d_i(d),
      .e_i(e),
      .f_i(f),
      .res_o(res)
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