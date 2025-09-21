//-------------------------------------------------------------------------------------------------
//
//  File: shift_reg.sv
//  Description: Parameterized shift register.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  demux #(
//    .OutputWidth(16)
//    ) dut (
//    .d_i(),
//    .sel_i(),
//    .d_o()
//  );

module shift_reg #(
    parameter N = 8
  ) (
    input   logic         clk_i,
    input   logic         rstn_i,
    input   logic         serial_parallel_i,
    input   logic         load_enable_i,
    input   logic         serial_i,
    input   logic [N-1:0] parallel_i,
    output  logic [N-1:0] parallel_o,
    output  logic         serial_o
  );

  logic [N-1:0] shift_reg;

  always_ff @( posedge clk_i or negedge rstn_i ) begin : blockName
    if (!rstn_i) begin
      shift_reg <= '0;
    end
    else begin
      if (load_enable_i) begin
        if (serial_parallel_i) begin
          shift_reg <= parallel_i;
        end
        else begin
          shift_reg <= shift_reg >> 1;
          shift_reg[N-1] <= serial_i;
        end
      end
    end
  end

  assign serial_o = shift_reg[0];
  assign parallel_o = shift_reg;

endmodule