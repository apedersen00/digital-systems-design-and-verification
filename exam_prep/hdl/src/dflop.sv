module dflop (
  input  logic in, clk, rst_n,
  output logic out
);

  always_ff @( posedge clk, negedge rst_n ) begin
    if (!rst_n) begin
      out <= 0;
    end else begin
      out <= in;
    end
  end

endmodule