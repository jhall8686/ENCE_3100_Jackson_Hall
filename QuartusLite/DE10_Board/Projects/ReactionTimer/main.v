module main(
	input		MAX10_CLK1_50,
	input 	[9:0] 	SW,
	output 	[9:0] 	LEDR,
	output 	[35:0]	GPIO
);
	wire w_clk;
	assign w_clk = MAX10_CLK1_50;
	wire [15:0] w_cnt;
	counter_1ms(.clk(w_clk), .reset(SW[0]), .ena(SW[1]), .count(w_cnt), .toggle(LEDR[0]));



endmodule