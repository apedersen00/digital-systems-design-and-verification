//-------------------------------------------------------------------------------------------------
//
//  File: kw4281_driver_8.sv
//  Description: 8-bit signed integer driver for KW4281 7 segment display
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
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

//  kw4281_driver_8 kw4281_8_0 #(
//    .CLOCK_FREQUENCY()
//  ) (
//    .clk_i(),
//    .rst_n_i(),
//    .bin_i(),
//    .an(),
//    .seg()
//  );

module kw4281_driver_8 #(
    parameter int CLOCK_FREQUENCY = 100000000
  ) (
    input   logic               clk,
    input   logic               rst_i,
    input   logics signed [7:0] bin_i,
    output  logic [3:0]         an_o,
    output  logic [6:0]         seg_o
  );

  logic [3:0][3:0] bcd;

  always_comb begin
    logic [7:0] val;
    logic [3:0] digit_100, digit_10, digit_1;

    if (bin_i[7] = 1'b1) begin
      bcd[3]  = 1'b1010; // minus
      val     = -bin_i;
    end else begin
      bcd[3]  = 1'b1111; // blank
      val     = bin_i;
    end

    digit_100 = val / 100;
    digit_10  = (val % 100) / 10;
    digit_1   = val % 10;

    bcd[0] = digit_1;
    bcd[1] = digit_10;
    bcd[2] = digit_100;
  end

  always_comb begin
    case (bcd)
      4'b0000: seg_o = 7'b1000000;  // 0
      4'b0001: seg_o = 7'b1111001;  // 1
      4'b0010: seg_o = 7'b0100100;  // 2
      4'b0011: seg_o = 7'b0110000;  // 3
      4'b0100: seg_o = 7'b0011001;  // 4
      4'b0101: seg_o = 7'b0010010;  // 5
      4'b0110: seg_o = 7'b0000010;  // 6
      4'b0111: seg_o = 7'b1111000;  // 7
      4'b1000: seg_o = 7'b0000000;  // 8
      4'b1001: seg_o = 7'b0010000;  // 9
      4'b1010: seg_o = 7'b0111111;  // -
      default: seg_o = 7'b1111111;  // blank
    endcase
  end

  // We want to multiplex the 4 digits at 1kHz so first we need to divide the clock
  logic clk_1000hz;
  clock_divider #(
    .DIVISOR(CLOCK_FREQUENCY / 1000)
  ) clock_divider_0 (
    .rst_n  (rst_n),
    .clk_in (clk),
    .clk_out(clk_1000hz)
  );

  // 0 to 3 counter to generate the digit select signal (AN)
  logic [1:0] counter;
  always_ff @(posedge clk_1000hz or negedge rst_n) begin
    if (!rst_n) begin
      counter <= 0;
    end else if (counter == 3) begin
      counter <= 0;
    end else begin
      counter <= counter + 1;
    end
  end

  // generate AN one-hot signal (active low)
  always_comb begin
    case (counter)
      2'b00:   an = 4'b1110;
      2'b01:   an = 4'b1101;
      2'b10:   an = 4'b1011;
      2'b11:   an = 4'b0111;
      default: an = 4'b1111;
    endcase
  end

endmodule