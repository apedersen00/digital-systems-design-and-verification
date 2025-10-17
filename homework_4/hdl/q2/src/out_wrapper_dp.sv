//-------------------------------------------------------------------------------------------------
//
//  File: out_wrapper_dp.sv
//  Description: Data path for output wrapper for IMC.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  out_wrapper_dp out_wrapper_dp_0 (
//    .clk_i(),
//    .drive_bus_i(),
//    .latch_imc_i(),
//    .data_mux_i(),
//    .a_i(),
//    .b_i(),
//    .c_i(),
//    .d_i(),
//    .data_o()
//  );

module out_wrapper_dp (
    input   logic         clk_i,
    input   logic         drive_bus_i,
    input   logic         latch_imc_i,
    input   logic [1:0]   data_mux_i,
    input   logic [15:0]  a_i,
    input   logic [15:0]  b_i,
    input   logic [15:0]  c_i,
    input   logic [15:0]  d_i,
    output  logic [15:0]  data_o
  );

  logic [15:0]  reg_a;
  logic [15:0]  reg_b;
  logic [15:0]  reg_c;
  logic [15:0]  reg_d;

  always_ff @( posedge clk_i ) begin
    if (latch_imc_i) begin
      reg_a <= a_i;
      reg_b <= b_i;
      reg_c <= c_i;
      reg_d <= d_i;
    end
  end

  always_comb begin
    case ({drive_bus_i, data_mux_i})
      3'b100  : data_o = reg_a;
      3'b101  : data_o = reg_b;
      3'b110  : data_o = reg_c;
      3'b111  : data_o = reg_d;
      default : data_o = 16'bzzzzzzzzzzzzzzzz;
    endcase
  end

endmodule