//-------------------------------------------------------------------------------------------------
//
//  File: sinx.sv
//  Description: sin(x) accelerator.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  avg_calc avg_calc_0 (
//    .clk_i(),
//    .rstn_i(),
//    .start_i(),
//    .x_i(),
//    .result_o(),
//    .done_o()
//  );

module sinx (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         start_i,
    input   logic [15:0]  x_i,
    output  logic [15:0]  result_o,
    output  logic         done_o
  );

  logic en_temp_reg;
  logic en_term_reg;
  logic en_sum_reg;
  logic sub;
  logic [1:0] mux_a;
  logic [1:0] mux_b;
  logic [2:0] counter;

  sinx_dp sinx_dp_0 (
    .clk_i            ( clk_i       )
    .x_i              ( x_i         ),
    .en_temp_reg_i    ( en_temp_reg ),
    .en_term_reg_i    ( en_term_reg ),
    .en_sum_reg_i     ( en_sum_reg  ),
    .sub_i            ( sub         ),
    .mux_a_i          ( mux_a       ),
    .mux_b_i          ( mux_b       ),
    .counter_i        ( counter     ),
    .result_o         ( result_o    )
  );

  sinx_controller sinx_controller_0 (
    .clk_i            ( clk_i       ),
    .rstn_i           ( rstn_i      ),
    .start_i          ( start_i     ),
    .dp_en_temp_reg_o ( en_temp_reg ),
    .dp_en_term_reg_o ( en_term_reg ),
    .dp_en_sum_reg_o  ( en_sum_reg  ),
    .dp_sub_o         ( sub         ),
    .dp_mux_a_o       ( mux_a       ),
    .dp_mux_b_o       ( mux_b       ),
    .dp_counter_o     ( counter     ),
    .done_o           ( done_o      )
  );

endmodule