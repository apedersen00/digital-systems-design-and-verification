//-------------------------------------------------------------------------------------------------
//
//  File: alu.sv
//  Description:
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

import rv32i_pkg::*;

module alu (
    input   logic [5:0]           op_i,
    input   logic [REG_WIDTH-1:0] a_i,  // operand a
    input   logic [REG_WIDTH-1:0] b_i,  // operand b
    output  logic [REG_WIDTH-1:0] res_o
);

  always_comb begin : calculate_result
    case (op_i)
      OP_ALU_ADD: res_o = a_i           +   b_i;
      OP_ALU_SUB: res_o = a_i           -   b_i;
      OP_ALU_AND: res_o = a_i           &   b_i;
      OP_ALU_OR : res_o = a_i           |   b_i;
      OP_ALU_XOR: res_o = a_i           ^   b_i;
      OP_ALU_SLL: res_o = a_i           <<  b_i[4:0];
      OP_ALU_SRL: res_o = a_i           >>  b_i[4:0];
      OP_ALU_SRA: res_o = $signed(a_i)  >>> b_i[4:0];
      OP_ALU_SLT: res_o = ($signed(a_i) < $signed(b_i)) ? 32'd1 : 32'd0;
      OP_ALU_SLTU:res_o = (a_i          <         b_i)  ? 32'd1 : 32'd0;
      default:    res_o = {REG_WIDTH{1'b0}};
    endcase
  end

endmodule