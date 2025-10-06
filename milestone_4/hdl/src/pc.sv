//-------------------------------------------------------------------------------------------------
//
//  File: pc.sv
//  Description: Program counter.
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

//  pc pc_0 (
//    .clk_i(),
//    .rstn_i(),
//    .en_i(),
//    .count_o()
//  );

module pc (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         en_i,
    output  logic [31:0]  count_o
  );

  logic [31:0] counter;

  always_ff @( posedge clk_i | negedge rstn_i ) begin : count
    if (!rstn_i) begin
      counter <= '0;
    end
    else begin
      if (en_i) begin
        counter <= counter + 1;
      end
    end
  end

endmodule

