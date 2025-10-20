//  top5_a top5_a_0 (
//    .clk(),
//    .rst_n(),
//    .a(),
//    .b(),
//    .z()
//  );

module top5_a (
  input   logic clk,
  input   logic rst_n,
  input   logic a,
  input   logic b,
  output  logic z
);

  logic q;
  logic q_next, t;
  logic x, y;
  
  always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
      q <= 0;
      t <= 0;
    end else begin
      t <= x;
      q <= q_next;
    end
  end
  
  always_comb begin
    x      = !b;
    y      = t | a;
    q_next = y;
  end

  assign z = q;

endmodule