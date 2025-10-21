module BCD_counter(
	input clk,
	input tick,
	input reset,
	output [3:0] ones,
	output [3:0] tens,
	output [3:0] hundreds,
	output [3:0] seconds
	);
	
	wire w_counters [3:0];
	assign w_counters[0] = tick;
	assign w_counters[1] = w_counters[0] && (ones == 4'd9);
	assign w_counters[2] = w_counters[1] && (tens == 4'd9);
	assign w_counters[3] = w_counters[2] && (hundreds == 4'd9);
	
	always @(posedge clk) begin
		if(reset) begin
			ones <= 4'd0;
			tens <= 4'd0;
			hundreds <= 4'd0;
			seconds <= 4'd0;
		end else begin
			
			if(w_counters[0])
				ones <= (ones == 4'd9) ? 4'd0 : (ones + 1);
				
			if(w_counters[1])
				tens <= (tens == 4'd9) ? 4'd0 : (tens + 1);

			if(w_counters[2])
				hundreds <= (hundreds == 4'd9) ? 4'd0 : (hundreds + 1);
				
			if(w_counters[3])
				seconds <= (seconds == 4'd9) ? 4'd0 : (seconds + 1);
				
		end
	end
endmodule