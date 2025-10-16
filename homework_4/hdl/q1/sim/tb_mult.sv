//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

module tb_mult
  (
    input   logic         sel,
    input   logic [15:0]  b,
    input   logic [15:0]  a,
    output  logic [15:0]  res
  );

    // DUT instance
    mult mult_0 (
      .sel_i  ( sel ),
      .a_i    ( a   ),
      .b_i    ( b   ),
      .res_o  ( res )
    );

    // Stimulus
    initial begin

      if ($test$plusargs("trace") != 0) begin
        $dumpfile("logs/tb_mult.vcd");
        $dumpvars();
      end

      $display("[%0t] Starting simulation...", $time);
    end

endmodule