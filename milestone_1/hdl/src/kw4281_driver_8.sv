//-------------------------------------------------------------------------------------------------
//
//  File: kw4281_driver_8.sv
//  Description: 8-bit signed integer driver for KW4281 4-digit 7-segment display
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
    input   logic               clk_i,
    input   logic               rst_i,
    input   logic signed [7:0]  bin_i,
    output  logic [3:0]         an_o,
    output  logic [6:0]         seg_o
  );

  // 4-digits of binary coded decimal
  logic [3:0][3:0] bcd;

  // generate digits
  always_comb begin
    logic [7:0] val;
    logic [3:0] digit_100, digit_10, digit_1;

    if (bin_i[7] == 1'b1) begin
      bcd[3]  = 4'b1010; // minus
      val     = -bin_i;
    end else begin
      bcd[3]  = 4'b1111; // blank
      val     = bin_i;
    end

    digit_100 = val / 100;
    digit_10  = (val % 100) / 10;
    digit_1   = val % 10;

    bcd[0] = digit_1;
    bcd[1] = digit_10;
    bcd[2] = digit_100;

    // blank leading zeros
    if (bcd[2] == 0) begin
      bcd[2] = 4'b1111;
      if (bcd[1] == 0) begin
        bcd[1] = 4'b1111;
      end
    end

  end

  // We want to multiplex the 4 digits at 1kHz so first we need to divide the clock
  logic clk_1000hz;
  clock_divider #(
    .DIVISOR(CLOCK_FREQUENCY / 1000)
  ) clock_divider_0 (
    .rst_n  (rst_i),
    .clk_i  (clk_i),
    .clk_o  (clk_1000hz)
  );

  // 0 to 3 counter to generate the digit select signal (AN)
  logic [1:0] counter;
  always_ff @(posedge clk_1000hz or negedge rst_i) begin
    if (!rst_i) begin
      counter <= 0;
    end
    else begin
      counter <= counter + 1;
    end
  end

  logic pwm;
  pwm #(
    .WIDTH(13)
  ) pwm_0 (
    .rst_n(1'b1),
    .clk_i(clk_i),
    .duty_i({8'd127, 5'd0}),
    .pwm_o(pwm)
  );

  // generate AN one-hot signal (active low)
  always_comb begin
    case (counter)
      2'b00:   an_o = 4'b0111 | {4{~pwm}};
      2'b01:   an_o = 4'b1011 | {4{~pwm}};
      2'b10:   an_o = 4'b1101 | {4{~pwm}};
      2'b11:   an_o = 4'b1110 | {4{~pwm}};
      default: an_o = 4'b1111;
    endcase
  end

  always_comb begin
    case (bcd[counter])
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

endmodule
