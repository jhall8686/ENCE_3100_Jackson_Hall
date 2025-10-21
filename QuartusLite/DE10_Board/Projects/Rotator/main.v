module main(
	input 	[9:0] 	SW,
	output 	[9:0] 	LEDR
);

rotator_5bit r0(.clk(SW[9]), .load(SW[8]), .ena(SW[7:6]), .data(SW[5:0]), .q(LEDR[5:0]));

endmodule