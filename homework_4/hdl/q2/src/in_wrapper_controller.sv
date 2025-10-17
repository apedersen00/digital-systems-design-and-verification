//-------------------------------------------------------------------------------------------------
//
//  File: in_wrapper_controller.sv
//  Description: Controller for input wrapper for IMC.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  in_wrapper_controller in_wrapper_controller_0 (
//    .clk_i(),
//    .rstn_i(),
//    .data_ready_i(),
//    .imc_ready_i(),
//    .data_accept_o(),
//    .imc_start_o(),
//    .en_a_o(),
//    .en_b_o(),
//    .en_c_o(),
//    .en_d_o()
//  );

module in_wrapper_controller (
    input   logic clk_i,
    input   logic rstn_i,
    input   logic data_ready_i,
    input   logic imc_ready_i,
    output  logic data_accept_o,
    output  logic imc_start_o,
    output  logic en_a_o,
    output  logic en_b_o,
    output  logic en_c_o,
    output  logic en_d_o
  );

  typedef enum logic [2:0] {
    STATE_IDLE,
    STATE_COLLECT,
    STATE_ACCEPT,
    STATE_WAIT_IMC,
    STATE_START_IMC
  } state_t;

  state_t cur_state, nxt_state;

  logic [1:0] data_count;

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      cur_state <= STATE_IDLE;
    end else begin
      cur_state <= nxt_state;
    end
  end

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      data_count <= 2'd0;
    end
    else begin
      if (cur_state == STATE_ACCEPT) begin
        data_count <= data_count + 2'd1;
      end
      else if (cur_state == STATE_IDLE) begin
        data_count <= 2'd0;
      end
    end
  end

  always_comb begin
    nxt_state = STATE_IDLE;

    case (cur_state)
      STATE_IDLE:
      begin
        nxt_state = data_ready_i ? STATE_COLLECT : STATE_IDLE;
      end

      STATE_COLLECT:
      begin
        if (data_ready_i) begin
          nxt_state = STATE_ACCEPT;
        end
        else begin
          nxt_state = STATE_COLLECT;
        end
      end

      STATE_ACCEPT:
      begin
        if (data_count == 2'b11) begin
          nxt_state = imc_ready_i ? STATE_START_IMC : STATE_WAIT_IMC;
        end
        else begin
          nxt_state = STATE_COLLECT;
        end
      end

      STATE_WAIT_IMC:
      begin
        nxt_state = imc_ready_i ? STATE_START_IMC : STATE_WAIT_IMC;
      end

      STATE_START_IMC:
      begin
        nxt_state = STATE_IDLE;
      end

      default:
      begin
        nxt_state = STATE_IDLE;
      end
    endcase
  end

  always_comb begin
    en_a_o        = 1'b0;
    en_b_o        = 1'b0;
    en_c_o        = 1'b0;
    en_d_o        = 1'b0;
    imc_start_o   = 1'b0;
    data_accept_o = 1'b0;

    if ((cur_state == STATE_COLLECT) && data_ready_i) begin
      case (data_count)
        2'd0: en_a_o = 1'b1;
        2'd1: en_b_o = 1'b1;
        2'd2: en_c_o = 1'b1;
        2'd3: en_d_o = 1'b1;
        default:
        begin
          en_a_o = 1'b0;
          en_b_o = 1'b0;
          en_c_o = 1'b0;
          en_d_o = 1'b0;
        end
      endcase
    end

  if (cur_state == STATE_ACCEPT) begin
    data_accept_o = 1'b1;
  end

  if (cur_state == STATE_START_IMC) begin
    imc_start_o = 1'b1;
  end

  end

endmodule