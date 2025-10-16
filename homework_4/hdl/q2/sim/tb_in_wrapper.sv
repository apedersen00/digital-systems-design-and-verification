//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

module tb_in_wrapper
  (
    input   logic         clk,
    input   logic         rstn,
    input   logic         data_ready,
    input   logic         imc_ready,
    input   logic [15:0]  data,
    output  logic         data_accept,
    output  logic         imc_start,
    output  logic [15:0]  a,
    output  logic [15:0]  b,
    output  logic [15:0]  c,
    output  logic [15:0]  d
  );

  // DUT instance
  in_wrapper in_wrapper_0 (
    .clk_i          ( clk         ),
    .rstn_i         ( rstn        ),
    .data_ready_i   ( data_ready  ),
    .imc_ready_i    ( imc_ready   ),
    .data_accept_o  ( data_accept ),
    .imc_start_o    ( imc_start   ),
    .data_i         ( data        ),
    .a_o            ( a           ),
    .b_o            ( b           ),
    .c_o            ( c           ),
    .d_o            ( d           )
  );

  // Stimulus
  initial begin

    if ($test$plusargs("trace") != 0) begin
      $dumpfile("logs/tb_in_wrapper.vcd");
      $dumpvars();
    end

    $display("[%0t] Starting simulation...", $time);
  end

endmodule