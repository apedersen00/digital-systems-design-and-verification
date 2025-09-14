//-------------------------------------------------------------------------------------------------
//
//  File: alu.sv
//  Description:
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

//  alu alu_0 #(
//    .BW(8)
//  ) (
//    .in_a(),
//    .in_b(),
//    .opcode(),
//    .out(),
//    .flags()
//  );

module alu #(
    parameter BW = 8
  ) (
    input   logic signed  [BW-1:0]  in_a,   // Operand A
    input   logic signed  [BW-1:0]  in_b,   // Operand B
    input   logic         [2:0]     opcode, // Operation code
    output  logic signed  [BW-1:0]  out,    // Output result
    output  logic signed  [2:0]     flags   // Flags of the result
  );

  logic flag_overflow;
  logic flag_negative;
  logic flag_zero;

  // instantiate signals for all possible outputs
  logic [BW-1:0] out_add;
  logic [BW-1:0] out_sub;
  logic [BW-1:0] out_and;
  logic [BW-1:0] out_or;
  logic [BW-1:0] out_xor;
  logic [BW-1:0] out_inc;
  logic [BW-1:0] out_mova;
  logic [BW-1:0] out_movb;

  // route selected op to the output
  mux #(
    .BitWidth(BW),
    .N(8)
  ) output_mux (
    .d_i({out_movb, out_mova, out_inc, out_xor, out_or, out_and, out_sub, out_add}),
    .sel_i(opcode),
    .d_o(out)
  );

  // op: additon
  cl_adder #(
    .Width(BW)
  ) cl_adder_0 (
    .a_i(in_a),
    .b_i(in_b),
    .sum_o(out_add),
    .c_o()
  );

  // op: subtraction
  cl_subtractor #(
    .Width(BW)
  ) cl_subtractor_0 (
    .a_i(in_a),
    .b_i(in_b),
    .sub_i(1'b1),
    .sum_o(out_sub),
    .c_o()
  );

  // op: bitwise and
  assign out_and  = in_a & in_b;

  // op: bitiwse or
  assign out_or   = in_a | in_b;

  // op: bitwise xor
  assign out_xor  = in_a ^ in_b;

  // op: increment of a
  cl_adder #(
    .Width(BW)
  ) cl_adder_1 (
    .a_i(in_a),
    .b_i(BW'(1)),
    .sum_o(out_inc),
    .c_o()
  );

  // op: passthrough of a
  assign out_mova = in_a;

  // op: passthrough of b
  assign out_movb = in_b;

  // flag generation
  always_comb begin : check_overflow
    flag_overflow = 1'b0;
    if (opcode == 3'b000) begin
      flag_overflow  = (in_a[BW-1] == in_b[BW-1]) && (in_a[BW-1] != out_add[BW-1]);
    end else if (opcode == 3'b001) begin
      flag_overflow  = (in_a[BW-1] != in_b[BW-1]) && (in_a[BW-1] != out_sub[BW-1]);
    end
  end

  assign flag_negative  = 1'b0;
  assign flag_zero      = 1'b0;

  assign flags = {flag_overflow, flag_negative, flag_zero};

endmodule
