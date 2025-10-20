//  top5_b top5_b_0 (
//    .clk(),
//    .rst_n(),
//    .a(),
//    .b(),
//    .z1()
//  );

module top5_b (
  input   logic clk,
  input   logic rst_n,
  input   logic a,
  input   logic b,
  output  logic z1
);

  logic x,y,t;
  always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
      z1 <= 0;
    end else begin
      x  = !b;
      y  = x | a;
      z1 <= y;
    end
  end

endmodule