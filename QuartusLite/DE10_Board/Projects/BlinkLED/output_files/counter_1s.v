//Counter with period of 1s on 50MHz clock

module counter_1s(
	input clk,
	input reset,
	output reg flag
	);
	
	reg [24:0] c;
	
	always @(posedge clk, negedge reset) begin
		if(!reset)
			c <= 0;
		else begin
			c <= c + 1;
			if(c == 25'd25_000_000) begin
				flag <= ~flag;
				c <= 0;
			end
		end
	end	
endmodule