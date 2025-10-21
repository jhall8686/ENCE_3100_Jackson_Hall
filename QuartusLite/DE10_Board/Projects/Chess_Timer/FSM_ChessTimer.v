module FSM_ChessTimer(
	input clk,
	input reset,
	input [1:0] buttons,
	input [9:0] counter_1,
	input [9:0] counter_2,
	output reg [1:0] load_counters,
	output reg [1:0] en_counters,
	output reg [1:0] state_displays
);

	reg [1:0] state, next_state;

	// States
	//... 
	
	localparam [1:0] START = 2'b00, P1 =2'b01, P2 = 2'b10, END = 2'b11;
	
	// 1. State Register (sequential)
	//...
	always @(posedge clk) begin
		if(reset)
			state <= START;
		else
			state <= next_state;
	end
	// 2. Next-State Logic (combinational)
	//...
		always @(*) begin
			case(state)
				START: begin
					if(buttons[0])
						next_state = P1;
					else if(buttons[1])
						next_state = P2;
					else
						next_state = START;
				end
				P1: begin
					if(buttons[1])
						next_state = P2;
					else begin
						if(counter_1 == 0)
							next_state = END;
						else
							next_state = P1;
					end
				end
				P2: begin
					if(buttons[0])
						next_state = P1;
					else begin
						if(counter_2 == 0)
							next_state = END;
						else
							next_state = P2;
					end
				end
				END: next_state = END;
			endcase
		end
				
	// 3. Output Logic (combinational)
	//...
		always @(*) begin
			case(state)
				START: begin
					load_counters = 2'b11;
					en_counters = 2'b00;
					state_displays = START;
				end
				P1: begin
					load_counters = 2'b00;
					en_counters = 2'b01;
					state_displays = P1;
				end
				P2: begin
					load_counters = 2'b00;
					en_counters = 2'b10;
					state_displays = P2;
				end
				END: begin
					load_counters = 2'b00;
					en_counters = 2'b00;
					state_displays = END;
				end
			endcase
		end
		
endmodule
