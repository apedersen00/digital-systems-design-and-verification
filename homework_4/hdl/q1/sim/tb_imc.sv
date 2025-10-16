//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

module tb_imc
  (
    input   logic         clk,
    input   logic         rstn,
    input   logic         start,
    input   logic [15:0]  a_in,
    input   logic [15:0]  b_in,
    input   logic [15:0]  c_in,
    input   logic [15:0]  d_in,
    output  logic [15:0]  a_out,
    output  logic [15:0]  b_out,
    output  logic [15:0]  c_out,
    output  logic [15:0]  d_out,
    output  logic         a_sign,
    output  logic         b_sign,
    output  logic         c_sign,
    output  logic         d_sign,
    output  logic         ready
  );

    // DUT instance
    imc imc_0 (
      // data inputs
      .clk_i    ( clk     ),
      .rstn_i   ( rstn    ),
      .start_i  ( start   ),
      .a_i      ( a_in    ),
      .b_i      ( b_in    ),
      .c_i      ( c_in    ),
      .d_i      ( d_in    ),
      // data outputs
      .a_o      ( a_out   ),
      .b_o      ( b_out   ),
      .c_o      ( c_out   ),
      .d_o      ( d_out   ),
      .a_sign_o ( a_sign  ),
      .b_sign_o ( b_sign  ),
      .c_sign_o ( c_sign  ),
      .d_sign_o ( d_sign  ),
      // outputs
      .ready_o  ( ready   )
    );

    // Stimulus
    initial begin

      if ($test$plusargs("trace") != 0) begin
        $dumpfile("logs/tb_imc.vcd");
        $dumpvars();
      end

      $display("[%0t] Starting simulation...", $time);
    end

endmodule