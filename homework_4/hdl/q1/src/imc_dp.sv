//-------------------------------------------------------------------------------------------------
//
//  File: imc_dp.sv
//  Description: Datapath of Inverse Matric Calculator.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  imc_dp imc_dp_0 (
      // data inputs
//    .clk_i(),
//    .a_i(),
//    .b_i(),
//    .c_i(),
//    .d_i(),
      // control signals
//    .en_a_i(),
//    .en_b_i(),
//    .en_c_i(),
//    .en_d_i(),
//    .en_det_i(),
//    .en_term_i(),
//    .neg_b_i(),
//    .neg_c_i(),
//    .sel_a_i(),
//    .sel_b_i(),
//    .sel_c_i(),
//    .sel_d_i(),
//    .sel_mul_a_0_i(),
//    .sel_mul_b_0_i(),
//    .sel_mul_a_1_i(),
//    .sel_mul_b_1_i(),
      // data outputs
//    .a_o(),
//    .b_o(),
//    .c_o(),
//    .d_o(),
//    .a_sign_o(),
//    .b_sign_o(),
//    .c_sign_o(),
//    .d_sign_o()
//  );

module imc_dp (
    // data inputs
    input   logic         clk_i,
    input   logic [15:0]  a_i,
    input   logic [15:0]  b_i,
    input   logic [15:0]  c_i,
    input   logic [15:0]  d_i,
    // control signals
    input   logic         en_a_i,         // enable reg
    input   logic         en_b_i,         // enable reg
    input   logic         en_c_i,         // enable reg
    input   logic         en_d_i,         // enable reg
    input   logic         en_det_i,       // enable reg
    input   logic         en_term_i,      // enable reg
    input   logic         neg_b_i,        // negate b
    input   logic         sel_a_i,        // 1'b0: a_i, 1'b1: mul_0
    input   logic         sel_b_i,        // 1'b0: b_i, 1'b1: mul_1
    input   logic         sel_c_i,        // 1'b0: c_i, 1'b1: mul_0
    input   logic         sel_d_i,        // 1'b0: d_i, 1'b1: mul_1
    input   logic         sel_mul_a_0_i,  // 1'b0: a  , 1'b1: term
    input   logic         sel_mul_b_0_i,  // 1'b0: d  , 1'b1: term
    input   logic         sel_mul_a_1_i,  // 1'b0: b  , 1'b1: a
    input   logic         sel_mul_b_1_i,  // 1'b0: c  , 1'b1: term
    // data outputs
    output  logic [15:0]  a_o,
    output  logic [15:0]  b_o,
    output  logic [15:0]  c_o,
    output  logic [15:0]  d_o,
    output  logic         a_sign_o,
    output  logic         b_sign_o,
    output  logic         c_sign_o,
    output  logic         d_sign_o
  );

  // registers
  logic [15:0] a;
  logic [15:0] b;
  logic [15:0] c;
  logic [15:0] d;
  logic [15:0] det;
  logic [15:0] term;

  // signals
  logic [15:0]  mul_0;
  logic [15:0]  mul_1;
  logic [15:0]  sum;
  logic [8:0]   recip;
  logic [15:0]  b_val;
  /* verilator lint_off UNUSEDSIGNAL */
  logic [15:0]  det_neg;
  /* verilator lint_on UNUSEDSIGNAL */

  // output assignments
  assign a_o = a;
  assign b_o = b;
  assign c_o = c;
  assign d_o = d;

  assign a_sign_o = det[15];
  assign b_sign_o = ~det[15];
  assign c_sign_o = ~det[15];
  assign d_sign_o = det[15];

  always_ff @( posedge clk_i ) begin : update_registers

    if (en_a_i) begin
      a <= sel_a_i ? mul_0 : a_i;
    end
    if (en_b_i) begin
      b <= sel_b_i ? mul_1 : b_i;
    end
    if (en_c_i) begin
      c <= sel_c_i ? mul_0 : c_i;
    end
    if (en_d_i) begin
      d <= sel_d_i ? mul_1 : d_i;
    end
    if (en_det_i) begin
      det <= sum;
    end
    if (en_term_i) begin
      term <= {7'd0, recip};
    end

  end

  mult mult_0 (
    .sel_i  ( 1'b0                      ),
    .a_i    ( sel_mul_a_0_i ? term  : a ),
    .b_i    ( sel_mul_b_0_i ? c     : d ),
    .res_o  ( mul_0                     )
  );

  mult mult_1 (
    .sel_i  ( 1'b0                          ),
    .a_i    ( sel_mul_a_1_i ? a    : b_val  ),
    .b_i    ( sel_mul_b_1_i ? term : c      ),
    .res_o  ( mul_1                         )
  );

  adder adder_0 (
    .sub_i  ( 1'b0                    ),
    .a_i    ( mul_0                   ),
    .b_i    ( mul_1                   ),
    .res_o  ( sum                     )
  );

  adder adder_neg_b (
    .sub_i  ( neg_b_i                 ),
    .a_i    ( 16'd0                   ),
    .b_i    ( b                       ),
    .res_o  ( b_val                   )
  );

  adder adder_neg_det (
    .sub_i  ( det[15]                 ),
    .a_i    ( 16'd0                   ),
    .b_i    ( det                     ),
    .res_o  ( det_neg                 )
  );


  reciprocal reciprocal_0 (
    .x_i    ( {8'd0, det_neg[15:8]}   ),
    .y_o    ( recip                   )
  );

endmodule