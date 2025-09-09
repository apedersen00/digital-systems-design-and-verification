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
//    .sum(),
//    .c_out(),
//  );

module cr_adder #(
    parameter Width = 4
  ) (
    input   logic [Width-1:0] a,
    input   logic [Width-1:0] b,
    output  logic [Width-1:0] sum,
    output  logic             c_out
  );

  logic [Width:0] c;
  assign c[0] = 1'b0;

  genvar i;
  generate
    for (i = 0; i < Width; i++) begin : adder_chain
      fulladder fa (
        .a      (a[i]),
        .b      (b[i]),
        .c_in   (c[i]),
        .sum    (sum[i]),
        .c_out  (c[i+1])
      );
    end
  endgenerate

  assign c_out  = c[Width];

endmodule