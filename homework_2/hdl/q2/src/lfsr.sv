//-------------------------------------------------------------------------------------------------
//
//  File: lfsr.sv
//  Description: Linear Feedback Shift Register (LFSR)
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  lfsr lfsr_0 (
//    .clk_i(),
//    .rstn_i(),
//    .sel_i(),
//    .parallel_i(),
//    .parallel_o()
//  );

module lfsr (
    input   logic       clk_i,
    input   logic       rstn_i,
    input   logic       sel_i,
    input   logic [5:0] parallel_i,
    output  logic [5:0] parallel_o
  );

  logic [5:0] shift_reg;

  always_ff @( posedge clk_i or negedge rstn_i ) begin : blockName
    if (!rstn_i) begin
      shift_reg <= '0;
    end
    else begin
      if (!sel_i) begin
        shift_reg <= parallel_i;
      end
      else begin
        shift_reg[0] <= shift_reg[5];
        shift_reg[1] <= shift_reg[0] ^ shift_reg[5];
        shift_reg[2] <= shift_reg[1];
        shift_reg[3] <= shift_reg[2] ^ shift_reg[5];
        shift_reg[4] <= shift_reg[3];
        shift_reg[5] <= shift_reg[4];
      end
    end
  end

  assign parallel_o = shift_reg;

endmodule