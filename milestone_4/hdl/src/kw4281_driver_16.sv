//-------------------------------------------------------------------------------------------------
//
//  File: kw4281_driver_16.sv
//  Description:
//
//    ---a---
//  |         |
//  f         b
//  |         |
//    ---g---
//  |         |
//  e         c
//  |         |
//    ---d---
//
//  seg[6:0] = {g, f, e, d, c, b, a}
//
//  Displays 4 hexadecimal digits (0–F) on 7-segment display
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

module kw4281_driver_8 #(
    parameter int CLOCK_FREQUENCY = 100_000_000
  ) (
    input   logic                 clk_i,
    input   logic                 rst_i,
    input   logic signed [15:0]   bin_i,
    output  logic [3:0]           an_o,
    output  logic [6:0]           seg_o
  );

  // Split into 4 hex digits
  logic [3:0][3:0] hex;
  assign hex[0] = bin_i[3:0];
  assign hex[1] = bin_i[7:4];
  assign hex[2] = bin_i[11:8];
  assign hex[3] = bin_i[15:12];

  // Generate 1kHz multiplex clock
  logic clk_1000hz;
  clock_divider #(
    .DIVISOR(CLOCK_FREQUENCY / 1000)
  ) clock_divider_0 (
    .rst_n  (rst_i),
    .clk_i  (clk_i),
    .clk_o  (clk_1000hz)
  );

  // 0–3 counter for digit selection
  logic [1:0] counter;
  always_ff @(posedge clk_1000hz or negedge rst_i) begin
    if (!rst_i)
      counter <= 0;
    else
      counter <= counter + 1;
  end

  // Generate active-low anode signals
  always_comb begin
    case (counter)
      2'b00:   an_o = 4'b0111;
      2'b01:   an_o = 4'b1011;
      2'b10:   an_o = 4'b1101;
      2'b11:   an_o = 4'b1110;
      default: an_o = 4'b1111;
    endcase
  end

  // Hexadecimal to 7-segment decoder
  always_comb begin
    case (hex[counter])
      4'h0: seg_o = 7'b1000000; // 0
      4'h1: seg_o = 7'b1111001; // 1
      4'h2: seg_o = 7'b0100100; // 2
      4'h3: seg_o = 7'b0110000; // 3
      4'h4: seg_o = 7'b0011001; // 4
      4'h5: seg_o = 7'b0010010; // 5
      4'h6: seg_o = 7'b0000010; // 6
      4'h7: seg_o = 7'b1111000; // 7
      4'h8: seg_o = 7'b0000000; // 8
      4'h9: seg_o = 7'b0010000; // 9
      4'hA: seg_o = 7'b0001000; // A
      4'hB: seg_o = 7'b0000011; // b
      4'hC: seg_o = 7'b1000110; // C
      4'hD: seg_o = 7'b0100001; // d
      4'hE: seg_o = 7'b0000110; // E
      4'hF: seg_o = 7'b0001110; // F
      default: seg_o = 7'b1111111; // blank
    endcase
  end

endmodule
