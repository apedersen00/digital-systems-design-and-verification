//-------------------------------------------------------------------------------------------------
//
//  File: cl_subtractor.sv
//  Description: Carry lookahead subtractor using a cascade of full adders and additional logic
//
//  Author:
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//  References:
//    - https://nandland.com/carry-lookahead-adder/
//
//-------------------------------------------------------------------------------------------------

//  cl_subtractor #(
//    .Width(8)
//  ) dut (
//    .a_i(),
//    .b_i(),
//    .sub_i(),
//    .sum_o(),
//    .c_o()
//  );

module cl_subtractor #(
    parameter Width = 8
  ) (
    input   logic [Width-1:0] a_i,
    input   logic [Width-1:0] b_i,
    input   logic             sub_i,
    output  logic [Width-1:0] sum_o,
    output  logic             c_o
  );

  logic [Width-1:0] w_G; // Generate terms: Gi = Ai * Bi
  logic [Width-1:0] w_P; // Propagate terms: Pi = Ai + Bi
  logic [Width-1:0] w_S; // Sum
  logic [Width:0]   w_C; // Carry terms
  assign w_C[0] = sub_i;

  genvar i;
  generate
    for (i = 0; i < Width; i++) begin : adder_chain
      fulladder fa (
        .a_i      (a_i[i]),
        .b_i      (b_i[i] ^ sub_i),
        .c_i      (w_C[i]),
        .sum_o    (w_S[i]),
        .c_o      ()
      );

      assign w_G[i] = a_i[i] & (b_i[i] ^ sub_i);
      assign w_P[i] = a_i[i] | (b_i[i] ^ sub_i);

      // CLA terms: Ci+1 = Gi + Pi*Ci
      if (i < Width) begin : gen_cla_terms
        assign w_C[i+1] = w_G[i] | (w_P[i] & w_C[i]);
      end
    end
  endgenerate

  assign sum_o = w_S;
  assign c_o = w_C[Width];

endmodule
