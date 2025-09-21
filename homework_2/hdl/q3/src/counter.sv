//-------------------------------------------------------------------------------------------------
//
//  File: counter.sv
//  Description: N-bit up/down counter.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  counter #(
//    .N()
//  ) counter_0 (
//    .clk_i(),
//    .rstn_i(),
//    .up_down_i(),
//    .load_en_i(),
//    .load_i(),
//    .count_o(),
//    .carry_o()
//  );

module counter #(
    parameter N = 8
  ) (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         up_down_i,
    input   logic         load_en_i,
    input   logic [N-1:0] load_i,
    output  logic [N-1:0] count_o,
    output  logic         carry_o
  );

  logic [N-1:0] counter;

  always_ff @( posedge clk_i or negedge rstn_i ) begin : count_incr
    if (!rstn_i) begin
      counter <= '0;
      carry_o <= 1'b0;
    end

    else begin
      if (load_en_i) begin
        counter <= load_i;
        carry_o <= 1'b0;
      end

      else begin
        if (up_down_i) begin
          counter <= counter + 1;
          carry_o <= (counter == '1) ? 1'b1 : 1'b0;
        end
        else begin
          counter <= counter - 1;
          carry_o <= (counter == '0) ? 1'b1 : 1'b0;
        end
      end

    end
  end

  assign count_o = counter;

endmodule