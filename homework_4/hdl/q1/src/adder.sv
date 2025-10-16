//-------------------------------------------------------------------------------------------------
//
//  File: adder.sv
//  Description: Adder/subtractor
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  adder adder_0 (
//    .sub_i(),
//    .a_i(),
//    .b_i(),
//    .res_o()
//  );

module adder (
    input   logic         sub_i,
    input   logic [15:0]  a_i,
    input   logic [15:0]  b_i,
    output  logic [15:0]  res_o
  );

  always_comb begin
    res_o = 16'd0;

    if (sub_i) begin
      res_o = a_i - b_i;
    end
    else begin
      res_o = a_i + b_i;
    end
  end

endmodule