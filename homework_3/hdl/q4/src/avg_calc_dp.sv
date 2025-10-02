//-------------------------------------------------------------------------------------------------
//
//  File: avg_calc_dp.sv
//  Description: Average calculator datapath.
//               Parameter n MUST be a power of 2.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  avg_calc_dp #(
//    .m(),
//    .n()
//  ) avg_calc_dp_0 (
//    .clk_i(),
//    .en_i(),
//    .data_i(),
//    .result_o()
//  );

module avg_calc_dp #(
    parameter m = 8,  // input bit-width
    parameter n = 4   // number of inputs
  ) (
    input   logic         clk_i,
    input   logic         en_i,
    input   logic         zero_i,
    input   logic [m-1:0] data_i,
    output  logic [m-1:0] result_o
  );

  logic [m-1:0] acc;

  // accumulate inputs
  always_ff @(posedge clk_i) begin
    if (!en_i) begin
      acc <= acc;
    end
    else begin
      if (zero_i) begin
        acc <= '0 + data_i;
      end
      else begin
        acc <= acc + data_i;
      end
    end
  end

  assign result_o = acc >> $clog2(n);

endmodule