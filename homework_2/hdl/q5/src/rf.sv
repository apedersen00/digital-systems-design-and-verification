//-------------------------------------------------------------------------------------------------
//
//  File: rf.sv
//  Description: Register file module
//
//  Author:
//      - A. Pedersen
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
    parameter BW    = 8,
    parameter DEPTH = 256
  ) (
    input  logic                     clk,
    input  logic                     rst_n,
    input  logic signed [BW-1:0]     data_in,
    input  logic [$clog2(DEPTH)-1:0] read_addr_1,
    input  logic [$clog2(DEPTH)-1:0] read_addr_2,
    input  logic [$clog2(DEPTH)-1:0] write_addr,
    input  logic                     write_en_n,
    input  logic                     chip_en,
    output logic signed [BW-1:0]     data_out_1,
    output logic signed [BW-1:0]     data_out_2
);

  logic [BW-1:0] regs [DEPTH-1:0];
  logic [BW-1:0] mux_out_1;
  logic [BW-1:0] mux_out_2;
  logic [$clog2(DEPTH)-1:0] read_addr_1_clocked;
  logic [$clog2(DEPTH)-1:0] read_addr_2_clocked;

  always_ff @( posedge clk or negedge rst_n ) begin : write_ff
    if (!rst_n) begin
      for (int i = 0; i < DEPTH; i++) begin
        regs[i] <= 0;
      end
    end else begin
      if (!write_en_n && chip_en) begin
        regs[write_addr] <= data_in;
      end
    end
  end

  always_ff @( posedge clk or negedge rst_n ) begin : read_ff
    read_addr_1_clocked <= read_addr_1;
    read_addr_2_clocked <= read_addr_2;
  end

  mux #(
    .BitWidth(BW),
    .N(DEPTH)
  ) mux_0 (
    .d_i(regs),
    .sel_i(read_addr_1_clocked),
    .d_o(mux_out_1)
  );

  mux #(
    .BitWidth(BW),
    .N(DEPTH)
  ) mux_1 (
    .d_i(regs),
    .sel_i(read_addr_2_clocked),
    .d_o(mux_out_2)
  );

  always_comb begin : output_comb
    data_out_1 = '0;
    data_out_2 = '0;
    if (chip_en) begin
      data_out_1 = mux_out_1;
      data_out_2 = mux_out_2;
    end
  end

endmodule