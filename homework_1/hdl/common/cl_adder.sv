//-------------------------------------------------------------------------------------------------
//
//  File: cl_adder.sv
//  Description: Carry lookahead adder using a cascade of full adders and additional logic
//
//  Author:
//      - A. Pedersen
//
//  References:
//    - https://nandland.com/carry-lookahead-adder/
//
//-------------------------------------------------------------------------------------------------

//  cl_adder #(
//    .Width(8)
//  ) dut (
//    .a_i(),
//    .b_i(),
//    .sum_o(),
//    .c_o()
//  );

module cl_adder #(
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

      assign w_G[i] = a_i[i] & b_i[i];
      assign w_P[i] = a_i[i] | b_i[i];

      // CLA terms: Ci+1 = Gi + Pi*Ci
      if (i < Width) begin
        assign w_C[i+1] = w_G[i] | (w_P[i] & w_C[i]);
      end
    end
  endgenerate

  assign sum_o = w_S;
  assign c_o = w_C[Width];

endmodule
