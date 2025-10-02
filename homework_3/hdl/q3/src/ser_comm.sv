//-------------------------------------------------------------------------------------------------
//
//  File: ser_comm.sv
//  Description: Serial communication device.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  ser_comm ser_comm_0 (
//    .clk_i(),
//    .rstn_i(),
//    .serdata_i(),
//    .valid_o()
//  );

module ser_comm (
    input   logic clk_i,
    input   logic rstn_i,
    input   logic serdata_i,
    output  logic valid_o
  );

  typedef enum logic [2:0] {
    S0,
    S1,
    S2,
    S3,
    S4,
    S5,
    S6
  } state_t;

  state_t cur_state, nxt_state;

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      cur_state <= S0;
    end
    else begin
      cur_state <= nxt_state;
    end
  end

  always_comb begin
    nxt_state = S0;
    case (cur_state)
      S0: nxt_state = !serdata_i ? S1 : S0;
      S1: nxt_state =  serdata_i ? S2 : S0;
      S2: nxt_state =  serdata_i ? S3 : S0;
      S3: nxt_state = !serdata_i ? S4 : S0;
      S4: nxt_state =  serdata_i ? S5 : S0;
      S5: nxt_state = !serdata_i ? S6 : S0;
      S6: nxt_state = (counter == 5'b00000) ? S0 : S6;
      default: nxt_state = S0;
    endcase
  end

  logic [4:0] counter;
  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      counter <= 5'b11111;
    end
    else if (cur_state == S6) begin
      counter <= counter - 1;
    end
  end

  assign valid_o = (cur_state == S6) ? 1'b1 : 1'b0;

endmodule