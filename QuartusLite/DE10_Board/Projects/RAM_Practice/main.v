module main(
	input 	[9:0] 	SW,
	input		[1:0] 	KEY,
	output 	[9:0] 	LEDR,
	inout		[35:0]	GPIO
);

	ram16x4_lut(.clk(KEY[0]), .we(SW[8]), .addr(4'd0), .din(SW[3:0]), .dout(LEDR[3:0]));


endmodule