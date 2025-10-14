//-------------------------------------------------------------------------------------------------
//
//  File: dual_port_bram.sv
//  Description: Model of Vivado generated dual-port BRAM.
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

//  dual_port_bram #(
//    .DATA_WIDTH(),
//    .DEPTH(),
//    .INIT_FILE()
//   ) data_mem_0 (
//    .clka(),
//    .wea(),
//    .addra(),
//    .dina(),
//    .clkb(),
//    .rstb(),
//    .enb(),
//    .addrb(),
//    .doutb(),
//    .douta()
//  );

module dual_port_bram #(
    parameter WIDTH     = 32,
    parameter DEPTH     = 16384,
    parameter INIT_FILE = ""
)(
    input  logic              clka,
    input  logic [3:0]        wea,
    input  logic [31:0]       addra,
    input  logic [WIDTH-1:0]  dina,
    input  logic              clkb,
    input  logic              enb,
    input  logic [31:0]       addrb,
    output logic [WIDTH-1:0]  doutb,
    output logic [WIDTH-1:0]  douta
);

    logic [WIDTH-1:0] mem [0:DEPTH-1];

    initial begin
        if (INIT_FILE != "") begin
            $display("Loading memory from %s", INIT_FILE);
            $readmemh(INIT_FILE, mem);
        end
    end

  always_ff @(posedge clka) begin
      if (|wea) begin
          for (int i = 0; i < 4; i++) begin
              if (wea[i]) begin
                  mem[(addra >> 2) % DEPTH][i*8 +: 8] <= dina[i*8 +: 8];
              end
          end
      end
      douta <= mem[(addra >> 2) % DEPTH];
  end

  always_ff @(posedge clkb) begin
      if (enb) begin
          doutb <= mem[(addrb >> 2) % DEPTH];
      end
  end

endmodule