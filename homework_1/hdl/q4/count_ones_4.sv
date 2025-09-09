//-------------------------------------------------------------------------------------------------
//
//  File: count_ones_4.sv
//  Description: Counts the number of ones in a 4-bit binary number
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  count_ones_4 dut (
//    .a_i(),
//    .out_o()
//  );

module count_ones_4 (
    input   logic [3:0] a_i,
    output  logic [2:0] out_o
  );

  assign out_o =  (a_i[0] ? 1 : 0) +
                  (a_i[1] ? 1 : 0) +
                  (a_i[2] ? 1 : 0) +
                  (a_i[3] ? 1 : 0);

endmodule