//-------------------------------------------------------------------------------------------------
//
//  File: imc.sv
//  Description: Inverse Matric Calculator.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  imc imc_0 (
//    .sel_i(),
//    .a_i(),
//    .b_i(),
//    .res_o()
//  );

module imc (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         start_i,
    input   logic [15:0]  a_i,
    input   logic [15:0]  b_i,
    input   logic [15:0]  c_i,
    input   logic [15:0]  d_i,
    output  logic         ready,
    output  logic [15:0]  a_o,
    output  logic [15:0]  b_o,
    output  logic [15:0]  c_o,
    output  logic [15:0]  d_o,
    output  logic         a_sign_o,
    output  logic         b_sign_o,
    output  logic         c_sign_o,
    output  logic         d_sign_o,
  );

  // control signals
  logic en_a;
  logic en_b;
  logic en_c;
  logic en_d;
  logic en_det;
  logic en_term;
  logic neg_b;
  logic neg_c;

  // registers
  logic [15:0] a;
  logic [15:0] b;
  logic [15:0] c;
  logic [15:0] d;
  logic [15:0] det;
  logic [15:0] term;
  logic [3:0]  signs; // {a, b, c, d}

  // signals
  logic [15:0]  mul_0;
  logic [15:0]  mul_1;
  logic [15:0]  sum;
  logic [8:0]   recip;
  logic [15:0]  b_val;
  logic [15:0]  c_val;

  // output assignments
  assign a_o = a;
  assign b_o = b;
  assign c_o = c;
  assign d_o = d;
  assign a_sign_o = signs[3];
  assign b_sign_o = signs[2];
  assign c_sign_o = signs[1];
  assign d_sign_o = signs[0];

  always_ff @( posedge clk_i ) begin : update_registers

    if (en_a) begin
      a <= sel_a ? mul_0 : a_i;
    end
    if (en_b) begin
      b <= sel_b ? mul_1 : b_i;
    end
    if (en_c) begin
      c <= sel_a ? mul_0 : a_i;
    end
    if (en_d) begin
      d <= sel_a ? mul_1 : a_i;
    end
    if (en_det) begin
      det <= sum;
    end
    if (en_term) begin
      term <= {7'd0, recip};
    end

  end

  mult mult_0 (
    .sel_i  ( 1'b0                    ),
    .a_i    ( sel_mul_a_0 ? term : a  ),
    .b_i    ( sel_mul_b_0 ? term : d  ),
    .res_o  ( mul_0                   )
  );

  mult mult_1 (
    .sel_i  ( 1'b0                    ),
    .a_i    ( sel_mul_a_1 ? term : b  ),
    .b_i    ( sel_mul_b_1 ? term : c  ),
    .res_o  ( mul_1                   )
  );

  adder adder_0 (
    .sub_i  ( 1'b0                    ),
    .a_i    ( mul_0                   ),
    .b_i    ( mul_1                   ),
    .res_o  ( sum                     )
  );

  adder adder_neg_b (
    .sub_i  ( neg_b                   ),
    .a_i    ( 16'd0                   ),
    .b_i    ( b                       ),
    .res_o  ( b_val                   )
  );

  adder adder_neg_c (
    .sub_i  ( neg_c                   ),
    .a_i    ( 16'd0                   ),
    .b_i    ( c                       ),
    .res_o  ( c_val                   )
  );

  reciprocal reciprocal_0 (
    .x_i    ( det                     ),
    .y_o    ( recip                   )
  );

endmodule