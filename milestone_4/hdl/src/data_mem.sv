//  data_mem #(
//    .DEPTH()
//   ) data_mem_0 (
//    .clk_i(),
//    .we_i(),
//    .addr_i(),
//    .data_i(),
//    .data_o()
//  );

module data_mem #(
    parameter  DEPTH      = 16384,
    localparam WIDTH      = 32,
    localparam INIT_FILE  = "../programs/nostdlib/out/test_program.hex"
  ) (
    input  logic                      clk_i,
    input  logic                      we_i,
    input  logic [$clog2(DEPTH)-1:0]  addr_i,
    input  logic [WIDTH-1:0]          data_i,
    output logic [WIDTH-1:0]          data_o
);
    logic [WIDTH-1:0] ram [0:DEPTH-1];

    initial begin
      $readmemh(INIT_FILE, ram);
    end

    always_ff @(posedge clk_i) begin
      if (we_i == 1'b1) begin
        ram[addr_i>>2] <= data_i;
      end
      data_o <= ram[addr_i>>2];
    end

endmodule