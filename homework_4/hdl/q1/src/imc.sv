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
//    // data inputs
//    .clk_i(),
//    .rstn_i(),
//    .start_i(),
//    .a_i(),
//    .b_i(),
//    .c_i(),
//    .d_i(),
//    // data outputs
//    .a_o(),
//    .b_o(),
//    .c_o(),
//    .d_o(),
//    .a_sign_o(),
//    .b_sign_o(),
//    .c_sign_o(),
//    .d_sign_o(),
//    // outputs
//    .ready_o()
//  );

module imc (
    // data inputs
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         start_i,
    input   logic [15:0]  a_i,
    input   logic [15:0]  b_i,
    input   logic [15:0]  c_i,
    input   logic [15:0]  d_i,
    // data outputs
    output  logic [15:0]  a_o,
    output  logic [15:0]  b_o,
    output  logic [15:0]  c_o,
    output  logic [15:0]  d_o,
    output  logic         a_sign_o,
    output  logic         b_sign_o,
    output  logic         c_sign_o,
    output  logic         d_sign_o,
    // outputs
    output  logic         ready_o
  );

    logic en_a;
    logic en_b;
    logic en_c;
    logic en_d;
    logic en_det;
    logic en_term;
    logic neg_b;
    logic sel_a;
    logic sel_b;
    logic sel_c;
    logic sel_d;
    logic sel_mul_a_0;
    logic sel_mul_b_0;
    logic sel_mul_a_1;
    logic sel_mul_b_1;

  imc_controller imc_controller_0 (
    // data inputs
    .clk_i          ( clk_i       ),
    .rstn_i         ( rstn_i      ),
    .start_i        ( start_i     ),
    // control signals
    .en_a_o         ( en_a        ),
    .en_b_o         ( en_b        ),
    .en_c_o         ( en_c        ),
    .en_d_o         ( en_d        ),
    .en_det_o       ( en_det      ),
    .en_term_o      ( en_term     ),
    .neg_b_o        ( neg_b       ),
    .sel_a_o        ( sel_a       ),
    .sel_b_o        ( sel_b       ),
    .sel_c_o        ( sel_c       ),
    .sel_d_o        ( sel_d       ),
    .sel_mul_a_0_o  ( sel_mul_a_0 ),
    .sel_mul_b_0_o  ( sel_mul_b_0 ),
    .sel_mul_a_1_o  ( sel_mul_a_1 ),
    .sel_mul_b_1_o  ( sel_mul_b_1 ),
    // outputs
    .ready_o        ( ready_o     )
  );

  imc_dp imc_dp_0 (
    // data inputs
    .clk_i          ( clk_i       ),
    .a_i            ( a_i         ),
    .b_i            ( b_i         ),
    .c_i            ( c_i         ),
    .d_i            ( d_i         ),
    // control signals
    .en_a_i         ( en_a        ),
    .en_b_i         ( en_b        ),
    .en_c_i         ( en_c        ),
    .en_d_i         ( en_d        ),
    .en_det_i       ( en_det      ),
    .en_term_i      ( en_term     ),
    .neg_b_i        ( neg_b       ),
    .sel_a_i        ( sel_a       ),
    .sel_b_i        ( sel_b       ),
    .sel_c_i        ( sel_c       ),
    .sel_d_i        ( sel_d       ),
    .sel_mul_a_0_i  ( sel_mul_a_0 ),
    .sel_mul_b_0_i  ( sel_mul_b_0 ),
    .sel_mul_a_1_i  ( sel_mul_a_1 ),
    .sel_mul_b_1_i  ( sel_mul_b_1 ),
    // data outputs
    .a_o            ( a_o         ),
    .b_o            ( b_o         ),
    .c_o            ( c_o         ),
    .d_o            ( d_o         ),
    .a_sign_o       ( a_sign_o    ),
    .b_sign_o       ( b_sign_o    ),
    .c_sign_o       ( c_sign_o    ),
    .d_sign_o       ( d_sign_o    )
  );

endmodule