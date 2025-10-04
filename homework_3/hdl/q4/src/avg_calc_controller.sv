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
      STATE_RESET : nxt_state = start_i ? STATE_RUN : STATE_RESET;
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
    else if (cur_state == STATE_RUN) begin
      counter <= counter - 1;
    end
  end

  always_comb begin
    en_dp_o   = 1'b0;
    zero_dp_o = 1'b0;
    done_o    = 1'b0;
    case (cur_state)
      STATE_RESET : begin
        en_dp_o   = start_i ? 1'b1 : 1'b0;
        zero_dp_o = start_i ? 1'b1 : 1'b0;
        done_o    = 1'b0;
      end
      STATE_RUN   : begin
        en_dp_o   = (counter == '0) ? 1'b0 : 1'b1;
        zero_dp_o = 1'b0;
        done_o    = (counter == '0) ? 1'b1 : 1'b0;
      end
      STATE_DONE  : begin
        en_dp_o   = 0'b0;
        zero_dp_o = 0'b0;
        done_o    = 1'b1;
      end
      default     : begin
        en_dp_o   = 0'b0;
        zero_dp_o = 0'b0;
        done_o    = 1'b0;
      end
    endcase
  end

endmodule