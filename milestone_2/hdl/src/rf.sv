//-------------------------------------------------------------------------------------------------
//
//  File: rf.sv
//  Description: Register file module
//
//  Author:
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

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



endmodule