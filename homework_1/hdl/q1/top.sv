//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for FIFO testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------



module top
  (
    input   logic [3:0] a,
    input   logic [3:0] b,
    output  logic [3:0] sum,
    output  logic       c_out
  );

    // DUT instance
    cr_adder #(
      .Width(4)
      ) dut (
      .a(a),
      .b(b),
      .sum(sum),
      .c_out(c_out)
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