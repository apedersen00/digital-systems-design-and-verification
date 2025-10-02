//-------------------------------------------------------------------------------------------------
//
//  File: avg_calc.sv
//  Description: Average calculator datapath.
//               Parameter n MUST be a power of 2.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  avg_calc #(
//    .m(),
//    .n()
//  ) avg_calc_0 (
//    .clk_i(),
//    .rstn_i(),
//    .start_i(),
//    .data_i(),
//    .done_o(),
//    .result_o()
//  );

module avg_calc #(
    parameter m = 8,  // input bit-width
    parameter n = 4   // number of inputs
  ) (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         start_i,
    input   logic [m-1:0] data_i,
    output  logic         done_o,
    output  logic [m-1:0] result_o
  );

  logic en_dp;
  logic zero_dp;

  avg_calc_dp #(
    .m(m),
    .n(n)
  ) avg_calc_dp_0 (
    .clk_i(clk_i),
    .en_i(en_dp),
    .zero_i(zero_dp),
    .data_i(data_i),
    .result_o(result_o)
  );

  avg_calc_controller #(
    .n(n)
  ) avg_calc_controller_0 (
    .clk_i(clk_i),
    .start_i(start_i),
    .rstn_i(rstn_i),
    .en_dp_o(en_dp),
    .zero_dp_o(zero_dp),
    .done_o(done_o)
  );

endmodule