//-------------------------------------------------------------------------------------------------
//
//  File: clk_div.sv
//  Description: Parameterized clock divider
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

//  clk_div clk_div_0 #(
//    .DIVISOR()
//  ) (
//    .rst_n(),
//    .clk_i(),
//    .clk_o()
//  );

module clk_div #(
    parameter DIVISOR = 2
  ) (
    input  logic rst_n,
    input  logic clk_i,
    output logic clk_o
  );

  logic [$clog2(DIVISOR)-1:0] counter;

  always_ff @(posedge clk_i or negedge rst_n) begin
    if (!rst_n) begin
      counter <= DIVISOR;
      clk_o <= 0;
    end else begin
      if (counter == 0) begin
        counter <= DIVISOR;
        clk_o <= ~clk_o;
      end else begin
        counter <= counter - 1;
      end
    end
  end

endmodule