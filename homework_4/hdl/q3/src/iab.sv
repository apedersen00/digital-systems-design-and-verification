//-------------------------------------------------------------------------------------------------
//
//  File: iab.sv
//  Description: Interface circuit for device A (64-bit) and device B (8-bit) over a
//               shared bus.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  iab iab_0 (
//    .clk_i(),
//    .rstn_i(),
//    .a_ready_i(),
//    .bus_grant_i(),
//    .accepted_i(),
//    .data_a_i(),
//    .data_b_o(),
//    .accepted_a_o(),
//    .bus_req_o(),
//    .ready_o()
//  );

module iab (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         a_ready_i,
    input   logic         bus_grant_i,
    input   logic         accepted_i,
    input   logic [63:0]  data_a_i,
    output  logic [7:0]   data_b_o,
    output  logic         accepted_a_o,
    output  logic         bus_req_o,
    output  logic         ready_o
  );

  logic drive_bus;
  logic latch;
  logic [2:0] mux;

  iab_controller iab_controller_0 (
    .clk_i        ( clk_i         ),
    .rstn_i       ( rstn_i        ),
    .a_ready_i    ( a_ready_i     ),
    .bus_grant_i  ( bus_grant_i   ),
    .accepted_i   ( accepted_i    ),
    .accepted_a_o ( accepted_a_o  ),
    .bus_req_o    ( bus_req_o     ),
    .ready_o      ( ready_o       ),
    .drive_bus_o  ( drive_bus     ),
    .latch_o      ( latch         ),
    .mux_o        ( mux           )
  );

  iab_dp iab_dp_0 (
    .clk_i        ( clk_i         ),
    .data_a_i     ( data_a_i      ),
    .latch_i      ( latch         ),
    .drive_bus_i  ( drive_bus     ),
    .mux_i        ( mux           ),
    .data_o       ( data_b_o      )
  );

endmodule