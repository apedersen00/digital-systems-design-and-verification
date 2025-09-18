//-------------------------------------------------------------------------------------------------
//
//  File: pwm.sv
//  Description: PWM generator
//
//  PWM Frequency = CLK / 2^WIDTH
//
//  Assuming clk_i = 100 Mhz
//  +---------+--------------+
//  |bit width| PWM frequency|
//  +---------+--------------+
//  |    7    |     781,250  |
//  |    8    |     390,625  |
//  |    9    |     195,313  |
//  |   10    |      97,656  |
//  |   11    |      48,828  |
//  |   12    |      24,414  |
//  |   13    |      12,207  |
//  |   14    |       6,104  |
//  |   15    |       3,052  |
//  |   16    |       1,526  |
//  |   17    |         763  |
//  |   18    |         381  |
//  |   19    |         191  |
//  |   20    |          95  |
//  |   21    |          48  |
//  |   22    |          24  |
//  |   23    |          12  |
//  |   24    |           6  |
//  +---------+--------------+
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//  Reference(s):
//      - https://forum.digikey.com/t/implementing-a-pulse-width-modulator-pwm-in-verilog/35889
//
//-------------------------------------------------------------------------------------------------

//  pwm pwm_0 #(
//    .WIDTH()
//  ) (
//    .rst_n(),
//    .clk_i(),
//    .duty_i(),
//    .pwm_o()
//  );

module pwm #(
    parameter WIDTH = 8
  ) (
    input   logic rst_n,
    input   logic clk_i,
    input   logic [WIDTH-1:0] duty_i,
    output  logic pwm_o
  );

  logic [WIDTH-1:0] counter;
  logic [WIDTH-1:0] counter_next;
  logic pwm_next;

  always_comb begin
    counter_next = counter + 1;

    if (counter < duty_i) begin
      pwm_next = 1;
    end
    else begin
      pwm_next = 0;
    end

  end

  always_ff @(posedge clk_div or negedge rst_n) begin
    if (!rst_n) begin
      counter <= 0;
      pwm_o   <= 0;
    end
    else begin
      counter <= counter_next;
      pwm_o   <= pwm_next;
    end
  end

endmodule