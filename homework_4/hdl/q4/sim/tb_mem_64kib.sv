//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

module tb_mem_64kib
  (
    input   logic         clk,
    input   logic         read_en,
    input   logic [3:0]   write_en,
    input   logic [31:0]  addr,
    input   logic [31:0]  d_i,
    output  logic [31:0]  d_o,
    output  logic         ready
  );

  // DUT instance
  mem_64kib mem_64kib_0 (
    .clk_i      ( clk         ),
    .read_en_i  ( read_en     ),
    .write_en_i ( write_en    ),
    .addr_i     ( addr        ),
    .d_i        ( d_i         ),
    .d_o        ( d_o         ),
    .ready_o    ( ready       )
  );

  // Stimulus
  initial begin

    if ($test$plusargs("trace") != 0) begin
      $dumpfile("logs/tb_mem_64kib.vcd");
      $dumpvars();
    end

    $display("[%0t] Starting simulation...", $time);
  end

endmodule