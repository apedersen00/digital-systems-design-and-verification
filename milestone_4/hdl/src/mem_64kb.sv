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

//  mem_64kib mem_64kib_0 (
//    .clk_i(),
//    .read_en_i(),
//    .addr_i(),
//    .d_i(),
//    .d_o(),
//    .ready_o()
//  );

module mem_64kb (
    input   logic         clk_i,
    input   logic         re_i,
    input   logic [31:0]  addr_i,
    input   logic [31:0]  d_i,
    output  logic [31:0]  d_o,
    output  logic         ready_o
  );

  logic mem_en;
  logic mem_we;

  bram_64kb #(
    .INIT_FILE("../programs/nostdlib/out/test_program.hex")
  ) bram_64kb_0 (
    .clk_i      ( clk_i         ),
    .en_i       ( mem_en        ),
    .we_i       ( mem_we        ),
    .addr_i     ( addr_i[15:2]  ),
    .d_i        ( d_i           ),
    .d_o        ( d_o           )
  );

  mem_controller mem_controller_0 (
    .clk_i      ( clk_i         ),
    .read_en_i  ( re_i          ),
    .write_en_i ( addr_i[1:0]   ),
    .ready_o    ( ready_o       ),
    .mem_en_o   ( mem_en        ),
    .mem_we_o   ( mem_we        )
  );

endmodule

