//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

module tb_out_wrapper
  (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         imc_ready_i,
    input   logic         start_transmit_i,
    input   logic         grant_i,
    input   logic         accepted_i,
    input   logic [15:0]  a_i,
    input   logic [15:0]  b_i,
    input   logic [15:0]  c_i,
    input   logic [15:0]  d_i,
    output  logic [15:0]  data_o,
    output  logic         avail_o,
    output  logic         request_o,
    output  logic         ready_o
  );

  // DUT instance
  out_wrapper out_wrapper_0 (
    .clk_i            ( clk_i           ),
    .rstn_i           ( rstn_i          ),
    .imc_ready_i      ( imc_ready_i     ),
    .start_transmit_i ( start_transmit_i),
    .grant_i          ( grant_i         ),
    .accepted_i       ( accepted_i      ),
    .a_i              ( a_i             ),
    .b_i              ( b_i             ),
    .c_i              ( c_i             ),
    .d_i              ( d_i             ),
    .data_o           ( data_o          ),
    .avail_o          ( avail_o         ),
    .request_o        ( request_o       ),
    .ready_o          ( ready_o         )
  );

  // Stimulus
  initial begin

    if ($test$plusargs("trace") != 0) begin
      $dumpfile("logs/tb_out_wrapper.vcd");
      $dumpvars();
    end

    $display("[%0t] Starting simulation...", $time);
  end

endmodule