module counter_1s(
	input clk,
	output reg tog
	);
	reg [25:0] count50M;
	always @(posedge clk) begin
		count50M <= count50M + 25'b1;
		if(count50M == 26'd50_000_000) begin
			tog <= ~tog;
			count50M <= 25'b0;
		end
	end

endmodule
