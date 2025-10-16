//-------------------------------------------------------------------------------------------------
//
//  File: seq_detector_struct.sv
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

module seq_detector_struct (
    input   logic clk_i,
    input   logic rstn_i,
    input   logic seq_i,
    output  logic det_o
  );

  logic [2:0] Q;
  logic [2:0] D;

  assign D[2] = (Q[1] & Q[0] & seq_i) | (Q[2] & seq_i);
  assign D[1] = (Q[1] & ~Q[0] & seq_i) | (~Q[2] & ~Q[1] & Q[0] & seq_i);
  assign D[0] = (~Q[0] & seq_i) | Q[2] & seq_i;

  assign det_o = Q[2] & Q[0];

  always_ff @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
      Q <= 3'b000;
    end
    else begin
      Q <= D;
    end
  end

endmodule