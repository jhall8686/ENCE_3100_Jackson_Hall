module main(
	input		MAX10_CLK1_50,
	input 	[9:0] 	SW,
	input		[1:0] 	KEY,
	output 	[9:0] 	LEDR,
	inout		[35:0]	GPIO
);

	//FSM_Moore fsm0(.w(SW[0]), .clk(~KEY[0]), .rst(SW[9]), .y(LEDR[0]));
	wire t;
	counter_1s(MAX10_CLK1_50, t);
	
	FSM_HW fsmb0(.w(SW[0]), .clk(KEY[0]), .rst(SW[9]), .z(LEDR[0]));

endmodule