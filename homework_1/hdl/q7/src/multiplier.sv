//-------------------------------------------------------------------------------------------------
//
//  File: multiplier.sv
//  Description: Parametric Baugh-Wooley multiplier. Design is based on the first reference.
//
//  Author:
//      - A. Pedersen
//
//  References:
//      - https://www.ece.uvic.ca/~fayez/courses/ceng465/lab_465/project2/multiplier.pdf
//      - https://github.com/fpozzana/Baugh-Wooley_multiplier
//      - https://publish.obsidian.md/cynixia/Baugh-Wooley+Algorithm
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
    input logic [Width-1:0]     a_i,    // Multiplicand
    input logic [Width-1:0]     b_i,    // Multiplier
    output logic [2*Width-1:0]  prod_o  // Product
);

  // A Baugh-Wooley (BW) multiplier is a "matrix" of white/gray BW cells.
  // To handle wire routing we define matrices for the sum and carry signals.

  logic [Width-1:0][Width-1:0] sum_matrix;
  logic [Width-1:0][Width-1:0] carry_matrix;

  logic [Width-1:0] final_sum_vector;
  logic [Width-1:0] final_carry_vector;

  // This generate logic is quite ugly.
  genvar i, j;
  generate
    for (i = 0; i < Width; i++) begin: rows
      for (j = 0; j < Width; j++) begin: cols

        if (i > 0 && i < Width - 1 && j < Width - 1) begin
          bw_white_cell bw_cell (
            .a_i  ( b_i[i]                ),
            .b_i  ( a_i[j]                ),
            .c_i  ( carry_matrix[i-1][j]  ),
            .s_i  ( sum_matrix[i-1][j+1]  ),
            .s_o  ( sum_matrix[i][j]      ),
            .c_o  ( carry_matrix[i][j]    )
          );
        end

        else if (i == 0 && j < Width - 1) begin
          bw_white_cell bw_cell (
            .a_i  ( b_i[0]                ),
            .b_i  ( a_i[j]                ),
            .c_i  ( 1'b0                  ),
            .s_i  ( 1'b0                  ),
            .s_o  ( sum_matrix[i][j]      ),
            .c_o  ( carry_matrix[i][j]    )
          );
        end

        else if (i == Width - 1 && j < Width - 1) begin
          bw_gray_cell bw_cell (
            .a_i  ( b_i[Width-1]          ),
            .b_i  ( a_i[j]                ),
            .c_i  ( carry_matrix[i-1][j]  ),
            .s_i  ( sum_matrix[i-1][j+1]  ),
            .s_o  ( sum_matrix[i][j]      ),
            .c_o  ( carry_matrix[i][j]    )
          );
        end

        else if (j == Width - 1 && i < Width - 1) begin
          bw_gray_cell bw_cell (
            .a_i  ( b_i[i]                ),
            .b_i  ( a_i[Width-1]          ),
            .c_i  ( 1'b0                  ),
            .s_i  ( 1'b0                  ),
            .s_o  ( sum_matrix[i][j]      ),
            .c_o  ( carry_matrix[i][j]    )
          );
        end

        else if (i == Width - 1 && j == Width - 1) begin
          bw_white_cell bw_cell (
            .a_i  ( b_i[Width-1]          ),
            .b_i  ( a_i[Width-1]          ),
            .c_i  ( 1'b0                  ),
            .s_i  ( 1'b0                  ),
            .s_o  ( sum_matrix[i][j]      ),
            .c_o  ( carry_matrix[i][j]    )
          );
        end

      end
    end
  endgenerate

  // Final row of full adders
  generate
    for (i = 0; i < Width; i++) begin: final_adder_row

      if (i == 0) begin
        fulladder f0 (
          .a_i    ( 1'b1                      ),
          .b_i    ( carry_matrix[Width-1][i]  ),
          .c_i    ( sum_matrix[Width-1][i+1]  ),
          .sum_o  ( final_sum_vector[i]       ),
          .c_o    ( final_carry_vector[i]     )
        );
      end

      else if (i == Width - 1) begin
        fulladder f1 (
          .a_i    ( final_carry_vector[i-1]   ),
          .b_i    ( carry_matrix[Width-1][i]  ),
          .c_i    ( 1'b1                      ),
          .sum_o  ( final_sum_vector[i]       ),
          .c_o    ( final_carry_vector[i]     )
        );
      end

      else begin
        fulladder f2 (
          .a_i    ( final_carry_vector[i-1]   ),
          .b_i    ( carry_matrix[Width-1][i]  ),
          .c_i    ( sum_matrix[Width-1][i+1]  ),
          .sum_o  ( final_sum_vector[i]       ),
          .c_o    ( final_carry_vector[i]     )
        );
      end

    end
  endgenerate

  // Generate output bit vector
  generate
    for (i = 0; i < 2 * Width; i++) begin: output_vec

      if (i < Width) begin
        assign prod_o[i] = sum_matrix[i][0];
      end

      else begin
        assign prod_o[i] = final_sum_vector[i-Width];
      end

    end
  endgenerate

endmodule