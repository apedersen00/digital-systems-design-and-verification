//-------------------------------------------------------------------------------------------------
//
//  File: mem_ext_unit.sv
//  Description: Extends the loaded values from memory according to RV32I specifications.
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

import rv32i_pkg::*;

//  mem_ext_unit mem_ext_unit_0 (
//    .op_i(),   
//    .d_i(),    
//    .addr_i(), 
//    .d_o()     
//  );

module mem_ext_unit (
    input   logic [2:0]           op_i,   // funct3
    input   logic [REG_WIDTH-1:0] d_i,    // data in
    input   logic [1:0]           addr_i, // lower 2 bits of address
    output  logic [REG_WIDTH-1:0] d_o     // data out (sign/zero extended)
);

  always_comb begin : extend

    case (op_i)

      // LB - Load Byte (sign extended)
      3'b000: begin
        case (addr_i)
          2'b00: d_o = {{24{d_i[7]}}, d_i[7:0]};     // byte 0
          2'b01: d_o = {{24{d_i[15]}}, d_i[15:8]};   // byte 1
          2'b10: d_o = {{24{d_i[23]}}, d_i[23:16]};  // byte 2
          2'b11: d_o = {{24{d_i[31]}}, d_i[31:24]};  // byte 3
        endcase
      end

      // LH - Load Halfword (sign extended)
      3'b001: begin
        case (addr_i[1])
          1'b0: d_o = {{16{d_i[15]}}, d_i[15:0]};    // halfword 0
          1'b1: d_o = {{16{d_i[31]}}, d_i[31:16]};   // halfword 1
        endcase
      end

      // LW - Load Word (no extension needed)
      3'b010: begin
        d_o = d_i;
      end

      // LBU - Load Byte Unsigned (zero extended)
      3'b100: begin
        case (addr_i)
          2'b00: d_o = {24'b0, d_i[7:0]};     // byte 0
          2'b01: d_o = {24'b0, d_i[15:8]};    // byte 1
          2'b10: d_o = {24'b0, d_i[23:16]};   // byte 2
          2'b11: d_o = {24'b0, d_i[31:24]};   // byte 3
        endcase
      end

      // LHU - Load Halfword Unsigned (zero extended)
      3'b101: begin
        case (addr_i[1])
          1'b0: d_o = {16'b0, d_i[15:0]};     // halfword 0
          1'b1: d_o = {16'b0, d_i[31:16]};    // halfword 1
        endcase
      end

      default: begin
        d_o = d_i;
      end

    endcase

  end

endmodule