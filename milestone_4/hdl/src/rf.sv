//-------------------------------------------------------------------------------------------------
//
//  File: rf.sv
//  Description: regsister file module
//
//  Author:
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

//  rf #(
//    .BW(),
//    .DEPTH()
//   ) rf_0 (
//    .clk(),
//    .rst_n(),
//    .data_in(),
//    .read_addr_1(),
//    .read_addr_2(),
//    .write_addr(),
//    .write_en_n(),
//    .chip_en(),
//    .data_out_1(),
//    .data_out_2()
//  );

module rf #(
    localparam WIDTH = 32,
    localparam DEPTH = 32
  ) (
    input   logic                     clk_i,
    input   logic                     rstn_i,
    input   logic                     chip_en_i,
    input   logic                     we_i,
    input   logic [WIDTH-1:0]         data_i,
    input   logic [$clog2(DEPTH)-1:0] rd_addr_i,
    input   logic [$clog2(DEPTH)-1:0] rs1_addr_i,
    input   logic [$clog2(DEPTH)-1:0] rs2_addr_i,
    output  logic [WIDTH-1:0]         rs1_o,
    output  logic [WIDTH-1:0]         rs2_o
);

  logic [WIDTH-1:0] regs [DEPTH-1:0];
  logic [WIDTH-1:0] mux_out_1;
  logic [WIDTH-1:0] mux_out_2;

  always_ff @( posedge clk_i or negedge rstn_i ) begin : write_ff
    if (!rstn_i) begin
      for (int i = 0; i < DEPTH; i++) begin
        regs[i] <= 0;
      end
    end else begin
      if (!we_i && chip_en_i) begin
        if (rd_addr_i != '0) begin
          regs[rd_addr_i] <= data_i;
        end
      end
    end
  end

  mux #(
    .BitWidth(WIDTH),
    .N(DEPTH)
  ) mux_0 (
    .d_i(regs),
    .sel_i(rs1_addr_i),
    .d_o(mux_out_1)
  );

  mux #(
    .BitWidth(WIDTH),
    .N(DEPTH)
  ) mux_1 (
    .d_i(regs),
    .sel_i(rs2_addr_i),
    .d_o(mux_out_2)
  );

  always_comb begin : output_comb
    rs1_o = '0;
    rs2_o = '0;
    if (chip_en_i) begin
      rs1_o = mux_out_1;
      rs2_o = mux_out_2;
    end
  end

endmodule