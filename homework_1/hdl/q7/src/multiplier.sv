//-------------------------------------------------------------------------------------------------
//
//  File: multiplier.sv
//  Description: Parametric multiplier using an array of AND gates and full adders
//
//  Author:
//      - A. Pedersen
//
//  References:
//      - https://www.youtube.com/watch?v=_ONOKFXkfN0
//      - https://www.youtube.com/watch?v=O34KquoMpT0
//
//-------------------------------------------------------------------------------------------------

//  multiplier #(
//    .Width(8)
//  ) dut (
//    .a_i(),
//    .b_i(),
//    .prod_o()
//  );

module multiplier #(
    parameter Width = 8
  ) (
    input   logic [Width-1:0]   a_i,    // Multiplicand
    input   logic [Width-1:0]   b_i,    // Multiplier
    output  logic [2*Width-1:0] prod_o  // Product
  );

  logic [Width-1:0] partial_products [Width-1:0];

  genvar i, j;

  // We start off by generating the partial products with a "cross" array of AND gates
  generate
    for (i = 0; i < Width; i++) begin
      for (j = 0; j < Width; j++) begin
        assign partial_products[i][j] = a_i[j] & b_i[i];
      end
    end
  endgenerate

  // Sum and carry vecotrs for the adder array
  logic [2*Width-1:0] sum   [Width:0];
  logic [2*Width-1:0] carry [Width:0];

  // Initialize first row
  assign sum[0]   = {{(Width){1'b0}}, partial_products[0]};
  assign carry[0] = '0;

  generate
    for (i = 1; i < Width; i++) begin: add_rows
      for (j = 0; j < 2*Width; j++) begin: add_bits
        fulladder fa (
          .a     (sum[i-1][j]),
          .b     ( (j >= i && j < i + Width) ? partial_products[i][j-i] : 1'b0 ),
          .c_in  ( (j == 0) ? 1'b0 : carry[i][j-1] ),
          .sum   (sum[i][j]),
          .c_out (carry[i][j])
        );
      end
    end
  endgenerate

  assign prod_o = sum[Width-1];

endmodule