//-------------------------------------------------------------------------------------------------
//
//  File: bin2bcd.sv
//  Description: 4-bit binary to BCD (Binary Coded Decimal) encoder.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

//  bin2bcd dut (
//    .binary(),
//    .bcd(),
//    .carry()
//  );

module bin2bcd (
    input   logic [3:0] binary_i,
    output  logic [3:0] bcd_o,
    output  logic       carry_o
  );

  logic [15:0] bcd_1_table = '{
    1'b1, // 1111
    0'b0, // 1110
    1'b1, // 1101
    0'b0, // 1100
    1'b1, // 1011
    0'b0, // 1010
    1'b1, // 1001
    0'b0, // 1000
    1'b1, // 0111
    0'b0, // 0110
    1'b1, // 0101
    0'b0, // 0100
    1'b1, // 0011
    0'b0, // 0010
    1'b1, // 0001
    0'b0  // 0000
  };

  logic [15:0] bcd_2_table = '{
    1'b0, // 1111
    0'b0, // 1110
    1'b1, // 1101
    0'b1, // 1100
    1'b0, // 1011
    0'b0, // 1010
    1'b0, // 1001
    0'b0, // 1000
    1'b1, // 0111
    0'b1, // 0110
    1'b0, // 0101
    0'b0, // 0100
    1'b1, // 0011
    0'b1, // 0010
    1'b0, // 0001
    0'b0  // 0000
  };

  logic [15:0] bcd_4_table = '{
    1'b1, // 1111
    0'b1, // 1110
    1'b0, // 1101
    0'b0, // 1100
    1'b0, // 1011
    0'b0, // 1010
    1'b0, // 1001
    0'b0, // 1000
    1'b1, // 0111
    0'b1, // 0110
    1'b1, // 0101
    0'b1, // 0100
    1'b0, // 0011
    0'b0, // 0010
    1'b0, // 0001
    0'b0  // 0000
  };

  logic [15:0] bcd_8_table = '{
    1'b0, // 1111
    0'b0, // 1110
    1'b0, // 1101
    0'b0, // 1100
    1'b0, // 1011
    0'b0, // 1010
    1'b1, // 1001
    0'b1, // 1000
    1'b0, // 0111
    0'b0, // 0110
    1'b0, // 0101
    0'b0, // 0100
    1'b0, // 0011
    0'b0, // 0010
    1'b0, // 0001
    0'b0  // 0000
  };

  logic [15:0] bcd_carry_table = '{
    1'b1, // 1111
    0'b1, // 1110
    1'b1, // 1101
    0'b1, // 1100
    1'b1, // 1011
    0'b1, // 1010
    1'b0, // 1001
    0'b0, // 1000
    1'b0, // 0111
    0'b0, // 0110
    1'b0, // 0101
    0'b0, // 0100
    1'b0, // 0011
    0'b0, // 0010
    1'b0, // 0001
    0'b0  // 0000
  };

  mux #(
    .InputWidth(16)
  ) mux_bcd_1 (
    .d_i(bcd_1_table),
    .sel_i(binary_i),
    .d_o(bcd_o[0])
  );

  mux #(
    .InputWidth(16)
  ) mux_bcd_2 (
    .d_i(bcd_2_table),
    .sel_i(binary_i),
    .d_o(bcd_o[1])
  );

  mux #(
    .InputWidth(16)
  ) mux_bcd_4 (
    .d_i(bcd_4_table),
    .sel_i(binary_i),
    .d_o(bcd_o[2])
  );

  mux #(
    .InputWidth(16)
  ) mux_bcd_8 (
    .d_i(bcd_8_table),
    .sel_i(binary_i),
    .d_o(bcd_o[3])
  );

  mux #(
    .InputWidth(16)
  ) mux_bcd_carry (
    .d_i(bcd_carry_table),
    .sel_i(binary_i),
    .d_o(carry_o)
  );

endmodule