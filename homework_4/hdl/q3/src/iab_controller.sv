//-------------------------------------------------------------------------------------------------
//
//  File: iab_controller.sv
//  Description: Controller for input wrapper for IMC.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  iab_controller iab_controller_0 (
//    .clk_i(),
//    .rstn_i(),
//    .a_ready_i(),
//    .bus_grant_i(),
//    .accepted_i(),
//    .acceped_a_o(),
//    .bus_req_o(),
//    .ready_o(),
//    .drive_bus_o(),
//    .latch_o(),
//    .mux_o()
//  );

module iab_controller (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         a_ready_i,
    input   logic         bus_grant_i,
    input   logic         accepted_i,
    output  logic         accepted_a_o,
    output  logic         bus_req_o,
    output  logic         ready_o,
    output  logic         drive_bus_o,
    output  logic         latch_o,
    output  logic [2:0]   mux_o
  );

  typedef enum logic [2:0] {
    STATE_IDLE,
    STATE_COLLECT,
    STATE_ACCEPT,
    STATE_REQUEST_BUS,
    STATE_TRANSMIT
  } state_t;

  state_t cur_state, nxt_state;

  logic [2:0] data_count;

  always_ff @( posedge clk_i or negedge rstn_i ) begin : state_update
    if (!rstn_i) begin
      cur_state <= STATE_IDLE;
    end
    else begin
      cur_state <= nxt_state;
    end
  end

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      data_count <= 3'd0;
    end
    else begin
      if (cur_state == STATE_TRANSMIT && accepted_i)
      begin
        data_count <= data_count + 3'd1;
      end
      else if (cur_state == STATE_IDLE)
      begin
        data_count <= 3'd0;
      end
    end
  end

  always_comb begin
    nxt_state = STATE_IDLE;

    case (cur_state)
      STATE_IDLE:
      begin
        nxt_state = a_ready_i ? STATE_COLLECT : STATE_IDLE;
      end

      STATE_COLLECT:
      begin
        if (a_ready_i) begin
          nxt_state = STATE_ACCEPT;
        end
        else begin
          nxt_state = STATE_COLLECT;
        end
      end

      STATE_ACCEPT:
      begin
        nxt_state = STATE_REQUEST_BUS;
      end

      STATE_REQUEST_BUS:
      begin
        nxt_state = bus_grant_i ? STATE_TRANSMIT : STATE_REQUEST_BUS;
      end

      STATE_TRANSMIT:
      begin
        if (data_count == 3'b111 && accepted_i) begin
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

  always_comb begin
    accepted_a_o = 1'b0;
    bus_req_o   = 1'b0;
    ready_o     = 1'b0;
    drive_bus_o = 1'b0;
    latch_o     = 1'b0;

    case (cur_state)
      STATE_COLLECT:
      begin
        latch_o       = 1'b1;
      end

      STATE_ACCEPT:
      begin
        accepted_a_o = 1'b1;
      end

      STATE_REQUEST_BUS:
      begin
        bus_req_o     = 1'b1;
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

  assign mux_o = data_count;

endmodule