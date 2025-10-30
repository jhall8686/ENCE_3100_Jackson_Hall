module main(
	input		MAX10_CLK1_50,
	input 	[9:0] 	SW,
	output 	[9:0] 	LEDR,
	inout		[35:0]	GPIO
);
	wire w_clk = MAX10_CLK1_50;
	
	wire quadA, quadB, button;
	assign quadA = GPIO[34];
	assign quadB = GPIO[32];
	assign button = GPIO[30];
	
	wire [7:0] count;
	
	quad q0(.quadA(quadA), .quadB(quadB), .clk(w_clk), .count(count));
	
	async_transmitter tx(.clk(w_clk), .TxD(GPIO[35]), .TxD_start(SW[0]), .TxD_data(count));
	
	assign LEDR[9] = button;
endmodule
