//-------------------------------------------------------------------------------------------------
//
//  File: out_wrapper_controller.sv
//  Description: Controller for input wrapper for IMC.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  out_wrapper_controller out_wrapper_controller_0 (
//    .clk_i(),
//    .rstn_i(),
//    .imc_ready_i(),
//    .start_transmit_i(),
//    .grant_i(),
//    .accepted_i(),
//    .avail_o(),
//    .request_o(),
//    .ready_o(),
//    .drive_bus_o(),
//    .latch_imc_o(),
//    .data_mux_o()
//  );

module out_wrapper_controller (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         imc_ready_i,
    input   logic         start_transmit_i,
    input   logic         grant_i,
    input   logic         accepted_i,
    output  logic         avail_o,
    output  logic         request_o,
    output  logic         ready_o,
    output  logic         drive_bus_o,
    output  logic         latch_imc_o,
    output  logic [1:0]   data_mux_o
  );

  typedef enum logic [2:0] {
    STATE_IDLE,
    STATE_READY,
    STATE_REQUEST_BUS,
    STATE_TRANSMIT
  } state_t;

  state_t cur_state, nxt_state;

  logic [1:0]   data_count;

  always_ff @( posedge clk_i or negedge rstn_i ) begin : state_update
    if (!rstn_i) begin
      cur_state <= STATE_IDLE;
    end
    else begin
      cur_state <= nxt_state;
    end
  end

  always_ff @(posedge clk_i or negedge rstn_i ) begin : data_count_incr
    if (!rstn_i) begin
      data_count <= 2'd0;
    end
    else begin
      if (cur_state == STATE_TRANSMIT && accepted_i) begin
        data_count <= data_count + 1;
      end
    end
  end

  always_comb begin : next_state
    nxt_state = STATE_IDLE;

    case (cur_state)
      STATE_IDLE:
      begin
        nxt_state = imc_ready_i ? STATE_READY : STATE_IDLE;
      end

      STATE_READY:
      begin
        nxt_state = start_transmit_i ? STATE_REQUEST_BUS : STATE_READY;
      end

      STATE_REQUEST_BUS:
      begin
        nxt_state = grant_i ? STATE_TRANSMIT : STATE_REQUEST_BUS;
      end

      STATE_TRANSMIT:
      begin
        if (data_count == 2'b11 && accepted_i) begin
          nxt_state = STATE_IDLE;
        end
        else begin
          nxt_state = STATE_TRANSMIT;
        end
      end

      default:
      begin
        nxt_state = STATE_IDLE;
      end
    endcase
  end

  always_comb begin: outputs
    avail_o     = 1'b0;
    request_o   = 1'b0;
    ready_o     = 1'b0;
    drive_bus_o = 1'b0;
    latch_imc_o = 1'b0;

    case (cur_state)
      STATE_READY:
      begin
        avail_o     = 1'b1;
        latch_imc_o = 1'b1;
      end

      STATE_REQUEST_BUS:
      begin
        request_o   = 1'b1;
      end

      STATE_TRANSMIT:
      begin
        ready_o     = 1'b1;
        drive_bus_o = 1'b1;
      end

      default:
      begin
        ready_o     = 1'b0;
      end
    endcase
  end

  assign data_mux_o = data_count;

endmodule