//-------------------------------------------------------------------------------------------------
//
//  File: sinx_controller.sv
//  Description:
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  sinx_controller sinx_controller_0 (
//    .clk_i(),
//    .rstn_i(),
//    .start_i(),
//    .dp_en_temp_reg_o(),
//    .dp_en_term_reg_o(),
//    .dp_en_sum_reg_o(),
//    .dp_sub_o(),
//    .dp_mux_a_o(),
//    .dp_mux_b_o(),
//    .dp_counter_o(),
//    .done_o()
//  );

module sinx_controller (
    input   logic       clk_i,
    input   logic       rstn_i,
    input   logic       start_i,

    output  logic       dp_en_temp_reg_o,
    output  logic       dp_en_term_reg_o,
    output  logic       dp_en_sum_reg_o,
    output  logic       dp_zero_sum_o,
    output  logic       dp_sub_o,
    output  logic       dp_mux_a_o,
    output  logic [1:0] dp_mux_b_o,
    output  logic [2:0] dp_counter_o,

    output  logic       done_o
  );

  typedef enum logic [2:0] {
    STATE_RESET,
    STATE_INIT,
    STATE_CALC_0,
    STATE_CALC_1,
    STATE_CALC_2,
    STATE_DONE
  } state_t;

  state_t cur_state, nxt_state;
  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      cur_state <= STATE_RESET;
    end
    else begin
      cur_state <= nxt_state;
    end
  end

  logic [2:0] counter;
  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      counter <= '0;
    end
    else if (cur_state == STATE_CALC_2 | cur_state == STATE_INIT) begin
      counter <= counter + 1;
    end
  end

  always_comb begin
    nxt_state = STATE_RESET;
    case (cur_state)
      STATE_RESET : nxt_state = start_i           ? STATE_INIT    : STATE_RESET;
      STATE_INIT  : nxt_state = STATE_CALC_0;
      STATE_CALC_0: nxt_state = STATE_CALC_1;
      STATE_CALC_1: nxt_state = STATE_CALC_2;
      STATE_CALC_2: nxt_state = (counter == 3'd7) ? STATE_DONE    : STATE_CALC_0;
      STATE_DONE  : nxt_state = start_i           ? STATE_INIT    : STATE_DONE;
      default     : nxt_state = STATE_RESET;
    endcase
  end

  // 2'b00: mul_a = x_i;
  // 2'b01: mul_a = temp_reg;
  // 2'b10: mul_a = 16'd1;

  // 2'b00: mul_b = x_i;
  // 2'b01: mul_b = lut;
  // 2'b10: mul_b = term_reg;

  always_comb begin
    case (cur_state)

      STATE_RESET : begin
        dp_en_temp_reg_o  = 1'b0;
        dp_en_term_reg_o  = 1'b0;
        dp_en_sum_reg_o   = 1'b0;
        dp_zero_sum_o     = 1'b0;
        dp_mux_a_o        = 1'b0;
        dp_mux_b_o        = 2'b00;
      end

      STATE_INIT  : begin
        dp_en_temp_reg_o  = 1'b0;
        dp_en_term_reg_o  = 1'b1;
        dp_en_sum_reg_o   = 1'b1;
        dp_zero_sum_o     = 1'b1;
        dp_mux_a_o        = 1'b0;   // x
        dp_mux_b_o        = 2'b01;  // LUT (1)
      end

      STATE_CALC_0 : begin
        dp_en_temp_reg_o  = 1'b1;
        dp_en_term_reg_o  = 1'b0;
        dp_en_sum_reg_o   = 1'b0;
        dp_zero_sum_o     = 1'b0;
        dp_mux_a_o        = 1'b0;   // x
        dp_mux_b_o        = 2'b00;  // x
      end

      STATE_CALC_1 : begin
        dp_en_temp_reg_o  = 1'b1;
        dp_en_term_reg_o  = 1'b0;
        dp_en_sum_reg_o   = 1'b0;
        dp_zero_sum_o     = 1'b0;
        dp_mux_a_o        = 1'b1;   // temp (x^2)
        dp_mux_b_o        = 2'b10;  // T_n
      end

      STATE_CALC_2 : begin
        dp_en_temp_reg_o  = 1'b0;
        dp_en_term_reg_o  = 1'b1;
        dp_en_sum_reg_o   = 1'b1;
        dp_zero_sum_o     = 1'b0;
        dp_mux_a_o        = 1'b1;   // temp (x^2 * T_n)
        dp_mux_b_o        = 2'b01;  // LUT
      end

      STATE_DONE  : begin
        dp_en_temp_reg_o  = 1'b0;
        dp_en_term_reg_o  = 1'b0;
        dp_en_sum_reg_o   = 1'b0;
        dp_zero_sum_o     = 1'b0;
        dp_mux_a_o        = 1'b0;
        dp_mux_b_o        = 2'b00;
      end

      default     : begin
        dp_en_temp_reg_o  = 1'b0;
        dp_en_term_reg_o  = 1'b0;
        dp_en_sum_reg_o   = 1'b0;
        dp_zero_sum_o     = 1'b0;
        dp_mux_a_o        = 1'b0;
        dp_mux_b_o        = 2'b00;
      end

    endcase
  end

  assign dp_counter_o = counter;
  assign dp_sub_o     = counter[0];
  assign done_o       = (cur_state == STATE_DONE) ? 1'b1 : 1'b0;

endmodule