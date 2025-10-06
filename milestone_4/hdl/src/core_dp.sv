//-------------------------------------------------------------------------------------------------
//
//  File: core_dp.sv
//  Description: CPU core datapath.
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

//  core core_0 (
//    .clk_i()
//  );

module core_dp (
    input   logic         clk_i,

    // register file control
    input   logic         en_rf_i,
    input   logic         we_rf_i,
    input   logic         sel_rf_i,

    // program counter control
    input   logic         en_pc_i,
    input   logic         rstn_pc_i,
    input   logic         load_pc_i,

    // instruction register control
    input   logic         we_ir_i,

    // memory address register control
    input   logic         load_addr_reg_i,

    // ALU control
    input   logic         sel_alu_port_a_i,
    input   logic         sel_alu_port_b_i,
    input   logic [2:0]   alu_op_i,

    // memory control
    input   logic         we_mem_i,
    input   logic         re_mem_i,

    // data in
    input   logic [31:0]  imm_i,
    input   logic [31:0]  mem_i,
    input   logic [31:0]  rf_data_i,
    input   logic [4:0]   rf_addr_a_i,
    input   logic [4:0]   rf_addr_b_i,

    // data out
    output  logic [2:0]   alu_flag_o
  );

  logic [31:0] alu_port_a;
  logic [31:0] alu_port_b;
  logic [31:0] rf_port;
  logic [31:0] alu_result;
  logic [31:0] mem_i;

  logic [31:0] rf_a;
  logic [31:0] rf_b;
  logic [31:0] pc;

  always_comb begin : alu_select
    alu_port_a  = '0;
    alu_port_b  = '0;
    rf_port     = '0;

    case (sel_alu_port_a_i)
        1'b0  : alu_port_a = rf_a;
        1'b1  : alu_port_a = pc;
      default : alu_port_a = '0;
    endcase

    case (sel_alu_port_b_i)
        1'b0  : alu_port_b = rf_b;
        1'b1  : alu_port_b = imm_i;
      default : alu_port_b = '0;
    endcase

    case (sel_rf_i)
        1'b0  : rf_port = alu_result;
        1'b1  : rf_port = mem_i;
      default : rf_port = '0;
    endcase
  end

  mem_64kib mem_64kib_0 (
    .clk_i(clk_i),
    .read_en_i(re_mem_i),
    .addr_i(),
    .d_i(),
    .d_o(),
    .ready_o()
  );

  pc pc_0 (
    .clk_i(clk_i),
    .rstn_i(rstn_pc_i),
    .en_i(en_pc_i),
    .count_o()
  );

  alu alu_0 #(
    .BW(32)
  ) (
    .in_a(alu_port_a),
    .in_b(alu_port_b),
    .opcode(alu_op_i),
    .out(),
    .flags(alu_flag_o)
  );

  rf #(
    .BW(32),
    .DEPTH()
  ) rf_0 (
    .clk(clk_i),
    .rst_n(1'b0),
    .data_in(rf_port),
    .read_addr_1(rf_addr_a_i),
    .read_addr_2(rf_addr_b_i),
    .write_addr(rf_addr_a_i),
    .write_en_n(we_rf_i),
    .chip_en(1'b1),
    .data_out_1(alu_port_a),
    .data_out_2(alu_port_b)
  );

endmodule
