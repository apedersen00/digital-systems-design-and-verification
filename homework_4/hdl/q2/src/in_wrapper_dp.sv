//-------------------------------------------------------------------------------------------------
//
//  File: in_wrapper_dp.sv
//  Description: Data path for input wrapper for IMC.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  in_wrapper_dp in_wrapper_dp_0 (
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

module in_wrapper_dp (
    input   logic         clk_i,
    input   logic         en_a_i,
    input   logic         en_b_i,
    input   logic         en_c_i,
    input   logic         en_d_i,
    input   logic [15:0]  data_i,
    output  logic [15:0]  a_o,
    output  logic [15:0]  b_o,
    output  logic [15:0]  c_o,
    output  logic [15:0]  d_o
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