//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for Urbana board.
//
//  Author:
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

import rv32i_pkg::*;

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

  logic [7:0] bcd_out;
  logic [2:0] signals;
  logic       reset;

  assign LED[2:0] = signals;
  assign reset    = !BTN[0];

  logic clk_1hz;
  clk_div #(
    .DIVISOR(CLOCK_FREQUENCY / 1000000)
  ) clock_divider_1 (
    .rst_n  (1'b1),
    .clk_i  (clk_i),
    .clk_o  (clk_1hz)
  );

  core core_0 (
    .clk_i      ( clk_1hz ),
    .rstn_i     ( rstn    ),
    .reg_o      ( out_reg ),
    .data_o     ( data    ),
    .addr_o     ( addr    ),
    .signals_o  ( signals )
  );

  kw4281_driver_16 driver_left (
    .clk_i(CLK_100MHZ),
    .rst_i(1'b1),
    .bin_i(data),
    .an_o(D0_AN),
    .seg_o(D0_SEG[6:0])
  );

  kw4281_driver_16 driver_right (
    .clk_i(CLK_100MHZ),
    .rst_i(1'b1),
    .bin_i(addr),
    .an_o(D1_AN),
    .seg_o(D1_SEG[6:0])
  );

endmodule