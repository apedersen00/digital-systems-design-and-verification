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

module bram_64kb #(
    parameter string INIT_FILE = "rams_init_file.data"  // initialization file
) (
    input   logic         clk_i,
    input   logic         en_i,
    input   logic         we_i,
    input   logic [13:0]  addr_i,
    input   logic [31:0]  d_i,
    output  logic [31:0]  d_o
  );

  logic [31:0] ram [0:16383];

  initial begin
    if (INIT_FILE != "") begin
      $readmemh(INIT_FILE, ram);
    end
  end

  always_ff @(posedge clk_i) begin
    if (en_i) begin
      d_o <= ram[addr_i];
      if (we_i) begin
        ram[addr_i] <= d_i;
      end
    end
  end

endmodule
