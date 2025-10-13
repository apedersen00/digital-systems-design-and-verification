module inst_mem #(
    parameter  DEPTH      = 1024,
    parameter  INIT_FILE  = "inst_mem.hex",
    localparam WIDTH      = 32 
  ) (
    input  logic                      clk_i,
    input  logic [$clog2(DEPTH)-1:0]  addr_i, // address in
    output logic [WIDTH-1:0]          inst_o  // instruction out
);
    logic [WIDTH-1:0] rom [0:DEPTH-1];

    initial begin
      $readmemh(INIT_FILE, rom);
    end

    always_ff @(posedge clk_i) begin
        inst_o <= rom[addr_i>>2];
    end

endmodule