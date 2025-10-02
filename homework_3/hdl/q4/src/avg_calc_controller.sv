//-------------------------------------------------------------------------------------------------
//
//  File: avg_calc_controller.sv
//  Description: Average calculator datapath.
//               Parameter n MUST be a power of 2.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  avg_calc_controller #(
//    .m(),
//    .n()
//  ) avg_calc_controller_0 (
//    .clk_i(),
//    .start_i(),
//    .rstn_i(),
//    .en_dp_o(),
//    .zero_dp_o(),
//    .done_o()
//  );

module avg_calc_controller #(
    parameter n = 4   // number of inputs
  ) (
    input   logic         clk_i,
    input   logic         start_i,
    input   logic         rstn_i,
    output  logic         en_dp_o,
    output  logic         zero_dp_o,
    output  logic         done_o
  );

  typedef enum logic [1:0] {
    STATE_RESET,
    STATE_ZERO,
    STATE_RUN,
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

  always_comb begin
    nxt_state = STATE_RESET;
    case (cur_state)
      STATE_RESET : nxt_state = start_i ? STATE_ZERO : STATE_RESET;
      STATE_ZERO  : nxt_state = STATE_RUN;
      STATE_RUN   : nxt_state = (counter == '0) ? STATE_DONE : STATE_RUN;
      STATE_DONE  : nxt_state = start_i ? STATE_RUN : STATE_DONE;
      default: nxt_state = STATE_RESET;
    endcase
  end

  logic [$clog2(n)-1:0] counter;
  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      counter <= '1;
    end
    else if (cur_state == STATE_RUN | cur_state == STATE_ZERO) begin
      counter <= counter - 1;
    end
  end

  assign en_dp_o    = (cur_state == STATE_RUN | cur_state == STATE_ZERO) ? 1'b1 : 1'b0;
  assign zero_dp_o  = (cur_state == STATE_ZERO) ? 1'b1 : 1'b0;
  assign done_o     = (cur_state == STATE_DONE) ? 1'b1 : 1'b0;

endmodule