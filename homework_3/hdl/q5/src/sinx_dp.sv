//-------------------------------------------------------------------------------------------------
//
//  File: sinx_dp.sv
//  Description: Datapath for sinx accelerator.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  sinx_dp sinx_dp_0 (
//    .clk_i()
//    .x_i(),
//    .en_temp_reg_i(),
//    .en_term_reg_i(),
//    .en_sum_reg_i(),
//    .sub_i(),
//    .mux_a_i(),
//    .mux_b_i(),
//    .counter_i(),
//    .result_o()
//  );

module sinx_dp (
    input   logic         clk_i,
    input   logic [15:0]  x_i,
    input   logic         en_temp_reg_i,
    input   logic         en_term_reg_i,
    input   logic         en_sum_reg_i,
    input   logic         sum_zero_i,
    input   logic         sub_i,
    input   logic         mux_a_i,
    input   logic [1:0]   mux_b_i,
    input   logic [2:0]   counter_i,
    output  logic [15:0]  result_o
  );

  // signals in 17-bit Q2.15 format
  logic [16:0] temp_reg;
  logic [16:0] term_reg;
  logic [16:0] sum_reg;
  logic [16:0] mul_a;
  logic [16:0] mul_b;
  logic [16:0] prod;

  // product in 34-bit Q4.30 format
  logic [33:0] prod_ext;

  // lut values in 16-bit Q1.15 format
  logic [15:0] lut;

  // sign extended input and lut
  logic [16:0] x_ext;
  logic [16:0] lut_ext;

  assign x_ext    = {1'b0, x_i};  // Q1.15 -> Q2.15
  assign lut_ext  = {1'b0, lut};  // Q1.15 -> Q2.15

  sinx_lut sinx_lut_0 (
    .addr_i(counter_i),
    .data_o(lut)
  );

  always_ff @( posedge clk_i ) begin : write_temp_reg
    if (en_temp_reg_i) begin
      temp_reg <= prod;
    end
  end

  always_ff @( posedge clk_i ) begin : write_term_reg
    if (en_term_reg_i) begin
      term_reg <= prod;
    end
  end

  always_comb begin : multiplier
    prod = '0;

    case (mux_b_i)
      2'b00: mul_b = x_ext;
      2'b01: mul_b = lut_ext;
      2'b10: mul_b = term_reg;
      2'b11: mul_b = '0;
      default: mul_b = '0;
    endcase

    case (mux_a_i)
      1'b0: mul_a = x_ext;
      1'b1: mul_a = temp_reg;
      default: mul_a = '0;
    endcase

    prod_ext = mul_b * mul_a;
    prod = prod_ext[31:15]; // extract Q2.15
  end

  always_ff @( posedge clk_i ) begin : sum
    if (en_sum_reg_i) begin
      if (sum_zero_i) begin
        sum_reg <= prod;
      end
      else if (sub_i) begin
        sum_reg <= sum_reg - prod;
      end
      else begin
        sum_reg <= sum_reg + prod;
      end
    end
  end

  assign result_o = sum_reg[15] ? 16'hFFFF : sum_reg[15:0] << 1; // Q2.15 -> Q0.16

endmodule