//-------------------------------------------------------------------------------------------------
//
//  File: tb_mem_64kib_constraint.sv
//  Description: Constrained random testbench for mem_64kib.
//
//  Author:
//      - A. Pedersen
//
//-------------------------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_mem_64kib;

  logic         clk;
  logic         read_en;
  logic [3:0]   write_en;
  logic [31:0]  addr;
  logic [31:0]  d_i;
  logic [31:0]  d_o;
  logic         ready;

  mem_64kib mem_64kib_0 (
    .clk_i      ( clk       ),
    .read_en_i  ( read_en   ),
    .write_en_i ( write_en  ),
    .addr_i     ( addr      ),
    .d_i        ( d_i       ),
    .d_o        ( d_o       ),
    .ready_o    ( ready     )
  );


  // clock
  initial clk = 0;
  always #5 clk = ~clk;

  // stimulus
  mem_transaction tr;

  initial begin
    if ($test$plusargs("trace") != 0) begin
      $dumpfile("logs/tb_mem_64kib.vcd");
      $dumpvars();
    end

    $display("[%0t] Starting simulation...", $time);

    // Initialize signals
    read_en   = 0;
    write_en  = 0;
    addr      = 0;
    d_i       = 0;
    tr        = new();

    // wait
    repeat (5) @(posedge clk);

    // generate random bursts
    repeat (20) begin
      void'(tr.randomize());
      $display("[%0t] Transaction: %s burst_len=%0d addr=0x%08h write_en=%b",
                $time, (tr.is_read ? "READ" : "WRITE"), tr.burst_len, tr.addr, tr.write_en);

      // Perform the burst
      for (int i = 0; i < tr.burst_len; i++) begin
        @(posedge clk);
        addr     <= tr.addr + i * 4;
        d_i      <= $urandom();
        read_en  <= tr.is_read;
        write_en <= tr.write_en;
      end

      @(posedge clk);
      read_en  <= 0;
      write_en <= 0;

      repeat (3) @(posedge clk);
    end

    $display("[%0t] Simulation completed.", $time);
    $finish;
  end

endmodule
