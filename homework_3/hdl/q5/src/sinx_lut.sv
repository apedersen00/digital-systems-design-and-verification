//-------------------------------------------------------------------------------------------------
//
//  File: sinx_lut.sv
//  Description: Look-Up Table for pre-calculated values of the recurrence relation of the Taylor
//               expansion of sin(x).
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  sinx_lut sinx_lut_0 (
//    .addr_i(),
//    .data_o()
//  );

module sinx_lut (
    input   logic [2:0]   addr_i,
    output  logic [15:0]  data_o,
  );

  always_comb begin : sinx_lut
    case (addr_i)
      3'd0: data_o = 16'h8000;
      3'd1: data_o = 16'h1555;
      3'd2: data_o = 16'h0666;
      3'd3: data_o = 16'h030C;
      3'd4: data_o = 16'h01C7;
      3'd5: data_o = 16'h012A;
      3'd6: data_o = 16'h00D2;
      3'd7: data_o = 16'h009C;
      default: data_o = 16'h0000;
    endcase
  end

endmodule