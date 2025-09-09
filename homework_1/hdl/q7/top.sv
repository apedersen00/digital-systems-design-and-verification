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
    output  logic [15:0]  prod
  );

    // DUT instance
    multiplier #(
      .Width(8)
    ) dut (
      .a_i(a),
      .b_i(b),
      .prod_o(prod)
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