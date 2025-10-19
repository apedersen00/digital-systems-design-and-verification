//-------------------------------------------------------------------------------------------------
//
//  File: tb_moore_1011.sv
//  Description: Assertion based testbench for Moore sequence detector (1011).
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_moore_1011 ();

  logic clk;
  logic rst_n;
  logic j;
  logic w;

  moore_1011 dut (
    .clk    ( clk   ),
    .rst_n  ( rst_n ),
    .j      ( j     ),
    .w      ( w     )
  );

  initial clk = 0;
  always #5 clk = ~clk;

  // stimulus
  initial begin
    rst_n = 0;
    j     = 0;
    repeat (2) @(posedge clk);
    rst_n = 1;

    // sequence
    j <= 1; @(posedge clk);
    j <= 0; @(posedge clk);
    j <= 1; @(posedge clk);
    j <= 1; @(posedge clk);

    // random values after
    repeat (10) begin
      j <= $urandom_range(0, 1);
      @(posedge clk);
    end

    $display("[%0t] Testbench done.", $time);
    $finish;
  end

  // store last 4 input bits
  logic [3:0] last_4;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      last_4 <= 4'b0000;
    else
      last_4 <= {last_4[2:0], j};
  end

  // whenever w is high, the last four input bits are equal 1011
  property p_correct_seq;
    @(posedge clk) disable iff(!rst_n)
    w |-> (last_4 == 4'b1011);
  endproperty

  property p_w_one_cycle;
    @(posedge clk) disable iff(!rst_n) // <-- fixed typo ("disalbe" → "disable")
    w |=> !w;
  endproperty

  a_correct_seq: assert property (p_correct_seq)
    else $error("[%0t] Error: w is high but input sequence is not 1011", $time);

  a_w_one_cycle: assert property (p_w_one_cycle)
    else $error("[%0t] Error: w was high for more than one cycle", $time);

endmodule
