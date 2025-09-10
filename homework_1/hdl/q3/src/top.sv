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
    input   logic [7:0]   A,
    input   logic [7:0]   B,
    output  logic [7:0]   sum,
    output  logic         carry
  );

    // DUT instance
    csa_8 dut (
      .A(A),
      .B(B),
      .sum(sum),
      .carry(carry)
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