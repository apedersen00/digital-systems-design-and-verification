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

module top
  (
    input   logic [15:0]   a,
    input   logic [15:0]   b,
    output  logic [31:0]  prod
  );

    // DUT instance
    mul_16 dut (
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