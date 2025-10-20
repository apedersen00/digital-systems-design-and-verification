//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

module tb_dflop
  (
    input   logic clk,
    input   logic rst_n,
    input   logic [3:0] D,
    output  logic [3:0] q
  );

  // DUT instance
  logic [3:0] s;
  genvar i;
  always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
      s <= 0;
    end else begin
      s <= D;
    end
  end

  generate
    for (i = 0; i < 4 ; i = i + 1 ) begin
      dflop u_flop(s[i], clk, rst_n, q[i]);
    end
  endgenerate

  // Stimulus
  initial begin

    if ($test$plusargs("trace") != 0) begin
      $dumpfile("logs/tb_dflop.vcd");
      $dumpvars();
    end

    $display("[%0t] Starting simulation...", $time);
  end

endmodule