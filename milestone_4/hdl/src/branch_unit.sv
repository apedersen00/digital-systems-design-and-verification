//-------------------------------------------------------------------------------------------------
//
//  File: branch_unit.sv
//  Description: Branch unit.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  branch_unit branch_unit_0 (
//    .op_i(),
//    .branch(),
//    .a_i(),
//    .b_i(),
//    .branch_o()
//  );

import rv32i_pkg::*;

module branch_unit (
    input   logic [2:0]           op_i,
    input   logic                 branch,
    input   logic [REG_WIDTH-1:0] a_i,      // operand a
    input   logic [REG_WIDTH-1:0] b_i,      // operand b
    output  logic                 branch_o
);

  always_comb begin : calculate_result
    branch_o = 1'b0;
    if (branch) begin
      case (op_i)
        BRANCH_BEQ      : branch_o =         a_i  ==          b_i;
        BRANCH_BNE      : branch_o =         a_i  !=          b_i;
        BRANCH_BLT      : branch_o = $signed(a_i) <   $signed(b_i);
        BRANCH_BGE      : branch_o = $signed(a_i) >=  $signed(b_i);
        BRANCH_BLTU     : branch_o =         a_i  <           b_i;
        BRANCH_BGEU     : branch_o =         a_i  >=          b_i;
        BRANCH_JAL_JALR : branch_o = 1'b1;
        default         : branch_o = 1'b0;
      endcase
    end
  end

endmodule