//-------------------------------------------------------------------------------------------------
//
//  File: bw_white_cell.sv
//  Description: Baugh-Wooley multiplier white-cell
//
//  Author:
//      - A. Pedersen
//
//  References:
//      - https://www.ece.uvic.ca/~fayez/courses/ceng465/lab_465/project2/multiplier.pdf
//
//-------------------------------------------------------------------------------------------------

//  bw_white_cell bw_white_0 (
//    .a_i(),
//    .b_i(),
//    .c_i(),
//    .s_i(),
//    .s_o(),
//    .c_o()
//  );

module bw_white_cell (
    input   logic a_i,
    input   logic b_i,
    input   logic c_i,
    input   logic s_i,
    output  logic s_o,
    output  logic c_o
  );

  fulladder fa_and (
    .a_i   ( a_i && b_i ),
    .b_i   ( c_i        ),
    .c_i   ( s_i        ),
    .sum_o ( s_o        ),
    .c_o   ( c_o        )
  );

endmodule