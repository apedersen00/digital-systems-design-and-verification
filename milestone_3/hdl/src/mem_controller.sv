//-------------------------------------------------------------------------------------------------
//
//  File: mem_controller.sv
//  Description: Parameterized NX-to-X multiplexer module.
//
//  Author(s):
//      - A. Pedersen
//      - J. Sadiq
//      - J. Yang
//
//-------------------------------------------------------------------------------------------------

//  mem_controller mem_controller_0 (
//    .clk_i(),
//    .read_en_i(),
//    .write_en_i(),
//    .ready_o(),
//    .mem_en_o(),
//    .mem_we_o()
//  );

module mem_controller (
    input   logic       clk_i,
    input   logic       read_en_i,
    input   logic [1:0] write_en_i,
    output  logic       ready_o,
    output  logic       mem_en_o,
    output  logic       mem_we_o
  );

  typedef enum logic [2:0] {
    STATE_IDLE,
    STATE_READ,
    STATE_WRITE
  } state_t;

  state_t cur_state, nxt_state;

  always_ff @( posedge clk_i ) begin
    cur_state <= nxt_state;
  end

  always_comb begin
    nxt_state = STATE_IDLE;

    case (cur_state)

      STATE_IDLE  : begin
        if ( |write_en_i ) begin
          nxt_state = STATE_WRITE;
        end
        else if ( read_en_i ) begin
          nxt_state = STATE_READ;
        end
      end

      STATE_READ  : nxt_state = STATE_IDLE;
      STATE_WRITE : nxt_state = STATE_IDLE;
      default: nxt_state = STATE_IDLE;
    endcase
  end

  assign ready_o  = (cur_state == STATE_IDLE)   ? 1'b1 : 1'b0;
  assign mem_en_o = (cur_state == STATE_IDLE)   ? 1'b0 : 1'b1;
  assign mem_we_o = (cur_state == STATE_WRITE)  ? 1'b1 : 1'b0; 

endmodule
