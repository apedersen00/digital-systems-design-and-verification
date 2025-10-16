//-------------------------------------------------------------------------------------------------
//
//  File: in_wrapper.sv
//  Description: Input wrapper for IMC.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  in_wrapper in_wrapper_0 (
//    .clk_i(),
//    .rstn_i(),
//    .data_ready_i(),
//    .imc_ready_i(),
//    .data_accept_o(),
//    .imc_start_o(),
//    .data_i(),
//    .a_o(),
//    .b_o(),
//    .c_o(),
//    .d_o()
//  );

module in_wrapper (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         data_ready_i,
    input   logic         imc_ready_i,
    output  logic         data_accept_o,
    output  logic         imc_start_o,
    input   logic [15:0]  data_i,
    output  logic [15:0]  a_o,
    output  logic [15:0]  b_o,
    output  logic [15:0]  c_o,
    output  logic [15:0]  d_o
  );

  logic en_a;
  logic en_b;
  logic en_c;
  logic en_d;

  in_wrapper_controller in_wrapper_controller_0 (
    .clk_i          ( clk_i         ),
    .rstn_i         ( rstn_i        ),
    .data_ready_i   ( data_ready_i  ),
    .imc_ready_i    ( imc_ready_i   ),
    .data_accept_o  ( data_accept_o ),
    .imc_start_o    ( imc_start_o   ),
    .en_a_o         ( en_a          ),
    .en_b_o         ( en_b          ),
    .en_c_o         ( en_c          ),
    .en_d_o         ( en_d          )
  );

  in_wrapper_dp in_wrapper_dp_0 (
    .clk_i          ( clk_i         ),
    .en_a_i         ( en_a          ),
    .en_b_i         ( en_b          ),
    .en_c_i         ( en_c          ),
    .en_d_i         ( en_d          ),
    .data_i         ( data_i        ),
    .a_o            ( a_o           ),
    .b_o            ( b_o           ),
    .c_o            ( c_o           ),
    .d_o            ( d_o           )
  );

endmodule