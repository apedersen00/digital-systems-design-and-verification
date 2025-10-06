`timescale 1ns/1ps

module memory_system_tb;
  localparam int DATA_WIDTH = 32;
  localparam int MEM_DEPTH  = 16384;

  logic clk, rst_n;
  logic [31:0] addr;
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;
  logic [3:0] write_en;
  logic read_en;
  logic ready;

  memory_system #(
    .DATA_WIDTH(DATA_WIDTH),
    .MEM_DEPTH (MEM_DEPTH)
  ) dut (
    .clk, .rst_n,
    .addr, .data_in, .data_out,
    .write_en, .read_en,
    .ready
  );

  always #5 clk = ~clk;

  task automatic do_write(input logic [31:0] a,
                          input logic [31:0] wdata);
    begin
      addr     = a;
      data_in  = wdata;
      write_en = 4'b1111;
      read_en  = 1'b0;
      @(posedge clk);
      while (!ready) @(posedge clk);
      write_en = 4'b0000;
      @(posedge clk);
    end
  endtask

  task automatic do_read_check(input logic [31:0] a,
                               input logic [31:0] exp_val);
    begin
      addr     = a;
      read_en  = 1'b1;
      write_en = 4'b0000;
      @(posedge clk);
      while (!ready) @(posedge clk);
      if (data_out !== exp_val) begin
        $error("READ MISMATCH @%08x: got %08x expect %08x", a, data_out, exp_val);
        $fatal;
      end
      read_en = 1'b0;
      @(posedge clk);
    end
  endtask

  logic req, req_q;
  assign req = read_en | (|write_en);
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) req_q <= 1'b0; else req_q <= req;
  end

  property p_ready_next;
    @(posedge clk) disable iff(!rst_n) $rose(req) |=> ready;
  endproperty
  assert property(p_ready_next);

  property p_hold_until_ready;
    @(posedge clk) disable iff(!rst_n) req |-> (req until_with ready);
  endproperty
  assert property(p_hold_until_ready);

  initial begin
    clk=0; rst_n=0;
    addr='0; data_in='0; write_en=4'b0000; read_en=0;
    repeat(4) @(posedge clk);
    rst_n=1;
    @(posedge clk);

    do_write(32'h0000_0000, 32'hA1B2_C3D4);
    do_read_check(32'h0000_0000, 32'hA1B2_C3D4);

    do_write(32'h0000_0004, 32'h1234_5678);
    do_read_check(32'h0000_0004, 32'h1234_5678);

    $display("All tests PASSED.");
    #20 $finish;
  end
endmodule
