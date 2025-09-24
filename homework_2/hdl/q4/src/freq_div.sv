//-------------------------------------------------------------------------------------------------
//
//  File: freq_div.sv
//  Description: Frequency divider alternating between division ratios of 18 and 866.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  freq_div freq_div_0 (
//    .clk_i,
//    .rstn_i,
//    .div_o
//  );

module freq_div (
    input   logic clk_i,
    input   logic rstn_i,
    output  logic div_o
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