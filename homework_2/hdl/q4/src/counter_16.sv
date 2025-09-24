//-------------------------------------------------------------------------------------------------
//
//  File: counter_16.sv
//  Description: 16-bit up counter made from 4-bit counters.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  counter_16 #(
//    .N()
//  ) counter_16_0 (
//    .clk_i(),
//    .rstn_i(),
//    .up_down_i(),
//    .load_en_i(),
//    .load_i(),
//    .count_o(),
//    .carry_o()
//  );

module counter_16 (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         up_down_i,
    input   logic         load_en_i,
    input   logic [15:0]  load_i,
    output  logic [15:0]  count_o,
    output  logic         carry_o
  );



endmodule