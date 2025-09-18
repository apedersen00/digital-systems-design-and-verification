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

/* Top module for urbana board
module top
  (
    input   logic         CLK_100MHZ,
    input   logic [15:0]  SW,
    input   logic [3:0]   BTN,
    output  logic [15:0]  LED,
    output  logic [7:0]   D0_SEG,     // left 4-digit display
    output  logic [3:0]   D0_AN,
    output  logic [7:0]   D1_SEG,     // right 4-digit display
    output  logic [3:0]   D1_AN
  );

    logic [7:0] a;
    logic [7:0] b;
    logic [2:0] op;
    logic [7:0] out;
    logic [2:0] flags;
    logic [7:0] bcd_out;
    
    assign op       = SW[11:9];
    assign LED[2:0] = flags;
    assign LED[8]   = 1'b1;

    always_ff @( posedge CLK_100MHZ ) begin : latch_input
      if (BTN[0] == 1'b1) begin
        if (SW[8] == 1'b0) begin
          a <= SW[7:0];
        end else begin
          b <= SW[7:0];
        end
      end
    end

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

    kw4281_driver_8 driver_left (
      .clk_i(CLK_100MHZ),
      .rst_i(1'b1),
      .bin_i(out),
      .an_o(D0_AN),
      .seg_o(D0_SEG[6:0])
    );

    kw4281_driver_8 driver_right (
      .clk_i(CLK_100MHZ),
      .rst_i(1'b1),
      .bin_i( SW[8] ? b : a ),
      .an_o(D1_AN),
      .seg_o(D1_SEG[6:0])
    );

endmodule
*/