//-------------------------------------------------------------------------------------------------
//
//  File: cr_adder.sv
//  Description: Carry ripple adder of arbitrary size using cascaded full adders
//
//  Author:
//      - A. Pedersen
//
//  References:
//    - https://www.chipverify.com/verilog/verilog-full-adder
//    - https://stackoverflow.com/questions/70210106/systemverilog-dataflow-modeling-ripple-adder-with-array-instances
//
//-------------------------------------------------------------------------------------------------

//  cr_adder #(
//    .Width(8)
//  ) dut (
//    .a(),
//    .b(),
//    .c_i(),
//    .sum(),
//    .c_o(),
//  );

module cr_adder #(
    parameter Width = 4
  ) (
    input   logic [Width-1:0] a_i,
    input   logic [Width-1:0] b_i,
    input   logic             c_i,
    output  logic [Width-1:0] sum_o,
    output  logic             c_o
  );

  logic [Width:0] c;
  assign c[0] = c_i;

  genvar i;
  generate
    for (i = 0; i < Width; i++) begin : adder_chain
      fulladder fa (
        .a_i      (a_i[i]),
        .b_i      (b_i[i]),
        .c_i      (c[i]),
        .sum_o    (sum_o[i]),
        .c_o      (c[i+1])
      );
    end
  endgenerate

  assign c_o = c[Width];

endmodule
