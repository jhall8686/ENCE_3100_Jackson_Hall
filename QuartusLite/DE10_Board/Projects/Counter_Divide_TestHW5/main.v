module main(
	input MAX10_CLK1_50,
	input 	[9:0] 	SW,
	output 	[9:0] 	LEDR,
	inout		[35:0]	GPIO
);
	wire clk_2Hz;
	
	counter_2Hz(.clk(MAX10_CLK1_50), .tog(clk_2Hz));
	assign LEDR[0] = clk_2Hz;
	
	counter_divider(.clk(clk_2Hz), .clk2(LEDR[1]), .clk4(LEDR[2]));

endmodule