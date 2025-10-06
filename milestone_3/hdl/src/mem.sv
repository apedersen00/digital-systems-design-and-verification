//-------------------------------------------------------------------------------------------------
//
//  File: mem.sv
//  Description: BRAM and controller.
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

//  bram_64kib bram_64kib_0 (
//    .clk_i(),
//    .en_i(),
//    .we_i(),
//    .addr_i(),
//    .d_i(),
//    .d_o()
//  );

module bram_64kib (
    input   logic         clk_i,
    input   logic         en_i,
    input   logic         we_i,
    input   logic [13:0]  addr_i,
    input   logic [31:0]  d_i,
    output  logic [31:0]  d_o
  );

  logic [31:0] ram [0:63];

  initial begin
    $readmemb("rams_init_file.data", ram);
  end

  always_ff @( posedge clk_i ) begin
    if ( en_i ) begin
      d_o <= ram[addr_i];
      if ( we_i ) begin
        ram[addr_i] <= d_i;
      end
    end
  end

endmodule

