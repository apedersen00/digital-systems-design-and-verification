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
//    .addr_i(),
//    .data_o()
//  );

module sinx_dp (
    input   logic         clk_i
    input   logic [15:0]  x_i,
    input   logic         en_temp_reg_i,
    input   logic         en_term_reg_i,
    input   logic         rst_i,
    input   logic         add_sub_i,
    input   logic         mux_a_i,
    input   logic [1:0]   mux_b_i,
    output  logic [15:0]  result_o
  );

  logic [15:0] temp_reg;
  logic [15:0] term_reg;
  logic [15:0] sum_reg;
  logic [15:0] lut;
  logic [15:0] mul_a;
  logic [15:0] mul_b;
  logic [31:0] prod;
  logic [2:0] counter;

  always_ff @( posedge clk_i ) begin : counter_ff
    if (rst) begin
      counter <= 3'b111;
    end
    else begin
      counter <= counter - 1;
    end
  end

  sinx_lut sinx_lut_0 (
    .addr_i(counter),
    .data_o(lut)
  );

  always_ff @( posedge clk_i ) begin : write_temp_reg
    if (en_temp_reg_i) begin
      temp_reg <= prod;
    end
  end

  always_ff @( posedge clk_i ) begin : write_term_reg
    if (rst) begin
      term_reg <= 16'd1;
    end
    else if (en_term_reg_i) begin
      term_reg <= prod;
    end
  end

  always_comb begin : multiplier
    prod = '0;
    case (mux_b_i)
      2'b00: mul_b = x_i;
      2'b01: mul_b = lut;
      2'b10: mul_b = term_reg;
      2'b11: mul_b = '0;
      default: mul_b = '0;
    endcase

    mul_a = mux_a_i ? temp_reg : x_i;

    prod = mul_b * mul_a;
  end

  always_ff @( posedge clk_i ) begin : sum
    if (rst) begin
      sum_reg <= '0;
    end
    else begin
      sum <= (counter % 2) ? (sum + prod) : (sum - prod);
    end
  end

  assign result_o = sum;

endmodule