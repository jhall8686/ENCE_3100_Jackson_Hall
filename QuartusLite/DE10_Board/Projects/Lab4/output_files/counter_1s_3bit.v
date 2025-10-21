module counter_1s_3bit(
	input clk,
	output reg [2:0] count1,
	output reg [2:0] count2,
	output reg [2:0] count3,
	output reg [2:0] count4,
	output reg [2:0] count5,
	output reg [2:0] count6 
	);
	reg [25:0] count50M;
	always @(posedge clk) begin
		count50M <= count50M + 25'b1;
		if(count50M == 26'd50_000_000) begin
			count1 <= count1 + 3'd1;
			count2 <= count1 + 3'd2;
			count3 <= count1 + 3'd3;
			count4 <= count1 + 3'd4;
			count5 <= count1 + 3'd5;
			count6 <= count1 + 3'd6;
			count50M <= 25'b0;
		end
		
	end

endmodule