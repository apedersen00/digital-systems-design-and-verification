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
//    .seq_i(),
//    .det_o()
//  );

module sinx_controller (
    input   logic       clk_i,
    input   logic       rstn_i,
    input   logic       start_i,

    output  logic       dp_en_o,
    output  logic       dp_rst_o,
    output  logic       dp_sub_o,
    output  logic       dp_counter_o,
    output  logic       dp_mux_a_o,
    output  logic [1:0] dp_mux_b_o,

    output  logic       done_o
  );

  typedef enum logic [2:0] {
    STATE_RESET,
    STATE_CALC_0,
    STATE_CALC_1,
    STATE_CALC_2,
    STATE_DONE
  } state_t;

  state_t cur_state, nxt_state;
  logic [2:0] counter;

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      counter <= '0
    end
    else if (cur_state == S3) begin
      counter <= counter + 1;
    end
  end

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      cur_state <= STATE_RESET;
    end
    else begin
      cur_state <= nxt_state;
    end
  end

  always_comb begin
    nxt_state = S0;

    case (cur_state)

      default: nxt_state = S0;
    endcase
  end

  assign done_o       = (cur_state == STATE_DONE)   ? 1'b1 : 1'b0;
  assign dp_en_o      = (cur_state != STATE_CALC_0) ? 1'b1 : 1'b0;
  assign dp_rst_o     = (cur_state == STATE_CALC_1) ? 1'b1 : 1'b0;
  assign dp_mux_a_o   = (cur_state == STATE_CALC_0) ? 1'b1 : 1'b0;
  assign dp_counter_o = counter;

  always_comb begin
    dp_mux_b_o = '0;

    case (cur_state)
      S0: dp_mux_b_o = 2'b00;
      S1: dp_mux_b_o = 2'b01;
      S2: dp_mux_b_o = 2'b10;
      default: dp_mux_b_o = 2'b00;
    endcase
  end

endmodule