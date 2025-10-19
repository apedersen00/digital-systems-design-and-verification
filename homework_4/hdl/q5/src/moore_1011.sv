module moore_1011 (
	input  logic clk,
	input  logic rst_n,
	input  logic j,
	output logic w
);
    
	logic [2:0] next_state, present_state;

	always_comb begin
		next_state = 3'b000;
		case(present_state)
			3'b000: next_state = j ? 3'b001 : 3'b000;
			3'b001: next_state = j ? 3'b001 : 3'b010;
			3'b010: next_state = j ? 3'b011 : 3'b000;
			3'b011: next_state = j ? 3'b100 : 3'b010;
			3'b100: next_state = j ? 3'b001 : 3'b010;
			default: next_state = 3'b000;
		endcase
	end

	assign w = (present_state == 3'b100) ? 1'b1 : 1'b0;

	always_ff @(posedge clk or negedge rst_n) begin
		if (!rst_n) 
			present_state <= 3'b000;
		else
			present_state <= next_state;
	end
    
endmodule 