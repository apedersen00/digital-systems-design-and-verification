//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

module tb_iab
  (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         a_ready_i,
    input   logic         bus_grant_i,
    input   logic         accepted_i,
    input   logic [63:0]  data_a_i,
    output  logic [7:0]   data_b_o,
    output  logic         accepted_a_o,
    output  logic         bus_req_o,
    output  logic         ready_o
  );

  // DUT instance
  iab iab_0 (
    .clk_i        ( clk_i         ),
    .rstn_i       ( rstn_i        ),
    .a_ready_i    ( a_ready_i     ),
    .bus_grant_i  ( bus_grant_i   ),
    .accepted_i   ( accepted_i    ),
    .data_a_i     ( data_a_i      ),
    .data_b_o     ( data_b_o      ),
    .accepted_a_o ( accepted_a_o  ),
    .bus_req_o    ( bus_req_o     ),
    .ready_o      ( ready_o       )
  );

  // Stimulus
  initial begin

    if ($test$plusargs("trace") != 0) begin
      $dumpfile("logs/tb_iab.vcd");
      $dumpvars();
    end

    $display("[%0t] Starting simulation...", $time);
  end

endmodule