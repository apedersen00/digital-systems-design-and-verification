//-------------------------------------------------------------------------------------------------
//
//  File: cpu_pkg.sv
//  Description: Parameters and enums for CPU.
//
//  Author:
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

package rv32i_pkg;

  parameter REG_WIDTH = 32;

  // RV32I Base Opcodes
  parameter [6:0] OP_LUI     = 7'b0110111; // U-Type: Load Upper Immediate
  parameter [6:0] OP_AUIPC   = 7'b0010111; // U-Type: Add Upper Immediate to PC
  parameter [6:0] OP_JAL     = 7'b1101111; // J-Type: Jump and Link
  parameter [6:0] OP_BRANCH  = 7'b1100011; // B-Type: Branch Instructions (BEQ, BNE, BLT, etc.)
  parameter [6:0] OP_STORE   = 7'b0100011; // S-Type: Store Instructions (SB, SH, SW)
  parameter [6:0] OP_ALU     = 7'b0110011; // R-Type: ALU Instructions (ADD, SUB, AND, OR, XOR, etc.)
  parameter [6:0] OP_JALR    = 7'b1100111; // I-Type: Jump and Link Register
  parameter [6:0] OP_LOAD    = 7'b0000011; // I-Type: Load Instructions (LB, LH, LW, LBU, LHU)
  parameter [6:0] OP_ALUI    = 7'b0010011; // I-Type: ALU Immediate Instructions (ADDI, ANDI, ORI, XORI, etc.)
  parameter [6:0] OP_FENCE   = 7'b0001111; // Fence
  parameter [6:0] OP_SYSTEM  = 7'b1110011; // System Instructions (ECALL, EBREAK, etc.)

  // ALU Operation codes
  parameter [5:0] OP_ALU_NOP  = 6'b000000;
  parameter [5:0] OP_ALU_ADD  = 6'b011001; // Add
  parameter [5:0] OP_ALU_SUB  = 6'b011011; // Subtract
  parameter [5:0] OP_ALU_AND  = 6'b011101; // Bitwise AND
  parameter [5:0] OP_ALU_OR   = 6'b011111; // Bitwise OR
  parameter [5:0] OP_ALU_XOR  = 6'b100001; // Bitwise XOR
  parameter [5:0] OP_ALU_SLT  = 6'b100011; // Set Less Than (signed)
  parameter [5:0] OP_ALU_SLTU = 6'b100101; // Set Less Than (unsigned)
  parameter [5:0] OP_ALU_SLL  = 6'b100111; // Shift Left Logical
  parameter [5:0] OP_ALU_SRL  = 6'b101001; // Shift Right Logical
  parameter [5:0] OP_ALU_SRA  = 6'b101011; // Shift Right Arithmetic

  // Branch operation codes
  parameter [2:0] BRANCH_BEQ      = 3'b000; // Branch Equal
  parameter [2:0] BRANCH_BNE      = 3'b001; // Branch Not Equal
  parameter [2:0] BRANCH_BLT      = 3'b100; // Branch Less Than
  parameter [2:0] BRANCH_BGE      = 3'b101; // Branch Greater Than Or Equal
  parameter [2:0] BRANCH_BLTU     = 3'b110; // Branch Less Than Unsigned
  parameter [2:0] BRANCH_BGEU     = 3'b111; // Branch Greater Than Or Equal Unsigned
  parameter [2:0] BRANCH_JAL_JALR = 3'b010; // Jump

endpackage