//-------------------------------------------------------------------------------------------------
//
//  File: iab_dp.sv
//  Description: Datapath for IAB.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  iab_dp iab_dp_0 (
//    .clk_i(),
//    .data_a_i(),
//    .latch_i(),
//    .drive_bus_i(),
//    .mux_i(),
//    .data_o()
//  );

module iab_dp (
    input   logic         clk_i,
    input   logic [63:0]  data_a_i,
    input   logic         latch_i,
    input   logic         drive_bus_i,
    input   logic [2:0]   mux_i,
    output  logic [7:0]   data_o
  );

  logic [63:0] a_reg;

  always_ff @( posedge clk_i ) begin
    if (latch_i) begin
      a_reg <= data_a_i;
    end
  end

  always_comb begin
    if (drive_bus_i) begin
      case (mux_i)
        3'b000: data_o = a_reg[7:0];
        3'b001: data_o = a_reg[15:8];
        3'b010: data_o = a_reg[23:16];
        3'b011: data_o = a_reg[31:24];
        3'b100: data_o = a_reg[39:32];
        3'b101: data_o = a_reg[47:40];
        3'b110: data_o = a_reg[55:48];
        3'b111: data_o = a_reg[63:56];
      endcase
    end
    else begin
      data_o = 8'd0;
    end
  end

endmodule