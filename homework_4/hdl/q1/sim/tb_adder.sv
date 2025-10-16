//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

module tb_adder
  (
    input   logic         sub,
    input   logic [15:0]  b,
    input   logic [15:0]  a,
    output  logic [15:0]  res
  );

    // DUT instance
    adder adder_0 (
      .sub_i  ( sub ),
      .a_i    ( a   ),
      .b_i    ( b   ),
      .res_o  ( res )
    );

    // Stimulus
    initial begin

      if ($test$plusargs("trace") != 0) begin
        $dumpfile("logs/tb_adder.vcd");
        $dumpvars();
      end

      $display("[%0t] Starting simulation...", $time);
    end

endmodule