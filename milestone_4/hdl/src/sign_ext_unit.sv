//-------------------------------------------------------------------------------------------------
//
//  File: sign_ext_unit.sv
//  Description: Sign extension unit.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  sign_ext_unit sign_ext_unit_0 (
//    .inst_i(),
//    .op_i(),
//    .imm_ext_o()
//  );

import rv32i_pkg::*;

module sign_ext_unit (
    /* verilator lint_off UNUSEDSIGNAL */
    input   logic [REG_WIDTH-1:0] inst_i,
    /* verilator lint_on UNUSEDSIGNAL */
    input   logic [6:0]           op_i,
    output  logic [REG_WIDTH-1:0] imm_ext_o
);

  always_comb begin
    imm_ext_o = 32'd0;
    case (op_i)

      // U-Type
      OP_LUI, OP_AUIPC:
        imm_ext_o = {inst_i[31:12], 12'd0};

      // J-Type
      OP_JAL:
        imm_ext_o =  {{11{inst_i[31]}},
                          inst_i[31],     // imm[20]
                          inst_i[19:12],  // imm[19:12]
                          inst_i[20],     // imm[11]
                          inst_i[30:21],  // imm[10:1]
                          1'b0};

      // B-Type
      OP_BRANCH:
        imm_ext_o =  {{19{inst_i[31]}},
                          inst_i[31],     // imm[12]
                          inst_i[7],      // imm[11]
                          inst_i[30:25],  // imm[10:5]
                          inst_i[11:8],   // imm[4:1]
                          1'b0};

      // S-Type
      OP_STORE:
        imm_ext_o = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
      
      // I-Type [12-bit]:
      OP_JALR, OP_LOAD, OP_ALUI:
        // imm[12:0] = inst[31:20]
        imm_ext_o = {{20{inst_i[31]}}, inst_i[31:20]};

      default:
        imm_ext_o = 32'd0;

    endcase
  end

endmodule