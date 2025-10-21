module FSM_chess_clock(
	input ch_clk,
	input st_clk,
	input rst,
	input b1,
	input b2,
	output count1,
	output count2
	);
	
	reg [1:0] state, next_state;
	
	localparam [1:0] IDLE = 2'b00, P1 = 2'b01, P2 = 2'b11, END = 2'b10;
	
	always @(posedge ch_clk) begin

	
	end
	
	always @(posedge st_clk) begin
		if(rst)
			state <= IDLE;
		else
			state <= next_state;
	end
	
	always @(*) begin
		next_state = IDLE;
		
		case(state) 
			IDLE: begin
				if(b1)
					next_state = P1;
				else if(b2)
					next_state = P2;
				else
					next_state = IDLE;
			end
		endcase
	end
	
	
	
endmodule