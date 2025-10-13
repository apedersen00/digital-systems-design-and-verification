//  data_mem #(
//    .DEPTH(),
//    .WIDTH(),
//    .INIT_FILE()
//   ) data_mem_0 (
//    .clk_i(),
//    .we_a_i(),
//    .addr_a_i(),
//    .data_a_i(),
//    .data__ao(),
//    .addr_b_i(),
//    .data_b_o()
//  );

module dual_port_bram #(
    parameter  DEPTH      = 16384,
    parameter WIDTH           = 32,
    parameter INIT_FILE       = "../programs/nostdlib/out/test_program.hex"
  ) (
    // Port A: Read/Write
    input  logic                      clk_i,
    input  logic                      we_a_i,
    input  logic [$clog2(DEPTH)-1:0]  addr_a_i,
    input  logic [WIDTH-1:0]          data_a_i,
    output logic [WIDTH-1:0]          data_a_o,

    // Port B: Read-only
    input  logic [$clog2(DEPTH)-1:0]  addr_b_i,
    output logic [WIDTH-1:0]          data_b_o
);

    logic [WIDTH-1:0] ram [0:DEPTH-1];

    initial begin
        $readmemh(INIT_FILE, ram);
    end

    always_ff @(posedge clk_i) begin
        if (we_a_i) begin
            ram[addr_a_i >> 2] <= data_a_i;
        end
        data_a_o <= ram[addr_a_i >> 2];
    end

    // Port B (read-only)
    always_ff @(posedge clk_i) begin
        data_b_o <= ram[addr_b_i >> 2];
    end

endmodule
