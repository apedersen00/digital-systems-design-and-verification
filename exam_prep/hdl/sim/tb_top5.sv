//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

module tb_top5
  (
    input   logic clk,
    input   logic rst_n,
    input   logic a,
    input   logic b,
    output  logic z_a,
    output  logic z_b
  );

  // DUT instance
  top5_a top5_a_0 (
    .clk    ( clk   ),
    .rst_n  ( rst_n ),
    .a      ( a     ),
    .b      ( b     ),
    .z      ( z_a   )
  );

  top5_b top5_b_0 (
    .clk    ( clk   ),
    .rst_n  ( rst_n ),
    .a      ( a     ),
    .b      ( b     ),
    .z1     ( z_b   )
  );

  // Stimulus
  initial begin

    if ($test$plusargs("trace") != 0) begin
      $dumpfile("logs/tb_top5.vcd");
      $dumpvars();
    end

    $display("[%0t] Starting simulation...", $time);
  end

endmodule