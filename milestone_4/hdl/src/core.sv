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
//    .clk_i(),
//  );

module core (
    input   logic         clk_i,
    input   logic         rstn_i,
    output  logic [31:0]  reg_o
  );

  // control signals
  logic [3:0] mem_write;
  logic alu_src_a;
  logic alu_src_b;
  logic [5:0] alu_op;
  logic branch_en;
  logic branch;
  logic [2:0] branch_op;
  logic [6:0] op;
  logic [1:0] result_mux;
  logic reg_write;
  logic read_inst;
  logic [2:0] funct3;

  // data
  logic [31:0]  alu_result;
  logic [31:0]  rs1;
  logic [31:0]  rs2;
  logic [4:0]   rs1_addr;
  logic [4:0]   rs2_addr;
  logic [4:0]   rd_addr;
  logic [31:0]  result;
  logic [31:0]  res_mux_d [2:0];
  logic [31:0]  imm;
  logic [31:0]  pc;
  logic [31:0]  pc_next;
  logic [31:0]  pc_update;
  logic [31:0]  pc_last;
  logic [31:0]  inst;
  logic [31:0]  inst_mem;
  logic [31:0]  mem_raw;
  logic [31:0]  mem_ext;
  logic         pc_en;

  // I/O
  logic mem_sel_io;
  logic [31:0] out_reg;
  assign reg_o      = out_reg;
  assign mem_sel_io = (alu_result == 32'd16384);

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      out_reg <= 32'd0;
    end
    else if (|mem_write && mem_sel_io) begin
      out_reg <= rs2;
    end
  end

  assign res_mux_d[0] = pc;  // PC + 4 for return address
  assign res_mux_d[1] = mem_ext;
  assign res_mux_d[2] = alu_result;

  always_comb begin
    result = 32'd0;
    case (result_mux)
      2'b00: result = res_mux_d[2]; // ALU
      2'b01: result = res_mux_d[0]; // PC + 4
      2'b10: result = res_mux_d[1]; // DATA_MEM
      2'b11: result = res_mux_d[2]; // Default to ALU
    endcase
  end

  assign pc_next    = pc + 32'd4;
  assign pc_update  = branch ? alu_result : pc_next;

  always_ff @( posedge clk_i or negedge rstn_i ) begin : program_counter
    if (!rstn_i) begin
      pc      <= 32'd0;
      pc_last <= 32'd0;
    end
    else begin
      if (pc_en) begin
        pc      <= pc_update;
        pc_last <= pc;
      end
    end
  end

  controller controller_0 (
    .clk_i        ( clk_i       ),
    .rstn_i       ( rstn_i      ),
    .inst_i       ( inst_mem    ),
    .funct3_o     ( funct3      ),
    .inst_o       ( inst        ),
    .read_inst    ( read_inst   ),
    .pc_en_o      ( pc_en       ),
    .op_o         ( op          ),
    .branch_o     ( branch_en   ),
    .result_mux_o ( result_mux  ),
    .branch_op_o  ( branch_op   ),
    .mem_write_o  ( mem_write   ),
    .alu_src_a_o  ( alu_src_a   ),
    .alu_src_b_o  ( alu_src_b   ),
    .reg_write_o  ( reg_write   ),
    .alu_op_o     ( alu_op      ),
    .rs1_addr_o   ( rs1_addr    ),
    .rs2_addr_o   ( rs2_addr    ),
    .rd_addr_o    ( rd_addr     )
  );

  rf rf_0 (
    .clk_i      ( clk_i       ),
    .rstn_i     ( rstn_i      ),
    .chip_en_i  ( 1'b1        ),
    .we_i       ( reg_write   ),
    .data_i     ( result      ),
    .rd_addr_i  ( rd_addr     ),
    .rs1_addr_i ( rs1_addr    ),
    .rs2_addr_i ( rs2_addr    ),
    .rs1_o      ( rs1         ),
    .rs2_o      ( rs2         )
  );

  dual_port_bram #(
    .DEPTH      ( 16384                                       ),
    .WIDTH      ( 32                                          ),
    .INIT_FILE  ( "../programs/nostdlib/out/test_program.hex" )
  ) data_mem_0 (
    .clka       ( clk_i         ),
    .wea        ( mem_write     ),
    .addra      ( alu_result    ),
    .dina       ( rs2           ),
    .clkb       ( clk_i         ),
    .enb        ( 1'b1          ),
    .addrb      ( pc            ),
    .doutb      ( inst_mem      ),
    .douta      ( mem_raw       )
  );

  mem_ext_unit mem_ext_unit_0 (
    .op_i   ( funct3          ),
    .d_i    ( mem_raw         ),
    .addr_i ( alu_result[1:0] ),
    .d_o    ( mem_ext         )
  );

  alu alu_0 (
    .op_i       ( alu_op                      ),
    .a_i        ( alu_src_a ? pc_last   : rs1 ),
    .b_i        ( alu_src_b ? imm       : rs2 ),
    .res_o      ( alu_result                  )
  );

  branch_unit branch_unit_0 (
    .op_i       ( branch_op   ),
    .branch     ( branch_en   ),
    .a_i        ( rs1         ),
    .b_i        ( rs2         ),
    .branch_o   ( branch      )
  );

  sign_ext_unit sign_ext_unit_0 (
    .inst_i     ( inst        ),
    .op_i       ( op          ),
    .imm_ext_o  ( imm         )
  );

endmodule
