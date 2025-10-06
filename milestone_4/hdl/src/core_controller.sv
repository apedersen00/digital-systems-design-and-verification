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

module core_dp (
    input   logic         clk_i,
    input   logic         rstn_i

    // register file control
    output  logic         en_rf_o,
    output  logic         we_rf_o,
    output  logic         sel_rf_o,

    // program counter control
    output  logic         en_pc_o,
    output  logic         rstn_pc_o,
    output  logic         load_pc_o,

    // instruction register control
    output  logic         we_ir_o,

    // memory address register control
    output  logic         load_addr_reg_o,

    // ALU control
    output  logic         sel_alu_port_a_o,
    output  logic         sel_alu_port_b_o,
    output  logic [2:0]   alu_op_o,

    // memory control
    output  logic         we_mem_o,
    output  logic         re_mem_o,
  );

  logic [31:0] ir;

  typedef enum logic [2:0] {
    STATE_FETCH,
    STATE_EXE_1,
    STATE_EXE_2
  } state_t;

  state_t cur_state, nxt_state;

  always_ff @( posedge clk_i ) begin
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
      STATE_EXE_1 : nxt_state = STATE_EXE_2;
      STATE_EXE_2 : nxt_state = STATE_FETCH;
      default: nxt_state = STATE_FETCH;
    endcase
  end

  // ADD HUUGE DECODER
  always_comb begin

    case (cur_state)

      STATE_FETCH: begin
        we_ir_o = 1'b1;
        en_pc_i = 1'b1;
      end

    endcase

  end

endmodule
