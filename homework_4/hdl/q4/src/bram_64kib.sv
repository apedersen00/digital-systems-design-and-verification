//-------------------------------------------------------------------------------------------------
//
//  File: mem_bram.sv
//  Description: BRAM template.
//  References: https://docs.amd.com/r/en-US/ug901-vivado-synthesis/Initializing-Block-RAM-From-an-External-Data-File-Verilog
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

//  bram_64kib #(
//    .INIT_FILE()
//  ) bram_64kib_0 (
//    .clk_i(),
//    .en_i(),
//    .we_i(),
//    .addr_i(),
//    .d_i(),
//    .d_o()
//  );

module bram_64kib #(
    parameter WIDTH     = 32,
    parameter DEPTH     = 16384,
    parameter INIT_FILE = ""
  ) (
    input   logic         clk_i,
    input   logic         en_i,
    input   logic [3:0]   we_i,
    input   logic [31:0]  addr_i,
    input   logic [31:0]  d_i,
    output  logic [31:0]  d_o
  );

  logic [WIDTH-1:0] mem [0:DEPTH-1];

  initial begin
      if (INIT_FILE != "") begin
          $display("Loading memory from %s", INIT_FILE);
          $readmemh(INIT_FILE, mem);
      end
  end

  always_ff @( posedge clk_i ) begin
    if (en_i) begin
      if (|we_i) begin
          for (int i = 0; i < 4; i++) begin
              if (we_i[i]) begin
                  mem[(addr_i >> 2) % DEPTH][i*8 +: 8] <= d_i[i*8 +: 8];
              end
          end
      end
      d_o <= mem[(addr_i >> 2) % DEPTH];
    end
  end

endmodule