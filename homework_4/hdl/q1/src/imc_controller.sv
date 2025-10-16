//-------------------------------------------------------------------------------------------------
//
//  File: imc_controller.sv
//  Description: Controller of Inverse Matric Calculator.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  imc_controller imc_controller_0 (
//    // data inputs
//    .clk_i(),
//    .rstn_i(),
//    .start_i(),
//    // control signals
//    .en_a_o(),
//    .en_b_o(),
//    .en_c_o(),
//    .en_d_o(),
//    .en_det_o(),
//    .en_term_o(),
//    .sel_a_o(),
//    .sel_b_o(),
//    .sel_c_o(),
//    .sel_d_o(),
//    .sel_mul_a_0_o(),
//    .sel_mul_b_0_o(),
//    .sel_mul_a_1_o(),
//    .sel_mul_b_1_o(),
//    // outputs
//    .ready_o()
//  );

module imc_controller (
    // data inputs
    input   logic clk_i,
    input   logic rstn_i,
    input   logic start_i,
    // control signals
    output  logic en_a_o,         // enable reg
    output  logic en_b_o,         // enable reg
    output  logic en_c_o,         // enable reg
    output  logic en_d_o,         // enable reg
    output  logic en_det_o,       // enable reg
    output  logic en_term_o,      // enable reg
    output  logic sel_a_o,        // 1'b0: a_i, 1'b1: mul_0
    output  logic sel_b_o,        // 1'b0: b_i, 1'b1: mul_1
    output  logic sel_c_o,        // 1'b0: c_i, 1'b1: mul_0
    output  logic sel_d_o,        // 1'b0: d_i, 1'b1: mul_1
    output  logic sel_mul_a_0_o,  // 1'b0: a  , 1'b1: c_val
    output  logic sel_mul_b_0_o,  // 1'b0: d  , 1'b1: term
    output  logic sel_mul_a_1_o,  // 1'b0: b  , 1'b1: a
    output  logic sel_mul_b_1_o,  // 1'b0: c  , 1'b1: term
    // outputs
    output  logic ready_o
  );

  typedef enum logic [2:0] {
    STATE_RESET,
    STATE_START,
    STATE_DET,
    STATE_TERM,
    STATE_MAT_1,
    STATE_MAT_2,
    STATE_READY
  } state_t;

  state_t cur_state, nxt_state;

  always_ff @( posedge clk_i or negedge rstn_i ) begin
    if (!rstn_i) begin
      cur_state <= STATE_RESET;
    end
    else begin
      cur_state <= nxt_state;
    end
  end

  always_comb begin : next_state
    nxt_state = STATE_RESET;

    case (cur_state)
      STATE_RESET : nxt_state = start_i ? STATE_START : STATE_RESET;
      STATE_START : nxt_state = STATE_DET;
      STATE_DET   : nxt_state = STATE_TERM;
      STATE_TERM  : nxt_state = STATE_MAT_1;
      STATE_MAT_1 : nxt_state = STATE_MAT_2;
      STATE_MAT_2 : nxt_state = STATE_READY;
      STATE_READY : nxt_state = start_i ? STATE_START : STATE_READY;
      default     : nxt_state = STATE_RESET;
    endcase
  end

  always_comb begin : outputs
    en_a_o        = 1'b0;
    en_b_o        = 1'b0;
    en_c_o        = 1'b0;
    en_d_o        = 1'b0;
    en_det_o      = 1'b0;
    en_term_o     = 1'b0;
    sel_a_o       = 1'b0;
    sel_b_o       = 1'b0;
    sel_c_o       = 1'b0;
    sel_d_o       = 1'b0;
    sel_mul_a_0_o = 1'b0;
    sel_mul_b_0_o = 1'b0;
    sel_mul_a_1_o = 1'b0;
    sel_mul_b_1_o = 1'b0;
    ready_o       = 1'b0;

    case (cur_state)

      STATE_START:
      begin
        en_a_o      = 1'b1;
        en_b_o      = 1'b1;
        en_c_o      = 1'b1;
        en_d_o      = 1'b1;
      end

      STATE_DET:
      begin
        en_det_o    = 1'b1;
      end

      STATE_TERM:
      begin
        en_term_o   = 1'b1;
      end

      STATE_MAT_1:
      begin
        en_a_o        = 1'b1;
        en_d_o        = 1'b1;
        sel_a_o       = 1'b1; // mul_0
        sel_d_o       = 1'b1; // mul_1
        sel_mul_a_0_o = 1'b1; // term
        sel_mul_a_1_o = 1'b1; // a
        sel_mul_b_1_o = 1'b1; // term
      end

      STATE_MAT_2:
      begin
        en_b_o        = 1'b1;
        en_c_o        = 1'b1;
        sel_b_o       = 1'b1; // mul_1
        sel_c_o       = 1'b1; // mul_0
        sel_mul_a_0_o = 1'b1; // term
        sel_mul_b_0_o = 1'b1; // c_val
        sel_mul_b_1_o = 1'b1; // term
      end

      STATE_READY:
      begin
        ready_o       = 1'b1;
      end

      default:
      begin
        ready_o       = 1'b0;
      end

    endcase

  end

endmodule