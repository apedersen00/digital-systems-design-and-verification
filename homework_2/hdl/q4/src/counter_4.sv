//-------------------------------------------------------------------------------------------------
//
//  File: counter_4.sv
//  Description: 4-bit up/down counter.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  counter_4 counter_4_0 (
//    .clk_i(),
//    .rstn_i(),
//    .up_down_i(),
//    .en_i(),
//    .load_en_i(),
//    .load_i(),
//    .count_o(),
//    .carry_o()
//  );

module counter_4 (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         up_down_i,
    input   logic         en_i,
    input   logic         load_en_i,
    input   logic [3:0]   load_i,
    output  logic [3:0]   count_o,
    output  logic         carry_o
  );

  logic [3:0] counter;

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
        if (en_i) begin
          if (up_down_i) begin
            counter <= counter + 1;
            carry_o <= (counter == 4'd14) ? 1'b1 : 1'b0;
          end
          else begin
            counter <= counter - 1;
            carry_o <= (counter == 4'd1) ? 1'b1 : 1'b0;
          end
        end
        else begin
          counter <= counter;
          carry_o <= carry_o;
        end
      end

    end
  end

  assign count_o = counter;

endmodule