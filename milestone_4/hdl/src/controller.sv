//-------------------------------------------------------------------------------------------------
//
//  File: core_controller.sv
//  Description: CPU core controller.
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

module controller (
    input   logic                 clk_i,
    input   logic                 rstn_i,
    input   logic [REG_WIDTH-1:0] inst_i,
    output  logic [2:0]           funct3_o,
    output  logic [REG_WIDTH-1:0] inst_o,
    output  logic                 read_inst,
    output  logic                 pc_en_o,
    output  logic [6:0]           op_o,
    output  logic                 branch_o,
    output  logic [1:0]           result_mux_o, // 2'b00: ALU, 2'b01: PC+4, 2'b10: DATA_MEM
    output  logic [2:0]           branch_op_o,
    output  logic                 mem_write_o,
    output  logic                 alu_src_a_o,  // 1'b0: REG_A, 1'b1: PC
    output  logic                 alu_src_b_o,  // 1'b0: REG_B, 1'b1: IMM
    output  logic                 reg_write_o,
    output  logic [5:0]           alu_op_o,
    output  logic [4:0]           rs1_addr_o,
    output  logic [4:0]           rs2_addr_o,
    output  logic [4:0]           rd_addr_o
  );

  typedef enum logic [2:0] {
    STATE_FETCH,
    STATE_EXE_1,
    STATE_EXE_2
  } state_t;

  state_t cur_state, nxt_state;

  always_ff @( posedge clk_i or negedge rstn_i ) begin
    if (!rstn_i) begin
      cur_state <= STATE_FETCH;
    end
    else begin
      cur_state <= nxt_state;
    end
  end

  always_comb begin
    nxt_state = STATE_FETCH;

    case (cur_state)
      STATE_FETCH : nxt_state = STATE_EXE_1;
      STATE_EXE_1 : begin
        if (op == OP_LOAD || op == OP_JAL || op == OP_JALR) begin
          nxt_state = STATE_EXE_2;
        end else begin
          nxt_state = STATE_FETCH;
        end
      end
      STATE_EXE_2 : nxt_state = STATE_FETCH;
      default     : nxt_state = STATE_FETCH;
    endcase
  end

  logic [31:0] inst;
  logic [6:0] op;
  logic [2:0] funct3;
  logic [2:0] funct3_reg;
  /* verilator lint_off UNUSEDSIGNAL */
  logic [6:0] funct7;
  /* verilator lint_on UNUSEDSIGNAL */

  assign op         = inst[6:0];
  assign funct3     = inst[14:12];
  assign funct7     = inst[31:25];

  assign op_o       = op;
  assign rs2_addr_o = inst[24:20];
  assign rd_addr_o  = inst[11:7];
  assign funct3_o   = funct3_reg;

  always_ff @( posedge clk_i ) begin
    if (cur_state == STATE_FETCH) begin
      inst <= inst_i;
      funct3_reg <= inst_i[14:12];
    end
  end

  assign inst_o = inst;

  always_comb begin
    pc_en_o = 1'b0;
    read_inst = 1'b0;

    case (cur_state)

      STATE_FETCH:
      begin
        pc_en_o = 1'b0;
        read_inst = 1'b1;
      end

      STATE_EXE_1:
      begin
        if (op == OP_LOAD) begin
          pc_en_o = 1'b0;
        end
        else begin
          pc_en_o   = 1'b1;
        end
      end

      STATE_EXE_2:
      begin
        pc_en_o   = 1'b1;
      end

      default:
      begin
        pc_en_o = 1'b0;
      end

    endcase
  end

  always_comb begin

    branch_o      = '0;
    result_mux_o  = '0;
    branch_op_o   = '0;
    mem_write_o   = '0;
    alu_src_a_o   = '0;
    alu_src_b_o   = '0;
    reg_write_o   = '0;
    alu_op_o      = '0;
    rs1_addr_o    = inst[19:15];

    case (cur_state)

      STATE_FETCH:
      begin
        result_mux_o  = 2'b00;
        reg_write_o   = 1'b0;
        alu_src_a_o   = 1'b0;
        alu_src_b_o   = 1'b0;
        alu_op_o      = OP_ALU_ADD;
      end

      STATE_EXE_1:
      begin
        case (op)

          // R-type
          OP_ALU:
          begin
            result_mux_o  = 2'b00; // ALU
            reg_write_o   = 1'b1;
            alu_src_a_o   = 1'b0;  // REG_A
            alu_src_b_o   = 1'b0;  // REG_B

            case ({funct7[5], funct3})
              4'b0000:  alu_op_o = OP_ALU_ADD;
              4'b1000:  alu_op_o = OP_ALU_SUB;
              4'b0001:  alu_op_o = OP_ALU_SLL;
              4'b0010:  alu_op_o = OP_ALU_SLT;
              4'b0011:  alu_op_o = OP_ALU_SLTU;
              4'b0100:  alu_op_o = OP_ALU_XOR;
              4'b0101:  alu_op_o = OP_ALU_SRL;
              4'b1101:  alu_op_o = OP_ALU_SRA;
              4'b0110:  alu_op_o = OP_ALU_OR;
              4'b0111:  alu_op_o = OP_ALU_AND;
              default:  alu_op_o = OP_ALU_NOP;
            endcase
          end

          // B-Type
          OP_BRANCH:
          begin
            result_mux_o  = 2'b00;  // ALU
            alu_src_a_o   = 1'b1;   // PC
            alu_src_b_o   = 1'b1;   // IMM
            branch_o      = 1'b1;
            alu_op_o      = OP_ALU_ADD;

            case (funct3)
              3'b000:   branch_op_o = BRANCH_BEQ;
              3'b001:   branch_op_o = BRANCH_BNE;
              3'b100:   branch_op_o = BRANCH_BLT;
              3'b101:   branch_op_o = BRANCH_BGE;
              3'b110:   branch_op_o = BRANCH_BLTU;
              3'b111:   branch_op_o = BRANCH_BGEU;
              default:  branch_op_o = BRANCH_BEQ;
            endcase
          end

        // S-Type
        OP_STORE:
        begin
          mem_write_o = 1'b1;
          alu_src_a_o = 1'b0; // REG_A
          alu_src_b_o = 1'b1; // IMM
          alu_op_o    = OP_ALU_ADD;
        end

        // I-Type
        OP_JALR:
        begin
          result_mux_o  = 2'b01;  // PC+4
          reg_write_o   = 1'b1;
          alu_src_a_o   = 1'b0;   // REG_A
          alu_src_b_o   = 1'b1;   // IMM
          alu_op_o      = OP_ALU_ADD;
          branch_o      = 1'b1;
          branch_op_o   = BRANCH_JAL_JALR;
        end

        OP_JAL:
        begin
          result_mux_o  = 2'b01;  // PC+1
          reg_write_o   = 1'b1;
          alu_src_a_o   = 1'b1;   // PC
          alu_src_b_o   = 1'b1;   // IMM
          alu_op_o      = OP_ALU_ADD;
          branch_o      = 1'b1;
          branch_op_o   = BRANCH_JAL_JALR;
        end

        // I-Type
        OP_LOAD:
        begin
          result_mux_o  = 2'b10;  // DATA_MEM
          reg_write_o   = 1'b0;
          alu_src_a_o   = 1'b0;   // REG_A
          alu_src_b_o   = 1'b1;   // IMM
          alu_op_o      = OP_ALU_ADD;
        end

        // I-Type
        OP_ALUI:
        begin
            result_mux_o  = 2'b00; // ALU
            reg_write_o   = 1'b1;
            alu_src_a_o   = 1'b0;  // REG_A
            alu_src_b_o   = 1'b1;  // IMM

            case (funct3)
              3'b000:   alu_op_o = OP_ALU_ADD;
              3'b010:   alu_op_o = OP_ALU_SLT;
              3'b011:   alu_op_o = OP_ALU_SLTU;
              3'b100:   alu_op_o = OP_ALU_XOR;
              3'b110:   alu_op_o = OP_ALU_OR;
              3'b111:   alu_op_o = OP_ALU_AND;
              3'b001:   alu_op_o = OP_ALU_SLL;
              3'b101: begin
                if (funct7[5] == 1'b0) begin
                  alu_op_o = OP_ALU_SRL;
                end else begin
                  alu_op_o = OP_ALU_SRA;
                end
              end
              default:  alu_op_o = OP_ALU_NOP;
            endcase
        end

        // Fence (NOP)
        OP_FENCE:
        begin
          result_mux_o  = 2'b00;  // ALU
        end

        // U-Type
        OP_LUI:
        begin
          result_mux_o  = 2'b00;  // ALU
          reg_write_o   = 1'b1;
          alu_src_a_o   = 1'b0;   // REG_A
          alu_src_b_o   = 1'b1;   // IMM
          alu_op_o      = OP_ALU_ADD;
          rs1_addr_o    = '0;
        end

        // U-Type
        OP_AUIPC:
        begin
          result_mux_o  = 2'b00;  // ALU
          reg_write_o   = 1'b1;
          alu_src_a_o   = 1'b1;   // PC
          alu_src_b_o   = 1'b1;   // IMM
          alu_op_o      = OP_ALU_ADD;
        end

        OP_SYSTEM:
        begin
          result_mux_o  = 2'b00;
          reg_write_o   = 1'b0;
          alu_src_a_o   = 1'b0;
          alu_src_b_o   = 1'b0;
          alu_op_o      = OP_ALU_ADD;
        end

        default:
        begin
          result_mux_o  = 2'b00;
          reg_write_o   = 1'b0;
          alu_src_a_o   = 1'b0;
          alu_src_b_o   = 1'b0;
          alu_op_o      = OP_ALU_ADD;
        end

        endcase
      end

      STATE_EXE_2:
      begin
        if (op == OP_LOAD) begin
          result_mux_o  = 2'b10;  // DATA_MEM
          reg_write_o   = 1'b1;
          alu_src_a_o   = 1'b0;   // REG_A
          alu_src_b_o   = 1'b1;   // IMM
          alu_op_o      = OP_ALU_ADD;
        end
        else begin
          // NOP
          result_mux_o  = 2'b00;
          reg_write_o   = 1'b0;
          alu_src_a_o   = 1'b0;
          alu_src_b_o   = 1'b0;
          alu_op_o      = OP_ALU_ADD;
        end
      end

      default:
      begin
        result_mux_o  = 2'b00;
        reg_write_o   = 1'b0;
        alu_src_a_o   = 1'b0;
        alu_src_b_o   = 1'b0;
        alu_op_o      = OP_ALU_ADD;
      end

    endcase
  
  end

endmodule