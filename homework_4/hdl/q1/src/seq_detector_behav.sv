//-------------------------------------------------------------------------------------------------
//
//  File: seq_detector_behav.sv
//  Description: Sequence detector for detecting an input sequence of 5 consecutive ones.
//               A new input is received at every clock cycle. Output is asserted as long as
//               the input reamins '1'.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  seq_detector_struct seq_detector_struct_0 (
//    .clk_i(),
//    .rstn_i(),
//    .seq_i(),
//    .det_o()
//  );

module seq_detector_behav (
    input   logic clk_i,
    input   logic rstn_i,
    input   logic seq_i,
    output  logic det_o
  );

  typedef enum logic [2:0] {
    S0,
    S1,
    S2,
    S3,
    S4,
    S5
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
      S0: nxt_state = seq_i ? S1 : S0;
      S1: nxt_state = seq_i ? S2 : S0;
      S2: nxt_state = seq_i ? S3 : S0;
      S3: nxt_state = seq_i ? S4 : S0;
      S4: nxt_state = seq_i ? S5 : S0;
      S5: nxt_state = seq_i ? S5 : S0;
      default: nxt_state = S0;
    endcase
  end

  assign det_o = (cur_state == S5) ? 1'b1 : 1'b0;

endmodule