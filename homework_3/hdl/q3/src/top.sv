//-------------------------------------------------------------------------------------------------
//
//  File: top.sv
//  Description: top module for testbench
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

module top
  (
    input   logic clk,
    input   logic rstn,
    input   logic serdata,
    output  logic valid
  );

    // DUT instance
    ser_comm ser_comm_0 (
      .clk_i(clk),
      .rstn_i(rstn),
      .serdata_i(serdata),
      .valid_o(valid)
    );

    // Stimulus
    initial begin

      if ($test$plusargs("trace") != 0) begin
        $dumpfile("logs/vlt_dump.vcd");
        $dumpvars();
      end

      $display("[%0t] Starting simulation...", $time);
    end

endmodule