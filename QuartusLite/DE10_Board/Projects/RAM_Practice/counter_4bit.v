module counter_4bit(
	input clk,
	input rst,
	output reg [3:0] count
	);
	
	always @(posedge clk) begin
		if(rst)
			count <= 0;
		else
			count <= (count + 1) % 16;
	end
	
endmodule