//-------------------------------------------------------------------------------------------------
//
//  File: mem_store_unit.sv
//  Description: Shifts output from rs2 to match the corresponding store operation.
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

import rv32i_pkg::*;

//  mem_store_unit mem_store_unit_0 (
//    .op_i(),
//    .d_i(),
//    .addr_i(),
//    .we_o(),
//    .d_o()
//  );

module mem_store_unit (
    input   logic [2:0]           op_i,     // funct3 (SB=000, SH=001, SW=010)
    input   logic [REG_WIDTH-1:0] d_i,      // rs2 data in
    input   logic [1:0]           addr_i,   // lower 2 bits of address
    input   logic                 we_i,
    output  logic [3:0]           we_o,     // byte write enables
    output  logic [REG_WIDTH-1:0] d_o       // data out (aligned for memory)
);

  always_comb begin : store_alignment
    d_o = d_i;
    we_o = 4'b0000;

    if (we_i) begin
      case (op_i)

        // SB - Store Byte (funct3 = 000)
        3'b000: begin
          case (addr_i)
            2'b00: begin
              d_o = {24'h0, d_i[7:0]};
              we_o = 4'b0001;
            end
            2'b01: begin
              d_o = {16'h0, d_i[7:0], 8'h0};
              we_o = 4'b0010;
            end
            2'b10: begin
              d_o = {8'h0, d_i[7:0], 16'h0};
              we_o = 4'b0100;
            end
            2'b11: begin
              d_o = {d_i[7:0], 24'h0};
              we_o = 4'b1000;
            end
          endcase
        end

        // SH - Store Halfword (funct3 = 001)
        3'b001: begin
          case (addr_i[1])
            1'b0: begin
              d_o = {16'h0, d_i[15:0]};
              we_o = 4'b0011;
            end
            1'b1: begin
              d_o = {d_i[15:0], 16'h0};
              we_o = 4'b1100;
            end
          endcase
        end

        // SW - Store Word (funct3 = 010)
        3'b010: begin
          d_o = d_i;
          we_o = 4'b1111;
        end

        default: begin
          d_o = d_i;
          we_o = 4'b0000;
        end

      endcase
    end
  end

endmodule