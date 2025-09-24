//-------------------------------------------------------------------------------------------------
//
//  File: counter_16.sv
//  Description: 16-bit up counter made from 4-bit counters.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  counter_16 counter_16_0 (
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

  logic [4:0] en;
  assign en[0] = 1'b1;

  genvar i;

  generate
    for (i = 0; i < 4; i++) begin : counter_cascade
      counter_4 counter_i (
        .clk_i      ( clk_i                     ),
        .rstn_i     ( rstn_i                    ),
        .up_down_i  ( up_down_i                 ),
        .en_i       ( i == 0 ? 1'b1 : &en[i:1]  ),
        .load_en_i  ( load_en_i                 ),
        .load_i     ( load_i[(i+1)*4-1:i*4]     ),
        .count_o    ( count_o[(i+1)*4-1:i*4]    ),
        .carry_o    ( en[i+1]                   )
      );
    end
  endgenerate

  assign carry_o = en[4];

endmodule