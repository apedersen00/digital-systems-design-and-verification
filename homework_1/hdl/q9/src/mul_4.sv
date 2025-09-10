module mul_4 (
  input   logic [3:0]   a_i,
  input   logic [3:0]   b_i,
  output  logic [7:0]   prod_o
);

  assign prod_o = a_i * b_i;

endmodule