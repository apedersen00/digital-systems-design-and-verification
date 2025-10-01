//-------------------------------------------------------------------------------------------------
//
//  File: msg_converter_mealy.sv
//  Description: Message conversion module.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  msg_converter_mealy msg_converter_mealy_0 (
//    .clk_i(),
//    .rstn_i(),
//    .x_i(),
//    .z_o()
//  );

module msg_converter_mealy (
    input   logic clk_i,
    input   logic rstn_i,
    input   logic x_i,
    output  logic z_o
  );

  typedef enum logic {
    S0,
    S1
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
      S0: nxt_state = x_i ? S0 : S1;
      S1: nxt_state = x_i ? S1 : S0;
    endcase
  end

  always_comb begin
    z_o = 1'b0;

    case (cur_state)
      S0: z_o = x_i ? 1'b1 : 1'b0;
      S1: z_o = x_i ? 1'b0 : 1'b1;
    endcase
  end

endmodule