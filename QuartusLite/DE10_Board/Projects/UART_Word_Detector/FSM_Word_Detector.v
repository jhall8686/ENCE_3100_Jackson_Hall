module FSM_Word_Detector(
	input rst,
	input clk,
	input [7:0] RxD_data,
	input Rx_detect,
	input [7:0] seg_data,
	input counter_done,
	output reg counter_start,
	output reg [7:0] HEX0,
	output reg [7:0] HEX1,
	output reg [7:0] HEX2,
	output reg [7:0] HEX3,
	output reg [7:0] HEX4,
	output reg [7:0] HEX5
	);
	
	reg [2:0] state, next_state, prev_state;

	localparam [2:0] A = 3'd0, H = 3'd1, E = 3'd2, L = 3'd3, L2 = 3'd4, O = 3'd5;
	
	always @(posedge clk) begin
		if(rst)
			state <= A;
		else begin
			prev_state <= state;
			state <= next_state;
		end
	end
	
	//next state logic
	always @(negedge Rx_detect, negedge counter_done) begin
		case(state)
			A: next_state <= (seg_data == 8'b10001001/*H*/) ? H : A;
			H: next_state <= (seg_data == 8'b10000110/*E*/) ? E : (seg_data == 8'b10001001/*H*/) ? H : A;
			E: next_state <= (seg_data == 8'b11000111/*L*/) ? L : (seg_data == 8'b10000110/*E*/) ? E : A;
			L: next_state <= (seg_data == 8'b11000111/*L*/ && prev_state == L) ? L2 : 
								 (seg_data == 8'b11000111/*L*/) ? L : A;
			L2: next_state <= (seg_data == 8'b10100011/*O*/) ? O : (seg_data == 8'b11000111/*L*/) ? L2 : A;
			O: next_state <= counter_done ? A : O;
		endcase
	end
	
	//output logic
	
	always @(*) begin
		case(state) 
			A: begin
				HEX0 = seg_data;
				HEX1 = 8'hFF;
				HEX2 = 8'hFF;
				HEX3 = 8'hFF;
				HEX4 = 8'hFF;
				HEX5 = 8'hFF;
				counter_start = 1'b0;
				
			end
			H: begin
				HEX0 = seg_data;
				HEX1 = 8'hFF;
				HEX2 = 8'hFF;
				HEX3 = 8'hFF;
				HEX4 = 8'hFF;
				HEX5 = 8'hFF;
				counter_start = 1'b0;
				
			end
			E: begin
				HEX0 = seg_data;
				HEX1 = 8'hFF;
				HEX2 = 8'hFF;
				HEX3 = 8'hFF;
				HEX4 = 8'hFF;
				HEX5 = 8'hFF;
				counter_start = 1'b0;
				
			end
			L: begin
				HEX0 = seg_data;
				HEX1 = 8'hFF;
				HEX2 = 8'hFF;
				HEX3 = 8'hFF;
				HEX4 = 8'hFF;
				HEX5 = 8'hFF;
				counter_start = 1'b0;
			end
			L2: begin
				HEX0 = seg_data;
				HEX1 = 8'hFF;
				HEX2 = 8'hFF;
				HEX3 = 8'hFF;
				HEX4 = 8'hFF;
				HEX5 = 8'hFF;
				counter_start = 1'b0;
				
			end
			O: begin
				HEX0 = 8'h7f;
				HEX5 = 8'b10001001/*H*/;
				HEX4 = 8'b10000110/*E*/;
				HEX3 = 8'b11000111/*L*/;
				HEX2 = 8'b11000111/*L*/;
				HEX1 = 8'b10100011/*O*/;
				counter_start = 1'b1;
				if(counter_done) 
					counter_start = 1'b0;
				
			end
		endcase
	end

	//assign HEX0 = (state == C) ? 8'h7F : seg_data;
endmodule