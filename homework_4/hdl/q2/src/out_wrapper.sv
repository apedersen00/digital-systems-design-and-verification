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
//    .en_a_i();
//    .en_b_i();
//    .en_c_i();
//    .en_d_i();
//    .data_i(),
//    .a_o(),
//    .b_o(),
//    .c_o(),
//    .d_o()
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

  logic [15:0]  reg_a;
  logic [15:0]  reg_b;
  logic [15:0]  reg_c;
  logic [15:0]  reg_d;

  always_ff @( posedge clk_i ) begin : load_registers
    if (en_a_i) begin
      reg_a <= data_i;
    end
    if (en_b_i) begin
      reg_b <= data_i;
    end
    if (en_c_i) begin
      reg_c <= data_i;
    end
    if (en_d_i) begin
      reg_d <= data_i;
    end
  end

  assign a_o = reg_a;
  assign b_o = reg_b;
  assign c_o = reg_c;
  assign d_o = reg_d;

endmodule