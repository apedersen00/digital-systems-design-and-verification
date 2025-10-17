//-------------------------------------------------------------------------------------------------
//
//  File: out_wrapper.sv
//  Description: Output wrapper for IMC.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  out_wrapper out_wrapper_0 (
//    .clk_i(),
//    .rstn_i(),
//    .imc_ready_i(),
//    .start_transmit_i(),
//    .grant_i(),
//    .accepted_i(),
//    .a_i(),
//    .b_i(),
//    .c_i(),
//    .d_i(),
//    .data_o(),
//    .avail_o(),
//    .request_o(),
//    .ready_o()
//  );

module out_wrapper (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         imc_ready_i,
    input   logic         start_transmit_i,
    input   logic         grant_i,
    input   logic         accepted_i,
    input   logic [15:0]  a_i,
    input   logic [15:0]  b_i,
    input   logic [15:0]  c_i,
    input   logic [15:0]  d_i,
    output  logic [15:0]  data_o,
    output  logic         avail_o,
    output  logic         request_o,
    output  logic         ready_o
  );

  logic drive_bus;
  logic latch_imc;
  logic [1:0] data_mux;

  out_wrapper_controller out_wrapper_controller_0 (
    .clk_i            ( clk_i             ),
    .rstn_i           ( rstn_i            ),
    .imc_ready_i      ( imc_ready_i       ),
    .start_transmit_i ( start_transmit_i  ),
    .grant_i          ( grant_i           ),
    .accepted_i       ( accepted_i        ),
    .avail_o          ( avail_o           ),
    .request_o        ( request_o         ),
    .ready_o          ( ready_o           ),
    .drive_bus_o      ( drive_bus         ),
    .latch_imc_o      ( latch_imc         ),
    .data_mux_o       ( data_mux          )
  );

  out_wrapper_dp out_wrapper_dp_0 (
    .clk_i            ( clk_i             ),
    .drive_bus_i      ( drive_bus         ),
    .latch_imc_i      ( latch_imc         ),
    .data_mux_i       ( data_mux          ),
    .a_i              ( a_i               ),
    .b_i              ( b_i               ),
    .c_i              ( c_i               ),
    .d_i              ( d_i               ),
    .data_o           ( data_o            )
  );

endmodule