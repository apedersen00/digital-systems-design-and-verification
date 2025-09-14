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
    input   logic [7:0] a,
    input   logic [7:0] b,
    input   logic [2:0] opcode,
    output  logic [7:0] out,
    output  logic [2:0] flags
  );

    // DUT instance
    alu alu_0 (
      .in_a(a),
      .in_b(b),
      .opcode(opcode),
      .out(out),
      .flags(flags)
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