module counter_1s(
	input clk,
	output tog,
	output reg [3:0] count
	);
	reg [25:0] count50M;
	always @(posedge clk) begin
		count50M <= count50M + 25'b1;
		if(count50M == 26'd50_000_000) begin
			count <= count + 4'b1;
			tog = ~tog;
			count50M <= 25'b0;
			if(count >= 4'd9)
				count <= 4'd0;
		end
	end

endmodule
