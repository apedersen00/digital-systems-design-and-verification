//-------------------------------------------------------------------------------------------------
//
//  File: freq_div.sv
//  Description: Frequency divider alternating between division ratios of 18 and 866.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  freq_div freq_div_0 (
//    .clk_i,
//    .rstn_i,
//    .div_o
//  );

module freq_div #(
    parameter ratio_0 = 18,
    parameter ratio_1 = 866
  ) (
    input   logic clk_i,
    input   logic rstn_i,
    output  logic div_o
  );

  logic [15:0] count;
  logic [15:0] target_count;
  logic state;  // 0 = use ratio_0, 1 = use ratio_1
  logic load_en;
  logic counter_reset;

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      state <= 1'b0;
      div_o <= 1'b0;
    end else begin
      if (count == target_count - 1) begin
        div_o <= ~div_o;
        state <= ~state;
      end
    end
  end

  always_comb begin
    if (state == 1'b0) begin
      target_count = ratio_0;
    end else begin
      target_count = ratio_1;
    end
  end

  assign counter_reset = (count == target_count - 1);
  assign load_en = counter_reset;

  counter_16 counter_16_0 (
    .clk_i      ( clk_i         ),
    .rstn_i     ( rstn_i        ),
    .load_en_i  ( load_en       ),
    .load_i     ( 16'd0         ),
    .count_o    ( count         ),
    .carry_o    (               )
  );

endmodule