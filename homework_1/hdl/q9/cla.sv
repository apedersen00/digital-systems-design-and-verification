//-------------------------------------------------------------------------------------------------
//
//  File: cla.sv
//  Description: Carry lookahead adder using a cascade of full adders and additional logic
//
//  Author:
//      - A. Pedersen
//
//  References:
//    - https://nandland.com/carry-lookahead-adder/
//
//-------------------------------------------------------------------------------------------------

//  cla #(
//    .Width(8)
//  ) dut (
//    .a_i(),
//    .b_i(),
//    .sum_o(),
//    .c_o()
//  );

module cla #(
    parameter Width = 8
  ) (
    input   logic [Width-1:0] a_i,
    input   logic [Width-1:0] b_i,
    output  logic [Width-1:0] sum_o,
    output  logic             c_o
  );

  logic [Width-1:0] w_G; // Generate terms: Gi = Ai * Bi
  logic [Width-1:0] w_P; // Propagate terms: Pi = Ai + Bi
  logic [Width-1:0] w_S; // Sum
  logic [Width:0]   w_C; // Carry terms
  assign w_C[0] = 1'b0;

  genvar i;
  generate
    for (i = 0; i < Width; i++) begin : adder_chain
      fulladder fa (
        .a      (a_i[i]),
        .b      (b_i[i]),
        .c_in   (w_C[i]),
        .sum    (w_S[i]),
        .c_out  ()
      );
    end
  endgenerate

  genvar j;
  generate
    for (j = 0; j < Width; j++) begin : lookahead_terms
      assign w_G[j]   = a_i[j] & b_i[j];
      assign w_P[j]   = a_i[j] | b_i[j];
      assign w_C[j+1] = w_G[j] | (w_P[j] & w_C[j]);
    end
  endgenerate

  assign c_o    = w_C[Width];
  assign sum_o  = w_S;

endmodule