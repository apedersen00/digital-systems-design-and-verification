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
    alu #(
      .BW(8)
    ) alu_0 (
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

/* Top module for Urbana board
module top
  (
    input   logic [15:0] SW,
    output  logic [15:0] LED
  );

    logic [5:0] a;
    logic [5:0] b;
    logic [2:0] op;
    logic [5:0] out;
    logic [2:0] flags;
    
    assign a      = SW[5:0];
    assign b      = SW[11:6];
    assign op     = SW[14:12];
    assign out    = LED[5:0];
    assign flags  = LED[15:13];

    // ALU instance
    alu #(
      .BW(6)
    ) alu_0 (
      .in_a(a),
      .in_b(b),
      .opcode(op),
      .out(out),
      .flags(flags)
    );

endmodule
*/