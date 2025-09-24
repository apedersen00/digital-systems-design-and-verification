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
    input  logic                    clk,
    input  logic                    rst_n,
    input  logic signed [8-1:0]     data_in,
    input  logic [$clog2(256)-1:0]  read_addr_1,
    input  logic [$clog2(256)-1:0]  read_addr_2,
    input  logic [$clog2(256)-1:0]  write_addr,
    input  logic                    write_en_n,
    input  logic                    chip_en,
    output logic signed [8-1:0]     data_out_1,
    output logic signed [8-1:0]     data_out_2
  );

    // DUT instance
    rf #(
      .BW(8),
      .DEPTH(256)
    ) rf_0 (
      .clk(clk),
      .rst_n(rst_n),
      .data_in(data_in),
      .read_addr_1(read_addr_1),
      .read_addr_2(read_addr_2),
      .write_addr(write_addr),
      .write_en_n(write_en_n),
      .chip_en(chip_en),
      .data_out_1(data_out_1),
      .data_out_2(data_out_2)
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
