module memory_system #(
    parameter int DATA_WIDTH = 32,
    parameter int MEM_DEPTH  = 16384,
    parameter int ADDR_LSB   = 2,
    parameter int ADDR_WIDTH = $clog2(MEM_DEPTH)
)(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic [31:0]            addr,
    input  logic [DATA_WIDTH-1:0]  data_in,
    output logic [DATA_WIDTH-1:0]  data_out,
    input  logic [3:0]             write_en,
    input  logic                   read_en,
    output logic                   ready
);
    typedef enum logic [1:0] {S_IDLE, S_BUSY, S_DONE} state_t;
    state_t state, state_n;

    logic [ADDR_WIDTH-1:0] word_addr;
    assign word_addr = addr[ADDR_LSB +: ADDR_WIDTH];

    logic req;
    assign req = read_en | (|write_en);

    logic ip_ena;
    logic       ip_wea1;
    logic [DATA_WIDTH-1:0] ip_douta;

    always_comb begin
        state_n = state;
        ready   = 1'b0;
        unique case (state)
            S_IDLE:  state_n = req ? S_BUSY : S_IDLE;
            S_BUSY:  state_n = S_DONE;
            S_DONE:  begin
                ready   = 1'b1;
                state_n = S_IDLE;
            end
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= S_IDLE;
        else        state <= state_n;
    end

    assign ip_ena  = 1'b1;
    assign ip_wea1 = |write_en;

    data_sram u_sram (
        .clka  (clk),
        .ena   (ip_ena),
        .wea   (ip_wea1),
        .addra (word_addr),
        .dina  (data_in),
        .douta (ip_douta)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) data_out <= '0;
        else if (ip_ena) data_out <= ip_douta;
    end
endmodule
