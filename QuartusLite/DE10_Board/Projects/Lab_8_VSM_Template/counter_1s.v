module counter_1s(
	input clk,
	input en,
	output reg clk_1s
	);
	reg [26:0] count;
	always @(posedge clk) begin
		if(en)
			count<=count+1;
		if(count == 26'd24_999_999) begin
			clk_1s <= ~clk_1s;
			count <= 0;
		end
	end
endmodule